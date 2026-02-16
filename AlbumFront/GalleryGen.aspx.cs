using System;
using System.Configuration;
using System.Web;

namespace AlbumFront
{
    public partial class GalleryGen : System.Web.UI.Page
    {
        protected string GetCanonicalUrl()
        {
            var domain = ConfigurationManager.AppSettings["CanonicalDomain"];
            var originalPath = Context.Items["OriginalGalleryPath"]?.ToString() ?? Request.Url.AbsolutePath;

            return "https://" + domain + "/Pub/" + originalPath;
        }

        protected string BackUrl
        {
            get
            {
                var referrer = Request.UrlReferrer;
                if (referrer == null)
                    return ResolveUrl("~/");

                var refHostPath = referrer.Host + referrer.AbsolutePath;
                var url = new Uri(HttpContext.Current.Items["OriginalAbsoluteUri"]?.ToString() ?? "/");
                var curHostPath = url.Host + url.AbsolutePath;

                if (string.Equals(refHostPath, curHostPath, StringComparison.OrdinalIgnoreCase))
                    return ResolveUrl("~/");

                return referrer.ToString();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string galleryPath = Context.Items["OriginalGalleryPath"]?.ToString();
            var virtualPath = "~/Pub/" + galleryPath.Replace(".aspx", "");
            var controlPath = virtualPath + ".ascx";

            if (!IsPostBack)
            {
                var gallery = LoadControl(controlPath);
                GalleryContent.Controls.Add(gallery);
            }

            var ascxFilePath = Server.MapPath(controlPath);
            HttpCachePolicy cache = Response.Cache;
            cache.SetCacheability(HttpCacheability.Public);
            cache.SetExpires(DateTime.Now.AddDays(1));
            cache.SetValidUntilExpires(true);
            Response.AddFileDependency(ascxFilePath);
            cache.VaryByParams["large"] = true;
            cache.VaryByParams["noviewer"] = true;
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            DataBind();
        }
    }
}