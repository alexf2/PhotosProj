<%@ Control Language="C#" 
    AutoEventWireup="true" 
    CodeBehind="PageFooter.ascx.cs" 
    Inherits="AlbumFront.Components.PageFooter" 
%>


<footer ID="RootElement" class="PageFooterLine" runat="server">
    <div class="LineBg" style="text-align: center">
        <div class="LineLeftCap">&nbsp;</div>
        <div class="LineRightCap">&nbsp;</div>
        <asp:PlaceHolder ID="FooterPlaceholder" runat="server" />        
    </div>
</footer>