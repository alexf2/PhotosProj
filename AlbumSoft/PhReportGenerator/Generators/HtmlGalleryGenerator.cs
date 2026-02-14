using System.IO;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace Alexf.PhotoReportGenerator.Generators
{
    internal sealed class HtmlGalleryGenerator : IGalleryGenerator
    {
        const string templateName = ".Resource.HtmlGalleryTransformation.xslt";
        public void Generate(XDocument microGallery, TextWriter output, Metadata meta)
        {
            XsltArgumentList prms = new XsltArgumentList();
            meta.AddTo(prms);

            output.WriteLine("<!DOCTYPE html>");
            CommonUtils.getTemplate(templateName).Transform(microGallery.CreateNavigator(), prms, output);
        }
    }
}
