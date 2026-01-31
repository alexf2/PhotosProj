<%@ Page
    Language="C#"
    MetaKeywords=""
    MetaDescription=""
    Culture="auto"
    UICulture="auto"
    Title="Сквозь горизонт: хайкинг, легкоходный туризм и фото-поездки налегке" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="ru">

<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="yandex-verification" content="d6ff7bab1f833376" />

    <link rel="icon" type="image/png" sizes="16x16" href="img/photo_album_blue.png">
    <link rel="icon" type="image/png" sizes="128x128" href="img/photo_album.png">
    <link rel="apple-touch-icon" sizes="128x128" href="img/photo_album.png">
    <meta name="theme-color" content="#ffffff">
    <link rel="manifest" href="img/manifest.json">

    <asp:PlaceHolder runat="server">
        <% = Styles.Render("~/bundles/extra-css") %>        
    </asp:PlaceHolder>
</head>

<body>
    <svg aria-hidden="true" style="position: absolute; width: 0; height: 0; overflow: hidden">
        <symbol id="icon-boosty" viewBox="0 0 30 30" fill="none" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <linearGradient x1="61.5370404%" y1="13%" x2="34.2376801%" y2="129.365079%" id="2bee7478__linearGradient-1">
                    <stop stop-color="#EF7829" offset="0%"></stop>
                    <stop stop-color="#F0692A" offset="28%"></stop>
                    <stop stop-color="#F15E2C" offset="63%"></stop>
                    <stop stop-color="#F15A2C" offset="100%"></stop>
                </linearGradient>
            </defs>
            <path d="M3.78233 17.9192L8.88813 0H16.7236L15.1391 5.55577C15.1224 5.58748 15.1088 5.62071 15.0985 5.655L10.9374 20.325H14.8204C13.1999 24.4385 11.9307 27.6635 11.0139 30C3.84956 29.9192 1.84086 24.7108 3.5992 18.5492L3.78233 17.9192ZM11.0406 30L20.486 16.2H16.4779L19.9644 7.36038C25.9476 7.995 28.7538 12.7719 27.1044 18.5481C25.3333 24.7615 18.1655 30 11.1866 30H11.0406Z" fill="url(#2bee7478__linearGradient-1)" fill-rule="nonzero"></path>
        </symbol>

        <symbol id="icon-note" fill="none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" color="gray">
            <path d="M6 6h4M6 8h4M6 10h2M9.793 13.5H3a.5.5 0 0 1-.5-.5V3a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 .5.5v6.793a.5.5 0 0 1-.146.353l-3.208 3.208a.5.5 0 0 1-.353.146Z" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"></path>
            <path d="M13.455 9.999H10v3.455" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"></path>
        </symbol>

        <symbol id="icon-telegram" viewBox="0 0 14 14" fill="none" color="#2596be" xmlns="http://www.w3.org/2000/svg">
            <path d="M13.7356 0.87504C13.4968 0.67253 13.1217 0.643555 12.7339 0.799258C12.326 0.962922 1.1873 5.74037 0.733881 5.93556C0.651412 5.96422 -0.068838 6.23295 0.00535216 6.83157C0.071582 7.37128 0.650457 7.5948 0.721144 7.62059L3.55279 8.59016C3.74065 9.21552 4.4332 11.5227 4.58636 12.0156C4.68188 12.3229 4.83759 12.7266 5.11047 12.8098C5.34991 12.9021 5.58809 12.8177 5.7422 12.6967L7.47341 11.091L10.2681 13.2705L10.3347 13.3103C10.5244 13.3944 10.7063 13.4364 10.8798 13.4364C11.0138 13.4364 11.1425 13.4112 11.2654 13.3609C11.6841 13.189 11.8516 12.79 11.8691 12.7448L13.9566 1.89428C14.084 1.31477 13.9069 1.01992 13.7356 0.87504ZM6.0501 8.97798L5.09486 11.5253L4.13963 8.34116L11.4631 2.92816L6.0501 8.97798Z" fill="currentColor"></path>
        </symbol>
    </svg>

    <asp:Panel ID="MainDiv" CssClass="Centering" role="main" runat="server">

        <header class="MainHeader Lnk">
            <div class="HeaderCont">
                <nav class="Nav" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <asp:HyperLink ID="aboutBoosty" NavigateUrl="https://boosty.to/through_horizon/posts/487bbf07-5b7a-4c56-9b24-621788b601c7?share=post_link" Target="_blank" runat="server">О сообществе</asp:HyperLink>&nbsp;&nbsp;|&nbsp;&nbsp;
                    <svg style="width: 24px; height: 24px">
                        <use xlink:href="#icon-boosty"></use></svg><asp:HyperLink ID="boosty" NavigateUrl="https://boosty.to/through_horizon" Target="_blank" runat="server">Сообщество</asp:HyperLink>&nbsp;&nbsp;|&nbsp;&nbsp;
                    <svg style="width: 24px; height: 24px">
                        <use xlink:href="#icon-telegram"></use></svg><asp:HyperLink ID="telegram" NavigateUrl="https://t.me/+GH9OFfv-lRgxMDMy" Target="_blank" runat="server">Канал</asp:HyperLink>&nbsp;&nbsp;|&nbsp;&nbsp;
                    <svg style="width: 24px; height: 24px">
                        <use xlink:href="#icon-note"></use></svg><asp:HyperLink ID="instruction" NavigateUrl="#instron" runat="server">Инструкции</asp:HyperLink>
                </nav>
            </div>
            <div class="HeaderCont">
                <div class="LogoName">
                    &nbsp;<b>Сквозь горизонт 🥾</b>
                </div>
            </div>
        </header>

        <div class="Container">
            <p>
                База маршрутов для легкоходного туризма, походов выходного дня и однодневок налегке.
                Всё, что нужно для прохождения: GPS-треки, фото, описания, инструкции и метрики.
            </p>
            <div>
                <img class="FadeOnLoad" src="<%=ResolveClientUrl("img/landing_img.jpg")%>" border="0" title="Сообщество Сквозь горизонт" />
            </div>
        </div>        

        <div class="FooterSep">&nbsp;</div>

        <footer class="Lnk">
            <div class="LineBg" style="text-align: center">
                <div class="LineLeftCap">&nbsp;</div>
                <div class="LineRightCap">&nbsp;</div>
            </div>
        </footer>
    </asp:Panel>


    <asp:PlaceHolder runat="server">
        <% = Scripts.Render("~/bundles/jquery") %>

        <script language="javascript1.1" type="text/javascript">
            $('.FadeOnLoad').each(function () {
                if (!this.complete)
                    $(this).on('load', function () { $(this).css('opacity', '1'); })
                else
                    $(this).css('opacity', '1');
            });
        </script>
    </asp:PlaceHolder>
</body>
