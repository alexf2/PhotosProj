using System;
using System.Web.UI.HtmlControls;

namespace AlbumFront.Components
{
    public partial class Toggle : System.Web.UI.UserControl
    {
        const string CSS_NAME = "toggle-css";

        public string Title { get; set; }

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
    }
}