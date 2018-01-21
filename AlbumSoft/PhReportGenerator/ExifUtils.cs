using System;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Globalization;

using TagLib;
using TagLib.IFD;
using TagLib.IFD.Entries;
using TagLib.IFD.Tags;

namespace Alexf.PhotoUtils
{    
    public static class ExifUtils
    {
        static ExifUtils()
        {
            if (System.Configuration.ConfigurationManager.AppSettings["useBrokenLatin1Behavior"] == "1")
                   ByteVector.UseBrokenLatin1Behavior = true; //для ascii-строк используется Encoding.Default, что эквивалентно Windows 1251 при русской локали            
        }

        public static int GetSize (string fullName)
        {
            return (int)new System.IO.FileInfo(fullName).Length;
        }

        public static ImageInfo GetExifData (string fullName, bool extended)
        {
            ImageInfo res = new ImageInfo();

            System.IO.FileInfo f = new System.IO.FileInfo(fullName);
            res.FileSize = (int)f.Length;

            if (extended)
            {
                using (TagLib.File file = TagLib.File.Create(fullName))
                {
                    TagLib.Image.File tagSharp = (TagLib.Image.File)file;
                    if (tagSharp == null)
                        throw new Exception(string.Format("File [{0}] is not a recognized by TagLib# image", System.IO.Path.GetFileName(fullName)));

                    //размер фотографии
                    res.W = tagSharp.Properties.PhotoWidth;
                    res.H = tagSharp.Properties.PhotoHeight;

                    //название фотографии
                    res.Caption = safeTrim(tagSharp.ImageTag.Title);                    
                    if (string.IsNullOrEmpty(res.Caption))
                        res.Caption = safeTrim(tagSharp.ImageTag.Comment);
                    
                    if (string.IsNullOrEmpty(res.Caption))
                    {
                        res.Caption = System.IO.Path.GetFileName(fullName);
                        res.FileNameIsUsed = true;
                    }

                    res.Description = safeTrim(tagSharp.ImageTag.Comment);

                    //время съемки
                    if (tagSharp.ImageTag.DateTime.HasValue)
                        res.Shot = tagSharp.ImageTag.DateTime.Value;
                    else                    
                        res.Shot = f.CreationTime < f.LastWriteTime ? f.CreationTime:f.LastWriteTime;

                    //место съемки
                    res.Latitude = tagSharp.ImageTag.Latitude;
                    res.Longitude = tagSharp.ImageTag.Longitude;
                    res.Altitude = tagSharp.ImageTag.Altitude;

                    //название и модель фотоаппарата
                    res.Camera = tagSharp.ImageTag.Model;
                    //параметры объектива
                    if (tagSharp.ImageTag.Xmp != null)
                        res.Lens = tagSharp.ImageTag.Xmp.GetLangAltNode("http://ns.adobe.com/exif/1.0/aux/", "Lens");

                    //размер ISO При съёмке
                    res.IsoSpeed = string.Format(CultureInfo.InvariantCulture, "{0}", tagSharp.ImageTag.ISOSpeedRatings);
                    //диафрагма при съёмке
                    res.Aperture = string.Format(CultureInfo.InvariantCulture, "{0:0.0}", tagSharp.ImageTag.FNumber);
                    //фокусное расстояние при сёмке
                    res.FocalLength = string.Format(CultureInfo.InvariantCulture, "{0}", tagSharp.ImageTag.FocalLength);
                    //выдержка
                    if (tagSharp.ImageTag.ExposureTime.HasValue)
                    {
                        if (tagSharp.ImageTag.ExposureTime < 1.0)
                            res.Exposure = string.Format(CultureInfo.InvariantCulture, "1/{0:0}", 1.0 / tagSharp.ImageTag.ExposureTime);
                        else
                            res.Exposure = string.Format(CultureInfo.InvariantCulture, "{0:0}", tagSharp.ImageTag.ExposureTime);
                    }

                    //определяем использовалась-ли вспышка
                    if (tagSharp.ImageTag.Exif != null && tagSharp.ImageTag.Exif.Structure != null)
                    {
                        SubIFDEntry ent = tagSharp.ImageTag.Exif.Structure.GetEntry(0, (ushort)IFDEntryTag.ExifIFD) as SubIFDEntry;
                        if (ent != null && ent.Structure != null)
                        {
                            ShortIFDEntry entry = ent.Structure.GetEntry(0, (ushort)ExifEntryTag.Flash) as ShortIFDEntry;
                            if (entry != null)
                                res.Flash = (entry.Value & 1) == 1; //flash fired
                        }
                    }
                }
            }
            else
            {
                using (Image img = Image.FromFile(fullName))
                {
                    //размер
                    res.W = img.Width; res.H = img.Height;

                    //название
                    PropertyItem pi = img.GetPropertyItem(0x10e);
                    res.Caption = pi == null ? 
                        System.IO.Path.GetFileName(fullName) : 
                        Encoding.GetEncoding(1251).GetString(pi.Value, 0, pi.Len - 1).Trim();


                    //съемка
                    pi = img.GetPropertyItem(0x132);
                    if (pi != null)
                    {
                        string dt = Encoding.UTF8.GetString(pi.Value, 0, pi.Len - 1);
                        res.Shot = System.Xml.XmlConvert.ToDateTime(dt, System.Xml.XmlDateTimeSerializationMode.Local);
                    }
                    else
                        res.Shot = f.CreationTime;
                }
            }

                        
            return res;
        }

