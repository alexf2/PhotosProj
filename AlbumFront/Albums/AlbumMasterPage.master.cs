using System;
using System.Text;
using System.Xml;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading;

using System.ComponentModel;
using System.Collections.Specialized;

using AWS.Utils;

public partial class AlbumMasterPage: System.Web.UI.MasterPage, IPostBackDataHandler, IMasterPageAccessor, IPostbackLinkUpdater
{        
    private const String IS_NAV_TREE_SHOWN_DEF_STR = "true";
    private const Boolean IS_NAV_TREE_SHOWN_DEF = true;
    const string HistoryKey = "node";

    private Int32 _changeProps;
    private static SiteMapResolveEventHandler _h = null;

    private LocaleHelper _locHlp = new LocaleHelper();
    //private String _uiLocaleName = String.Empty;
    private String _requestedProviderName;

    private Boolean _requiresDataBinding = false;

    private String Hidden_IsNavTreeShown
    {
        get { return "__" + idBody.ClientID + "_IsNavShown"; }
    }

    private String Hidden_ScX
    {
        get { return "__" + idBody.ClientID + "_Scx"; }
    }
    private String Hidden_ScY
    {
        get { return "__" + idBody.ClientID + "_Scy"; }
    }
    private String Hidden_ScrollHeight
    {
        get { return "__" + idBody.ClientID + "_Sch"; }
    }
    private String Hidden_ScrollWidth
    {
        get { return "__" + idBody.ClientID + "_Scw"; }
    }

    private Int32 _treeScx = 0, _treeScy = 0;
    private Int32 _treeSch = 0, _treeScw = 0;


    public AlbumMasterPage()
    {
        _requestedProviderName = _locHlp.DefaultProvider; //by cookie        
    }

    [
        Bindable( false ),
        Browsable( false ),
        Themeable( false )
    ]
    protected String CurrentProvidername
    {
        get{
            Object o = ViewState[ "CurrentProvidername" ];
            return o == null ? _locHlp.DefaultProvider:(String)o;
        }
        set{
            ViewState[ "CurrentProvidername" ] = value;
        }
    }

    [
        Bindable( true ),
        Browsable( true ),
        Themeable( false ),
        DefaultValue( typeof(Boolean), IS_NAV_TREE_SHOWN_DEF_STR )
    ]
    protected Boolean IsNavigationTreeShown
    {
        get{
            Object o = ViewState[ "IsNavigationTreeShown" ];            
            return o == null ? IS_NAV_TREE_SHOWN_DEF:(Boolean)o;
        }
        set{
            ViewState[ "IsNavigationTreeShown" ] = value;
        }
    }

    [
        Bindable( true ),
        Browsable( true ),
        DefaultValue( typeof(String), "-1" ),
        Themeable( false )
    ]
    public String CurrentNode
    {
        get{
            Object o = ViewState[ "CurrentNode" ];
            return o == null ? Page.ResolveUrl("-1").ToLower():(String)o;
        }
        set{
            ViewState[ "CurrentNode" ] = (value != null ? value.ToLower():null); 
        }
    }

    protected override bool OnBubbleEvent( Object source, EventArgs args )
    {
        if( !(args is CommandEventArgs) )
            return false;	

        Control srcObj = (Control)source;
        Boolean res = true;
        CommandEventArgs a = (CommandEventArgs)args;
        HttpCookie cook;

	//L2.Text = string.Format("OnBubbleEvent: {0}  /{1}", srcObj.ID, a.CommandName);

        if( srcObj.ID == btnRus.ID || srcObj.ID == btnEng.ID )
        {
            LocaleElement loc = _locHlp.GetLocaleByProvider( a.CommandName );
            if( loc != null )
            {
                cook = Response.Cookies[ LocaleHelper.CONFG_COOKIE_NAME ];
                cook[ LocaleHelper.COOKIE_LANG_NAME ] = loc.ProviderName;
                cook.Expires = DateTime.Now.AddYears( 50 );
                ReadLocale( cook );

                SwitchSiteMapProvider( Request.QueryString["isTransfered"] != null );            

                //Response.Redirect( Request.Url.AbsolutePath, true );
                if( Request.QueryString["isTransfered"] == null )
                    Context.Server.Transfer( Request.RawUrl + "?isTransfered=" + CurrentProvidername, true );            
                else
                    Context.RewritePath( Request.RawUrl, Request.PathInfo, "" );
            }
            else
                return base.OnBubbleEvent( source, args );
        }
        else if (srcObj.ID == btnHome.ID)
        {
            /*int idx = Request.Url.AbsoluteUri.IndexOf(Request.ApplicationPath);
            if (idx != -1)
            {                
                Context.Response.Redirect(Request.Url.AbsoluteUri.Substring(0, idx), true);
            }*/
            Context.Response.Redirect(string.Format("{0}{1}{2}:{3}", Request.Url.Scheme, Uri.SchemeDelimiter,  Request.Url.Host, Request.Url.Port));
        }
        else
        {
            switch (srcObj.ID)
            {
                case "btnPrev":
                case "btnUp":
                case "btnDown":
                case "btnNext":
                    break;

                case "btnLogOff":
                    FormsAuthentication.SignOut();
                    Session.Abandon();
                    Response.Redirect("~/login.aspx");                    
                    break;

                default:
                    res = false;
                    break;
            }
        }

        return res;
    }

