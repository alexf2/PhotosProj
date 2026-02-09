<%@ Page
    Language="C#"
    AutoEventWireup="true"
    CodeBehind="ThroughHorizonLanding.aspx.cs"
    Inherits="AlbumFront.ThroughHorizonLanding"
    MetaKeywords="хайкинг, легкоходный туризм, туризм налегке, фото-поездки, треккинг, ПВД, однодневки, походы на два три дня, походы из Москвы, GPS, GPX треки"
    MetaDescription="Сквозь горизонт: хайкинг, легкоходный туризм и фото-поездки налегке. Полезные гайды, маршруты и советы для трейлов с минимальным весом. База походов с метриками сложности и GPS-Треками. Присоединяйтесь к сообществу на Boosty!"
    Culture="auto"
    UICulture="auto"
    Title="Сквозь горизонт: хайкинг, легкоходный туризм и фото-поездки налегке" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="ru">

<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="yandex-verification" content="d6ff7bab1f833376" />

    <link rel="canonical" href="<%= "https://" + ConfigurationManager.AppSettings["CanonicalDomain"] + HttpContext.Current.Request.Url.AbsolutePath %>" />
    <link rel="icon" type="image/png" sizes="16x16" href="img/photo_album_blue.png">
    <link rel="icon" type="image/png" sizes="128x128" href="img/photo_album.png">
    <link rel="apple-touch-icon" sizes="128x128" href="img/photo_album.png">
    <meta name="theme-color" content="#ffffff">
    <link rel="manifest" href="img/manifest.json">

    <asp:PlaceHolder runat="server">
        <% = Styles.Render("~/bundles/extra-css") %>
        <% = Styles.Render("~/bundles/horizon-css") %>        
    </asp:PlaceHolder>

    <!-- Yandex.Metrika counter -->
    <script type="text/javascript">
        (function (m, e, t, r, i, k, a) {
            m[i] = m[i] || function () { (m[i].a = m[i].a || []).push(arguments) };
            m[i].l = 1 * new Date();
            for (var j = 0; j < document.scripts.length; j++) { if (document.scripts[j].src === r) { return; } }
            k = e.createElement(t), a = e.getElementsByTagName(t)[0], k.async = 1, k.src = r, a.parentNode.insertBefore(k, a)
        })(window, document, 'script', '//mc.yandex.ru/metrika/tag.js?id=106723925', 'ym');

        ym(106723925, 'init', { ssr: true, webvisor: true, clickmap: true, referrer: document.referrer, url: location.href, accurateTrackBounce: true, trackLinks: true });
    </script>
    <noscript>
        <div>
            <img src="//mc.yandex.ru/watch/106723925" style="position: absolute; left: -9999px;" alt="" />
        </div>
    </noscript>
    <!-- /Yandex.Metrika counter -->
</head>