        static string safeTrim (string v)
        {
            return string.IsNullOrEmpty(v) ? null : v.Trim();
        }

        static string structDumper(IFDStructure st, ushort tagParentCode, StringBuilder blsExt = null, int recurse = 0)
        {
            //Encoding enc = Encoding.GetEncoding(1251);
            Encoding enc = Encoding.Unicode;
            string pref = string.Empty;

            if (recurse > 0)
                for (int i = 0; i < recurse; ++i)
                    pref += "\t";

            System.Text.StringBuilder bld = blsExt ?? new System.Text.StringBuilder();
            bld.AppendFormat("{0}Directories Count = {1}\r\n", pref, st.Directories.Length);

            Type enumFldType = typeof(IFDEntryTag);
            if (tagParentCode != 0)
                if (tagParentCode == (ushort)IFDEntryTag.ExifIFD)
                    enumFldType = typeof(ExifEntryTag);
                else if (tagParentCode == (ushort)IFDEntryTag.GPSIFD)
                    enumFldType = typeof(GPSEntryTag);
                else if (tagParentCode == (ushort)IFDEntryTag.OPIProxy)
                    enumFldType = typeof(IOPEntryTag);


            int cnt = 1;
            foreach (IFDDirectory dir in st.Directories)
            {
                bld.AppendFormat("{0}Dir {1}:\r\n", pref, cnt++);

                foreach (var kv in dir)
                {
                    string tagName = null;
                    try { tagName = Enum.GetName(enumFldType, kv.Key); }
                    catch { };
                    if (string.IsNullOrEmpty(tagName))
                        tagName = kv.Key.ToString();

                    bld.AppendFormat("{0}{1}/{2}: ", pref, tagName, kv.Value.GetType().Name);
                    if (kv.Value.GetType().GetProperty("Value") != null)
                    {
                        dynamic d = kv.Value;
                        bld.Append(d.Value);
                    }
                    if (kv.Value is ByteVectorIFDEntry)
                    {
                        ByteVectorIFDEntry bv = (ByteVectorIFDEntry)kv.Value;
                        bld.AppendFormat(" len = {0}, [{1}]", bv.Data.Data.Length, enc.GetString(bv.Data.Data));
                    }
                    else if (kv.Value is UndefinedIFDEntry)
                    {
                        UndefinedIFDEntry ue = (UndefinedIFDEntry)kv.Value;
                        bld.AppendFormat(" len = {0}, [{1}]", ue.Data.Data.Length, enc.GetString(ue.Data.Data));
                    }
                    else if (kv.Value is SubIFDEntry)
                    {
                        SubIFDEntry sub = (SubIFDEntry)kv.Value;
                        structDumper(sub.Structure, sub.Tag, bld, recurse + 1);
                    }
                    bld.AppendLine();
                }
            }

            return blsExt == null ? bld.ToString() : string.Empty;
        }

        public static string DumpGdiExifTags (string fullName)
        {
            StringBuilder bld = new StringBuilder();
            using (Image img = Image.FromFile(fullName))
            {
                Encoding enc = Encoding.GetEncoding(1251);
                foreach (var item in img.PropertyItems)
                {
                    if (bld.Length > 0)
                        bld.Append("\r\n");

                    string v = decodeVal(item.Value, item.Len, (int)item.Type);
                        //enc.GetString(item.Value, 0, item.Len - 1);
                    bld.AppendFormat("{0}/{1} = {2}", item.Id, item.Type, v == null ? v:v.Trim());
                }
            }
            return bld.ToString();
        }

        static string decodeVal (byte[] item, int len, int type)
        {
            if (type == 1)
                return string.Join("", item.Take(len).Select((b) => b.ToString("X2")).ToArray());

            else if (type == 2)
                return Encoding.GetEncoding(1251).GetString(item, 0, len - 1);

            else if (type == 3)
            {
                byte[] c = new byte[len];
                Array.Copy(item, c, len);
                if (BitConverter.IsLittleEndian)
                    Array.Reverse(c);
                return BitConverter.ToInt16(c, 0).ToString();
            }
            else if (type == 4)
            {
                byte[] c = new byte[len];
                Array.Copy(item, c, len);
                if (BitConverter.IsLittleEndian)
                    Array.Reverse(c);
                return BitConverter.ToInt32(c, 0).ToString();
            }
            else if (type == 7)
            {
                StringBuilder bld = new StringBuilder();
                for (int i = 0; i < len; i += 4)
                {
                    int l = Math.Min(4, len - i);
                    byte[] c = new byte[l];
                    Array.Copy(item, i, c, 0, l);
                    if (BitConverter.IsLittleEndian)
                        Array.Reverse(c);

                    if (bld.Length > 0)
                        bld.Append(",");

                    if (c.Length < 4)
                        bld.Append(".");
                    else
                        bld.Append(BitConverter.ToInt32(c, 0).ToString());
                }
                return bld.ToString();
            }
            else
                return string.Format("data = {0}", string.Join("", item.Take(len).Select((b) => b.ToString("X2")).ToArray()));
            
        }
    }
}
