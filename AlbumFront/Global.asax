<%@ Application Language="C#" %>
<%@ Import Namespace="System.Web.Hosting" %>
<%@ Import Namespace = "System.Web.Routing" %>
<%@ Import Namespace = "System.Diagnostics" %>


<script runat="server">
    const string TestJsFileName = "~/Scripts/jquery*.js";
    string _jqueryVersion;

    void Application_Start(object sender, EventArgs e)
    {
        _jqueryVersion = GetJqueryVer(TestJsFileName);

        registerRoutes(RouteTable.Routes);
        //registerScriptMappins(ScriptManager.ScriptResourceMapping);
        registerBundles(BundleTable.Bundles);
    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_BeginRequest( Object sender, EventArgs e )
    {
        //AWS.Utils.WebUtils.SetLocale( Request );

        var request = HttpContext.Current.Request;
        var response = HttpContext.Current.Response;
        bool enforceHttps = false;
        bool.TryParse(ConfigurationManager.AppSettings["EnforceHttps"], out enforceHttps);
        string canonicalDomain = ConfigurationManager.AppSettings["CanonicalDomain"];
        var techDomains = new HashSet<string>(
            (ConfigurationManager.AppSettings["TechDomains"] ?? string.Empty).Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries),
            StringComparer.OrdinalIgnoreCase);

        // это конфигурации при разработке: поэтому редирект не нужен
        if (request.IsLocal || techDomains.Contains(request.Url.Host))
            return;

        if (enforceHttps && !request.IsSecureConnection || !string.Equals(canonicalDomain, request.Url.Host, StringComparison.OrdinalIgnoreCase))
        {
            var protocol = enforceHttps ? "https://" : request.Url.Scheme + "://";
            HttpContext.Current.Response.Redirect(protocol + canonicalDomain + request.RawUrl, true);

        }
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
        // This is for WebResource.axd to work
        routes.Add(new Route("{resource}.axd/{*pathInfo}", new StopRoutingHandler()));
        // Routing should ignore web services
        routes.Add(new Route("{service}.asmx/{*path}", new StopRoutingHandler()));
        routes.Ignore("{*botdetect}", new { botdetect = @"(.*)BotDetectCaptcha\.ashx" });

        routes.Add("Default", new Route(string.Empty, new PageRouteHandler("~/default.aspx")));
        routes.Add("About", new Route("about", new PageRouteHandler("~/about.aspx")));
        routes.Add("Contacts", new Route("contacts", new PageRouteHandler("~/Mail.aspx")));
        routes.Add("Albums", new Route("albums", new PageRouteHandler("~/Albums/PageGen.aspx")));
        routes.Add("FrVersion", new Route("frversion", new PageRouteHandler("~/FrVersion.aspx")));
        routes.Add("HorizonLanding", new Route("horizon", new PageRouteHandler("~/ThroughHorizonLanding.aspx")));
    }

    //про bundles
    //http://blogs.msdn.com/b/pranav_rastogi/archive/2012/09/21/asp-net-4-5-scriptmanager-improvements-in-webforms.aspx
    //http://blogs.msdn.com/b/rickandy/archive/2012/08/15/adding-web-optimization-to-a-web-pages-site.aspx
    //http://blogs.msdn.com/b/rickandy/archive/2012/08/14/adding-bundling-and-minification-to-web-forms.aspx
    void registerScriptMappins(ScriptResourceMapping mapping)
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
    }

    void registerBundles (BundleCollection bundles)
    {
        bundles.UseCdn = true;
        BundleTable.EnableOptimizations = true;

        var b = new ScriptBundle("~/bundles/jquery", string.Format("//code.jquery.com/jquery-{0}.min.js", _jqueryVersion)).Include("~/Scripts/jquery-{version}.js");
        b.CdnFallbackExpression = "window.jQuery";
        bundles.Add(b);


        bundles.Add(new StyleBundle("~/bundles/extra-css").Include(
            "~/css/normalize.css",
            "~/css/css-ext.css",
            "~/css/fonts.css"
       ));

        bundles.Add(new StyleBundle("~/bundles/horizon-css").Include("~/css/horizon.css"));


        //для Mail.aspx, которая не использует masterpage
        ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
        {
            Path = "~/Scripts/jquery-" + _jqueryVersion + ".min.js",
            DebugPath = "~/Scripts/jquery-" + _jqueryVersion + ".js",
            CdnPath = "//code.jquery.com/jquery-" + _jqueryVersion + ".min.js",
            CdnDebugPath = "//code.jquery.com/jquery-" + _jqueryVersion + ".js",
            CdnSupportsSecureConnection = true,
            LoadSuccessExpression = "window.jQuery"
        });
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
