using Alexf.PhotoUtils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace Alexf.PhotoReportGenerator.Generators
{
    internal class CatalogGenerator
    {
        readonly IGalleryGenerator generator;
        public CatalogGenerator(IGalleryGenerator generator)
        {
            this.generator = generator;
        }
        const string MetaFile = "meta.xml";
        public int Process(string albumFolderPath, string catalogOutPath)
        {
            using (FileStream outStm = File.Create(Path.Combine(albumFolderPath, catalogOutPath)))
            using (StreamWriter writer = new StreamWriter(outStm, Encoding.UTF8))
            {
                var meta = LoadMeta(albumFolderPath);
                generator.Generate(collectAlbumPhotosData(albumFolderPath, meta), writer, meta);
            }
            return 0;
        }

        static Metadata LoadMeta(string photosDirPath)
        {
            var meta = Metadata.FileFactory(Path.Combine(photosDirPath, MetaFile));
            if (string.IsNullOrEmpty(meta.Title))
                meta.Title = getLastDir(photosDirPath);
            return meta;
        }

        static string getLastDir(string path)
        {
            string[] comps = path.Split('\\');
            return comps.LastOrDefault(s => !string.IsNullOrEmpty(s));
        }

        static XDocument collectAlbumPhotosData(string path, Metadata meta)
        {
            double timeShift = meta.TimeShift ?? 0;
            XElement root;
            XDocument res = new XDocument(root = new XElement("photos"));

            //XmlDocument res = new XmlDocument();
            //XmlElement root = (XmlElement)res.AppendChild(res.CreateElement("photos"));

            Regex regTypedName = new Regex(@"^(?'name'\w{1,}.+)_(?'stype'pub|pup|thumb)\.jpe?g$",
                RegexOptions.CultureInvariant | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase | RegexOptions.Singleline);

            Regex regMainName = new Regex(@"^(?'name'\w{1,}.+)\.jpe?g$",
                RegexOptions.CultureInvariant | RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase | RegexOptions.Singleline);

            Dictionary<string, XElement> processed = new Dictionary<string, XElement>(StringComparer.OrdinalIgnoreCase);
            foreach (string f in Directory.EnumerateFiles(path, "*.jpg", SearchOption.TopDirectoryOnly).Union(Directory.EnumerateFiles(path, "*.jpeg", SearchOption.TopDirectoryOnly)))
            {
                string name = Path.GetFileName(f);

                NameType nt = NameType.Main;
                string baseName;
                Match m = regTypedName.Match(name);
                if (m.Success)
                {
                    baseName = m.Groups["name"].Value;
                    nt = string.Compare(m.Groups["stype"].Value, "thumb", true) == 0 ? NameType.Thumb : NameType.Pub;
                }
                else
                {
                    m = regMainName.Match(name);
                    if (m.Success)
                    {
                        baseName = m.Groups["name"].Value;
                        nt = NameType.Main;
                    }
                    else
                    {
                        Console.WriteLine(string.Format("Warning: file {0} isn't recognized", name));
                        continue;
                    }
                }

                XElement fi;
                if (!processed.TryGetValue(baseName, out fi))
                {
                    root.Add(fi = new XElement("f"));
                    processed.Add(baseName, fi);
                }

                switch (nt)
                {
                    case NameType.Main:
                        fi.SetAttributeValue("main", name);
                        break;

                    case NameType.Thumb:
                        fi.SetAttributeValue("thumb", name);
                        ImageInfo info = ExifUtils.GetExifData(f, true);
                        //Console.WriteLine(ExifUtils.DumpGdiExifTags(f));
                        fi.SetAttributeValue("caption", info.FileNameIsUsed ? baseName : info.Caption);
                        fi.SetAttributeValue("w", info.W.ToString()); fi.SetAttributeValue("h", info.H.ToString());
                        fi.SetAttributeValue("date", info.Shot.AddHours(timeShift).ToString("dd-MMMM-yyyy HH:mm", System.Globalization.CultureInfo.InvariantCulture));
                        fi.SetAttributeValue("shot-info", info.GetShotCaption(true));
                        if (info.Latitude.HasValue)
                        {
                            fi.SetAttributeValue("lat", info.Latitude);
                            fi.SetAttributeValue("long", info.Longitude);
                        }

                        break;

                    case NameType.Pub:
                        fi.SetAttributeValue("pub", name);
                        break;
                }

                fi.SetAttributeValue("size", ExifUtils.GetSize(f).ToString());
            }


            return res;
        }
    }
}
