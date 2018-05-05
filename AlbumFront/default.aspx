<%@ Page Language="C#"    
    EnableEventValidation="True"
    MasterPageFile = "~/OuterMasterPage.master"
    MetaKeywords = "Алексей Федоров, фотографии, альбомы, Одиссей, Крым, Адыгея, Греция, Италия, Норвегия, Исландия, Испания, Франция, Индия, Киргизия, Египет, Раджастан, Марокко, Сахара, США, Аризона, Юта, Невада, Мьянма, Бирма, Чехия, Словакия, Южная Моравия"
    MetaDescription="Фотоальбомы Одиссея, экспедиции и автопробеги, отчеты"
    Culture="auto"  UICulture="auto" Title = "Ὀδύσσεια ---== Odyssey's Photos ==--- Ὀδύσσεια" %>

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

            <div class="pad">
                <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=Adygeya&amp;pwd=ad1278")%>">Горная Адыгея 2009</a>
            </div>
            <a href="<%=ResolveClientUrl("Pub/Adygeya/Adygeya2009Pub.htm")%>"><img src="<%=ResolveClientUrl("img/AdygeyaRepThumb.jpg")%>" class="ImgThumbNormal FadeOnLoad EasingShadow" title="Репортаж Горная Адыгея 2009" alt="Репортаж Горная Адыгея 2009" /></a> <br />	<br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=Norway&amp;pwd=nrw952")%>">Автопробег по Норвегии 2010</a>
            </div>
            <a href="<%=ResolveClientUrl("Pub/Norway2010/Norway2010Pub.htm")%>"><img src="<%=ResolveClientUrl("img/Norway2010RepThumb.jpg")%>" class="ImgThumbSmall FadeOnLoad EasingShadow" title="Репортаж Норвегия 2010" alt="Репортаж Норвегия 2010" /></a> <br />	<br />

            <div class="pad" >
                <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=Iceland&amp;pwd=ice952")%>">Экспедиция Исландия 2011</a>&nbsp;&nbsp;<a href="<%=ResolveClientUrl("Pub/Maps/iceland2010.htm")%>"><img style="vertical-align: middle" src="<%=ResolveClientUrl("img/map.gif")%>" border="0" title="Карта маршрута" alt="Карта маршрута" /></a>
            </div>
            <a href="<%=ResolveClientUrl("Pub/Iceland2011/Iceland2011Pub.htm")%>"><img src="<%=ResolveClientUrl("img/IcelandRepThumb.jpg")%>" class="ImgThumbNormal_Ice FadeOnLoad EasingShadow" title="Репортаж Исландия 2011" alt="Репортаж Исландия 2011" /></a> <br />	<br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=SpainFrance&amp;pwd=spf127")%>">Испания - Андорра - Франция/катарские замки 2011</a>&nbsp;&nbsp;<a href="<%=ResolveClientUrl("Pub/Maps/spainfrance2011.htm")%>"><img style="vertical-align: middle" src="<%=ResolveClientUrl("img/map.gif")%>" border="0" title="Карта маршрута" alt="Карта маршрута" /></a>
            </div>
            <a href="<%=ResolveClientUrl("Pub/SpainFrance2011/SpainFrance2011Pub.htm")%>"><img src="<%=ResolveClientUrl("img/SpainFranceThumb.jpg")%>" class="ImgThumbNormal FadeOnLoad EasingShadow" title="Репортаж Испания - Андорра - Франция/катарские замки 2011" alt="Репортаж Испания - Андорра - Франция/катарские замки 2011" /></a> <br />	<br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=ehypet&amp;pwd=ehypet08260")%>">Северная Африка 2012</a>&nbsp;&nbsp;<a href="<%=ResolveClientUrl("Pub/Maps/ehypet2012.htm")%>"><img style="vertical-align: middle" src="<%=ResolveClientUrl("img/map.gif")%>" border="0" title="Карта маршрута" alt="Карта маршрута" /></a>&nbsp;&nbsp;<a href="<%=ResolveClientUrl("Pub/EhypetGroup/EhypetGroup.htm")%>">Группа</a>
            </div>
            <a href="<%=ResolveClientUrl("Pub/Ehypet2012/Ehypet2012Pub.htm")%>"><img src="<%=ResolveClientUrl("img/EhypetRepThumb.jpg")%>" class="ImgThumbNormal FadeOnLoad EasingShadow" title="Репортаж Египет 2012" alt="Репортаж Египет 2012" /></a> <br /> <br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Pub/Kirgiz2012/Kirgiz2012Pub.htm")%>">Киргизия 2012</a>&nbsp;&nbsp;<a href="<%=ResolveClientUrl("Pub/Maps/Kirgiz2012.htm")%>"><img style="vertical-align: middle" src="<%=ResolveClientUrl("img/map.gif")%>" border="0" title="Карта маршрута" alt="Карта маршрута" /></a>
            </div>
            <a href="<%=ResolveClientUrl("Pub/Kirgiz2012/Kirgiz2012Pub.htm")%>"><img src="<%=ResolveClientUrl("img/KirgizRepThumb.jpg")%>" class="ImgThumbNormal_Kgz FadeOnLoad EasingShadow" title="Репортаж Киргизия 2012" alt="Репортаж Киргизия 2012" /></a> <br /> <br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Pub/India2013/India2013Pub.htm")%>">Индия 2013 Раджастан</a>
            </div>
            <a href="<%=ResolveClientUrl("Pub/India2013/India2013Pub.htm")%>"><img src="<%=ResolveClientUrl("img/India2013RepThumb.jpg")%>" class="ImgThumbNormal_Ind FadeOnLoad EasingShadow" title="Репортаж по Индии 2013, Раджастану" alt="Репортаж по Индии 2013, Раджастану" /></a> <br /><br />
            
            <div class="pad">
                <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=morocco&amp;pwd=mrk1947845")%>">Марокко 2013, Север, Юг, Сахара и Атлас</a>&nbsp;&nbsp;<a href="<%=ResolveClientUrl("Pub/Morocco2013Group/Morocco2013Group.htm")%>">Группа</a>
            </div>
            <a href="<%=ResolveClientUrl("Pub/Morocco2013/Morocco2013.htm")%>"><img src="<%=ResolveClientUrl("img/Morocco2013RepThumb.jpg")%>" class="ImgThumbNormal FadeOnLoad EasingShadow" title="Марокко 2013, Север, Юг, Сахара и Атлас" alt="Марокко 2013, Север, Юг, Сахара и Атлас" /></a> <br />	<br />

	        <div class="pad">
                <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=norway2016&amp;pwd=nrw952")%>">Норвегия 2016, Тюнсет, Оппдал, Науста</a>&nbsp;&nbsp;
            </div>
            <a href="<%=ResolveClientUrl("Pub/Norway2016/Norway2016.htm")%>"><img src="<%=ResolveClientUrl("img/Norway2016Thumb.jpg")%>" class="ImgThumbNormal_Norw2016 FadeOnLoad EasingShadow" title="Норвегия 2016, Тюнсет, Оппдал, Науста" alt="Норвегия 2016, Тюнсет, Оппдал, Науста" /></a> <br />	<br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Pub/TrollTunga2016/TrollTunga2016.htm")%>">Норвегия 2016, Язык Тролля и Хордаланн</a>&nbsp;&nbsp;
            </div>
            <a href="<%=ResolveClientUrl("Pub/TrollTunga2016/TrollTunga2016.htm")%>"><img src="<%=ResolveClientUrl("img/TrollTunga2016Thumb.jpg")%>" class="ImgThumbNormal_TrollTunga2016 FadeOnLoad EasingShadow" title="Норвегия 2016, Язык Тролля и Хордаланн" alt="Норвегия 2016, Язык Тролля и Хордаланн" /></a> <br />	<br />
            
            <div class="pad">
                <a href="<%=ResolveClientUrl("Pub/Usa2017/Usa2017.htm")%>">Америка 2017: Аризона, Юта, Невада, Калифорния</a>&nbsp;&nbsp;
            </div>
            <a href="<%=ResolveClientUrl("Pub/Usa2017/Usa2017.htm")%>"><img src="<%=ResolveClientUrl("img/Usa2017Thumb.jpg")%>" class="ImgThumbNormal_Usa2017 FadeOnLoad EasingShadow" title="Америка 2017: Аризона, Юта, Невада, Калифорния" alt="Америка 2017: Аризона, Юта, Невада, Калифорния" /></a> <br />	<br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Albums/Login.aspx?login=myanmar2015&amp;pwd=mmr2015")%>">Бирма 2015: Янгон, Баган, Мандалай, озеро Инле</a>&nbsp;&nbsp;
            </div>
            <a href="<%=ResolveClientUrl("Pub/Myanmar2015/Myanmar2015.htm")%>"><img src="<%=ResolveClientUrl("img/Myanmar2015Thumb.jpg ")%>" class="ImgThumbNormal_Myanmar2015 FadeOnLoad EasingShadow" title="Бирма 2015: Янгон, Баган, Мандалай, озеро Инле" alt="Бирма 2015: Янгон, Баган, Мандалай, озеро Инле" /></a> <br />	<br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Pub/Moravia2016/Moravia2016.htm")%>">Южная Моравия 2016</a>&nbsp;&nbsp;
            </div>
            <a href="<%=ResolveClientUrl("Pub/Moravia2016/Moravia2016.htm")%>"><img src="<%=ResolveClientUrl("img/Moravia2016Thumb.jpg ")%>" class="ImgThumbNormal_Myanmar2015 FadeOnLoad EasingShadow" title="Южная Моравия 2016" alt="Южная Моравия 2016" /></a> <br /><br />

            <div class="pad">
                <a href="<%=ResolveClientUrl("Pub/Cappadocia2018/Cappadocia2018.htm")%>">Каппадокия 2018</a>&nbsp;&nbsp;
            </div>
            <a href="<%=ResolveClientUrl("Pub/Cappadocia2018/Cappadocia2018.htm")%>"><img src="<%=ResolveClientUrl("img/Cappadocia2018Thumb.jpg ")%>" class="ImgThumbNormal_Myanmar2015 FadeOnLoad EasingShadow" title="Каппадокия 2018" alt="Каппадокия 2018" /></a> <br /><br />
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
