<%@ Page Language="C#"
    AutoEventWireup="true"
    CodeBehind="GalleryGen.aspx.cs"
    Inherits="AlbumFront.GalleryGen"
    Title="Галерея" %>

<%@ Register TagPrefix="uc"
    TagName="YandexCounter"
    Src="~/Components/YandexCounter.ascx" %>

<%@ Register TagPrefix="uc"
    TagName="MailRuCounter"
    Src="~/Components/MailRuCounter.ascx" %>

<%@ Register TagPrefix="uc"
    TagName="SeoInformers"
    Src="~/Components/SeoInformers.ascx" %>

<%@ Register TagPrefix="uc"
    TagName="ShareLinkIcons"
    Src="~/Components/ShareLinkIcons.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" prefix="og: http://ogp.me/ns#" lang="ru-RU">

<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <meta property="og:title" content="Сквозь горизонт: хайкинг, легкоходный туризм и фото-поездки налегке" />
    <meta property="og:description" content="Сквозь горизонт: хайкинг, легкоходный туризм и фото-поездки налегке. Полезные гайды, маршруты и советы для трейлов с минимальным весом. База походов с метриками сложности и GPS-Треками. Присоединяйтесь к сообществу на Boosty!" />
    <meta property="og:url" content="<%# GetCanonicalUrl() %>" />
    <meta property="og:image" content="<%# Request.Url.GetLeftPart(UriPartial.Authority) + Page.ResolveUrl("~/img/logo_23696-2.png") %>" />
    <meta property="og:type" content="website" />
    <meta property="og:locale" content="ru_RU" />

    <link rel="canonical" href="<%# GetCanonicalUrl() %>" />
    <link rel="icon" type="image/png" sizes="16x16" href="<%# Page.ResolveUrl("img/photo_album_blue.png") %>" />
    <link rel="icon" type="image/png" sizes="128x128" href="<%# Page.ResolveUrl("img/photo_album.png") %>" />
    <link rel="apple-touch-icon" sizes="128x128" href="<%# Page.ResolveUrl("img/photo_album.png") %>" />
    <meta name="theme-color" content="#ffffff" />
    <link rel="manifest" href="<%# Page.ResolveUrl("img/manifest.json") %>" />

    <asp:PlaceHolder runat="server">        
        <% = Styles.Render("~/bundles/gallery-css") %>        
    </asp:PlaceHolder>

    <uc:YandexCounter id="YandexCounter" runat="server" />
</head>

<body>
    <uc:MailRuCounter id="MailRuCounter" runat="server" />

    <form id="form1" runat="server">
        <main>
            XXX
            <footer class="Lnk">
                <div class="LineBg" style="text-align: center">
                    <div class="LineLeftCap">&nbsp;</div>
                    <div class="LineRightCap">&nbsp;</div>
                </div>
            </footer>

            <asp:PlaceHolder runat="server">
                <% = Scripts.Render("~/bundles/jquery") %>
            </asp:PlaceHolder>
            
            <div class="FooterContainer">
                <uc:SeoInformers ID="Informers" CssClass="SeoInformers" runat="server" /> 
                <uc:ShareLinkIcons CssClass="ShareLinkPosHorizon" runat="server" />
            </div>
        </main>
    </form>

</body>
</html>
