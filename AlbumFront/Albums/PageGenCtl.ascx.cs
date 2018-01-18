using System;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class PageGenCtl: System.Web.UI.UserControl
{
    public String GetKey()
    {
        return CurrentProvider.CurrentNode.Key + " - " + CurrentProvider.Name + " u:" +
            AWS.Utils.WebUtils.GetUserRoles();
    }

    public String Key
    {
        get { return GetKey(); }
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {           
        //SetLayout();
    }

    protected override void OnPreRender( EventArgs e )
    {
        SetLayout();
        base.OnPreRender( e );        
    }

    protected override void Render(HtmlTextWriter writer)
    {
        base.Render(writer);
    }

    public SiteMapProvider CurrentProvider
    {
        get{            
            return ((IMasterPageAccessor)Page.Master).Provider;
        }
    }

    bool IsGalery
    {
        get { return CurrentProvider.CurrentNode.ChildNodes.Count > 0; }
    }

    //Reserved for the future
    bool UseLightBox
    {
        get { return true; }
    }
    
    protected string GetRel(object item)
    {
        var phi = (PhotoPageData.PhotoItem)item;
        return !UseLightBox || phi.IsFolder || string.IsNullOrEmpty(phi.UnderlyingUrl) ? string.Empty : "data-rel='gal'";
    }

    protected string GetRef(object item)
    {
        var phi = (PhotoPageData.PhotoItem)item;
        return !UseLightBox || phi.IsFolder || string.IsNullOrEmpty(phi.UnderlyingUrl) ? string.Empty : "href='" + ResolveClientUrl(phi.UnderlyingUrl) + "'";
    }

    protected string GetOnClick(object item)
    {
        var phi = (PhotoPageData.PhotoItem)item;
        return !UseLightBox || phi.IsFolder || string.IsNullOrEmpty(phi.UnderlyingUrl) ? "onclick=\"" + phi.Link + "\"" : string.Empty;
    }

    protected string GetFullTitle(object item)
    {
        var phi = (PhotoPageData.PhotoItem)item;
        return !UseLightBox || phi.IsFolder ? string.Empty : string.Format("data-title='{0}'", BuildLightboxTitle(phi));
    }

    string BuildLightboxTitle(PhotoPageData.PhotoItem item)
    {
        StringBuilder bld = new StringBuilder();

        if (!string.IsNullOrEmpty(item.Title))
        {
            bld.Append("<b>");
            bld.Append(HttpUtility.HtmlEncode(item.Title));
            bld.Append("</b>");
        }

        if (!string.IsNullOrEmpty(item.Description))
        {
            bld.Append("&nbsp;&nbsp;");
            bld.Append(HttpUtility.HtmlEncode(item.Description));
        }

        var shot = item.Shot;

        if ((!string.IsNullOrEmpty(item.Title) || !string.IsNullOrEmpty(item.Description)) && (!string.IsNullOrEmpty(item.Date) || !string.IsNullOrEmpty(shot)))
            bld.Append("<br/>");

        if (!string.IsNullOrEmpty(item.Date))        
            bld.Append(item.Date);
        
        if (!string.IsNullOrEmpty(shot))
        {
            bld.Append(":&nbsp;&nbsp;");
            bld.Append(HttpUtility.HtmlEncode(shot));
        }

        return bld.ToString();
    }

    protected void SetLayout()
    {
        if (!Page.Master.Page.IsCallback)
        {
            if (IsGalery)
            {
                DataListThumb.Visible = true;
                DataListThumb.DataSourceID = "ObjectDataSource1";

                DataListImg.Visible = false;
                DataListImg.DataSourceID = null;

                idDateDiv.Visible = true;

                DataListThumb.DataBind();

                ScriptManager.RegisterStartupScript(this, GetType(), "execLightbox", LightboxScript, true);
            }
            else
            {
                DataListThumb.Visible = false;
                DataListThumb.DataSourceID = null;                

                DataListImg.Visible = true;
                DataListImg.DataSourceID = "ObjectDataSource1";

                idDateDiv.Visible = false;

                DataListImg.DataBind();
            }
        }
    }

    string LightboxScript
    {
        get { return "$('.ImagePane a[data-rel]:not([href=\"\"])').lightbox({'move': false})"; }
    }

    public void ObjectDataSource1_OjectCreating( Object sender, ObjectDataSourceEventArgs a )
    {
        a.ObjectInstance = new PhotoPageData( new MasterAcc((IMasterPageAccessor)Page.Master), GetKey() );
    }

    protected class MasterAcc: IMasterPageAccessor
    {        
        private IMasterPageAccessor _m;
        public MasterAcc( IMasterPageAccessor m )
        {
            _m = m;
        }
        public SiteMapProvider Provider
        {
            get { return _m.Provider; }
        }
    }

    protected string GetParentDate ()
    {
        if (CurrentProvider.CurrentNode.ParentNode == null && CurrentProvider.CurrentNode.ChildNodes.Count > 0)
            return PhotoPageData.GetDate(CurrentProvider.CurrentNode.ChildNodes[ 0 ]["date"]);

        return PhotoPageData.GetDate(CurrentProvider.CurrentNode[ "date" ]);
    }

    protected void ObjectDataSource1_DataBinding (object sender, EventArgs e)
    {
    }
}
