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

            if (!IsPostBack)
            {
                var gallery = LoadControl(virtualPath + ".ascx");
                GalleryContent.Controls.Add(gallery);
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            DataBind();
        }
    }
}