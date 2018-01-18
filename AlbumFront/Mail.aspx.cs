using System;

using System.Net.Mail;
using System.Configuration;



namespace AlbumFront
{
    public partial class Mail : System.Web.UI.Page
    {
        public void Page_LoadComplete(object sender, EventArgs e)
        {
            SendingStatus.Visible = false;
            StatusMsg.Text = null;

            if (IsPostBack && IsValid)
            {

                string title = FirstName.Value;
                if (!string.IsNullOrEmpty(LastName.Value) && !string.IsNullOrEmpty(title))
                    title += " ";
                if (!string.IsNullOrEmpty(LastName.Value))
                    title += LastName.Value;

                using (MailMessage msg = new MailMessage(new MailAddress(ConfigurationManager.AppSettings["sys-source-email"], title), new MailAddress(ConfigurationManager.AppSettings["contact-email"], string.Empty)))
                {
                    msg.Subject = Subject.Value;
                    msg.Body = MailBody.Value;
                    msg.BodyEncoding = System.Text.Encoding.UTF8;

                    msg.ReplyToList.Add(new MailAddress(ReplyAddress.Value, title));

                    using (SmtpClient client = new SmtpClient(ConfigurationManager.AppSettings["smtp-host"], int.Parse(ConfigurationManager.AppSettings["smtp-port"])))
                    {
                        string login = ConfigurationManager.AppSettings["smtp-login"];

                        if (!string.IsNullOrEmpty(login))
                        {
                            client.UseDefaultCredentials = false;
                            client.Credentials = new System.Net.NetworkCredential(login, ConfigurationManager.AppSettings["smtp-pwd"]);
                        }

                        try
                        {
                            client.Send(msg);

                            SendingStatus.Visible = true;
                            SendingStatus.CssClass = "OpMessageOK";
                            StatusMsg.Text = string.Format("Mail \"{0}\" has been sent", Subject.Value);
                            clearForm();
                        }
                        catch (Exception ex)
                        {
                            Exception ex2 = ex;
                            string errorMessage = string.Empty;
                            while (ex2 != null)
                            {
                                if (!string.IsNullOrEmpty(errorMessage))
                                    errorMessage += "<br/>";

                                errorMessage += ex2.ToString();
                                ex2 = ex2.InnerException;
                            }
                            SendingStatus.Visible = true;
                            SendingStatus.CssClass = "OpMessageErr";
                            StatusMsg.Text = string.Format("Error happened: {0}", errorMessage);
                        }
                    }
                }
            }
        }

        void clearForm()
        {
            FirstName.Value = null;
            LastName.Value = null;
            ReplyAddress.Value = null;
            Subject.Value = null;
            MailBody.Value = null;
            ControlCode.Value = null;
        }

        protected void CaptchaValidator_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            // validate the Captcha to check we're not dealing with a bot
            args.IsValid = RegisterCaptcha.Validate(args.Value.Trim().ToUpper());
            ControlCode.Value = null; // clear previous user input
        }        
    }
}