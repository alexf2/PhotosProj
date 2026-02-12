using System;
using System.Web.UI;

namespace AlbumFront.Components
{
    public partial class CatItem : UserControl
    {
        private const string ImgCssBase = "FadeOnLoad EasingShadow";
        private string reportageDescription;

        public string Name { get; set; }
        public string Group { get; set; }
        public string Path { get; set; }
        public string Description { get; set; }
        public string MapName { get; set; }

        public string ReportageDescription
        {
            get
            {
                return string.IsNullOrEmpty(reportageDescription) ?
                    (HasALbum ? $"Репортаж {Description}" : Description)
                    :
                    reportageDescription;
            }
            set
            {
                reportageDescription = value;
            }
        }
        public string Login { get; set; }
        public string Pwd { get; set; }

        public string ImgCss { get; set; }

        public bool NewGal { get; set; } = false;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string GetPubUrl() => Page.ResolveUrl($"~/Pub/{Path ?? Name}/{Name}.{(NewGal ? "aspx" : "htm")}");

        public string GetAlbumUrl() => Page.ResolveUrl($"~/Albums/Login.aspx?login={Login}&pwd={Pwd}");

        public string GetImgUrl() => Page.ResolveUrl($"~/img/{Name}Thumb.jpg");

        public string GetGroupUrl() => Page.ResolveUrl($"~/Pub/{Group}/{Group}.{(NewGal ? "aspx" : "htm")}");

        public string GetMapUrl() => Page.ResolveUrl($"~/Pub/Maps/{MapName}.htm");

        public string GetImgClass() => $"{ImgCss} {ImgCssBase}";

        public bool HasALbum => !string.IsNullOrEmpty(Login);

        public bool HasGroup => !string.IsNullOrEmpty(Group);
        public bool HasMap => !string.IsNullOrEmpty(MapName);
    }
}
