using System;
using System.Text;
using System.Collections;
using System.Xml;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.ComponentModel;

public interface IMasterPageAccessor
{
    SiteMapProvider Provider
    {
        get;
    }
}

public interface ICustomCacheInfo
{
    String GetKey();    
}

[DataObject(true)]
public sealed class PhotoPageData
{
    private const String DATA_ENTRY_NAME = "aws_thumbs";
    private const Int32  VIEW_STATE_CACHE_TIMEOUT = 48; //hours

    private IMasterPageAccessor _parentMasterAcc;
    private String _dataKey;
    private static readonly System.Threading.ReaderWriterLock _rwLock = new System.Threading.ReaderWriterLock();
    private Boolean _useFullValidation = AWS.Utils.WebUtils.GetFromString( ConfigurationManager.AppSettings["full-image-security-validation"], false );

    public PhotoPageData( IMasterPageAccessor par, string dataKey )
    {
        _parentMasterAcc = par;
        _dataKey = dataKey;
    }

    //http://www.codeguru.com/Csharp/.NET/net_asp/article.php/c5363
    //About locking on Cache: "Synchronizing Cache Access in ASP.NET"
    [DataObjectMethod(DataObjectMethodType.Select)]
    public /*static*/ ICollection GetPage()
    {
        ArrayList res;
        String realK = DATA_ENTRY_NAME + _dataKey;

        _rwLock.AcquireReaderLock( TimeSpan.FromMinutes(10) );
        try
        {
            res = (ArrayList)HttpContext.Current.Cache[ realK ];            
            if( res == null )
            {
                _rwLock.ReleaseReaderLock();
                _rwLock.AcquireWriterLock( TimeSpan.FromMinutes(10) );
                res = (ArrayList)HttpContext.Current.Cache[ realK ];

                if( res == null )
                {
                    res = FetchData();
                    HttpContext.Current.Cache.Add( realK, res, null,
                        DateTime.Now.AddHours(VIEW_STATE_CACHE_TIMEOUT),
                        System.Web.Caching.Cache.NoSlidingExpiration,
                        System.Web.Caching.CacheItemPriority.Normal, null
                    );
                }
            }
        }
        finally
        {
            if( _rwLock.IsReaderLockHeld )
                _rwLock.ReleaseReaderLock();

            if( _rwLock.IsWriterLockHeld )
                _rwLock.ReleaseWriterLock();            
        }

        return res;
    }

    private ArrayList FetchData()
    {
        ArrayList res = new ArrayList();
        //SiteMapNode nd = SiteMap.CurrentNode;
        SiteMapNode nd = _parentMasterAcc.Provider.CurrentNode;
        if( nd.ChildNodes.Count != 0 )
            foreach( SiteMapNode node in nd.ChildNodes )
            {
                if( node.ChildNodes.Count != 0 ) //folder
                {
                    PhotoItem item = new PhotoItem( node.Title, node.Description,
                        GetClientPathFolder(), GetLink(node), GetDate(node["date"]), string.Empty
                    );
                    item.IsFolder = true;
                    item.DetectSize( null );                    

                    res.Add( item );
                }
                else //image
                {
                    Boolean isExists;
                    String realPath, origPath;
                    String path = GetClientPath( node, true, out isExists, out realPath, out origPath );
                    Boolean isImg = true;
                    
                    if( !isExists )
                    {
                        path = GetClientPathFolder();
                        isImg = false;
                        origPath = string.Empty;
                    }

                    PhotoItem item = new PhotoItem( node.Title, node.Description, 
                        path, GetLink(node), GetDate(node["date"]), origPath
                    );
                    item.DetectSize( realPath );
                    if( isImg == true )
                        item.IsThumb = true;
                    else
                        item.IsFolder = true;

                    item.Shot = node["shot"];

                    res.Add( item );
                }
            }
        else
        {
            //String path = GetClientPath( nd, false );
            Boolean isExists;
            String realPath, origPath;
            String path = GetClientPath( nd, false, out isExists, out realPath, out origPath);
            if( isExists )
            {
                PhotoItem item = new PhotoItem( nd.Title, nd.Description, 
                    path, GetLink(nd), GetDate(nd["date"]), string.Empty
                );
                item.IsFolder = true;
                item.DetectSize( realPath );
                res.Add( item );
            }
        }

        PhotoItem.CalculateMaxSize( (ICollection)res );

        return ArrayList.Synchronized( res );
    }

    public static String GetDate( String xmlDate )
    {
        String res = String.Empty;
        if( xmlDate != null )
        {
            DateTime dt = XmlConvert.ToDateTime( xmlDate, XmlDateTimeSerializationMode.RoundtripKind );
            res = String.Format( "{0:F}", dt );
        }
        return res;
    }

