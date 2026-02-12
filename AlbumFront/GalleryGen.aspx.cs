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
            // galleryPath = "Laplandia2020/Laplandia2020.aspx"

            string physicalPath = Server.MapPath("~/Pub/" + galleryPath.Replace(".aspx", ""));
            // Загружаете данные из ~/Pub/Laplandia2020/
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            DataBind();
        }
    }
}