<%@ Page Language="C#"    
    EnableEventValidation="True"
    MasterPageFile = "~/OuterMasterPage.master"
    MetaKeywords = "Алексей Федоров, фотографии, альбомы, Одиссей, Крым, Адыгея, Греция, Италия, Норвегия, Исландия, Испания, Франция, Индия, Киргизия, Египет, Раджастан, Марокко, Сахара, США, Аризона, Юта, Невада, Мьянма, Бирма, Чехия, Словакия, Южная Моравия"
    MetaDescription="Фотоальбомы Одиссея, экспедиции и автопробеги, отчеты"
    Culture="auto"  UICulture="auto" Title = "Ὀδύσσεια ---== Odyssey's Photos ==--- Ὀδύσσεια" %>

<%@ Register TagPrefix="uc" 
             TagName="CatItem" 
             Src="./CatItem.ascx" %>

<script language="c#" runat="server">
    public void Page_Load (object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var ctl = (HyperLink)this.Master.FindControl("defLnk");
            if (ctl != null)
            {
                ctl.Enabled = false;
                ctl.CssClass = "LinkCurr";
            }
        }
 
    }
</script>

<asp:Content ContentPlaceHolderID = "idIndicatorsInit" runat = "server" >
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
            //]]></script><noscript>
            <div style="position:absolute;left:-10000px;">
                <img src="//top-fwz1.mail.ru/counter?id=2448879;js=na" style="border:0;" height="1" width="1" alt="Рейтинг@Mail.ru" />
            </div>
        </noscript>
        <!-- //Rating@Mail.ru counter -->
</asp:Content>