    public SiteMapNode GetCurrNode()
    {
        SiteMapNode res;
        String key = CurrentNode;
        if( key == null )            
            res = Provider.RootNode;
        else
            res = Provider.FindSiteMapNode( key );

        return res == null ? Provider.RootNode:res;
    }

    public SiteMapProvider Provider
    {
        get{
            return SiteMap.Providers[ CurrentProvidername ];
        }
    }

    public String Hello
    {
        get { return "hello"; }
    }

    protected void OnScmNavigateHistory (object sender, HistoryEventArgs args)
    {
	    string state = args.State[ HistoryKey ];
	    //L1.Text = "OnScmNavigateHistory: " + state;
	    CurrentNode = string.IsNullOrEmpty(state) ? Page.ResolveUrl("-1"):state;
    }

    string safeGetNodeDesription (SiteMapNode node)
    {
	    return node == null ? "Unknown":node.Title;
    }

    Boolean IPostBackDataHandler.LoadPostData( String k, NameValueCollection postCollection )
    {
//L1.Text = string.Format("LoadPostData: {0}  /{1}  /{2}  /{3} /{4}", k, postCollection["__EVENTTARGET"], postCollection["__EVENTARGUMENT"], ScriptManagerMain.IsNavigating, IsPostBack);

        _changeProps = 0;
        if( postCollection["__EVENTTARGET"] == ClientID )
        {
            String val = postCollection[ "__EVENTARGUMENT" ];
            if( val != CurrentNode )
            {
                CurrentNode = val;
                _changeProps |= 1;            

		if (ScriptManagerMain.EnableHistory && CurrentNode != null && !ScriptManagerMain.IsNavigating && ScriptManagerMain.IsInAsyncPostBack && !Page.IsCallback)
	    	{
	   	   ScriptManagerMain.AddHistoryPoint(HistoryKey, CurrentNode, safeGetNodeDesription(GetCurrNode()));
	    	}
	    }

        }

        if( postCollection[Hidden_ScX] != null )
        {
            String val = postCollection[ Hidden_ScX ];
            _treeScx = XmlConvert.ToInt32( val );
        }
        if( postCollection[Hidden_ScY] != null )
        {
            String val = postCollection[ Hidden_ScY ];
            _treeScy = XmlConvert.ToInt32( val );
        }

        if( postCollection[Hidden_ScrollHeight] != null )
        {
            String val = postCollection[ Hidden_ScrollHeight ];
            _treeSch = XmlConvert.ToInt32( val );
        }
        if( postCollection[Hidden_ScrollWidth] != null )
        {
            String val = postCollection[ Hidden_ScrollWidth ];
            _treeScw = XmlConvert.ToInt32( val );
        }

        

        Boolean isNavigationTreeShown = WebUtils.GetBooleanFromStr( postCollection[Hidden_IsNavTreeShown], IS_NAV_TREE_SHOWN_DEF );

        if( IsNavigationTreeShown != isNavigationTreeShown )
        {
            IsNavigationTreeShown = isNavigationTreeShown;
            _changeProps |= 2;
        }

        return _changeProps != 0;
    }

    void IPostBackDataHandler.RaisePostDataChangedEvent()
    {
    }

    string GetKeywords()
    {
        var root = Provider.RootNode;
        var bld = new StringBuilder();
        if (root != null && root.HasChildNodes)
        {
            foreach (SiteMapNode node in root.ChildNodes)
            {
                if (bld.Length > 0)
                    bld.Append(", ");
                bld.Append(node.Title);
            }
        }
        return bld.ToString();
    }

