<%@ Control Language="C#" AutoEventWireup="true" 
    Inherits="PageGenCtl" Codebehind="PageGenCtl.ascx.cs" %>

    <%
        //AlbumMasterPage m = (AlbumMasterPage)this.Master;
        
        
        //SiteMapNode nd = SiteMap.CurrentNode;
        //Response.Write( String.Format("Key = {0}, Descr = {1}, Title = {2}", nd.Key, nd.Description, nd.Title) );

        
        /*foreach( SiteMapNode node in nd.ChildNodes )
        {
            Response.Write( "<p>" + node.Title + "</p>" );
        }*/        
    %>
    <asp:ScriptManagerProxy runat="server" ID="SciptMgrProxy">
    </asp:ScriptManagerProxy>

    <asp:datalist id="DataListThumb" runat="server" 
        DataSourceID=""
        RepeatDirection="Horizontal"
        RepeatLayout="Flow"
        RepeatColumns="0"
        ShowBorder="True"
        Visible="False"
    >
        <ItemTemplate>
            <div class="CatalogViewPhotoDIV" 
                 style="width: <%#Eval("DivWidth")%>; height: <%#Eval("DivHeight")%>;">
                <table cellpadding="0" cellspacing="0" class="CatalogViewPhotoTable" >
                    <tr>
                        <td  style="padding-bottom:6px;"  >
                            <div class="ThumbDiv">
								<a class = "LinkPhoto" title="<%#HttpUtility.HtmlEncode(Eval("Title"))%>"
								   onclick = "<%#Eval("Link") %>" href="<%#Eval("Link") %>" ><%#HttpUtility.HtmlEncode(Eval("Title"))%></a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" valign = "bottom"  >
                            <a <%#GetRel(Container.DataItem)%> <%#GetRef(Container.DataItem)%> <%# GetFullTitle(Container.DataItem)%> >
                                <img height="<%#Eval("Height")%>" 
                                        width="<%#Eval("Width")%>" 
                                        class="<%#Eval("ImageClass")%>"
									    <%#GetOnClick(Container.DataItem)%> 
                                        src="<%#ResolveClientUrl((string)Eval("Url"))%>"
                                        title="<%#HttpUtility.HtmlEncode(Eval("DescriptionWithDate"))%>"
                                        alt="<%#Eval("DescriptionWithDate")%>" />
                            </a>
                        </td>
                    </tr>
                </table>
            </div>
        </ItemTemplate>
   </asp:datalist>
   
   <asp:datalist id="DataListImg" runat="server" 
        DataSourceID=""
        RepeatDirection="Horizontal"
        RepeatLayout="Flow"
        RepeatColumns="0"
        ShowBorder="True"
        Visible="False"
    >
        <ItemTemplate>
            
                <table border="0"  class="CatalogViewPhotoTableImg" >
                    <tr>
                        <td style="height:1%; padding-bottom:6px" >
                            <span><%#HttpUtility.HtmlEncode(DataBinder.Eval(Container.DataItem, "Description"))%></span>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;" >                            
                            <div class="ImageDiv" >
                                <img height="<%#DataBinder.Eval(Container.DataItem, "Height")%>" 
                                     width="<%#Eval("Width")%>" 
                                     class="ImagePhotoImg"
                                     src="<%#ResolveClientUrl((string)Eval("Url"))%>"
                                     title="<%#HttpUtility.HtmlEncode(Eval("Title"))%>"
                                     alt="<%#HttpUtility.HtmlEncode(Eval("Title"))%>"
                                     galleryimg="no"
                                />
                            </div>                            
                        </td>
                    </tr>
                    <tr>
                        <td class="CDate" ><%#Eval("Date")%></td>
                        <% if (!string.IsNullOrEmpty(CurrentProvider.CurrentNode["shot"])) { %>
                            <td class="CDate" ><%=CurrentProvider.CurrentNode["shot"]%></td>
                        <%} %>
                    </tr>
                </table>
            
        </ItemTemplate>
   </asp:datalist>
   


   <div id="idDateDiv" runat = "server" class="CDate" nowrap > <%= GetParentDate() %></div>
   <div class="CDate">&nbsp;</div>

   <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
            SelectMethod="GetPage" TypeName="PhotoPageData" OnObjectCreating = "ObjectDataSource1_OjectCreating" OnDataBinding="ObjectDataSource1_DataBinding" />
            
            
