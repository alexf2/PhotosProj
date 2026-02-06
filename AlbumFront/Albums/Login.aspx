<%@ Page Language="C#"
    AutoEventWireup="true"
    Inherits="Login"
    enableViewState="True"  Title="Login page" EnableEventValidation="True"
    SmartNavigation="False" MaintainScrollPositionOnPostback = "False"
    EnableSessionState = "True" 
    Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Login.aspx.cs" %>
<!DOCTYPE html>


<html lang="<%=System.Globalization.CultureInfo.CurrentUICulture.TwoLetterISOLanguageName%>">

<head runat="server">
    <title><asp:Localize runat = "server" meta:resourcekey = "TitleLogin">Login page</asp:Localize></title>        

    <link rel="icon" type="image/png" sizes="16x16" href="images/photo_album_blue.png">
    <link rel="icon" type="image/png" sizes="128x128" href="images/photo_album.png">
    <link rel="apple-touch-icon" sizes="128x128" href="images/photo_album.png">
    <meta name="theme-color" content="#ffffff">
    <link rel="manifest" href="images/manifest.json">

    <asp:PlaceHolder runat="server">  
        <% = Styles.Render("~/bundles/extra-css") %>        
    </asp:PlaceHolder>
</head>

<body onload = "javascript:document.getElementById('Login1_UserName').focus();">    
<form id="form1" runat="server" style="height: 100%;" >

        <asp:ScriptManager ID="ScriptManagerMain" runat="server" ScriptMode="Auto" EnableCdn="true">
            <Scripts>
                <%--Framework Scripts--%>
                <asp:ScriptReference Name="WebForms.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebForms.js" />
                <asp:ScriptReference Name="WebUIValidation.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebUIValidation.js" />
                <asp:ScriptReference Name="MenuStandards.js" Assembly="System.Web" Path="~/Scripts/WebForms/MenuStandards.js" />
                <asp:ScriptReference Name="GridView.js" Assembly="System.Web" Path="~/Scripts/WebForms/GridView.js" />
                <asp:ScriptReference Name="DetailsView.js" Assembly="System.Web" Path="~/Scripts/WebForms/DetailsView.js" />
                <asp:ScriptReference Name="TreeView.js" Assembly="System.Web" Path="~/Scripts/WebForms/TreeView.js" />
                <asp:ScriptReference Name="WebParts.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebParts.js" />
                <asp:ScriptReference Name="Focus.js" Assembly="System.Web" Path="~/Scripts/WebForms/Focus.js" />
                <asp:ScriptReference Name="WebFormsBundle" />
            </Scripts>
        </asp:ScriptManager>

    <div class = "MainLoginContainer" role="main">
        <header class = "LoginHeader">
            <asp:ImageButton id="btnHome" ImageAlign="AbsMiddle" CssClass = "CHideFocus" hidefocus="true" runat="server"  ImageUrl = "~/images/Home.png" ToolTip = "Home" CommandName="home" meta:resourcekey="btnHomeResource1" />
        </header>

        <article class = "LoginContainer" role="main">
            <div class = "LoginCtlWrapper" >
            <asp:Login ID="Login1" runat="server"  BorderPadding="4"                
                Height="163px" meta:resourcekey="Login1Resource1" Width="342px" 
                OnLoggedIn = "Login1_OnLoggedIn" CssClass="LoginCtlClass" ClientIDMode="Predictable"
            >

                <TitleTextStyle BackColor="#5D7B9D" Font-Bold="True" Font-Size="0.9em" ForeColor="White" />
                <InstructionTextStyle Font-Italic="True" ForeColor="Black" />
                <TextBoxStyle Font-Size="1em" />
                <LoginButtonStyle  CssClass = "CtlButtons PadRight"  />
                <CheckBoxStyle CssClass = "LoginLabel" />                
            </asp:Login>            
            </div>
       </article>

       <footer class = "LoginFooter">
    

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
		            document.write("<a href='//www.1gb.ru?cnt=66030'>"+
		            "<img src='http://counter.1gb.ru/cnt.aspx?"+
		            "u=66030&"+cgb_r+
		            "&' border=0 width=88 height=31 "+
		            "alt='1Gb.ru counter'><\/a>")</script>
		            <noscript><a href='//www.1gb.ru?cnt=66030'>
		            <img src="//counter.1gb.ru/cnt.aspx?u=66030" 
		            border=0 width="88" height="31" alt="1Gb.ru counter"></a>
	            </noscript>
              </div>

           </footer>
        </div>

</form>


</body>
</html>
