using System;
using System.Configuration;

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