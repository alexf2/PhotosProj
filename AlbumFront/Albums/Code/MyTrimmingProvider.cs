using System;
using System.Collections;
using System.Web;

public interface IPostbackLinkUpdater
{
    void UpdateLink( SiteMapNode node );
}

/// <summary>
/// Summary description for MyTrimmingProvider
/// </summary>
public class MyTrimmingProvider: XmlSiteMapProvider
{
    private readonly ArrayList _lstPerm = new ArrayList();
    private Boolean _buildInvoked = false;
    public MyTrimmingProvider()
    {
        _lstPerm.Add( "*" );
    }

    public override SiteMapNode BuildSiteMap()
    {
        SiteMapNode res = base.BuildSiteMap();
        if( !_buildInvoked )
        {
            _buildInvoked = true;
            try {
                UpdateRoles( res );
            }
            finally
            {
                _buildInvoked = false;
            }
        }
        return res;
    }
    protected override void AddNode(SiteMapNode node, SiteMapNode parentNode)
    {
        base.AddNode( node, parentNode );
    }
    
    private void UpdateRoles( SiteMapNode nd )
    {
        Upd( nd );
        //avoid load
        //foreach( SiteMapNode ndd in nd.ChildNodes )
            //UpdateRoles( ndd );
    }
    private void Upd( SiteMapNode node )
    {
        if( node.Roles == null || node.Roles.Count == 0 )
        {
            Boolean rd = node.ReadOnly;
            node.ReadOnly = false;
            node.Roles = _lstPerm;
            node.ReadOnly = rd;
        }
    }

    public override bool IsAccessibleToUser( HttpContext context, SiteMapNode node )
    {
        if( HttpContext.Current.Handler != null )
        {
            IPostbackLinkUpdater pg = (IPostbackLinkUpdater)HttpContext.Current.Handler;
            pg.UpdateLink( node );
        }

        //IList<String> lst = new IList<String>();
        if( !SecurityTrimmingEnabled )
            return true;

        Boolean res = true;
        SiteMapNode nd = node;
        while( nd != null )
        {
            Boolean permFound = false;
            if( nd.Roles.Count > 0 )
                foreach( String roleName in nd.Roles )
                {
                    if( roleName == "*" ||  (context != null && context.User != null && context.User.IsInRole(roleName)) )
                    {
                        permFound = true;
                        break;
                    }
                }
            else
                permFound = true;

            if( !permFound )
            {
                res = false;
                break;
            }
            nd = nd.ParentNode;
        }
        //return base.IsAccessibleToUser(context, node);
        return res;
    }
}
