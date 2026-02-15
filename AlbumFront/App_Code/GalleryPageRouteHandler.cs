using System.Web;
using System.Web.Compilation;
using System.Web.Routing;
using System.Web.UI;

public class GalleryPageRouteHandler : IRouteHandler
{
    private readonly string _virtualPath;

    public GalleryPageRouteHandler(string virtualPath)
    {
        _virtualPath = virtualPath;
    }

    public IHttpHandler GetHttpHandler(RequestContext requestContext)
    {
        // 1. Сохраняем исходный путь (если нужен для логики страницы)
        var originalPath = requestContext.RouteData.Values["path"] as string;
        HttpContext.Current.Items["OriginalGalleryPath"] = originalPath;
        HttpContext.Current.Items["OriginalAbsoluteUri"] = requestContext.HttpContext.Request.Url.AbsoluteUri;

        // 2. Создаём страницу по фиксированному пути
        var page = (Page)BuildManager.CreateInstanceFromVirtualPath(_virtualPath, typeof(Page));

        // 3. Устанавливаем корректный контекст (страница «думает», что она ~/GalleryGen.aspx)
        page.AppRelativeVirtualPath = "~/GalleryGen.aspx";

        // 4. Переопределяем путь запроса, чтобы ASP.NET не пытался искать ресурсы по /Pub/...
        requestContext.HttpContext.RewritePath("~/GalleryGen.aspx");

        return page;
    }
}
