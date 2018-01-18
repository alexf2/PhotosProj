<%@ Page Language="C#" AutoEventWireup="true" Inherits="PageGen" 
    enableViewState="True"  Title="Photos content page" EnableEventValidation="False"
    SmartNavigation="False" MaintainScrollPositionOnPostback = "True"
    MasterPageFile = "~/AlbumMasterPage.master"
    EnableSessionState = "True" 
 Codebehind="PageGen.aspx.cs" %>
<%@Register  TagPrefix="fragment" TagName="PageGen" Src="PageGenCtl.ascx" %>

<asp:Content ID = "idPhotosContent" ContentPlaceHolderID = "idPhotosPlace" runat = "server" >    
    <fragment:PageGen id = "idPgGen" runat="server" enableViewState="True" />
</asp:Content>

