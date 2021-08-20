using System;
using System.Web.UI;

namespace AlbumFront
{
    public partial class CatItem : UserControl
    {
        private const string ImgCssBase = "FadeOnLoad EasingShadow";
        private string reportageDescription;

        public string Name { get; set; }
        public string Group { get; set; }
        public string Description { get; set; }

        public string ReportageDescription {
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

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string GetPubUrl() => ResolveClientUrl($"Pub/{Name}/{Name}.htm");

        public string GetAlbumUrl() => ResolveClientUrl($"Albums/Login.aspx?login={Login}&pwd={Pwd}");

        public string GetImgUrl() => ResolveClientUrl($"img/{Name}Thumb.jpg");

        public string GetGroupUrl() => ResolveClientUrl($"Pub/{Group}/{Group}.htm");

        public string GetImgClass() => $"{ImgCss} {ImgCssBase}";

        public bool HasALbum {
            get {
                return !string.IsNullOrEmpty(Login);
            }
        }
        public bool HasGroup
        {
            get
            {
                return !string.IsNullOrEmpty(Group);
            }
        }
    }
}
