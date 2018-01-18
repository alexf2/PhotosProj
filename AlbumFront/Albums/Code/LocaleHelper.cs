using System;


public sealed class LocaleHelper
{
    public const String CONFG_COOKIE_NAME = "AlbumConfig";
    public const String COOKIE_LANG_NAME = "Lang";

    private const String LOCALES_NAME = "awsLocales";
    private AwsConfigSection _cs;
    private System.Web.Configuration.SiteMapSection _siteMap;

    public LocaleHelper()
    {
        _cs = (AwsConfigSection)System.Configuration.ConfigurationManager.GetSection( LOCALES_NAME );
        _siteMap = (System.Web.Configuration.SiteMapSection)System.Configuration.ConfigurationManager.GetSection( "system.web/siteMap" );
    }

    public String DefaultProvider
    {
        get{
            return _siteMap.DefaultProvider;
        }
    }
    public String DefaultCultureName
    {
        get{
            return GetLocaleByProvider(_siteMap.DefaultProvider).Culture;
        }
    }
    public LocaleElement DefaultLocale
    {
        get{
            return GetLocaleByProvider(_siteMap.DefaultProvider);
        }
    }
    public LocaleElement GetLocaleByProvider( String prov )
    {        
        return _cs.Locales[ prov ];
    }
    public LocaleElement GetLocaleByCulture( String cutlure )
    {
        foreach( LocaleElement el in _cs.Locales )
            if( String.Compare(el.Culture, cutlure, true) == 0 )
                return el;

        return _cs.Locales[ DefaultProvider ];
    }
}
