using System;
using System.Configuration;
using System.Web;

namespace AlbumFront
{
    public partial class ThroughHorizonLanding : System.Web.UI.Page
    {
        protected string URL_HORIZON => "//boosty.to/through_horizon";
        protected string URL_ABOUT_HORIZON => "//boosty.to/through_horizon/posts/487bbf07-5b7a-4c56-9b24-621788b601c7?share=post_link";
        protected string URL_TG => "//t.me/+GH9OFfv-lRgxMDMy";
        protected string URL_ONE_DAY => "//boosty.to/through_horizon/purchase/3622358?ssource=DIRECT&share=subscription_link";
        protected string URL_PVD => "//boosty.to/through_horizon/purchase/3622368?ssource=DIRECT&share=subscription_link";
        protected string URL_FULL => "//boosty.to/through_horizon/purchase/3622371?ssource=DIRECT&share=subscription_link";

        protected string GetCanonicalUrl()
        {
            var domain = ConfigurationManager.AppSettings["CanonicalDomain"];
            var path = HttpContext.Current.Request.Url.AbsolutePath;

            return "https://" + domain + path;
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            DataBind();
        }
    }
}