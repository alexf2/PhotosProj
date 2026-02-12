<%@ Page Language="C#" AutoEventWireup="true" Inherits="AlbumFront.Mail" 
    EnableEventValidation="True" Title="Contact page" 
    EnableSessionState = "true" ViewStateMode = "Enabled"
    MetaDescription = "Форма для связи, почта"
    MetaKeywords = "Алексей Федоров, контакты, форма связи"
    Culture="auto" meta:resourcekey="MailPageResource" UICulture="auto" Codebehind="Mail.aspx.cs" %>

<script language="c#" runat="server">
    public void Page_Load (object sender, EventArgs e)
    {
        ((Panel)this.Master.FindControl("MainDiv")).Width = new Unit(60, UnitType.Percentage);
    
        if (!IsPostBack)
        {
            var ctl = (HyperLink)this.Master.FindControl("mailLnk");
            if (ctl != null)
            {
                ctl.Enabled = false;
                ctl.CssClass = "LinkCurr";      
            }        
        } 
    }
</script>


<asp:Content ContentPlaceHolderID = "idMainContent" runat = "server" >    
    
    <script language="javascript1.1" type="text/javascript">
     function mySubmit (el) {
         if (!Page_ClientValidate()) 
             return false;
         
         el.value = 'Sending...';
         el.className += ' Grayed';
         $(el).closest('form').submit();
         el.disabled = true;
         return false;
      } 
    </script>

    <asp:ScriptManager ID="ScriptManagerMain" runat="server" ScriptMode="Auto" EnableCdn="true">
        <Scripts>                
        </Scripts>
    </asp:ScriptManager>

	<article>
            <div class="SectionHeaderBg">
                <div class="SectionHeader" style="float:left">Contact</div><div class="SectionHeaderBgCap" style="float:right" ></div>
            </div>
            
            <div class="FormContainer">
                <asp:Panel ID="SendingStatus" Visible = "false" CssClass="OpMessageOK" runat="server"><asp:Literal ID="StatusMsg" runat="server" /></asp:Panel>
                <asp:ValidationSummary ID="validationSummary" CssClass="ValSummary" runat="server" DisplayMode="BulletList" EnableClientScript = "true" HeaderText = "There are errors in the form:" />

                
                <div class="FormItem">
                    <asp:Label ID="lblFirstName" AssociatedControlID="FirstName" CssClass="LabelFix1" runat="server">Given Name:*</asp:Label>
                    <input type="text" id="FirstName" name="FirstName" size="35" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="None" ControlToValidate="FirstName"
                                ErrorMessage="Please enter your Name" Text="*" InitialValue = "" EnableClientScript = "true" />
                    <br />
                    </div>

                <div class="FormItem">
                    <asp:Label ID="lblLastName" AssociatedControlID="LastName" CssClass="LabelFix1" runat="server">Last Name:</asp:Label>
                    <input type="text" id="LastName" name="LastName" size="35" runat="server" />                    
                    <br />
                </div>

                <div class="FormItem">
                    <asp:Label ID="lblReplyAddress" AssociatedControlID="ReplyAddress" CssClass="LabelFix1" runat="server">Your EMail:*</asp:Label>
                    <input type="email" id="ReplyAddress" name="ReplyAddress" size="35" runat="server"  />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="None" ControlToValidate="ReplyAddress"
                                ErrorMessage="Please enter your EMail" Text="*" InitialValue = "" EnableClientScript = "true" />
                    <br />
                </div>

                <div class="FormItem" style="padding-right:4px">
                    <asp:Label ID="lblSubject" AssociatedControlID="Subject" CssClass="LabelFix1" Style="margin-bottom:4px" runat="server">Subject:*</asp:Label>
                    <input type="text" id="Subject" name="Subject" style="width:100%"  runat="server" />
                    <br />
                </div>
                

                <div class="FormBigItem">
                    <textarea id="MailBody" name="MailBody" rows="15" style="width:100%"  runat="server" /><br />
                </div>

                <div class="FormItem" style="text-align:right">
                    <div class="Captcha">
                        <BotDetect:WebFormsCaptcha ID="RegisterCaptcha" ImageWidth="250" ImageHeight="40" runat="server"  />
                    </div>
                    <div class="InnerFormItem">
                        <asp:Label ID="lblControlCode" AssociatedControlID="ControlCode" runat="server">Code:*</asp:Label>
                        <input type="text" id="ControlCode" name="ControlCode" size="15" runat="server" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="None" ControlToValidate="ControlCode"
                                ErrorMessage="Please enter the validation code, shown on the Captcha" Text="*" InitialValue = "" EnableClientScript = "true" />
                        <asp:CustomValidator runat="server" ID="CaptchaValidator" ControlToValidate="ControlCode"
                                        Display="None" ErrorMessage="Incorrect code, please try again." 
                                        OnServerValidate="CaptchaValidator_ServerValidate" />
                     </div>                    
                </div>

                <div class="FormButtonsPanel">
                    <input type="submit" value="Send Mail" name="Submit" class="CtlButtons FloatRight" onclick="return mySubmit(this)"  />
                </div>                
            </div> 
            <div class="Clear">&nbsp;</div>
    </article>

</asp:Content>
