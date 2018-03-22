<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version = "2.0" xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" xmlns:msxsl = "urn:schemas-microsoft-com:xslt"	
	exclude-result-prefixes = "xsl msxsl" xml:space ="default" >  

  <xsl:output method = "xml" indent = "yes" omit-xml-declaration = "yes" encoding = "UTF-8" />
    <xsl:param name = "title" />
    <xsl:param name = "keywords" />
    <xsl:param name = "description" />
    <xsl:param name = "lang" />
	
    <xsl:template match = "photos">
<html lang="{$lang}">
    
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <xsl:if test = "$description">
      <meta name="description" content="{$description}" />
    </xsl:if>
    <xsl:if test = "$keywords">
      <meta name="keywords" content="{$keywords}" />
    </xsl:if>
		<title><xsl:value-of select="$title" /></title>

    <link rel="stylesheet" type="text/css" href="../LightBox/themes/classic/jquery.lightbox.css" />
    
    <xsl:text disable-output-escaping="yes"><![CDATA[
<!--[if IE 6]>
    	<link rel="stylesheet" type="text/css" href="../LightBox/themes/classic/jquery.lightbox.ie6.css" />
    <![endif]-->
]]></xsl:text>

    <link rel="stylesheet" type="text/css" href="../Include/pub.css" />
	</head>

	<body>
    <xsl:call-template name = "Controls" />
		<xsl:apply-templates select = "f" />
    <xsl:call-template name = "BootstrapScript" />
    <xsl:call-template name = "Counter" />
	</body>
