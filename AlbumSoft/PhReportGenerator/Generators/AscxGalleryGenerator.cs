using System.IO;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace Alexf.PhotoReportGenerator.Generators
{
    internal sealed class AscxGalleryGenerator : IGalleryGenerator
    {
        const string templateName = ".Resource.AscxGalleryTransformation.xslt";
        public void Generate(XDocument microGallery, TextWriter output, Metadata meta)
        {
            /*#if DEBUG
            microGallery.Save("photos.xml");
            #endif*/

            XsltArgumentList prms = new XsltArgumentList();
            meta.AddTo(prms);

            CommonUtils.getTemplate(templateName).Transform(microGallery.CreateNavigator(), prms, output);
        }
    }
}
