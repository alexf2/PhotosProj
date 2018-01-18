using System;
using System.Configuration;
using System.Web;
using System.Text;

using System.Threading;

namespace AWS {

    //http://msdn.microsoft.com/msdnmag/issues/03/06/Threading/default.aspx
    public class ImgHandler: IHttpAsyncHandler, IPostbackLinkUpdater
    {        
        public IAsyncResult BeginProcessRequest( HttpContext context, AsyncCallback cb, Object obj )
        {
            Boolean useFullValidation = AWS.Utils.WebUtils.GetFromString( ConfigurationManager.AppSettings["full-image-security-validation"], false );
            
            String imagePath;
            String requestPath = context.Request.FilePath;
            
            if( useFullValidation )
            {                
                Boolean isThumbinal = context.Request.QueryString["thumb"] == null ? false:true;
                
                requestPath = context.Request.QueryString[ "id" ];
                /*else
                {
                    if( (idx = requestPath.LastIndexOf(".")) != -1 )
                        requestPath = requestPath.Substring( 0, idx );

                    if( (idx = requestPath.ToLower().LastIndexOf("_thumb")) != -1 )
                    {
                        isThumbinal = true;
                        requestPath = requestPath.Substring( 0, idx );
                    }
                    else
                        isThumbinal = false;
                }*/

                SiteMapProvider prov = AWS.Utils.WebUtils.GetCurrProvider( context.Request );
                SiteMapNode nd = prov.FindSiteMapNodeFromKey( requestPath );
                if( nd == null )
                    imagePath = context.Server.MapPath( requestPath );
                else
                {
                    requestPath = GetClientPath( nd, isThumbinal );
                    if( !prov.SecurityTrimmingEnabled || prov.IsAccessibleToUser(context, nd) )
                        imagePath = context.Server.MapPath( requestPath );
                    else
                        throw new Exception( String.Format("Access to image is denied: '{0}'." + requestPath) );
                }
            }
            else
                imagePath = context.Server.MapPath( requestPath );
            

            MyAsyncRequestState st = new MyAsyncRequestState( context, cb, obj, imagePath );

            Thread t = new Thread( new ThreadStart(st.ProcessRequest) );
            t.Start();

            return st;
        }

        private sealed class MyAsyncRequestState: AWS.Utils.AsyncRequestState
        {    
            private String _filePath;

            public MyAsyncRequestState( HttpContext ctx, AsyncCallback cb, Object extraData, String filePath ):
                base(ctx, cb, extraData)
            {
                _filePath = filePath;
            }

            public override void ProcessRequest()
            {
                try
                {
                    _ctx.Response.Cache.SetCacheability( HttpCacheability.Private );
                    _ctx.Response.ContentType = AWS.Utils.WebUtils.GetMimeByExt( _filePath );
                    _ctx.Response.TransmitFile( _filePath );
                }
                finally
                {
                    CompleteRequest();
                }
            }
        }

        public void EndProcessRequest( IAsyncResult ar )
        {
            MyAsyncRequestState ars = ar as MyAsyncRequestState;
            if( ars != null )
                ars.Dispose();
        }

        void IPostbackLinkUpdater.UpdateLink( SiteMapNode node )
        {
            //simulate update
        }

        private static String GetClientPath( SiteMapNode nd0, Boolean isThumbinal )
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

            String val = bld.ToString();
            if( isThumbinal )
            {
                Int32 idxPt = val.LastIndexOf( '.' );
                if( idxPt == -1 )
                    val += "_thumb";
                else
                    val = val.Substring(0, idxPt) + "_thumb" + val.Substring(idxPt);
            }

            return val;
        }

        public void ProcessRequest( HttpContext context )
        {   
            throw new InvalidOperationException();         
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