    protected void Page_Load( object sender, EventArgs e )
    {
        SwitchSiteMapProvider( true );

        //if( !Page.IsCallback )
        //SyncTree();

        if (!Page.IsCallback)
        {
            Page.RegisterRequiresPostBack(this);
            Page.MetaKeywords = GetKeywords();
        }
        
        //Membership.

        //фикс глюка с текущем узлом (их постепенно становится много) для CssFriendly adapter
        //без адаптера не нужен
        if (TreeView1.Nodes.Count > 0)
        {
            int t = 0;
            TreeNode last = null;
            countAndDeselectNodes(TreeView1.Nodes[0], ref t, ref last);
    
            //if (t > 0)                
                //last.Select();
        }
    }

    void countAndDeselectNodes(TreeNode nd, ref int cnt, ref TreeNode l)
    {
        if (nd.Selected)
        {
            ++cnt;
            l = nd;
            l.Selected = false;
        }

        if (nd.ChildNodes.Count > 0)
            foreach (TreeNode n in nd.ChildNodes)
                countAndDeselectNodes(n, ref cnt, ref l);        
    }

    private void SyncTree()
    {
        List<SiteMapNode> lst = new List<SiteMapNode>();
        SiteMapNode nd = GetCurrNode();
        do {
            lst.Insert( 0, nd );
        } while( (nd = nd.ParentNode) != null );

        StringBuilder bld = new StringBuilder();
        foreach( SiteMapNode nd2 in lst )
        {
            if( bld.Length > 0 )
                bld.Append( TreeView1.PathSeparator );
            //bld.Append( nd2.Title );
            bld.Append( nd2.Key );

            TreeNode ndt = TreeView1.FindNode( bld.ToString() );
            if( ndt != null )
            {                
                ndt.Select();
                ndt.Expand();
            }
        }
    }

    public void SwitchSiteMapProvider( Boolean enableRebind )
    {
        Boolean needRebind = false;
        if( CurrentProvidername != _requestedProviderName )
        {
            CurrentProvidername = _requestedProviderName;
            SiteMapDataSource1.SiteMapProvider = CurrentProvidername;
            SiteMapPath1.SiteMapProvider = CurrentProvidername;
            //CheckUpdateSiteMap();

            needRebind = true;
        }

        LocaleElement loc = _locHlp.GetLocaleByProvider( CurrentProvidername );
        if( String.Compare( Thread.CurrentThread.CurrentCulture.Name, loc.Culture, true) != 0 )
        {
            Thread.CurrentThread.CurrentUICulture =
            Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture( loc.Culture );
            needRebind = true;
        }

        if( enableRebind && needRebind )
        {
            //pgGen = (ASP.pagegen_aspx)((ContentPlaceHolder)idPhotosPlace).Page;
            //pgGen.
            //Control cc = idPhotosPlace;

            /*this.DataBind();
            //idPhotosPlace.DataBind();
            if( !Page.IsCallback )
                SyncTree();*/
            _requiresDataBinding = true;
        }
    }

    private void ReadLocale( HttpCookie cook )
    {
        if( Request.QueryString["isTransfered"] != null )
            _requestedProviderName = Request.QueryString[ "isTransfered" ];
        else
        {
            if( cook == null )
                _requestedProviderName = this._locHlp.DefaultProvider;
            else
                _requestedProviderName = cook[ LocaleHelper.COOKIE_LANG_NAME ];        
        }
    }

    protected override void OnInit( EventArgs e )
    {
        ReadLocale( Request.Cookies[LocaleHelper.CONFG_COOKIE_NAME] );
        //CheckUpdateSiteMap();

        /*lock( SiteMap.Provider )
        {
            if( _h == null )
            {
                _h = new SiteMapResolveEventHandler( ResolveIds );
                SiteMap.SiteMapResolve += _h;
            }
        }*/
        lock( SiteMap.Providers )
        {
            if( _h == null )
            {                
                _h = new SiteMapResolveEventHandler( ResolveIds );
                foreach( SiteMapProvider prov in SiteMap.Providers )
                    prov.SiteMapResolve += _h;
            }
        }
        base.OnInit( e );        
    }
    private void ChooseStateImageForButton( ImageButton btn )
    {
        String url = (btn.Enabled ? btn.Attributes["aws-url"]:btn.Attributes["aws-url-d"]);
        url = Page.ResolveUrl( url );
        if( String.Compare(btn.ImageUrl, url, true) != 0 )
            btn.ImageUrl = url;
    }

