using System;

namespace AlbumFront.Components
{
    public partial class SeoInformers : System.Web.UI.UserControl
    {
        public string CssClass
        {
            get => RootElement.CssClass;
            set => RootElement.CssClass = value;
        }

        public bool Render1GbInformer
        {
            get => OneGb.Visible;
            set => OneGb.Visible = value;
        }
        public bool RenderExtremeInformer
        {
            get => Extreme.Visible;
            set => Extreme.Visible = value;
        }
        public bool RenderMailRuInformer
        {
            get => MailRu.Visible;
            set => MailRu.Visible = value;
        }
        public bool RenderYandexInformer
        {
            get => Yandex.Visible;
            set => Yandex.Visible = value;
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}