using System;
using System.Web;


public partial class PageGen: AwsBasePage, ICustomCacheInfo, IPostbackLinkUpdater
{        
    public PageGen(): base( ViewStateStorageType.SessionID )
    {
    }

    void IPostbackLinkUpdater.UpdateLink( SiteMapNode node )
    {
        IPostbackLinkUpdater m = (IPostbackLinkUpdater)Master;
        m.UpdateLink( node );
    }

    public String GetKey()
    {
        return CurrentProvider.CurrentNode.Key + " - " + CurrentProvider.Name;
    }
    public SiteMapProvider CurrentProvider
    {
        get{            
            return ((IMasterPageAccessor)Master).Provider;
        }
    }

    protected override void SavePageStateToPersistenceMedium( object state )
    {
        SavePageStateToSession( state );
        //base.SavePageStateToPersistenceMedium(state);

    }
    protected override object LoadPageStateFromPersistenceMedium()
    {
        return LoadPageStateFromSession();
        //return base.LoadPageStateFromPersistenceMedium();
    }
    
}
