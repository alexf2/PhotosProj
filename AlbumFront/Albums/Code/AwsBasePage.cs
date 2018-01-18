using System;
using System.IO;
using System.Text;
using System.Web.UI;

/// <summary>
/// Summary description for AwsBasePage
/// </summary>
public class AwsBasePage: System.Web.UI.Page
{
    public enum ViewStateStorageType
    {
        Page, SessionID, SessionGUID
    }

    private const Int32 CACHE_VS_TIMEOUT = 30;//minutes

    private ViewStateStorageType _vsst;

    private LosFormatter _losFmt = null;
    protected LosFormatter LosFmt
    {
        get{
            return _losFmt != null ? _losFmt:(_losFmt = new LosFormatter());
        }
    }

    protected String ViewStateID
    {
        get {
            return  String.Format( "{0}_{1}_Viewstate", Request.Path.Replace( "/", "-"), Session.SessionID );
        }
    }
    protected String Hidden_ViewstateID
    {
        get { return "__" + Page.ClientID + "_ViewStateID"; }
    }

    public AwsBasePage( ViewStateStorageType vsst )
    {
        _vsst = vsst;
    }

    protected void SavePageStateToSession( Object vs )
    {
        switch( _vsst )
        {
            case ViewStateStorageType.Page:
                base.SavePageStateToPersistenceMedium( vs );
                break;

            case ViewStateStorageType.SessionID: case ViewStateStorageType.SessionGUID:
                {
                    String id;
                    if( _vsst == ViewStateStorageType.SessionID )
                        id = ViewStateID;
                    else
                    {
                        id = Guid.NewGuid().ToString( "N" );
                        Page.ClientScript.RegisterHiddenField( Hidden_ViewstateID, id );
                    }

                    using( MemoryStream stm = new MemoryStream() )
                    {
                        using( StreamWriter wr = new StreamWriter(stm, Encoding.ASCII) )            
                            LosFmt.Serialize( wr, vs );

                        Session[ id ] = stm.ToArray();
                    }
                }
                break;            
        }                            
    }
    protected Object LoadPageStateFromSession()
    {        
        switch( _vsst )
        {
            case ViewStateStorageType.Page:
                return base.LoadPageStateFromPersistenceMedium();

            case ViewStateStorageType.SessionID:
                {
                    Object res = null;
                    String id = ViewStateID;
                    if( id != null && id.Length != 0 )
                    {
                        res = Session[ id ];
                        if( res != null )
                        {
                            using( MemoryStream stm = new MemoryStream((Byte[])res) )
                            {
                                using( StreamReader rd = new StreamReader(stm, Encoding.ASCII) )            
                                    res = LosFmt.Deserialize( rd );
                            }
                        }
                    }
                    return res;
                }

            case ViewStateStorageType.SessionGUID:
                {
                    Object res = null;
                    String id = Request.Form[ Hidden_ViewstateID ];
                    if( id != null && id.Length != 0 )
                    {
                        res = Session[ id ];
                        if( res != null )
                        {
                            Cache.Add( id, res, null, DateTime.Now.AddMinutes(CACHE_VS_TIMEOUT),
                                System.Web.Caching.Cache.NoSlidingExpiration,
                                System.Web.Caching.CacheItemPriority.Normal, null );
                            Session.Remove( id );
                        }
                        else
                            res = Cache[ id ];

                        if( res != null )
                            using( MemoryStream stm = new MemoryStream((Byte[])res) )
                            {
                                using( StreamReader rd = new StreamReader(stm, Encoding.ASCII) )            
                                    res = LosFmt.Deserialize( rd );
                            }
                    }
                    return res;
                }

            default:
                return null;

        }
    }
}