    protected override void OnPreRender( EventArgs e )
    {        
        base.OnPreRender( e );

        if( _requiresDataBinding /*|| !Page.IsPostBack*/ )
            Page.DataBind();

        if( Page.IsPostBack && !Page.IsCallback )
            SyncTree();


        String priv, next, parent;
        GetNodesFor( CurrentNode, out priv, out next, out parent );
        AssignClientUrlAction( btnPrev, priv );
        AssignClientUrlAction( btnUp, parent );
        AssignClientUrlAction( btnNext, next );        

        ChooseStateImageForButton( btnPrev );
        ChooseStateImageForButton( btnUp );
        ChooseStateImageForButton( btnNext );
        //ChooseStateImageForButton( btnLogOff );

        if( IsNavigationTreeShown )
        {
            idDivLeft.Style[ HtmlTextWriterStyle.Display ] = "block";
            idDivLeft.Style[ HtmlTextWriterStyle.Visibility ] = "visible";

            //idTreeTable.Style[ HtmlTextWriterStyle.Display ] = "block";
            //idTreeTable.Style[ HtmlTextWriterStyle.Visibility ] = "visible";

            idDivLeft.Attributes["width"] = "20%";
        }
        else
        {
            idDivLeft.Style[ HtmlTextWriterStyle.Display ] = "none";
            idDivLeft.Style[ HtmlTextWriterStyle.Visibility ] = "hidden";

            //idTreeTable.Style[ HtmlTextWriterStyle.Display ] = "none";
            //idTreeTable.Style[ HtmlTextWriterStyle.Visibility ] = "hidden";

            idDivLeft.Attributes["width"] = "1px";
        }

        StringBuilder bld;

        if( !Page.ClientScript.IsStartupScriptRegistered(idBody.ClientID + "_ScrFrameMapRuntime") )
        {
            bld = new StringBuilder();
            bld.AppendFormat( "<script language=\"javascript\">\r\ndocument.getElementById('{0}').awsFrameMapRuntime = new Object();\r\n",
                idBody.ClientID );
            bld.AppendFormat( "var tmpInit = document.getElementById('{0}').awsFrameMapRuntime;\r\n", idBody.ClientID );

            WebUtils.GenerateCustomIdsMap( bld, "tmpInit",
                "isNavTreeShown", XmlConvert.ToString(IsNavigationTreeShown),

                "hiddenIsNavTreeShown", Hidden_IsNavTreeShown,
                "formID" , form1.ClientID,
                "hiddenScx" , Hidden_ScX,
                "hiddenScy" , Hidden_ScY,
                "hiddenSch" , Hidden_ScrollHeight,
                "hiddenScw" , Hidden_ScrollWidth,
                "treeContId" , idDivLeft.ClientID
                /*"apsNet_TreeViewSelNodeInputID", TreeView1.ClientID + "_SelectedNode",
                "treeContainerID", idDivLeft.ClientID */
            );

            bld.Append( "</script>" );
            Page.ClientScript.RegisterStartupScript( this.GetType(), idBody.ClientID + "_ScrFrameMapRuntime", bld.ToString(), false );
        }

        Page.ClientScript.RegisterHiddenField( Hidden_IsNavTreeShown, "" );

        Page.ClientScript.RegisterHiddenField( Hidden_ScX, XmlConvert.ToString(_treeScx) );
        Page.ClientScript.RegisterHiddenField( Hidden_ScY, XmlConvert.ToString(_treeScy) );

        Page.ClientScript.RegisterHiddenField( Hidden_ScrollHeight, XmlConvert.ToString(_treeSch) );
        Page.ClientScript.RegisterHiddenField( Hidden_ScrollWidth, XmlConvert.ToString(_treeScw) );

        if( !Page.ClientScript.IsStartupScriptRegistered(idBody.ClientID + "_ScrFrameMap") )
        {
            bld = new StringBuilder();
            bld.AppendFormat("<script language=\"javascript\">\r\ndocument.getElementById('{0}').awsFrameMap = new Object();\r\n",
                idBody.ClientID );
            bld.AppendFormat( "var tmpInit = document.getElementById('{0}').awsFrameMap;\r\n", idBody.ClientID );

            WebUtils.GenerateIdsMap( bld, "tmpInit",
                btnHideTree,
                UpdButtons.FindControl("btnPrev"),
                UpdButtons.FindControl("btnNext"),
                UpdButtons.FindControl("btnUp")
            );

            bld.Append("</script>");
            Page.ClientScript.RegisterStartupScript( this.GetType(), idBody.ClientID + "_ScrFrameMap", bld.ToString(), false );
        }

        if( !Page.ClientScript.IsStartupScriptRegistered(idBody.ClientID + "_ScrMaster") )
        {
            bld = new StringBuilder();
            bld.AppendFormat("<script language=\"javascript\">\r\ndocument.getElementById('{0}').awsMaster = new Master('{0}', '{1}');\r\n",
                idBody.ClientID, idDivLeft.ClientID);
            bld.AppendFormat( "var tmpInit = document.getElementById('{0}').awsMaster;\r\n", idBody.ClientID );
            bld.Append( "tmpInit.init();" );

            bld.Append("</script>");
            Page.ClientScript.RegisterStartupScript( this.GetType(), idBody.ClientID + "_ScrMaster", bld.ToString(), false );
        }
    }

