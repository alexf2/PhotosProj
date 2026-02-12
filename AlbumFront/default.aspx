<%@ Page Language="C#"
    EnableEventValidation="True"
    MasterPageFile="~/OuterMasterPage.master"
    MetaKeywords="Алексей Федоров, фотографии, альбомы, Одиссей, Крым, Адыгея, Греция, Италия, Норвегия, Исландия, Испания, Франция, Индия, Киргизия, Египет, Раджастан, Марокко, Сахара, США, Аризона, Юта, Невада, Мьянма, Бирма, Чехия, Словакия, Южная Моравия"
    MetaDescription="Фотогалереи и фотоотчёты Одиссея: путешествия, автопробеги и походы по Крыму, Абхазии, Норвегии, Исландии, Альпам, США, Кавказу, Лапландии и историческим местам России с отчётами и альбомами."
    Culture="auto" UICulture="auto"
    Title="<%$ AppSettings:HomePageTitle %>" 
%>
    

<%@ Register TagPrefix="uc"
    TagName="CatItem"
    Src="~/Components/CatItem.ascx" %>
<%@ Register TagPrefix="uc"
    TagName="SectionHeader"
    Src="~/Components/SectionHeader.ascx" %>
<%@ Register TagPrefix="uc"
    TagName="ShareLinkIcons"
    Src="~/Components/ShareLinkIcons.ascx" %>

<asp:Content ContentPlaceHolderID="HeadMeta" runat="server">
    <meta property="og:title" content="Ὀδύσσεια ---== Odyssey's Photos ==--- Ὀδύσσεια" />
    <meta property="og:description" content="Фотогалереи и фотоотчёты Одиссея: путешествия, автопробеги и походы по Крыму, Абхазии, Норвегии, Исландии, Альпам, США, Кавказу, Лапландии и историческим местам России с отчётами и альбомами." />
    <meta property="og:url" content="<%= (Page.Master as AlbumFront.OuterMasterPage).GetCanonicalUrl() %>" />
    <meta property="og:image" content="<%= Request.Url.GetLeftPart(UriPartial.Authority) + Page.ResolveUrl("~/img/logo_23696-2.png") %>" />
    <meta property="og:type" content="website" />
    <meta property="og:locale" content="ru_RU" />
</asp:Content>

<script language="c#" runat="server">
    public void Page_Load(object sender, EventArgs e)
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

