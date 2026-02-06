<%@ Application Language="C#" %>
<%@ Import Namespace="System.Web.Hosting" %>
<%@ Import Namespace = "System.Web.Routing" %>


<script runat="server">
    const string TestJsFileName = "~/Scripts/jquery*.js";
    string _jqueryVersion;
        
    public override string GetVaryByCustomString( HttpContext context, string custom )
    {
        if( custom == "awsPg" )
        //if( custom != null )
        {
            /*if( context.Handler != null )
            {
                ICustomCacheInfo h = (ICustomCacheInfo)context.Handler;
                return h.GetKey();
            }
            else*/
            {
                String k = context.Request.Form[ "__EVENTARGUMENT" ];
                if( k != null )
                    k = k.Trim();
                if( k == null || k.Length == 0 )
                    return base.GetVaryByCustomString( context, custom );
                
                HttpCookie cook = Request.Cookies[ LocaleHelper.CONFG_COOKIE_NAME ];
                if( cook != null )
                {
                    LocaleElement requiredLoc = AWS.Utils.WebUtils.DetectLocale( Request );
                    k += " - " + requiredLoc.ProviderName;
                }
                k = k.ToLower();
                return k;
                //return base.GetVaryByCustomString( context, custom );
            }            
        }
        else
            return base.GetVaryByCustomString( context, custom );
    }
        
    
    void Application_Start(object sender, EventArgs e) 
    {
        _jqueryVersion = GetJqueryVer(TestJsFileName);
        
        registerRoutes(RouteTable.Routes);
        
        registerScriptMappins(ScriptManager.ScriptResourceMapping);
        //addAjaxMappings(ScriptManager.ScriptResourceMapping);
        //addWebFormsMapping(ScriptManager.ScriptResourceMapping);
        
        registerBundles(BundleTable.Bundles);        
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }

    

    void Application_BeginRequest( Object sender, EventArgs e )
    {
        AWS.Utils.WebUtils.SetLocale( Request );
    }
        

    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
    
    void registerRoutes (RouteCollection routes)
    {
        routes.Add(new Route("{resource}.axd/{*pathInfo}", new StopRoutingHandler()));
        // Routing should ignore web services
        routes.Add(new Route("{service}.asmx/{*path}", new StopRoutingHandler()));
        routes.Add("Default", new Route(string.Empty, new PageRouteHandler("~/PageGen.aspx")));
    }

    //про bundles
    //http://blogs.msdn.com/b/pranav_rastogi/archive/2012/09/21/asp-net-4-5-scriptmanager-improvements-in-webforms.aspx
    //http://www.asp.net/mvc/tutorials/mvc-4/bundling-and-minification
    //http://johnnewcombe.net/blog/post/4
    //http://boniestdeveloper.net/category/AspNet.aspx
    void registerScriptMappins (ScriptResourceMapping mapping)
    {        
        mapping.AddDefinition("jquery", new ScriptResourceDefinition
        {
            Path = "~/Scripts/jquery-" + _jqueryVersion + ".min.js",
            DebugPath = "~/Scripts/jquery-" + _jqueryVersion + ".js",
            CdnPath = "//code.jquery.com/jquery-" + _jqueryVersion + ".min.js",
            CdnDebugPath = "//code.jquery.com/jquery-" + _jqueryVersion + ".js",
            CdnSupportsSecureConnection = true,
            LoadSuccessExpression = "window.jQuery"
        });

        mapping.AddDefinition("BrowserDetect", new ScriptResourceDefinition
        {
            Path = "~/Scripts/BrowserDetect.js",
            DebugPath = "~/Scripts/BrowserDetect.js"
        });

        mapping.AddDefinition("commonUtils", new ScriptResourceDefinition
        {
            Path = "~/Scripts/commonUtils.js",
            DebugPath = "~/Scripts/commonUtils.js"
        });

        mapping.AddDefinition("EventInterop", new ScriptResourceDefinition
        {
            Path = "~/Scripts/EventInterop.js",
            DebugPath = "~/Scripts/EventInterop.js"
        });

        mapping.AddDefinition("Master", new ScriptResourceDefinition
        {
            Path = "~/Scripts/Master.js",
            DebugPath = "~/Scripts/Master.js"
        });

        mapping.AddDefinition("MemberHandlerAdapter", new ScriptResourceDefinition
        {
            Path = "~/Scripts/MemberHandlerAdapter.js",
            DebugPath = "~/Scripts/MemberHandlerAdapter.js"
        });

        addAjaxMappings(mapping);
        addWebFormsMapping(mapping);
    }

    void addAjaxMappings(ScriptResourceMapping mapping)
    {
        mapping.AddDefinition("MsAjaxBundle", new ScriptResourceDefinition
        {
            Path = "~/bundles/MsAjaxJs",
            CdnPath = "//ajax.aspnetcdn.com/ajax/4.5/6/MsAjaxBundle.js",
            LoadSuccessExpression = "window.Sys",
            CdnSupportsSecureConnection = true
        });

        addMsAjaxMapping(mapping, "MicrosoftAjax.js", "window.Sys && Sys._Application && Sys.Observer");
        addMsAjaxMapping(mapping, "MicrosoftAjaxCore.js", "window.Type && Sys.Observer");
        addMsAjaxMapping(mapping, "MicrosoftAjaxGlobalization.js", "window.Sys && Sys.CultureInfo");
        addMsAjaxMapping(mapping, "MicrosoftAjaxSerialization.js", "window.Sys && Sys.Serialization");
        addMsAjaxMapping(mapping, "MicrosoftAjaxComponentModel.js", "window.Sys && Sys.CommandEventArgs");
        addMsAjaxMapping(mapping, "MicrosoftAjaxNetwork.js", "window.Sys && Sys.Net && Sys.Net.WebRequestExecutor");
        addMsAjaxMapping(mapping, "MicrosoftAjaxHistory.js", "window.Sys && Sys.HistoryEventArgs");
        addMsAjaxMapping(mapping, "MicrosoftAjaxWebServices.js", "window.Sys && Sys.Net && Sys.Net.WebServiceProxy");
        addMsAjaxMapping(mapping, "MicrosoftAjaxTimer.js", "window.Sys && Sys.UI && Sys.UI._Timer");
        addMsAjaxMapping(mapping, "MicrosoftAjaxWebForms.js", "window.Sys && Sys.WebForms");
        addMsAjaxMapping(mapping, "MicrosoftAjaxApplicationServices.js", "window.Sys && Sys.Services");
    }
    static void addMsAjaxMapping(ScriptResourceMapping mapping, string name, string loadSuccessExpression)
    {
        mapping.AddDefinition(name, new ScriptResourceDefinition
        {
            Path = "~/Scripts/WebForms/MsAjax/" + name,
            CdnPath = "//ajax.aspnetcdn.com/ajax/4.5/6/" + name,
            LoadSuccessExpression = loadSuccessExpression,
            CdnSupportsSecureConnection = true
        });
    }
    void addWebFormsMapping(ScriptResourceMapping mapping)
    {
        mapping.AddDefinition("WebFormsBundle", new ScriptResourceDefinition
        {
            Path = "~/bundles/WebFormsJs",
            CdnPath = "//ajax.aspnetcdn.com/ajax/4.5/6/WebFormsBundle.js",
            LoadSuccessExpression = "window.WebForm_PostBackOptions",
            CdnSupportsSecureConnection = true
        });
    }

    void registerBundles (BundleCollection bundles)
    {        
        bundles.UseCdn = true;

        var b = new ScriptBundle("~/bundles/jquery", string.Format("//code.jquery.com/jquery-{0}.min.js", _jqueryVersion)).Include("~/Scripts/jquery-{version}.js");
        b.CdnFallbackExpression = "window.jQuery";
        bundles.Add(b);

        bundles.Add(new ScriptBundle("~/bundles/myscripts").Include(
            "~/Scripts/BrowserDetect.js",
            "~/Scripts/commonUtils.js",
            "~/Scripts/EventInterop.js",
            "~/Scripts/Master.js",
            "~/Scripts/MemberHandlerAdapter.js",
            "~/Scripts/LightBox/jquery.lightbox3.js"
        ));

        bundles.Add(new StyleBundle("~/bundles/extra-css").Include(
            "~/CssExtra/normalize.css",
            "~/CssExtra/css.css",
            "~/CssExtra/TreeViewPretty.css"            
       ));
        bundles.Add(new StyleBundle("~/Scripts/LightBox/themes/classic/lightbox").Include(
            "~/Scripts/LightBox/themes/classic/jquery.lightbox.css"
       ));
       bundles.Add(new StyleBundle("~/Scripts/LightBox/themes/classic/lightbox-ie6").Include(
            "~/Scripts/LightBox/themes/classic/jquery.lightbox.ie6.css"
       ));
        //bundles.Add(new DynamicFolderBundle("ThemeCss", "*.css"));

        //для Login.aspx, которая не использует masterpage
        /*ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
        {
            Path = "~/Scripts/jquery-" + ver + ".min.js",
            DebugPath = "~/Scripts/jquery-" + ver + ".js",
            CdnPath = "http://code.jquery.com/jquery-" + ver + ".min.js",
            CdnDebugPath = "http://code.jquery.com/jquery-" + ver + ".js",
            CdnSupportsSecureConnection = true,
            LoadSuccessExpression = "window.jQuery"
        });*/

        //ajax
        bundles.Add(new ScriptBundle("~/bundles/MsAjaxJs").Include(
            "~/Scripts/WebForms/MsAjax/MicrosoftAjax.js",
            "~/Scripts/WebForms/MsAjax/MicrosoftAjaxApplicationServices.js",
            "~/Scripts/WebForms/MsAjax/MicrosoftAjaxTimer.js",
            "~/Scripts/WebForms/MsAjax/MicrosoftAjaxWebForms.js"));

        //WebForms
        bundles.Add(new ScriptBundle("~/bundles/WebFormsJs").Include(
                  "~/Scripts/WebForms/WebForms.js",
                  "~/Scripts/WebForms/WebUIValidation.js",
                  "~/Scripts/WebForms/MenuStandards.js",
                  "~/Scripts/WebForms/Focus.js",
                  "~/Scripts/WebForms/GridView.js",
                  "~/Scripts/WebForms/DetailsView.js",
                  "~/Scripts/WebForms/TreeView.js",
                  "~/Scripts/WebForms/WebParts.js"));
    }

    static readonly Regex _exParseVer = new Regex(@"\d+\.(\d+[\.\-])*", RegexOptions.CultureInvariant | RegexOptions.Singleline);

    static string GetJqueryVer(string filePattern)
    {
        if (!BundleTable.VirtualPathProvider.FileExists(filePattern))
        {
            VirtualFile f = BundleTable.VirtualPathProvider.GetFile(filePattern);

            Match m = _exParseVer.Match(f.Name);
            if (!m.Success)
                throw new Exception(string.Format("Can't extract version: {0}", f.Name));

            string res = m.Groups[0].Value;

            return res.EndsWith(".") || res.EndsWith("-") ? res.Substring(0, res.Length - 1) : res;
        }
        else
        {
            throw new Exception(string.Format("Can't find {0}", filePattern));
        }
    }

</script>
