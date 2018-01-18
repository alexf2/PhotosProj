using System;
using System.Configuration;

public sealed class AwsConfigSection: ConfigurationSection 
{
    public AwsConfigSection()
    {
    }

    [ConfigurationProperty("", IsDefaultCollection = true, IsKey=false, IsRequired = true)]
    [ConfigurationCollection( typeof(LocalesCollection), AddItemName="locale")]
    public LocalesCollection Locales
    {
        get { return (LocalesCollection)this[""]; }
        set { this[""] = value; }
    }
}

public sealed class LocalesCollection: ConfigurationElementCollection
{
    public override ConfigurationElementCollectionType CollectionType
    {
        get {return ConfigurationElementCollectionType.BasicMapAlternate;}
    }

    protected override bool IsElementName( String elementName )
    {
        return !String.IsNullOrEmpty(elementName) && elementName == "locale";
    }

    protected override ConfigurationElement CreateNewElement()
    {
        return new LocaleElement();
    }
    protected override ConfigurationElement CreateNewElement( string elementName )
    {
        String n = elementName.Trim().ToLower();
        switch( n )
        {
            case "locale":
                return new LocaleElement();
            default:
                throw new Exception( "Unsupported element type in custom config setcion: '" + elementName + "'." );
        }        
    }
    protected override object GetElementKey( ConfigurationElement element )
    {
        return ((LocaleElement)element).ProviderName;        
    }

    public LocaleElement this[ Int32 index ]
    {
        get { return (LocaleElement)BaseGet(index); }
        set{
            if( BaseGet(index) != null ) BaseRemoveAt( index );
            BaseAdd( index, value );
        }
    }

    new public LocaleElement this[ String name ]
    {
        get { return (LocaleElement)BaseGet(name); }
    }
}

public sealed class LocaleElement: ConfigurationElement
{   
    [ConfigurationProperty("description", IsRequired=false, DefaultValue="")]
    public String Description
    {
        get { return (String)this[ "description" ]; }
        set { this[ "description" ] = value; }
    }
    [ConfigurationProperty("providerName", IsRequired=true, IsKey = true)]
    public String ProviderName
    {
        get { return (String)this[ "providerName" ]; }
        set { this[ "providerName" ] = value; }
    }
    [ConfigurationProperty("sitemapFileSuffix", IsRequired=true)]
    public String SitemapFileSuffix
    {
        get { return (String)this[ "sitemapFileSuffix" ]; }
        set { this[ "sitemapFileSuffix" ] = value; }
    }
    [ConfigurationProperty("culture", IsRequired=true)]
    public String Culture
    {
        get { return (String)this[ "culture" ]; }
        set { this[ "culture" ] = value; }
    }
}

