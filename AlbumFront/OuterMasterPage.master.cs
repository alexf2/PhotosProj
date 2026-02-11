using System;
using System.Configuration;
using System.Web;

namespace AlbumFront
{
    public partial class OuterMasterPage : System.Web.UI.MasterPage
    {
        protected string GetCanonicalUrl()
        {
            var domain = ConfigurationManager.AppSettings["CanonicalDomain"];
            var path = HttpContext.Current.Request.Url.AbsolutePath;

            // нормализуем домашнюю страницу
            if (string.Equals(path, "/default.aspx", StringComparison.OrdinalIgnoreCase))
                path = "/";


            return "https://" + domain + path;
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            DataBind();
        }
    }
}