using System.IO;
using System.Xml.Linq;

namespace Alexf.PhotoReportGenerator.Generators
{
    enum NameType
    {
        Main, Thumb, Pub
    };
    internal interface IGalleryGenerator
    {
        void Generate(XDocument microGallery, TextWriter output, Metadata meta);
    }
}
