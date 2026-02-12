using System;

namespace AlbumFront.Components
{
    public partial class SectionHeader : System.Web.UI.UserControl
    {
        public string Name { get; set; }

        public string CssClass
        {
            get => RootElement.Attributes["class"] ?? "";
            set => RootElement.Attributes["class"] = $"SectionHeaderBg {value}";
        }

        public string CssClassHeader
        {
            get => HeaderElement.Attributes["class"] ?? "";
            set => HeaderElement.Attributes["class"] = $"SectionHeader {value}";
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}