using System;
using System.Xml;
using System.Text;
using System.Threading;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Reflection;
using System.Drawing;
using System.IO;
using System.Collections.Specialized;

namespace AWS.Utils
{
    public abstract class AsyncRequestState: IAsyncResult
    {
        protected HttpContext _ctx;
        protected AsyncCallback _cb;
        protected object _extraData;

        private bool _isCompleted = false;
        private ManualResetEvent _callCompleteEvent = null;

        public AsyncRequestState( HttpContext ctx, AsyncCallback cb, Object extraData )
        {
            _ctx = ctx;
            _cb = cb;
            _extraData = extraData;
        }

        //should call CompleteRequest()
        public abstract void ProcessRequest();
        public virtual void Dispose()
        {
        }

        protected void CompleteRequest()
        {
            _isCompleted = true;

            if( _callCompleteEvent != null )
                lock( this )
                {
                  if( _callCompleteEvent != null )
                    _callCompleteEvent.Set();
                  _callCompleteEvent = null;
                }

            if( _cb != null )
              _cb( this );
        }

        public object AsyncState           
        { 
            get { return(_extraData); } 
        }
        public bool CompletedSynchronously 
        { 
            get { return(false); }
        }
        public bool IsCompleted            
        { 
            get { return(_isCompleted); }
        }
        public WaitHandle AsyncWaitHandle
        {
            get
            {
              if( _callCompleteEvent == null )
                  lock( this )
                  {
                    if( _callCompleteEvent == null )
                        _callCompleteEvent = new ManualResetEvent( false ); 
                  }
              return _callCompleteEvent;
            }
        }
    }

    public static class WebUtils
    {
        public static Boolean GetFromString( String val, Boolean defVal )
        {
            return val == null ? defVal:XmlConvert.ToBoolean( val );
        }
        public static Int32 GetFromString( String val, Int32 defVal )
        {
            return val == null ? defVal:XmlConvert.ToInt32( val );
        }

        public static String GetMimeByExt( String path )
        {
            String res;
			switch( Path.GetExtension(path).ToLower() )
			{
				case ".bmp":
					res = "image/bmp";
					break;
				case ".emf":
					res = "image/x-emf";
					break;
				case ".aiff":
					res = "audio/x-aiff";
					break;
				case ".gif":
					res = "image/gif";
					break;
				case ".ico":
					res = "image/ico";
					break;
				case ".jpg":
					res = "image/jpeg";
					break;
				case ".png":
					res = "image/png";
					break;
				case ".tif":
					res = "image/tif";
					break;
				case ".wmf":
					res = "image/x-wmf";
					break;
				default:
					res = "application/octet-stream";
					break;
			}
			return res;
        }

        public static LocaleElement DetectLocale( HttpRequest req )
        {
            LocaleElement requiredLoc;
            
            LocaleHelper hlp = new LocaleHelper();
            HttpCookie cook = req.Cookies[ LocaleHelper.CONFG_COOKIE_NAME ];        

            if( req.QueryString["isTransfered"] != null )
                requiredLoc = hlp.GetLocaleByProvider( req.QueryString["isTransfered"] );
            else
                requiredLoc = (cook == null ? hlp.DefaultLocale:hlp.GetLocaleByProvider( cook[LocaleHelper.COOKIE_LANG_NAME] ));

            return requiredLoc;
        }

        public static String GetCurrProviderName( HttpRequest req )
        {
            LocaleHelper hlp = new LocaleHelper();
            HttpCookie cook = req.Cookies[ LocaleHelper.CONFG_COOKIE_NAME ];

            if( req.QueryString["isTransfered"] != null )
                return req.QueryString[ "isTransfered" ];
            else
                return cook == null ? hlp.DefaultProvider:cook[ LocaleHelper.COOKIE_LANG_NAME ];
        }
        public static SiteMapProvider GetCurrProvider( HttpRequest req )
        {
            return SiteMap.Providers[ GetCurrProviderName(req) ];
        }

        public static void SetLocale( HttpRequest req )
        {
            try
		    {
			    /*if( Request.UserLanguages != null && Request.UserLanguages.Length > 0 )
			    {
				    CultureInfo ci = CultureInfo.CreateSpecificCulture( Request.UserLanguages[0] );
				    Thread th = Thread.CurrentThread;
				    th.CurrentUICulture = th.CurrentCulture = ci;
			    }*/
                
                /*cook = Response.Cookies[ CONFG_COOKIE_NAME ];
                cook[ COOKIE_LANG_NAME ] = loc.ProviderName;
                
                if( String.Compare( Thread.CurrentThread.CurrentCulture.Name, loc.Culture, true) != 0 )*/            
                
                LocaleHelper hlp = new LocaleHelper();            
                LocaleElement requiredLoc = WebUtils.DetectLocale( req );

                if( String.Compare(Thread.CurrentThread.CurrentCulture.Name, requiredLoc.Culture, true) != 0 ||
                    String.Compare(Thread.CurrentThread.CurrentUICulture.Name, requiredLoc.Culture, true) != 0
                  )
                    Thread.CurrentThread.CurrentCulture = Thread.CurrentThread.CurrentUICulture =
                        System.Globalization.CultureInfo.CreateSpecificCulture( requiredLoc.Culture );
		    }
		    catch( Exception )
		    {
		    }
        }

