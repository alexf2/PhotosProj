using System.IO;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.Xsl;

namespace Alexf.PhotoReportGenerator
{
    [XmlRoot("meta")]
    public sealed class Metadata
    {
        [XmlElement("lang")]
        public string Lang { get; set; }

        [XmlElement("keywords")]
        public string Keywords { get; set; }

        [XmlElement("description")]
        public string Description { get; set; }

        [XmlElement("time-shift")]
        public double? TimeShift { get; set; }

        [XmlElement("title")]
        public string Title { get; set; }
        
        public void AddTo (XsltArgumentList xsltParams)
        {
            if (!string.IsNullOrEmpty(Lang))
                xsltParams.AddParam("lang", string.Empty, Lang);

            if (!string.IsNullOrEmpty(Keywords))
                xsltParams.AddParam("keywords", string.Empty, Keywords);

            if (!string.IsNullOrEmpty(Description))
                xsltParams.AddParam("description", string.Empty, Description);

            if (!string.IsNullOrEmpty(Title))
                xsltParams.AddParam("title", string.Empty, Title);
        }

        public static Metadata StreamFactory(Stream stm)
        {
            var serializer = new XmlSerializer(typeof(Metadata));
            return (Metadata)serializer.Deserialize(stm);
        }
        public static Metadata FileFactory(string fileName)
        {
            if (!File.Exists(fileName))
                return new Metadata();
            using (var fileStream = File.OpenRead(fileName))
                return StreamFactory(fileStream);
        }
    }
}
