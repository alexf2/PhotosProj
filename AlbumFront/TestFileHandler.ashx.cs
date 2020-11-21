using System.Web;


public class TestFileHandler: IHttpHandler
{
    /// <summary>
    /// You will need to configure this handler in the Web.config file of your 
    /// web and register it with IIS before being able to use it. For more information
    /// see the following link: https://go.microsoft.com/?linkid=8101007
    /// </summary>
    #region IHttpHandler Members

    public bool IsReusable
    {
        // Return false in case your Managed Handler cannot be reused for another request.
        // Usually this would be false in case you have some state information preserved per request.
        get { return true; }
    }

    public void ProcessRequest (HttpContext context)
    {
        string filePath;
        if (context.Request.FilePath.EndsWith(".ashx"))
        {
            filePath = "~/App_Data/ex01-1.xsl ";
        } else
        {
            filePath = "~/App_Data" + context.Request.FilePath;
        }
        filePath = context.Server.MapPath(filePath);

        context.Response.Cache.SetCacheability(HttpCacheability.Private);
        context.Response.ContentType = "text/xml";
        context.Response.AppendHeader("Access-Control-Allow-Origin", "*");
        context.Response.TransmitFile(filePath);
    }

    #endregion
}
