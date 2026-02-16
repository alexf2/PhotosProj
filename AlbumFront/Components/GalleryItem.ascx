<%@ Control Language="C#"
    AutoEventWireup="true"
    CodeBehind="GalleryItem.ascx.cs"
    Inherits="AlbumFront.Components.GalleryItem" %>

<div id="n">
    <div id="c"><%# Title %></div>
    <div title="<%# Title %>">        
        <a href="<%# ActiveFile %>"  data-rel="pub" data-title="<%# DataTitle %>">
            <img src="<%# ThumbFile %>" width="<%# ThumbWidth %>" height="<%# ThumbHeight %>" alt="<%# Title %>" loading="lazy" />
        </a>                    
    </div>
</div>
