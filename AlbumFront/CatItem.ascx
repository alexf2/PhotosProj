<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CatItem.ascx.cs" Inherits="AlbumFront.CatItem" %>

<div class="pad">
    <a href="<%=HasALbum ? this.GetAlbumUrl() : this.GetPubUrl()%>" rel='<%= HasALbum ? "nofollow" : ""  %>' ><%=this.Description%></a>&nbsp;&nbsp;
    <% if (this.HasGroup) { %>
        <a href="<%=this.GetGroupUrl()%>">/ Группа</a>&nbsp;&nbsp;
    <%} %>
</div>

<% if (!string.IsNullOrEmpty(this.ImgCss)) { %>
    <a href="<%=this.GetPubUrl()%>"><img src="<%=this.GetImgUrl()%>" class="<%=this.GetImgClass() %>" title="<%=this.ReportageDescription%>" alt="<%=this.ReportageDescription%>" /></a>
    <br /><br />
<%} %>
