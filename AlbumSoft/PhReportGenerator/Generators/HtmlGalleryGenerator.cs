using System.IO;
using System.Reflection;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace Alexf.PhotoReportGenerator.Generators
{
    internal sealed class HtmlGalleryGenerator : IGalleryGenerator
    {
        const string TemplateName = "GenPhotoReport.xslt";
        public void Generate(XDocument microGallery, TextWriter output, Metadata meta)
        {
            XslCompiledTransform tr = new XslCompiledTransform(false);
            tr.Load(getTemplate().CreateNavigator());
            XsltArgumentList prms = new XsltArgumentList();
            meta.AddTo(prms);

            output.WriteLine("<!DOCTYPE html>");
            tr.Transform(microGallery.CreateNavigator(), prms, output);
        }

        static XDocument getTemplate()
        {
            using (FileStream f = File.OpenRead(Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), TemplateName)))
            {
                return XDocument.Load(f);
            }

        }
    }
}