    private static String GetClientPathFolder()
    {
        Page pg = (Page)HttpContext.Current.Handler;
        return pg.ResolveUrl( "images/folder2.gif" );
    }
    private String GetClientPath( SiteMapNode nd0, Boolean isThumbinal, out Boolean isExists, out String realPath, out string origPath)
    {
        StringBuilder bld = new StringBuilder();
        SiteMapNode nd = nd0;
        do
        {
            if( nd["path2"] != null )
            {
                if( bld.Length > 0 )
                    bld.Insert( 0, '/' );
                bld.Insert( 0, nd["path2"] );
            }
        } while( (nd = nd.ParentNode) != null );

        origPath = bld.ToString();
        String val = origPath;
        if( isThumbinal )
        {
            Int32 idxPt = val.LastIndexOf( '.' );
            if( idxPt == -1 )
                val += "_thumb";
            else
                val = val.Substring(0, idxPt) + "_thumb" + val.Substring(idxPt);
        }
        Page pg = (Page)HttpContext.Current.Handler;
        //String res = pg.ResolveUrl( val );
        String res = val;
        realPath = res;
        
        isExists = System.IO.File.Exists( HttpContext.Current.Request.MapPath(res) );
        if( !isExists )
            realPath = null;

        if( _useFullValidation )
        {
            if( isThumbinal )
                return String.Format( "IamgeHandler.ashx?id={0}&thumb=1", HttpContext.Current.Server.UrlEncode(nd0.Key) );
            else
                return String.Format( "IamgeHandler.ashx?id={0}", HttpContext.Current.Server.UrlEncode(nd0.Key) );
        }
        else
            return res;
    }
    private static String GetLink( SiteMapNode nd )
    {
        //Page pg = (Page)HttpContext.Current.Handler;
        //return pg.ClientScript.GetPostBackEventReference( pg.Master, nd.Url );
        return nd.Url;
    }

    [Serializable]
    public sealed class PhotoItem
    {
        private String _title, _description, _url, _link, _dt;
        private Int32 _width = 0, _height = 0;
        private Int32 _maxWidth = 0, _maxHeight = 0;
        private Boolean _isFolder = false;
        private Boolean _isThumb = false;

        public PhotoItem( String title, String description, String url, String link, String dt, string underlyingImageUrl )
        {
            _title = title;
            _description = description;
            _url = url;
            _link = link;
            _dt = dt;
            UnderlyingUrl = underlyingImageUrl;
        }

        internal void DetectSize( String realPath )
        {
            Page pg = (Page)HttpContext.Current.Handler;            
            String url = realPath == null ? _url:realPath;
            using( System.Drawing.Image img = System.Drawing.Image.FromFile(pg.MapPath(url)) )
            {                
                _width = img.Width;
                _height = img.Height;
            }
        }
        internal static void CalculateMaxSize( ICollection coll )
        {
            Int32 w = 0, h = 0;
            foreach( PhotoItem it in coll )
            {
                if( it.Width > w ) w = it.Width;
                if( it.Height > h ) h = it.Height;
            }
            foreach( PhotoItem it in coll )
            {
                it.MaxWidth = w;
                it.MaxHeight = h;
            }
        }

        public Boolean IsFolder
        {
            get { return _isFolder; }
            set { _isFolder = value; }
        }
        public Boolean IsThumb
        {
            get { return _isThumb; }
            set { _isThumb = value; }
        }

        public Int32 Width
        {
            get { return _width; }            
        }
        public Int32 Height
        {
            get { return _height; }            
        }
        public Int32 MaxWidth
        {
            get { return _maxWidth; }
            set { _maxWidth = value; }
        }
        public Int32 MaxHeight
        {
            get { return _maxHeight; }
            set { _maxHeight = value; }
        }

        public String  Title
        {
            get { return _title; }            
        }
        public String  Description
        {
            get { return _description; }            
        }
        public String  DescriptionWithDate
        {
            get{
                return _dt.Length > 0 ? (_description + (_description.Length > 0 ? "\r\n":String.Empty) + _dt):_description;
            }
        }
        public String Url
        {
            get { return _url; }
            set { _url = value; }
        }
        /// <summary>
        /// For thumbinal level keeps underlying image.
        /// </summary>
        public string UnderlyingUrl { get; private set; }
        public String  Link
        {
            get { return _link; }
            set { _link = value; }
        }

        public String DivWidth
        {
            get{
                return (_maxWidth + 16).ToString() + "px";
            }
        }
        public String DivHeight
        {            
            get{
                return (_maxHeight + 40).ToString() + "px";
            }
        }
        public String ImageClass
        {
            get{
                return _isFolder ? "ImagePhotoFld":"ImagePhoto";
            }
        }
        public String Date
        {
            get{
                return _dt;
            }
        }

        public string Shot { get; set; }
    }
}
