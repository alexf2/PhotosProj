using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace AlbumFront.Components
{
    public partial class PageFooter : System.Web.UI.UserControl
    {
        const string CSS_NAME = "page-footer-css";

        [PersistenceMode(PersistenceMode.InnerDefaultProperty)]
        [TemplateInstance(TemplateInstance.Single)]
        public ITemplate FooterTemplate { get; set; }

        public string CssClass
        {
            get => RootElement.Attributes["class"] ?? "";
            set => RootElement.Attributes["class"] = $"PageFooterLine {value}";
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
        protected void Page_Init(object sender, EventArgs e)
        {
            if (FooterTemplate != null)
            {
                FooterTemplate.InstantiateIn(FooterPlaceholder);
            }
        }
    }
}