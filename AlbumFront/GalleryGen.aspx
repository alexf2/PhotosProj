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

<%@ Register TagPrefix="uc"
    TagName="PageFooter"
    Src="~/Components/PageFooter.ascx" %>

<%@ Register TagPrefix="uc"
    TagName="Toggle"
    Src="~/Components/Toggle.ascx" %>

<!DOCTYPE html>

<html id="HtmlRoot" xmlns="http://www.w3.org/1999/xhtml" prefix="og: http://ogp.me/ns#" runat="server">

<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
        <% = Styles.Render("~/bundles/gallery-css", "~/Scripts/LightBox/themes/classic/jquery.lightbox.css") %>        
    </asp:PlaceHolder>
    <script type="text/javascript">
        function getUrlVars() {
            const vars = {};
            const params = new URLSearchParams(window.location.search);

            for (const [key, value] of params) {
                vars[key] = value;
            }

            return vars;
        }
    </script>

    <uc:YandexCounter ID="YandexCounter" runat="server" />
</head>

<body>
    <uc:MailRuCounter ID="MailRuCounter" runat="server" />

    <form id="form1" runat="server">
        <main>
            <ul class="GalleryToolbar">
                <li>
                    <a href="javascript:history.back();" class="back-btn" title="Назад">
                         <svg 
                             xmlns="http://www.w3.org/2000/svg"
                             aria-hidden="true"
                             focusable="false"
	                         viewBox="18 40 360 320" >
                            
			                <path d="M401.947,159.301c0-8.583-6.949-15.742-15.497-15.889l0,0H197.515c-7.021-1.589-12.309-7.886-12.309-15.369V78.976
				                c0-8.675-5.397-11.163-11.993-5.535L4.948,190.735c-6.598,5.634-6.598,14.847,0,20.479l168.262,117.29
				                c6.599,5.632,11.996,3.146,11.996-5.528v-49.067c0-8.673,7.097-15.771,15.771-15.771l185.201-0.276
				                c8.676-0.004,15.771-7.101,15.771-15.771L401.947,159.301z"/>		                    
                        </svg>
                    </a>                    
                </li>
                <li>
                    <uc:Toggle ID = "toggleGallery" Title="Gallery On/Off" runat="server" />
                </li>
                <li>
                    <uc:Toggle ID = "toggleSize" Title="Large Size" runat="server" />
                </li>
            </ul>
            <br />

            <asp:PlaceHolder ID="GalleryContent" runat="server" />            

            <uc:PageFooter CssClass="Lnk" runat="server">
                <FooterTemplate>
                    <p class="Copyright"><a runat="server" href="<%$RouteUrl:routename=Default %>">Odyssey's Photography</a>, &copy; Aleksey Fedorov 2006 - 2026, All rights reserved&nbsp;&nbsp;|&nbsp;&nbsp;<a runat="server" class="Copyright" href="<%$RouteUrl:routename=HorizonLanding %>">Horizon</a></p>
                </FooterTemplate>
            </uc:PageFooter>

            <br />

            <asp:PlaceHolder runat="server">
                <% = Scripts.Render("~/bundles/jquery", "~/bundles/lightbox") %>
            </asp:PlaceHolder>

            <div class="FooterContainer">
                <uc:SeoInformers ID="Informers" CssClass="SeoInformers" runat="server" />
                <uc:ShareLinkIcons CssClass="ShareLinkPosHorizon" runat="server" />
            </div>
        </main>

        <script type="text/javascript">
            var galeryOn = true;
            var largeOn = false;
            (function($) {
                const vars = getUrlVars();
                
                if (vars["noviewer"] == "1") {
                    galeryOn = false;                    
                }
                if (vars["large"] == "1") {
                    largeOn = true;
                }
                if (galeryOn) {
                    $('div#n a').lightbox({ 'move': false });
                }
      
                function switchGalery(ev, optionName, value) {
                    ev.stopPropagation();

                    const url = new URL(window.location.href);
                    const params = url.searchParams;

                    if (ev.target.checked == value) {                        
                        params.set(optionName, '1');
                    } else {                        
                        params.delete(optionName);
                    }
                    
                    url.search = params.toString();
                    window.location.href = url.toString();
                }

                $('#toggleGallery').prop('checked', galeryOn == true ? true : false);
                $('#toggleGallery').on('change', (ev) => switchGalery(ev, 'noviewer', false));
                $('#toggleSize').prop('checked', largeOn == true ? true : false);
                $('#toggleSize').on('change', (ev) => switchGalery(ev, 'large', true));
            })(jQuery);
        </script>

    </form>
</body>
</html>
