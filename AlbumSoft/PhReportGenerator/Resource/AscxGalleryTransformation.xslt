<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xsl msxsl">

	<xsl:output method="text" encoding="UTF-8" />
	<xsl:param name="title" />
	<xsl:param name="keywords" />
	<xsl:param name="description" />
	<xsl:param name="lang" />

	<xsl:template match="/">
		<xsl:call-template name="AscxDerective" />
		<xsl:call-template name="AscxImports" />
		<xsl:call-template name="AscxSetPageMeta" />
		<xsl:apply-templates select="photos" />
	</xsl:template>

	<!-- Шаблон для замены кавычек (аналог replace) -->
	<xsl:template name="fix-quotes">
		<xsl:param name="text" />
		<xsl:choose>
			<xsl:when test="contains($text, '&quot;')">
				<xsl:value-of select="substring-before($text, '&quot;')" />
				<xsl:text>'</xsl:text>
				<xsl:call-template name="fix-quotes">
					<xsl:with-param name="text" select="substring-after($text, '&quot;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="photos">
		<xsl:apply-templates select="f"/>
	</xsl:template>

	<xsl:template match="f">
		<xsl:text>&lt;uc:GalleryItem </xsl:text>
		<xsl:text>&#10;    Title="</xsl:text>
		<xsl:call-template name="fix-quotes">
			<xsl:with-param name="text" select="@caption" />
		</xsl:call-template>
		<xsl:text>"</xsl:text>
		<xsl:text>&#10;    File="</xsl:text>
		<xsl:choose>
			<xsl:when test="contains(@main, '.')">
				<xsl:value-of select="substring-before(@main, '.')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@main"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>"</xsl:text>
		<xsl:text>&#10;    ThumbWidth="</xsl:text>
		<xsl:value-of select="@w"/>
		<xsl:text>"</xsl:text>
		<xsl:text>&#10;    ThumbHeight="</xsl:text>
		<xsl:value-of select="@h"/>
		<xsl:text>"</xsl:text>
		<xsl:text>&#10;    DataTitle="</xsl:text>
		<xsl:call-template name="FormatTitle">
			<xsl:with-param name="caption" select="@caption" />
			<xsl:with-param name="date" select="@date" />
			<xsl:with-param name="shot-info" select="@shot-info" />
		</xsl:call-template>
		<xsl:text>"</xsl:text>
		<xsl:text>&#10;    runat="server" /&gt;&#10;</xsl:text>
	</xsl:template>

	<xsl:template name="FormatTitle">
		<xsl:param name="caption" />
		<xsl:param name="date" />
		<xsl:param name="shot-info" />

		<xsl:if test="string-length($caption) > 0">
			<xsl:text>&lt;b&gt;</xsl:text>
			<xsl:call-template name="fix-quotes">
				<xsl:with-param name="text" select="$caption" />
			</xsl:call-template>
			<xsl:text>&lt;/b&gt;</xsl:text>
		</xsl:if>

		<xsl:if test="string-length(@lat) > 0">
			<!-- Начало тега и протокол -->
			<xsl:text>  &lt;a href=&apos;https://www.google.com/maps/search/?api=1&amp;query=</xsl:text>

			<!-- КООРДИНАТЫ -->
			<xsl:value-of select="@lat" />
			<xsl:text>,</xsl:text>
			<xsl:value-of select="@long" />

			<!-- КОНЕЦ ТЕГА -->
			<xsl:text>&apos; target=&apos;_blank&apos;&gt;(map)&lt;/a&gt;</xsl:text>
		</xsl:if>

		<xsl:if test="(string-length($date) > 0 or string-length($shot-info) > 0) and string-length($caption) > 0">
			<xsl:text>&lt;br/&gt;</xsl:text>
		</xsl:if>

		<xsl:value-of select="$date" />

		<xsl:if test="string-length($shot-info) > 0">
			<xsl:if test="string-length($date) > 0">
				<xsl:text>  </xsl:text>
			</xsl:if>
			<xsl:text>&lt;span class=&apos;CShotPInfo&apos;&gt;</xsl:text>
			<xsl:call-template name="fix-quotes">
				<xsl:with-param name="text" select="$shot-info" />
			</xsl:call-template>
			<xsl:text>&lt;/span&gt;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="AscxDerective">
		<xsl:text disable-output-escaping="yes">&lt;%@ Control Language="C#" AutoEventWireup="true" %&gt;&#10;</xsl:text>
	</xsl:template>

	<xsl:template name="AscxImports">
		<xsl:text disable-output-escaping="yes">&lt;%@ Register TagPrefix="uc" TagName="GalleryItem" Src="~/Components/GalleryItem.ascx" %&gt;&#10;</xsl:text>
	</xsl:template>

	<xsl:template name="AscxSetPageMeta">
		<xsl:text>&lt;script runat="server"&gt;
    protected void Page_Init(object sender, EventArgs e)
    {     
        Page.Title = "</xsl:text>
		<xsl:value-of select="$title"/>
		<xsl:text>";
        Page.MetaDescription = "</xsl:text>
		<xsl:value-of select="$description"/>
		<xsl:text>";
        Page.MetaKeywords = "</xsl:text>
		<xsl:value-of select="$keywords"/>
		<xsl:text>";  
        
        foreach (Control c in Page.Controls) 
        {
            if (c.ID == "HtmlRoot") 
            {
                ((HtmlElement)c).Attributes["lang"] = "</xsl:text>
		<xsl:value-of select="$lang"/>
		<xsl:text>";
                break;
            }
        }
    }
&lt;/script&gt;</xsl:text>
	</xsl:template>	
</xsl:stylesheet>