    private void AssignClientUrlAction( ImageButton btn, String urlToGo )
    {
        if( urlToGo == null )
        {
            btn.OnClientClick = null;
            btn.Enabled = false;
        }
        else
        {
            if( urlToGo.IndexOf("javascript:", StringComparison.OrdinalIgnoreCase) == -1 )
                urlToGo = GetScriptForNavigationPostback( urlToGo );
            btn.Enabled = true;
            btn.OnClientClick = urlToGo;
        }
    }

    private void GetNodesFor( String nodeFor, out String previous, out String next, out String parent )
    {
        //SiteMapProvider prov = SiteMap.Providers[  CurrentProvidername ];
        SiteMapNode currNod = GetCurrNode();
        if( currNod.PreviousSibling == null )
            previous = null;
        else
            previous = currNod.PreviousSibling.Url;

        if( currNod.NextSibling == null )
            next = null;
        else
            next = currNod.NextSibling.Url;

        if( currNod.ParentNode == null )
            parent = null;
        else
            parent = currNod.ParentNode.Url;
    }
    

    protected static SiteMapNode ResolveIds( Object sender, SiteMapResolveEventArgs e )
    {
        /*SiteMapProvider prov = (SiteMapProvider)sender;
        SiteMapNode nn = prov.FindSiteMapNode( HttpContext.Current );
        nn = nn.Clone( true );
        nn.Url += "_ppp";*/

        AlbumMasterPage pg = ((Page)HttpContext.Current.Handler).Master as AlbumMasterPage;
        if( pg == null )
            return e.Provider.FindSiteMapNode( HttpContext.Current );            
        else         
            return  pg.GetCurrNode();
    }

    /*private void UpdateNodes( SiteMapNode nd )
    {
        MakeUpdateNode( nd );
        foreach( SiteMapNode node in nd.GetAllNodes() )
            MakeUpdateNode( node );
        
    }*/

    void IPostbackLinkUpdater.UpdateLink( SiteMapNode node )
    {
        MakeUpdateNode( node );
    }

    private void MakeUpdateNode( SiteMapNode node )
    {
        //if( node.ReadOnly )
        if( node.Url.IndexOf("javascript:") == -1 )
        {
            node.ReadOnly = false;
            node.Url = GetScriptForNavigationPostback( node.Url );            
        }
    }
    private String GetScriptForNavigationPostback( String url )
    {
        return "javascript:" + Page.ClientScript.GetPostBackEventReference( this, url );
    }
    protected void TreeView1_SelectedNodeChanged( object sender, EventArgs e )
    {
        /*TreeView tw = (TreeView)sender;
        if( tw.SelectedNode != null )
            tw.SelectedNode.SelectAction = TreeNodeSelectAction.SelectExpand;*/
    }
    protected void btn_Command(object sender, CommandEventArgs e)
    {

    }
    protected void SiteMapDataSource1_DataBinding(object sender, EventArgs e)
    {

    }

    public String GetLayout ()
    {
        HttpBrowserCapabilities caps = Request.Browser;
        return caps.Browser.ToUpper().IndexOf("IE") > -1 ? "fixed":"auto";
    }
}


