using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace AlbumFront.Components
{
    public partial class ShareLinkIcons : UserControl
    {
        const string CSS_NAME = "shared-link-icons-css";

        protected global::System.Web.UI.HtmlControls.HtmlGenericControl RootElement;

        public string CssClass
        {
            get => RootElement.Attributes["class"] ?? "";
            set => RootElement.Attributes["class"] = $"ShareLinkList {value}";
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            if (Page.Header != null && Page.Items[CSS_NAME] == null)
            {
                var link = new HtmlLink
                {
                    Href = Page.ResolveUrl($"~/bundles/{CSS_NAME}")
                };
                link.Attributes.Add("rel", "stylesheet");
                link.Attributes.Add("type", "text/css");
                Page.Header.Controls.Add(link);
                Page.Items[CSS_NAME] = true;
            }
        }

        string Description
        {
            get => Page.Title;
        }

        public string TelegramShareUrl
        {
            get
            {
                var currentUrl = HttpUtility.UrlEncode(Request.Url.AbsoluteUri);
                return $"https://t.me/share/url?url={currentUrl}&text={Description}";
            }
        }

        public string VkShareUrl
        {
            get
            {
                var currentUrl = HttpUtility.UrlEncode(Request.Url.AbsoluteUri);
                var imageUrl = HttpUtility.UrlEncode(Request.Url.GetLeftPart(UriPartial.Authority) + "/img/logo_23696-2.png");
                return $"https://vk.com/share.php?url={currentUrl}&title={Description}&image={imageUrl}";
            }
        }

        public string WhatsAppShareUrl
        {
            get
            {
                var currentUrl = HttpUtility.UrlEncode(Request.Url.AbsoluteUri);
                return $"https://api.whatsapp.com/send?text={Description}%20{currentUrl}";
            }
        }

        public string TwitterShareUrl
        {
            get
            {
                var currentUrl = HttpUtility.UrlEncode(Request.Url.AbsoluteUri);
                return $"https://twitter.com/intent/tweet?text={Description}&url={currentUrl}";
            }
        }
    }
}
