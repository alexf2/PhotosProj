<%@ Page Language="C#"    
    EnableEventValidation="True"      
    MasterPageFile = "~/OuterMasterPage.master"      
    MetaKeywords = "Aleksey Fedorov, Photography, Albums, About"
    Culture="auto"  UICulture="auto" Title="About" %>

<script language="c#" runat="server">
    public void Page_Load (object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            var ctl = (HyperLink)this.Master.FindControl("aboutLnk");
            if (ctl != null)
            {
                ctl.Enabled = false;
                ctl.CssClass = "LinkCurr";
            }
        }
 
    }
</script>

<asp:Content ContentPlaceHolderID = "idMainPls" runat = "server" >    

        <article>
            <div class="SectionHeaderBg">
                <div class="SectionHeader" style="float:left">Об авторе</div><div class="SectionHeaderBgCap" style="float:right"></div>
            </div>
            
            <div class="Container">
                <div class="Left">
                    <h3 style="margin-top:0">Алексей Федоров</h3>
                    <p>
                        Фотограф, снимавший ещё в 80-е годы на чёрно-белую плёнку "Свема",
                        испробовавший первые цветные материалы, бумагу "Фотоцвет-4" и плёнки Orwo Chrom,
                        камеры Фэд и Зенит, а ныне успешно применяющий цифровую цветокоррекцию
                        к произведениям, отснятым современными зеркалками Canon и Nikon с Байеровской матрицей,
                        среди которых пейзажи из интересных экспедиций, уличный жанр колоритных стран, портреты,
                        равно как и простая трэвел съёмка.
                    </p>
                    <p>Самые интересные произведения по возможности выкладываются вот <a href="http://500px.com/aleksey-fedorov/sets">здесь, на 500px</a>.</a></p>
                    <p>
                        Но на фотографии и цветокоррекции интересы не заканчиваются.
                        Кроме этого, ещё является опытным разработчиком-архитектором целого ряда программных систем
                        на платформе Windows в области машинной графики, экспертных систем, распознавания документов, высоконагруженных интернет-сервисов и других систем.
                        Обладает познаниями в иностранных языках и биржевой торговле.
                    </p>
                </div>

                <div class="Right"><img class="FadeOnLoad" src="<%=ResolveClientUrl("img/SelfPort.jpg")%>" border="0" title="Автопртрет" /></div>

		        <div class="FooterSep">&nbsp;</div>
            </div>
        </article>

    
</asp:Content>

