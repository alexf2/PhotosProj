<%@ Control 
    Language="C#" 
    AutoEventWireup="true" 
    CodeBehind="Toggle.ascx.cs" 
    Inherits="AlbumFront.Components.Toggle" %>


<label class="toggle">
    <input type="checkbox" id="<%= this.ID %>" />
    <span class="toggle-track">
        <span class="toggle-thumb"></span>
    </span>
    <span class="toggle-label"><%: Title %></span>
</label>