<asp:Content ID = "idAboutContent" ContentPlaceHolderID = "idMainPls" runat = "server" >    
    
    <article class="Centering ContentLnk">

        <div class="SectionHeaderBg">
            <div class="SectionHeader" style="float:left">Отчёты Одиссея</div><div class="SectionHeaderBgCap" style="float:right"></div>
        </div>
        <div class="SectionBody">
            <a href="<%=ResolveClientUrl("TravelReports/CrimeaReport2006/Crimea2006Report_cenz.htm")%>">Транскрымский автопробег 2006</a><br />
            <a href="<%=ResolveClientUrl("TravelReports/CrimeaReport2007/SevenPagesAboutCrimea.htm")%>">Семь страниц о Крыме (Крым 2007)</a><br />
            <a href="<%=ResolveClientUrl("TravelReports/Abhaziya2007/Abhaziya2007.htm")%>">Абхазия 2007</a>
        </div>

        <div class="SectionHeaderBg">
            <div class="SectionHeader" style="float:left">Альбомы и репортажи Одиссея</div><div class="SectionHeaderBgCap" style="float:right"></div>
        </div>
        <div class="SectionBody">
            <a href="<%=ResolveClientUrl("Albums/PageGen.aspx")%>">Все альбомы</a> <br /><br />
            <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=crimea&amp;pwd=crim8976")%>">Крым 2006</a> <br />
            <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=crimea&amp;pwd=crim8976")%>">Крым 2007</a> <br />
            <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=seliger&amp;pwd=lake875")%>">Селигер</a> <br />
            <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=aws&amp;pwd=aws8778566")%>">AWS</a> <br />
            <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=moscow-reg&amp;pwd=msc0987")%>">Подмосковье</a> <br />
            <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=Greece&amp;pwd=gr19655")%>">Греция 2008</a> <br />
            <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=Italy&amp;pwd=gr19655")%>">Италия 2009</a>&nbsp;&nbsp;<a href="<%=ResolveClientUrl("Pub/Maps/italy2009.htm")%>"><img style="vertical-align: middle" src="<%=ResolveClientUrl("img/map.gif")%>" alt="Карта маршрута" border="0" title="Карта маршрута" /></a> <br />

            <uc:CatItem Name="Adygeya2009" Login="Adygeya" Pwd="ad1278" ImgCss="ImgThumbNormal" Description="Горная Адыгея 2009" runat="server" />
            <uc:CatItem Name="Norway2010" Login="Norway" Pwd="nrw952" ImgCss="ImgThumbSmall" Description="Автопробег по Норвегии 2010" runat="server" />
            <uc:CatItem Name="Iceland2011" Login="Iceland" Pwd="ice952" ImgCss="ImgThumbNormal_Ice" Description="Экспедиция Исландия 2011" runat="server" />
            <uc:CatItem Name="SpainFrance2011" Login="SpainFrance" Pwd="spf127" ImgCss="ImgThumbNormal" Description="Испания - Андорра - Франция/катарские замки 2011" runat="server" />
            <uc:CatItem Name="Ehypet2012" Group="EhypetGroup" Login="ehypet" Pwd="ehypet08260" ImgCss="ImgThumbNormal" Description="Северная Африка 2012" runat="server" />
            <uc:CatItem Name="Kirgiz2012" ImgCss="ImgThumbNormal_Kgz" Description="Киргизия 2012" runat="server" />
            <uc:CatItem Name="India2013" ImgCss="ImgThumbNormal_Ind" Description="Индия 2013 Раджастан" runat="server" />
            <uc:CatItem Name="Morocco2013" Group="Morocco2013Group" Login="morocco" Pwd="mrk1947845" ImgCss="ImgThumbNormal" Description="Марокко 2013, Север, Юг, Сахара и Атлас" runat="server" />
            <uc:CatItem Name="Norway2016" Login="norway2016" Pwd="nrw952" ImgCss="ImgThumbNormal_Norw2016" Description="Норвегия 2016, Тюнсет, Оппдал, Науста" runat="server" />
            <uc:CatItem Name="TrollTunga2016" ImgCss="ImgThumbNormal_TrollTunga2016" Description="Норвегия 2016, Язык Тролля и Хордаланн" runat="server" />
            <uc:CatItem Name="Usa2017" ImgCss="ImgThumbNormal_Usa2017" Description="Америка 2017: Аризона, Юта, Невада, Калифорния" runat="server" />
            <uc:CatItem Name="Myanmar2015" Login="myanmar2015" Pwd="mmr2015" ImgCss="ImgThumbNormal_Myanmar2015" Description="Бирма 2015: Янгон, Баган, Мандалай, озеро Инле" runat="server" />
            <uc:CatItem Name="Moravia2016" ImgCss="ImgThumbNormal_Myanmar2015" Description="Южная Моравия 2016" runat="server" />
            <uc:CatItem Name="DolomiteAlps2016" ImgCss="ImgThumbNormal_Myanmar2015" Description="Доломитовые Альпы 2016" runat="server" />
            <uc:CatItem Name="Montblanc2017" ImgCss="ImgThumbNormal_Myanmar2015" Description="Альпы 2017: трек вокруг Монблана (TMB)" runat="server" />
            <uc:CatItem Name="Scotland2017" ImgCss="ImgThumbNormal_Myanmar2015" Description="Экспедиция в Шотландию 2017" runat="server" />
            <uc:CatItem Name="Cappadocia2018" ImgCss="ImgThumbNormal_Myanmar2015" Description="Каппадокия 2018" runat="server" />
            <uc:CatItem Name="Madeira2018" ImgCss="ImgThumbNormal_Myanmar2015" Description="Мадейра 2018" runat="server" />
            <uc:CatItem Name="Solovki2019" ImgCss="ImgThumbNormal_Myanmar2015" Description="Соловецкие острова 2019, Белое море" runat="server" />
            <uc:CatItem Name="Laplandia2020" ImgCss="ImgThumbNormal_Myanmar2015" Description="Лапландия 2020" runat="server" />

            <uc:CatItem Name="Seliger2019" Description="Сплав по Селигеру 2019" runat="server" />
            <uc:CatItem Name="BenskiePorogi2019" Description="Сплав по Волге на Бенские пороги 2019" runat="server" />
            <uc:CatItem Name="PlescheevoLake2019" Description="Поход вокруг Плещеева озера 42км 2019" runat="server" />
            <uc:CatItem Name="PraRafting" Description="Сплав по Пре 50км, 2019" runat="server" />
            <uc:CatItem Name="Konduki2019" Description="Кондуки, лето 2019" runat="server" />
            <uc:CatItem Name="Konduki2019-2" Description="Кондуки, осень 2019" runat="server" />
            <uc:CatItem Name="Divnogorie2020" Description="Дивногорье, лето 2020" runat="server" />
            <uc:CatItem Name="Epifan2019" Description="Епифань, лето 2020" runat="server" />
            <uc:CatItem Name="Pronsk" Description="Пронск, лето 2020" runat="server" />
            <uc:CatItem Name="Tarusa" Description="Таруса, лето 2020" runat="server" />
            <uc:CatItem Name="Ishutino" Description="Ишутино среди сезонов" runat="server" />
            <uc:CatItem Name="Vorgol" Description="Воргольские скалы, лето 2019" runat="server" />
        </div>

        <div class="SectionHeaderBg">
            <div class="SectionHeader" style="float:left">Прочее</div><div class="SectionHeaderBgCap" style="float:right"></div>
        </div>
        <div class="SectionBody">
            <a href="<%=ResolveClientUrl("Pub/Jokes/Laps.htm")%>">Таймлапсы</a><br />
            <a href="<%=ResolveClientUrl("Pub/Celebrity/Celerbrity.htm")%>">Знаменитости</a><br />
        </div>
    </article>
    
