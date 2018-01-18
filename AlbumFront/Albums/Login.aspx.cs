using System;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

using AWS.Utils;

public partial class Login : Page
{
    private Boolean _loginViaHttps = WebUtils.GetFromString( ConfigurationManager.AppSettings["login-via-https"], false );
    

    protected void Page_Load(object sender, EventArgs e)
    {
        //CultureInfo inf1 = System.Threading.Thread.CurrentThread.CurrentCulture;
        //CultureInfo inf2 = System.Threading.Thread.CurrentThread.CurrentUICulture;

        if (Request.QueryString["login"] != null && !IsPostBack)
	    {
                Login1.UserName = Request.QueryString["login"];
                if (Request.IsAuthenticated)
                    FormsAuthentication.SignOut();
        }
	    else if (Request.IsAuthenticated)	               
		    Response.Redirect(FormsAuthentication.DefaultUrl, true);

        if (!IsPostBack)
            Form.DefaultButton = Login1.FindControl("LoginButton").UniqueID;


        if (Request.QueryString["pwd"] != null)
        {
            //Login1. Password = Request.QueryString["pwd"];
            //Object o =Login1.Controls;
            TextBox pwd = (TextBox)Login1.FindControl( "Password" );
            if( pwd != null )
            {
                //pwd.Text = Request.QueryString[ "pwd" ];

                if( !Page.ClientScript.IsStartupScriptRegistered("InitPwd") )
                    Page.ClientScript.RegisterStartupScript( this.GetType(), "InitPwd",
                        String.Format("<script language=\"javascript\">document.getElementById('{0}').value='{1}';</script>", pwd.ClientID, Request.QueryString["pwd"])
                    );            
            }
        }
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();

    }

    protected override bool OnBubbleEvent ( Object source, EventArgs args )
    {        
        if (!(args is CommandEventArgs))
            return false;

        Control srcObj = (Control)source;
        Boolean res = false;
        CommandEventArgs a = (CommandEventArgs)args;

        if (srcObj.ID == btnHome.ID)
        {
            res = true;
            /*int idx = Request.Url.AbsoluteUri.IndexOf(Request.ApplicationPath);
            if (idx != -1)
                Context.Response.Redirect(Request.Url.AbsoluteUri.Substring(0, idx), true);*/
            Context.Response.Redirect(string.Format("{0}{1}{2}:{3}", Request.Url.Scheme, Uri.SchemeDelimiter, Request.Url.Host, Request.Url.Port));
        }

        return res;
    }

    protected override void InitializeCulture()
    {
        AWS.Utils.WebUtils.SetLocale( Request );
        base.InitializeCulture();
    }

    protected override void OnInit( EventArgs e )
    {
        if( !Request.IsSecureConnection && _loginViaHttps )
            SslTools.SwitchToSsl();

        base.OnInit( e );
    }
    protected void Login1_OnLoggedIn( Object sender, EventArgs e )
    {
        if( _loginViaHttps )
        {
	        String url;
	        if( Request.QueryString["ReturnUrl"] != null && Request.QueryString["ReturnUrl"].Length != 0 )
		        url = Request.QueryString["ReturnUrl"];
	        else
		        url = FormsAuthentication.DefaultUrl;

	        url = ResolveClientUrl( url );
	        url = SslTools.GetAbsoluteUrl( url, ProtocolOptions.Http );

	        Response.Redirect( url, true );
        }
    }
}
