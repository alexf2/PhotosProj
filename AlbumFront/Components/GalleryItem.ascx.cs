using System;
using System.Web;

namespace AlbumFront.Components
{
    public partial class GalleryItem : System.Web.UI.UserControl
    {
        string _dataTitle;

        public string Title
        {
            get;
            set;
        }
        public string File
        {
            get;
            set;
        }
        public string ThumbFile
        {
            get => File + "_thumb.jpg";
        }
        public string PubFile
        {
            get => (NoPub ? File : File + "_pub") + ".jpg";
        }
        public string FullFile
        {
            get => File + ".jpg";
        }
        public bool NoPub
        {
            get;
            set;
        } = false;

        public string ActiveFile
        {
            get
            {
                var qsValue = HttpContext.Current?.Request?.QueryString["large"];
                bool isLarge = !string.IsNullOrEmpty(qsValue) && qsValue == "1";

                return isLarge ? FullFile : PubFile;
            }
        }

        public string ThumbWidth
        {
            get;
            set;
        }

        public string ThumbHeight
        {
            get;
            set;
        }

        public string DataTitle
        {
            get { return HttpUtility.HtmlEncode(_dataTitle); }
            set { _dataTitle = value; }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            DataBind();
        }

    }
}