</html>
</xsl:template>

  <xsl:template name = "BootstrapScript">
    <xsl:text disable-output-escaping="yes"><![CDATA[<script type = "text/javascript" src = "http://code.jquery.com/jquery-3.3.1.min.js"></script>]]></xsl:text>
    <xsl:text disable-output-escaping="yes"><![CDATA[<script type = "text/javascript" src = "../LightBox/jquery.lightbox3.min.js"></script>]]></xsl:text>
    <xsl:text disable-output-escaping="yes"><![CDATA[<script type = "text/javascript" src = "../Include/my.helpers.js"></script>]]></xsl:text>


    <script type = "text/javascript">
      var galeryOn = false;
      (function($) {
        if (getUrlVars()["noviewer"] !== "1")
        {
          galeryOn = true;
          $('div#n a').lightbox({'move': false});
        }
      
        function switchGalery (e)
        {
          e.stopPropagation();
          if (e.target.checked === false) {
            window.location.href = $(window.location).attr('href').split(/\?/)[ 0 ] + '?noviewer=1';
          }
          else {
            window.location.href = $(window.location).attr('href').split(/\?/)[ 0 ];
          }
        }

        $('#chGal').prop('checked', galeryOn == true ? true:false);
        $('#chGal').on('change', switchGalery);
      })(jQuery);
    </script>
  </xsl:template>
  
  <xsl:template name = "Controls">
    <xsl:element name="input" >
      <xsl:attribute name = "type">checkbox</xsl:attribute>
      <xsl:attribute name = "id">chGal</xsl:attribute>
    </xsl:element>
    <xsl:element name="span" >Gallery (on/off)</xsl:element>
    <xsl:element name="br" />
  </xsl:template>
  
	<xsl:template match = "f">
		<xsl:element name="div" >
			<xsl:attribute name = "id">n</xsl:attribute>

			<xsl:element name="div" >
        <xsl:attribute name = "id">c</xsl:attribute>
        <xsl:if test="string-length(@caption) > 20">
          <xsl:attribute name = "title"><xsl:value-of select="@caption" /></xsl:attribute>
        </xsl:if>
        <xsl:value-of select = "@caption" />
      </xsl:element>
			<xsl:element name="div" >
				<xsl:choose>
					<xsl:when test = "@pub">
						<xsl:element name="nobr" >
							<xsl:call-template name="PubImg">
								<xsl:with-param name="pub-img" select = "@pub" />
								<xsl:with-param name="thumb-img" select = "@thumb" />
								<xsl:with-param name="w" select = "@w" />
								<xsl:with-param name="h" select = "@h" />
                <xsl:with-param name="caption" select = "@caption" />
                <xsl:with-param name="date" select = "@date" />
                <xsl:with-param name="shot-info" select = "@shot-info" />
							</xsl:call-template>
							<xsl:if test = "@main">
								<xsl:call-template name="FullImg">
									<xsl:with-param name="img" select = "@main" />
                  <xsl:with-param name="caption" select = "@caption" />
                  <xsl:with-param name="date" select = "@date" />
                  <xsl:with-param name="shot-info" select = "@shot-info" />
								</xsl:call-template>						
							</xsl:if>
						</xsl:element>
					</xsl:when>

					<xsl:otherwise>
						<xsl:call-template name="PubImg">
							<xsl:with-param name="pub-img" select = "@main" />
							<xsl:with-param name="thumb-img" select = "@thumb" />
							<xsl:with-param name="w" select = "@w" />
							<xsl:with-param name="h" select = "@h" />
              <xsl:with-param name="caption" select = "@caption" />
              <xsl:with-param name="date" select = "@date" />
              <xsl:with-param name="shot-info" select = "@shot-info" />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name = "PubImg">
		<xsl:param name="pub-img" />
		<xsl:param name="thumb-img" />
		<xsl:param name="w" />
		<xsl:param name="h" />
    <xsl:param name="caption" />
    <xsl:param name="date" />
    <xsl:param name="shot-info" />

		<xsl:element name="a" >
			<xsl:attribute name = "href"><xsl:value-of select="$pub-img" /></xsl:attribute>
      <xsl:attribute name = "title">Publication Size</xsl:attribute>
      <xsl:attribute name = "data-rel">pub</xsl:attribute>
      <xsl:attribute name = "data-title">
        <xsl:call-template name="FormatTitle">
          <xsl:with-param name="caption" select = "$caption" />
          <xsl:with-param name="date" select = "$date" />
          <xsl:with-param name="shot-info" select = "$shot-info" />
        </xsl:call-template>
      </xsl:attribute>

			<xsl:element name="img" >
				<xsl:attribute name = "src"><xsl:value-of select="$thumb-img" /></xsl:attribute>
				<xsl:attribute name="width"><xsl:value-of select="$w" /></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="$h" /></xsl:attribute>
			</xsl:element>
		</xsl:element>		
	</xsl:template>

	<xsl:template name = "FullImg">
		<xsl:param name="img" />
    <xsl:param name="caption" />
    <xsl:param name="date" />
    <xsl:param name="shot-info" />

		<xsl:element name="a" >
			<xsl:attribute name = "href"><xsl:value-of select="$img"></xsl:value-of></xsl:attribute>
			<xsl:attribute name = "title">Album Size</xsl:attribute>
      <xsl:attribute name = "data-rel">full</xsl:attribute>
      <xsl:attribute name = "data-title">
        <xsl:call-template name="FormatTitle">
          <xsl:with-param name="caption" select = "$caption" />
          <xsl:with-param name="date" select = "$date" />
          <xsl:with-param name="shot-info" select = "$shot-info" />
        </xsl:call-template>
      </xsl:attribute>
			<xsl:text>+</xsl:text>
		</xsl:element>
	</xsl:template>

  <xsl:template name = "FormatTitle">
    <xsl:param name="caption" />
    <xsl:param name="date" />
    <xsl:param name="shot-info" />    

    
    <xsl:if test="string-length($caption) > 0">
      <xsl:text disable-output-escaping="yes"><![CDATA[<b>]]></xsl:text>
      <xsl:value-of select="$caption" />
      <xsl:text disable-output-escaping="yes"><![CDATA[</b>]]></xsl:text>
    </xsl:if>

    <xsl:if test="string-length(@lat) > 0">
      <xsl:text disable-output-escaping="yes"><![CDATA[&#160;&#160;<a href="https://www.google.com/maps/search/?api=1&query=]]></xsl:text>
      <xsl:value-of select="concat(@lat, ',', @long)" />
      <xsl:text disable-output-escaping="yes"><![CDATA[">(map)</a>]]></xsl:text>
    </xsl:if>

    <xsl:if test="(string-length($date) > 0 or string-length($shot-info) > 0) and string-length($caption) > 0">
      <xsl:text disable-output-escaping="yes"><![CDATA[<br/>]]></xsl:text>
    </xsl:if>    

    <xsl:value-of select="$date" />

    <xsl:if test="string-length($shot-info) > 0">
      <xsl:if test="string-length($date) > 0">
        <xsl:text>&#160;&#160;</xsl:text>
      </xsl:if>
      <xsl:text disable-output-escaping="yes"><![CDATA[<span class="CShotPInfo">]]></xsl:text>
      <xsl:value-of select="$shot-info" />
      <xsl:text disable-output-escaping="yes"><![CDATA[</span>]]></xsl:text>
    </xsl:if>
  </xsl:template >
  
  <xsl:template name = "Counter">
    <xsl:text disable-output-escaping="yes"><![CDATA[
<div style="clear:both">
	<script language="javascript" type="text/javascript">
		cgb_js="1.0"; cgb_r=""+Math.random()+"&r="+
		escape(document.referrer)+"&pg="+
		escape(window.location.href);
		document.cookie="rqbct=1; path=/"; cgb_r+="&c="+
		(document.cookie?"Y":"N");
		</script><script language="javascript1.1" type="text/javascript">
		cgb_js="1.1";cgb_r+="&j="+
		(navigator.javaEnabled()?"Y":"N")</script>
		<script language="javascript1.2" type="text/javascript">
		cgb_js="1.2"; cgb_r+="&wh="+screen.width+
		'x'+screen.height+"&px="+
		(((navigator.appName.substring(0,3)=="Mic"))?
		screen.colorDepth:screen.pixelDepth)</script>
		<script language="javascript1.3" type="text/javascript">
		cgb_js="1.3"</script>
		<script language="javascript" 
		type="text/javascript">cgb_r+="&js="+cgb_js; 
		document.write("<a href='http://www.1gb.ru?cnt=66030'>"+
		"<img src='http://counter.1gb.ru/cnt.aspx?"+
		"u=66030&"+cgb_r+
		"&' border=0 width=88 height=31 "+
		"alt='1Gb.ru counter'><\/a>")</script>
		<noscript><a href='http://www.1gb.ru?cnt=66030'>
		<img src="http://counter.1gb.ru/cnt.aspx?u=66030" 
		border=0 width="88" height="31" alt="1Gb.ru counter"></a>
	</noscript>
  </div>
]]></xsl:text>
  </xsl:template>

		<!--xsl:template match = "* | @*">
		<xsl:copy>
			<xsl:apply-templates select = "* | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match = "processing-instruction()" >
		<xsl:copy />
	</xsl:template-->
</xsl:stylesheet>