</asp:Content>

<asp:Content ContentPlaceHolderID = "idIndicatorsView" runat = "server" >    
<div id="oneGb" style="float:left;">
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
                    document.write("<a href='http://www.1gb.ru?cnt=66030'>" +
                    "<img src='http://counter.1gb.ru/cnt.aspx?" +
                    "u=66030&" + cgb_r +
                    "&' border=0 width=88 height=31 " +
                    "alt='1Gb.ru counter'><\/a>")</script>
                <noscript>
                    <a href='http://www.1gb.ru?cnt=66030'>
                        <img src="http://counter.1gb.ru/cnt.aspx?u=66030"
                             border=0 width="88" height="31" alt="1Gb.ru counter" />
                    </a>
                </noscript>
            </div>

            <div id="eXTReMe" style="float:left; padding-left: 5pt">
                                
                    <a href="http://extremetracking.com/open?login=osyssey"><img src="http://t1.extreme-dm.com/i.gif" style="border: 0;"
                         height="38" width="41" id="EXim" alt="eXTReMe Tracker" /></a>
                
                <script type="text/javascript">
<!--
        EXref="";top.document.referrer?EXref=top.document.referrer:EXref=document.referrer;//-->
                </script>
                <script type="text/javascript">
<!--
        var EXlogin='osyssey' // Login
        var EXvsrv='s9' // VServer
        EXs=screen;EXw=EXs.width;navigator.appName!="Netscape"?
        EXb=EXs.colorDepth:EXb=EXs.pixelDepth;EXsrc="src";
        navigator.javaEnabled()==1?EXjv="y":EXjv="n";
        EXd=document;EXw?"":EXw="na";EXb?"":EXb="na";
        EXref?EXref=EXref:EXref=EXd.referrer;
        EXd.write("<img "+EXsrc+"=http://e0.extreme-dm.com",
        "/"+EXvsrv+".g?login="+EXlogin+"&amp;",
        "jv="+EXjv+"&amp;j=y&amp;srw="+EXw+"&amp;srb="+EXb+"&amp;",
        "l="+escape(EXref)+" height=1 width=1>");//-->
                </script><noscript>
                    <div id="neXTReMe">
                        <img height="1" width="1" alt=""
                             src="http://e0.extreme-dm.com/s9.g?login=osyssey&amp;j=n&amp;jv=n" />
                    </div>
                </noscript>
            </div>

            <div id="mailRu" style="float:left; padding-left: 2pt">
                <!-- Rating@Mail.ru logo -->
                <a href="http://top.mail.ru/jump?from=2448879">
                    <img src="http://top-fwz1.mail.ru/counter?id=2448879;t=479;l=1"
                         style="border:0;" height="31" width="88" alt="Рейтинг@Mail.ru" />
                </a>
                <!-- //Rating@Mail.ru logo -->
            </div>
</asp:Content>
