<%@ Control Language="C#"
    AutoEventWireup="true"
    CodeBehind="SeoInformers.ascx.cs"
    Inherits="AlbumFront.Components.SeoInformers" %>

<asp:Panel runat="server" ID="RootElement">
    <asp:PlaceHolder ID="OneGb" runat="server">
        <div>
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
    </asp:PlaceHolder>

    <asp:PlaceHolder ID="Extreme" runat="server">
        <div>
            <script src="https://efreecode.com/js.js" id="eXF-osyssey-0" async defer></script>
        </div>
    </asp:PlaceHolder>

    <asp:PlaceHolder ID="MailRu" runat="server">
        <div>
            <!-- Rating@Mail.ru logo -->
            <a href="https://top.mail.ru/jump?from=2448879">
                <img src="//top-fwz1.mail.ru/counter?id=2448879;t=479;l=1"
                    style="border: 0;" height="31" width="88" alt="Рейтинг@Mail.ru" />
            </a>
            <!-- //Rating@Mail.ru logo -->
        </div>
    </asp:PlaceHolder>

    <asp:PlaceHolder ID="Yandex" runat="server">
        <div>
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
    </asp:PlaceHolder>
</asp:Panel>
