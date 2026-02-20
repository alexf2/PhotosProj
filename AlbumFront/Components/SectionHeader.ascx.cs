using System;

namespace AlbumFront.Components
{
    public partial class SectionHeader : System.Web.UI.UserControl
    {
        public string Name { get; set; }

        public string CssClass
        {
            get => RootElement.Attributes["class"] ?? "";
            set => RootElement.Attributes["class"] = $"SectionHeader {value}";
        }

        public string CssClassHeader
        {
            get => HeaderElement.Attributes["class"] ?? "";
            set => HeaderElement.Attributes["class"] = $"Wrapper {value}";
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}