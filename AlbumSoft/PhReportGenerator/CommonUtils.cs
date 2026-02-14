using System.IO;
using System.Reflection;
using System.Xml;
using System.Xml.Xsl;

namespace Alexf.PhotoReportGenerator
{
    internal static class CommonUtils
    {
        public static XslCompiledTransform getTemplate(string resourceName)
        {
            string fullname = typeof(Program).Namespace + resourceName;
            using (var stm = Assembly.GetExecutingAssembly().GetManifestResourceStream(fullname))
            {
                if (stm == null)
                    throw new FileNotFoundException($"XSLT resource not found: {fullname}");

                XslCompiledTransform tr = new XslCompiledTransform(false);
                tr.Load(XmlReader.Create(stm));
                return tr;
            }
        }
    }
}