<body class="horizon">
    <!-- Rating@Mail.ru counter -->
    <script language="javascript1.1" type="text/javascript">
        //<![CDATA[
        var _tmr = _tmr || [];
        _tmr.push({ id: "2448879", type: "pageView", start: (new Date()).getTime() });
        (function (d, w) {
            var ts = d.createElement("script"); ts.type = "text/javascript"; ts.async = true;
            ts.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//top-fwz1.mail.ru/js/code.js";
            var f = function () { var s = d.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ts, s); };
            if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); }
        })(document, window);
        //]]></script>
    <noscript>
        <div style="position: absolute; left: -10000px;">
            <img src="//top-fwz1.mail.ru/counter?id=2448879;js=na" style="border: 0;" height="1" width="1" alt="Рейтинг@Mail.ru" />
        </div>
    </noscript>
    <!-- //Rating@Mail.ru counter -->

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

    <main class="PageContainer">

        <header class="MenuHeader  LnkCont">
            <nav class="MenuHeaderContent" xmlns:xlink="http://www.w3.org/1999/xlink">
                <a href="<% = URL_HORIZON %>" target="_blank" rel="noopener">
                    <svg role="img" aria-label="О сообществе">
                        <use xlink:href="#icon-boosty"></use></svg>Сообщество
                </a>|
                <a href="<% = URL_ABOUT_HORIZON %>" target="_blank" rel="noopener">О сообществе</a>|
                <a href="<% = URL_TG %>" target="_blank" rel="noopener">
                    <svg role="img" aria-label="Канал">
                        <use xlink:href="#icon-telegram"></use></svg>Канал
                </a>|
                <a href="#instructions">
                    <svg role="img" aria-label="Инструкции">
                        <use xlink:href="#icon-note"></use></svg>Инструкции
                </a>
            </nav>
            <div class="MenuHeaderContent LogoName"><b>Сквозь горизонт 🥾</b></div>
        </header>

        <section class="MainContainer">
            <header class="HeaderContainer">
                База маршрутов для легкоходного туризма, походов выходного дня и однодневок налегке.
                    Всё, что нужно для прохождения: GPS-треки, фото, описания, инструкции и метрики.                
            </header>
            <div class="InnerContainer">
                <img class="FadeOnLoad LogoImg" width="240" height="239" src="<%=ResolveClientUrl("img/logo_23696-2.png")%>" border="0" title="Сообщество Сквозь горизонт" alt="Сообщество Сквозь горизонт" />
                <div class="LandingImage">
                    <img class="FadeOnLoad" width="1000" height="667" src="<%=ResolveClientUrl("img/landing_img.jpg")%>" border="0" title="Сообщество Сквозь горизонт" alt="Сообщество Сквозь горизонт" />
                </div>
                <div class="Subscriptions">
                    <div>
                        <a href="<% = URL_ONE_DAY %>" target="_blank" rel="noopener">
                            <img class="FadeOnLoad" width="240" height="164" src="<%=ResolveClientUrl("img/25-jonas__68768.jpg")%>" border="0" title="Подписка на однодневки" alt="Подписка на однодневки" />
                        </a>
                        <a class="LinkBtn" role="button" href="<% = URL_ONE_DAY %>" target="_blank" rel="noopener">Подписаться</a>
                    </div>

                    <div>
                        <a href="<% = URL_PVD  %>" target="_blank" rel="noopener">
                            <img class="FadeOnLoad" width="240" height="164" src="<%=ResolveClientUrl("img/35-jonas-rafael__68769.jpg")%>" border="0" title="Подписка на ПВД" alt="Подписка на ПВД" />
                        </a>
                        <a class="LinkBtn" role="button" href="<% = URL_PVD %>" target="_blank" rel="noopener">Подписаться</a>
                    </div>

                    <div>
                        <a href="<% = URL_FULL %>" target="_blank" rel="noopener">
                            <img class="FadeOnLoad" width="240" height="164" src="<%=ResolveClientUrl("img/45-jonas-rafael-alejandro__68770.jpg")%>" border="0" title="Полная подписка" alt="Полная подписка" />
                        </a>
                        <a class="LinkBtn" role="button" href="<% = URL_FULL%>" target="_blank" rel="noopener">Подписаться</a>
                    </div>
                </div>
            </div>
        </section>

        <section id="instructions" class="PlainText">
            <header class="SectionHeaderBg">
                <div class="SectionHeader2" style="float: left">Как присоединиться к сообществу &quot;Сквозь Горизонт&quot;</div>
                <div class="SectionHeaderBgCap" style="float: right"></div>
            </header>

            <p>
                База походных маршрутов ведётся в форме канала на платформе Boosty, куда и предпочтительно подписываться, так
                как имеется Web и мобильное приложение с функционалом, сопоставимым Телеграму. Кроме того, Boosty удобнее
                для поиска и фильтрации походов, поддерживает фильтр по тегам, позволяющий сразу найти требуемые типы походов. 
                Например, только однодневки, только ПВД или отфильтровать по сложности. При этом, на платформе нет проблем доступа
                к фото и видео контенту, как замедление в Телеграме, и нет проблем с оплатой: принимается карта Мир. Над Boosty
                не висит угроза блокировки. Мобильное приложение Boosty предоставляет уведомления, как и Телеграм.
            </p>
            <p>
                Как дополнительные ворота в сообщество &quot;Сквозь Горизонт🥾&quot; имеется Телеграм канал. Это способ мгновенного
                доступа к сообществу для тех, у кого ещё нет регистрации на Boosty, однако, он неполноценный, так как в Телеграме
                нельзя покупать артефакты для прохождения маршрутов и походов: GPS-треки, дополнительные координаты и расширенные инструкции.
            </p>
            <p>
                Поэтому, я рекомендую  👉регистрироваться в Boosty и устанавливать мобильное приложение.
            </p>
            <ol class="StepsList">
                <li>Зарегистрируйтесь на Boosty по ссылке: 🔗<a href="https://boosty.to/" target="_blank" rel="noopener">https://boosty.to/</a>.
                    Кнопка регистрации в правом верхнем углу. Boosty поддерживает OAuth, поэтому, если у вас уже есть
                    регистрация в Google, VK, Одноклассниках, MailRu, YouTube или Твиче, то регистрироваться не понадобится,
                    можно просто присоединиться используя одну из перечисленных учёток.
                </li>
                <li>Далее, откройте страницу нашего сообщества: 🔗<a href="https://boosty.to/through_horizon" target="_blank" rel="noopener">https://boosty.to/through_horizon</a>.
                    Cлева вверху под логотипом канала будет кнопочка Follow/Отслеживать, чтобы 🔔 подписаться на канал. Нажимаем.
                </li>
                <li>Появится диалоговое окно с двумя кнопками: Subscribe/Оформить подписку и Skip/Пропустить. Жмём Skip.
                    Готово! 🤝 Вы подписаны на уведомления нашего канала. Платную подписку можно выбрать в любое время позже,
                    если она вам понадобится. Ваши подписки 🔔 отобразятся на домашней странице Boosty в правой трети экрана.
                </li>
                <li>Теперь устанавливаем  👉мобильное приложение Boosty из RuStore. В нём нужно будет залогиниться
                    используя ту же учётку, что и в Web-версии.<br />
                    🔗<a href="https://www.rustore.ru/" target="_blank" rel="noopener">https://www.rustore.ru/</a><br />
                    🔗<a href="https://www.rustore.ru/instruction" target="_blank" rel="noopener">Инструкция по установке RuStore.</a><br />
                    🔗<a href="https://www.rustore.ru/catalog/app/to.boosty.mobile" target="_blank" rel="noopener">Мобильное приложение Boosty в RuStore.</a>
                </li>
            </ol>
            <img class="FadeOnLoad ImgCentered" width="389" height="422" src="<%=ResolveClientUrl("img/boosty_qr_rustore.jpg")%>" border="0" title="QR-код для установки Boosty" alt="QR-код для установки Boosty" />
            <p>
                После этого, вам уже не понадобится костыль в виде Телеграм, так как вы напрямую будете 
                получать уведомления в мобильном Boosty и читать  мой канал напрямую, без помощи 
                Web-браузера, что быстрее и удобнее. Также, если вам понадобится GPS трек, точки 
                похода/поездки, то только через Boosty вы сможете купить закрытую часть поста, либо 
                оформить подписку с доступом к закрытым частям. 🤝
            </p>
        </section>

        <footer class="LnkCont">
            <div class="LineBg" style="text-align: center">
                <div class="LineLeftCap">&nbsp;</div>
                <div class="LineRightCap">&nbsp;</div>
            </div>
        </footer>

        <asp:PlaceHolder runat="server">
            <% = Scripts.Render("~/bundles/jquery") %>

            <script language="javascript1.1" type="text/javascript">
                $('.FadeOnLoad').each(function () {
                    if (!this.complete)
                        $(this).one('load', function () { $(this).css('opacity', '1'); })
                    else
                        $(this).css('opacity', '1');
                });
            </script>
        </asp:PlaceHolder>

        <div id="Counter" style="display: flex; gap: 0.5rem; margin-top: 1rem">
            <div id="oneGb">
                <script language="javascript" type="text/javascript">
                    cgb_js = "1.0"; cgb_r = "" + Math.random() + "&r=" +
                        escape(document.referrer) + "&pg=" +
                        escape(window.location.href);
                    document.cookie = "rqbct=1; path=/"; cgb_r += "&c=" +
                        (document.cookie ? "Y" : "N");
                </script>
                <script language="javascript1.1" type="text/javascript">
                    cgb_js = "1.1"; cgb_r += "&j=" +
                        (navigator.javaEnabled() ? "Y" : "N")</script>
                <script language="javascript1.2" type="text/javascript">
                    cgb_js = "1.2"; cgb_r += "&wh=" + screen.width +
                        'x' + screen.height + "&px=" +
                        (((navigator.appName.substring(0, 3) == "Mic")) ?
                            screen.colorDepth : screen.pixelDepth)</script>
                <script language="javascript1.3" type="text/javascript">
                    cgb_js = "1.3"</script>
                <script language="javascript"
                    type="text/javascript">
                    cgb_r += "&js=" + cgb_js;
                    document.write("<a href='https://www.1gb.ru?cnt=66030'>" +
                        "<img src='//counter.1gb.ru/cnt.aspx?" +
                        "u=66030&" + cgb_r +
                        "&' border=0 width=88 height=31 " +
                        "alt='1Gb.ru counter'><\/a>")</script>
                <noscript>
                    <a href='https://www.1gb.ru?cnt=66030'>
                        <img src="//counter.1gb.ru/cnt.aspx?u=66030"
                            border="0" width="88" height="31" alt="1Gb.ru counter" />
                    </a>
                </noscript>
            </div>

            <div id="eXTReMe">
                <script src="https://efreecode.com/js.js" id="eXF-osyssey-0" async defer></script>
            </div>

            <div id="mailRu">
                <!-- Rating@Mail.ru logo -->
                <a href="https://top.mail.ru/jump?from=2448879">
                    <img src="//top-fwz1.mail.ru/counter?id=2448879;t=479;l=1"
                        style="border: 0;" height="31" width="88" alt="Рейтинг@Mail.ru" />
                </a>
                <!-- //Rating@Mail.ru logo -->
            </div>

            <div id="yandex_inf">
                <!-- Yandex.Metrika informer -->
                <a href="https://metrica.yandex.com/stat/?id=106723925&amp;from=informer" target="_blank" rel="nofollow">
                    <img src="//informer.yandex.ru/informer/106723925/3_1_FFFFFFFF_EFEFEFFF_0_pageviews"
                        style="width: 88px; height: 31px; border: 0;"
                        alt="Yandex Metrica"
                        title="Yandex Metrica: data for today (pageviews, visits and unique users)"
                        class="ym-advanced-informer" data-cid="106723925" data-lang="en" />
                </a>
                <!-- /Yandex.Metrika informer -->
            </div>


            <div id="yandex">
                <!-- Yandex.Webmaster index X -->
                <a href="https://webmaster.yandex.ru/siteinfo/?site=https://afedorov.info">
                    <img width="88" height="31" alt="" border="0" border-radius="8" src="//yandex.ru/cycounter?https://afedorov.info&theme=light&lang=en" />
                </a>
                <!-- Yandex.Webmaster index X -->
            </div>

        </div>
    </main>
</body>
