<%@ Control Language="C#" 
    AutoEventWireup="true" 
    CodeBehind="ShareLinkIcons.ascx.cs"
    Inherits="AlbumFront.Components.ShareLinkIcons"
%>

<ul ID="RootElement" class="ShareLinkList" runat="server">
    <li>
        <a class="telegram" href="<%= TelegramShareUrl %>" rel="nofollow noopener" target="_blank" title="Telegram" alt="Telegram">            
        </a>
    </li>
    <li>
        <a class="vk" href="<%= VkShareUrl %>" rel="nofollow noopener" target="_blank" title="ВКонтакте" alt="ВКонтакте">            
        </a>
    </li>
    <li>
        <a class="whatsapp" href="<%= WhatsAppShareUrl %>" rel="nofollow noopener" target="_blank" title="WhatsApp" alt="WhatsApp">            
        </a>
    </li>
    <li>
        <a class="twitter" href="<%= TwitterShareUrl %>" rel="nofollow noopener" target="_blank" title="Twitter" alt="Twitter">            
        </a>
    </li>    
</ul>   
