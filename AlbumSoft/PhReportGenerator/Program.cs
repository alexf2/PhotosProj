using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Text;
using System.Xml.Xsl;
using System.IO;
using System.Reflection;
using System.Text.RegularExpressions;

using Alexf.PhotoUtils;

namespace Alexf.PhotoReportGenerator
{
    /// <summary>
    /// Файлы должны быть 
    /// </summary>
	public sealed class Program
	{
		const string TemplateName = "GenPhotoReport.xslt";
        const string MetaFile = "meta.xml";

        [STAThread]
		static int Main (string[] args)
		{
			int res = 0;

			if (args.Length != 2)
			{
                Console.WriteLine("PhotoReportGenerator   path_with_images   out_file_name");
				res = -1;
			}
			else
			{
				string srcPath = args[ 0 ];
				if (!Directory.Exists(srcPath))
				{
					Console.WriteLine(string.Format("Path {0} isn't found", srcPath));
					res = -1;
				}
				else
				{
					string outf = args[ 1 ];
					if (outf.IndexOf(".") == -1)
					{
						outf += ".htm";
					}

					try {
						XslCompiledTransform tr = new XslCompiledTransform(false);
						tr.Load(getTemplate().CreateNavigator());

						using (FileStream outStm = File.Create(Path.Combine(srcPath, outf)))
                        using (StreamWriter wrPref = new StreamWriter(outStm, Encoding.UTF8))
						{                            
                            wrPref.WriteLine("<!DOCTYPE html>");

							XsltArgumentList prms = new XsltArgumentList();
                            //Console.WriteLine( getLastDir(srcPath) );
                            var meta = AddMeta(prms, srcPath);
                            tr.Transform(getFileList(srcPath, meta).CreateNavigator(), prms, wrPref);
						}
					}
					catch (Exception ex)
					{
						Console.WriteLine(string.Format("Error during transformation: {0}", ex));
						res = -1;
					}
				}
			}

			Environment.ExitCode = res;
			return res;
		}

        static Metadata AddMeta(XsltArgumentList prms, string photosDirPath)
        {
            var meta = Metadata.FileFactory(Path.Combine(photosDirPath, MetaFile));
            if (string.IsNullOrEmpty(meta.Title))
                meta.Title = getLastDir(photosDirPath);
            meta.AddTo(prms);
            return meta;
        }

        static string getLastDir (string path)
		{
			string[] comps = path.Split('\\');			
			return comps.LastOrDefault( s => !string.IsNullOrEmpty(s) );
		}

        static XDocument getTemplate ()
		{
            using (FileStream f = File.OpenRead(Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), TemplateName)))
            {
                return XDocument.Load(f);
            }
		}

        enum NameType
		{
			Main, Thumb, Pub
		};

        static XDocument getFileList (string path, Metadata meta)
		{
            double timeShift = meta.TimeShift ?? 0;
            XElement root;
            XDocument res = new XDocument(root = new XElement("photos"));

			//XmlDocument res = new XmlDocument();
			//XmlElement root = (XmlElement)res.AppendChild(res.CreateElement("photos"));

			Regex regTypedName = new Regex(@"^(?'name'\w{1,}.+)_(?'stype'pub|pup|thumb)\.jpe?g$",
				RegexOptions.CultureInvariant|RegexOptions.ExplicitCapture|RegexOptions.IgnoreCase|RegexOptions.Singleline);

			Regex regMainName = new Regex(@"^(?'name'\w{1,}.+)\.jpe?g$",
				RegexOptions.CultureInvariant|RegexOptions.ExplicitCapture|RegexOptions.IgnoreCase|RegexOptions.Singleline);

            Dictionary<string, XElement> processed = new Dictionary<string, XElement>(StringComparer.OrdinalIgnoreCase);
            foreach (string f in Directory.EnumerateFiles(path, "*.jpg", SearchOption.TopDirectoryOnly).Union(Directory.EnumerateFiles(path, "*.jpeg", SearchOption.TopDirectoryOnly)))
			{
				string name = Path.GetFileName(f);

				NameType nt = NameType.Main;
				string baseName;
				Match m = regTypedName.Match(name);
				if (m.Success)
				{
					baseName = m.Groups[ "name" ].Value;
					nt = string.Compare(m.Groups["stype"].Value, "thumb", true) == 0 ? NameType.Thumb:NameType.Pub;
				}
				else
				{
					m = regMainName.Match(name);
					if (m.Success)
					{
						baseName = m.Groups[ "name" ].Value;
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
                        fi.SetAttributeValue("caption", info.FileNameIsUsed ? baseName:info.Caption);
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
