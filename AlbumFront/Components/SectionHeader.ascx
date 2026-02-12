<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SectionHeader.ascx.cs" Inherits="AlbumFront.Components.SectionHeader" %>

<header ID="RootElement" class="SectionHeaderBg" runat="server">
    <div ID="HeaderElement" class="SectionHeader" style="float: left" runat="server">
        <%= Name %>
    </div>
    <div class="SectionHeaderBgCap" style="float: right"></div>
</header>