        public static String GetUserRoles()
        {            
            if( HttpContext.Current.User != null && HttpContext.Current.User.Identity != null )
            {
                String[] roles = System.Web.Security.Roles.GetRolesForUser( HttpContext.Current.User.Identity.Name );
                StringBuilder bld = new StringBuilder();
                foreach( String r in roles )
                {
                    if( bld.Length > 0 )
                        bld.Append( ',' );
                    bld.Append( r );
                }
                return bld.ToString();
            }
            else
                return String.Empty;
        }

        public static void AssignProtectedControls( Control root, Control ctl )
        {
            Type t = root.GetType();
            foreach( Control c in ctl.Controls )
            {
                if( c.ID != null && c.ID.Length > 0 )
                {
                    FieldInfo fi = t.GetField( c.ID, BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.IgnoreCase );
                    if( fi != null )
                        try
                        {
                            fi.SetValue( root, c );
                        }
                        catch( ArgumentException e )
                        {
                            throw new ApplicationException(String.Format("Protected field '{0}' is of incompatible type with server control. Control is [{1}], but field is [{2}].", fi.Name, c.GetType().Name, fi.FieldType.Name), e);
                        }
                }

                AssignProtectedControls(root, c);
            }
        }

        public static void SetViewStateFlagOnChildren( Control ctl, Boolean flag )
        {
            foreach( Control c in ctl.Controls )
            {
                c.EnableViewState = flag;
                SetViewStateFlagOnChildren( c, flag );
            }
        }

        public static void GenerateIdsMap( StringBuilder bld, String varName, params Control[] ctls )
        {
            foreach( Control ctl in ctls )
                if( ctl != null )
                    bld.AppendFormat( "{0}.{1} = '{2}';\r\n", varName, ctl.ID, ctl.ClientID );
        }

        public static String ToColor16Str( Color c )
        {
            return "0x" + Convert.ToString(c.ToArgb() & 0xffffff, 16);
        }
        public static void GenerateCustomIdsMap( StringBuilder bld, String varName, params String[] args )
        {
            for( Int32 i = 0; i < args.Length; i += 2 )
                if( args[i + 1] != null )
                    bld.AppendFormat( "{0}.{1} = \"{2}\";\r\n", varName, args[i], args[i + 1] );
        }

        public static Single GetSingleFromStr(String str)
        {
            if (str.Length == 0) return 0;
            return Convert.ToSingle( str, CultureInfo.InvariantCulture );
        }
        public static Boolean GetBooleanFromStr( String str, Boolean defaultVal )
        {
            if( str.Length == 0 ) return defaultVal;
            return Convert.ToBoolean( str, CultureInfo.InvariantCulture );
        }
        public static void LoadIds( StringDictionary visIDs, String strIDs )
        {
            foreach( String id in strIDs.Split(',') )
                visIDs[id] = null ;
        }

        public static Control FindControlEx( string controlID, ControlCollection controls )
        {
            foreach( Control c in controls )
            {
                if( c.ID == controlID )
                    return c;

                if( c.HasControls() )
                {
                    Control cTmp = WebUtils.FindControlEx( controlID, c.Controls );
                    if( cTmp != null )
                        return cTmp;
                }
            }

            return null;
        }
    }

    public class RcHelper
    {
        System.Resources.ResourceManager _rc;
        public RcHelper( System.Resources.ResourceManager rc )
        {
            _rc = rc;
        }
        public String this[ String key ]
        {
            get
            {
                return _rc.GetString( key );
            }
        }
        public void LoadTitles( Control ctl, params Object[] prms )
        {
            for( Int32 i = 0; i < prms.Length; i += 2 )
                if( prms[i] != null )
                    ((IAttributeAccessor)prms[ i ]).SetAttribute( "title", this[(String)prms[i + 1]] );
        }

        public static String GetTextResource( String baseName, Assembly srcAssembly )
        {
            using( StreamReader rd = new StreamReader(srcAssembly.GetManifestResourceStream(baseName)) )
                return rd.ReadToEnd();
        }
    }
}
