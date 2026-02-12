<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CatItem.ascx.cs" Inherits="AlbumFront.Components.CatItem" %>

<div class="SectionHdr">
    <a href="<%=HasALbum ? this.GetAlbumUrl() : this.GetPubUrl()%>" rel='<%= HasALbum ? "nofollow" : ""  %>' ><%=this.Description%></a>&nbsp;
    <% if (this.HasGroup) { %>
        <a href="<%= this.GetGroupUrl() %>">/ Группа</a>&nbsp;
    <%} %>
    <% if (this.HasMap) { %>
        <a href="<%= this.GetMapUrl() %>">
            <img width="18" src="<%=Page.ResolveUrl("~/img/map-locator_7500893.png")%>" alt="Карта маршрута" border="0" title="Карта маршрута" />
        </a>
    <%} %>
</div>

<% if (!string.IsNullOrEmpty(this.ImgCss)) { %>
    <a href="<%= this.GetPubUrl() %>"><img src="<%=this.GetImgUrl()%>" class="<%=this.GetImgClass() %>" title="<%=this.ReportageDescription%>" alt="<%=this.ReportageDescription%>" /></a>
    <br /><br />
<%} %>

