using System;

namespace AlbumFront
{
    public partial class Error : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            Elmah.ErrorSignal.FromCurrentContext().Raise(ex);
            Server.ClearError();
        }
    }
}