<asp:Content ID="idAboutContent" ContentPlaceHolderID="idMainPls" runat="server">

    <article class="Centering ContentLnk">
        <uc:SectionHeader Name="Альбомы и репортажи Одиссея" runat="server" />
        <section class="SectionBody">
            <a href="<%=Page.ResolveUrl("Albums/PageGen.aspx")%>">Все альбомы</a>
            <uc:ShareLinkIcons CssClass="ShareLinkPos" runat="server" />
            <br />
            <br />

            <uc:CatItem Name="Usa2019" ImgCss="ImgThumbNormal_Myanmar2015" Description="Западная Америка 2019" runat="server" />
            <uc:CatItem Name="Laplandia2020" ImgCss="ImgThumbNormal_Myanmar2015" Description="Лапландия 2020" runat="server" />
            <uc:CatItem Name="Solovki2019" ImgCss="ImgThumbNormal_Myanmar2015" Description="Соловецкие острова 2019, Белое море" runat="server" />
            <uc:CatItem Name="Madeira2018" ImgCss="ImgThumbNormal_Myanmar2015" Description="Мадейра 2018" runat="server" />
            <uc:CatItem Name="Cappadocia2018" ImgCss="ImgThumbNormal_Myanmar2015" Description="Каппадокия 2018" runat="server" />
            <uc:CatItem Name="Scotland2017" ImgCss="ImgThumbNormal_Myanmar2015" Description="Экспедиция в Шотландию 2017" runat="server" />
            <uc:CatItem Name="Montblanc2017" ImgCss="ImgThumbNormal_Myanmar2015" Description="Альпы 2017: трек вокруг Монблана (TMB)" runat="server" />
            <uc:CatItem Name="DolomiteAlps2016" ImgCss="ImgThumbNormal_Myanmar2015" Description="Доломитовые Альпы 2016" runat="server" />
            <uc:CatItem Name="Moravia2016" ImgCss="ImgThumbNormal_Myanmar2015" Description="Южная Моравия 2016" runat="server" />
            <uc:CatItem Name="Myanmar2015" Login="myanmar2015" Pwd="mmr2015" ImgCss="ImgThumbNormal_Myanmar2015" Description="Бирма 2015: Янгон, Баган, Мандалай, озеро Инле" runat="server" />
            <uc:CatItem Name="Usa2017" ImgCss="ImgThumbNormal_Usa2017" Description="Америка 2017: Аризона, Юта, Невада, Калифорния" runat="server" />
            <uc:CatItem Name="TrollTunga2016" ImgCss="ImgThumbNormal_TrollTunga2016" Description="Норвегия 2016, Язык Тролля и Хордаланн" runat="server" />
            <uc:CatItem Name="Norway2016" Login="norway2016" Pwd="nrw952" ImgCss="ImgThumbNormal_Norw2016" Description="Норвегия 2016, Тюнсет, Оппдал, Науста" runat="server" />
            <uc:CatItem Name="Morocco2013" Group="Morocco2013Group" Login="morocco" Pwd="mrk1947845" ImgCss="ImgThumbNormal" Description="Марокко 2013, Север, Юг, Сахара и Атлас" runat="server" />
            <uc:CatItem Name="India2013" ImgCss="ImgThumbNormal_Ind" Description="Индия 2013 Раджастан" runat="server" />
            <uc:CatItem Name="Kirgiz2012" ImgCss="ImgThumbNormal_Kgz" Description="Киргизия 2012" MapName="Kirgiz2012" runat="server" />
            <uc:CatItem Name="Ehypet2012" Group="EhypetGroup" Login="ehypet" Pwd="ehypet08260" MapName="ehypet2012" ImgCss="ImgThumbNormal" Description="Северная Африка 2012" runat="server" />
            <uc:CatItem Name="SpainFrance2011" Login="SpainFrance" Pwd="spf127" ImgCss="ImgThumbNormal" MapName="spainfrance2011" Description="Испания - Андорра - Франция/катарские замки 2011" runat="server" />
            <uc:CatItem Name="Iceland2011" Login="Iceland" Pwd="ice952" MapName="iceland2010" ImgCss="ImgThumbNormal_Ice" Description="Экспедиция Исландия 2011" runat="server" />
            <uc:CatItem Name="Norway2010" Login="Norway" Pwd="nrw952" ImgCss="ImgThumbSmall" Description="Автопробег по Норвегии 2010" runat="server" />
            <uc:CatItem Name="Adygeya2009" Login="Adygeya" Pwd="ad1278" ImgCss="ImgThumbNormal" Description="Горная Адыгея 2009" runat="server" />
            <uc:CatItem Login="Italy" Pwd="gr19655" MapName="italy2009" Description="Италия 2009" runat="server" />
            <uc:CatItem Login="Greece" Pwd="gr19655" Description="Греция 2008" runat="server" />
            <uc:CatItem Login="moscow-reg" Pwd="msc0987" Description="Подмосковье" runat="server" />
            <uc:CatItem Login="aws" Pwd="aws8778566" Description="AWS" runat="server" />
            <uc:CatItem Login="seliger" Pwd="lake875" Description="Селигер" runat="server" />
            <uc:CatItem Login="crimea" Pwd="crim8976" Description="Крым 2007" runat="server" />
            <uc:CatItem Login="crimea" Pwd="crim8976" Description="Крым 2006" runat="server" />
        </section>

        <uc:SectionHeader Name="Отчёты Одиссея" runat="server" />
        <section class="SectionBody">
            <a href="<%=Page.ResolveUrl("TravelReports/CrimeaReport2006/Crimea2006Report_cenz.htm")%>">Транскрымский автопробег 2006</a><br />
            <a href="<%=Page.ResolveUrl("TravelReports/CrimeaReport2007/SevenPagesAboutCrimea.htm")%>">Семь страниц о Крыме (Крым 2007)</a><br />
            <a href="<%=Page.ResolveUrl("TravelReports/Abhaziya2007/Abhaziya2007.htm")%>">Абхазия 2007</a>
        </section>

        <uc:SectionHeader Name="Мини альбомы Одиссея" runat="server" />
        <section class="SectionBody">
            <uc:CatItem Path="Winter2024/Frost" Name="Frost" Description="Иней в декабре, 2025" runat="server" />
            <uc:CatItem Path="Winter2025/Waterfall_Gorodenka" Name="Waterfall_Gorodenka" Description="Водопадик в лесу на роднике около Городенки / Шемякино, 2025" runat="server" />
            <uc:CatItem Path="Summer2022/Solotchya" Name="Solotchya" Description="Окская часть тропы Паустовского, лето 2022" runat="server" />
            <uc:CatItem Path="Summer2022/RaiSemenovskoye" Name="RaiSemenovskoye" Description="Райсемёновское, Иванова гора, лето 2022" runat="server" />
            <uc:CatItem Path="Summer2022/Pogost" Name="Pogost" Description="Село Погост Кассимовского района Рязанской области, лето 2022" runat="server" />
            <uc:CatItem Path="Summer2022/Krivoborye" Name="Krivoborye" Description="Подкова на Дону около Кривоборья летом 2022" runat="server" />                                                            
            <uc:CatItem Name="Kasimov" Description="Касимов 2021" runat="server" />
            <uc:CatItem Name="Vysha_StaroChereevo" Description="Выша и Старочернеево летом 2021" runat="server" />
            <uc:CatItem Path="Ivanovo2023/YurievPolskii" Name="YurievPolskii" Description="Юрьев Польский зимой 2023" runat="server" />
            <uc:CatItem Path="Ivanovo2023/ShuyaSobor" Name="ShuyaSobor" Description="Шуя зимой 2023" runat="server" />            
            <uc:CatItem Path="Ivanovo2023/Dyunilovo" Name="Dyunilovo" Description="Дунилово зимой 2023" runat="server" />
            <uc:CatItem Path="Ivanovo2023/Ivanovo" Name="Ivanovo" Description="Паровоз П36 в Иваново 2023" runat="server" />
            <uc:CatItem Name="Buzarovo" Description="Бужарово на Истре" runat="server" />
            <uc:CatItem Name="Istra" Description="Зимняя Истра и Новый Иерусалим" runat="server" />
            <uc:CatItem Path="Spring2023/Poschupovo" Name="Poschupovo" Description="Разлив Оки в Пощупово, Иоанно-Богословский монастырь 2023" runat="server" />
            <uc:CatItem Path="Spring2023/OldRyazan" Name="OldRyazan" Description="Разлив Оки в Старой Рязани 2023" runat="server" />
            <uc:CatItem Path="Spring2023/Murmino" Name="Murmino" Description="Разлив Оки в Мурмино 2023" runat="server" />
            <uc:CatItem Path="Spring2023/Ryazan" Name="Ryazan" Description="Разлив Оки в Шумаши 2023" runat="server" />
            <uc:CatItem Path="Summer2022/SchilovoForest" Name="SchilovoForest" Description="Шиловская аномалия, пьяный лес, лето 2022" runat="server" />
            <uc:CatItem Path="Autumn2021/Ishutino" Name="Ishutino" Description="Бабье лето 2021 на Ишутинском городище" runat="server" />
            <uc:CatItem Path="Autumn2021/Suvorov" Name="Suvorov" Description="Бабье лето 2021 на Суворовских карьерах" runat="server" />
            <uc:CatItem Path="Autumn2021/Tish" Name="Tish" Description="Бабье лето 2021 на озере Тишь" runat="server" />
            <uc:CatItem Path="Autumn2021/Chekalin" Name="Chekalin" Description="Бабье лето 2021 в Чекалине на Оке" runat="server" />
            <uc:CatItem Name="Flooding2021" Description="Весенний разлив 2021: Суздаль, Покрова на Нерли, Махра, Крутово, Весь" runat="server" />
            <uc:CatItem Name="Filipovskoe" Description="Разлив Шерны в Филиповском 2021" runat="server" />
            <uc:CatItem Name="SmallKonduki" Description="Малые Кондуки, лето 2020" runat="server" />
            <uc:CatItem Name="Sunflowers" Description="Подсолнухи, лето 2020, Ефремов" runat="server" />
            <uc:CatItem Name="Dyunilovo" Description="Дунилово, осень 2020" runat="server" />
            <uc:CatItem Name="Konstantinovo" Description="Константиново, осень 2019" runat="server" />
            <uc:CatItem Name="Vorgol" Description="Воргольские скалы, лето 2019" runat="server" />
            <uc:CatItem Name="Ishutino" Description="Ишутино среди сезонов" runat="server" />
            <uc:CatItem Name="Tarusa" Description="Таруса, лето 2020" runat="server" />
            <uc:CatItem Name="Pronsk" Description="Пронск, лето 2020" runat="server" />
            <uc:CatItem Name="Epifan2019" Description="Епифань, лето 2020" runat="server" />
            <uc:CatItem Name="Divnogorie2020" Description="Дивногорье, лето 2020" runat="server" />
            <uc:CatItem Name="Konduki2019-2" Description="Кондуки, осень 2019" runat="server" />
            <uc:CatItem Name="Konduki2019" Description="Кондуки, лето 2019" runat="server" />
            <uc:CatItem Name="PraRafting" Description="Сплав по Пре 50км, 2019" runat="server" />
            <uc:CatItem Name="PlescheevoLake2019" Description="Поход вокруг Плещеева озера 42км 2019" runat="server" />
            <uc:CatItem Name="BenskiePorogi2019" Description="Сплав по Волге на Бенские пороги 2019" runat="server" />
            <uc:CatItem Name="Seliger2019" Description="Сплав по Селигеру 2019" runat="server" />
        </section>

        <uc:SectionHeader Name="Прочее" runat="server" />
        <section class="SectionBody">
            <a href="<%=Page.ResolveUrl("Pub/Jokes/Laps.htm")%>">Таймлапсы</a><br />
            <a href="<%=Page.ResolveUrl("Pub/Celebrity/Celebrity.htm")%>">Знаменитости</a><br />
        </section>
    </article>
</asp:Content>
