using System;
using TagLib;
using TagLib.IFD;
using TagLib.IFD.Entries;
using TagLib.IFD.Tags;
using System.Text;

public class ParsePhotoApp
{
	public static void Main (string [] args)
	{
        if(args.Length == 0) {
            Console.Error.WriteLine("USAGE: mono ParsePhoto.exe PATH [...]");
            return;
        }

		foreach (string path in args)
			ParsePhoto (path);
	}

	static void ParsePhoto (string path)
	{
		TagLib.File file = null;

		try {
			file = TagLib.File.Create(path);
		} catch (TagLib.UnsupportedFormatException) {
			Console.WriteLine ("UNSUPPORTED FILE: " + path);
			Console.WriteLine (String.Empty);
			Console.WriteLine ("---------------------------------------");
			Console.WriteLine (String.Empty);
			return;
		}

		var image = file as TagLib.Image.File;
		if (file == null) {
			Console.WriteLine ("NOT AN IMAGE FILE: " + path);
			Console.WriteLine (String.Empty);
			Console.WriteLine ("---------------------------------------");
			Console.WriteLine (String.Empty);
			return;
		}

		Console.WriteLine (String.Empty);
		Console.WriteLine (path);
		Console.WriteLine (String.Empty);

		Console.WriteLine("Tags in object  : " +  image.TagTypes);
		Console.WriteLine (String.Empty);

		Console.WriteLine("Comment         : " +  image.ImageTag.Comment);
		Console.Write("Keywords        : ");
		foreach (var keyword in image.ImageTag.Keywords) {
			Console.Write (keyword + " ");
		}
        Console.WriteLine(String.Empty);
        Console.WriteLine("Title           : " + image.ImageTag.Title);
        Console.WriteLine("Copyright      : " + image.ImageTag.Copyright);
		Console.WriteLine ();
		Console.WriteLine("Rating          : " +  image.ImageTag.Rating);
		Console.WriteLine("DateTime        : " +  image.ImageTag.DateTime);
		Console.WriteLine("Orientation     : " +  image.ImageTag.Orientation);
		Console.WriteLine("Software        : " +  image.ImageTag.Software);
		Console.WriteLine("ExposureTime    : " +  image.ImageTag.ExposureTime);
        

		Console.WriteLine("FNumber         : " +  image.ImageTag.FNumber);
		Console.WriteLine("ISOSpeedRatings : " +  image.ImageTag.ISOSpeedRatings);
		Console.WriteLine("FocalLength     : " +  image.ImageTag.FocalLength);
		Console.WriteLine("FocalLength35mm : " +  image.ImageTag.FocalLengthIn35mmFilm);
		Console.WriteLine("Make            : " +  image.ImageTag.Make);
		Console.WriteLine("Model           : " +  image.ImageTag.Model);

		if (image.Properties != null) {
			Console.WriteLine("Width           : " +  image.Properties.PhotoWidth);
			Console.WriteLine("Height          : " +  image.Properties.PhotoHeight);
			Console.WriteLine("Type            : " +  image.Properties.Description);
		}

		Console.WriteLine ();
		Console.WriteLine("Writable?       : " +  image.Writeable.ToString ());
		Console.WriteLine("Corrupt?        : " +  image.PossiblyCorrupt.ToString ());

		if (image.PossiblyCorrupt) {
			foreach (string reason in image.CorruptionReasons) {
				Console.WriteLine ("    * " + reason);
			}
		}

        
        Console.WriteLine("tag types = " + file.TagTypes);
        
        string  lens = image.ImageTag.Xmp.GetLangAltNode("http://ns.adobe.com/exif/1.0/aux/", "Lens");
        Console.WriteLine("Lens = " + lens);
               

        IFDTag tag = file.GetTag(TagTypes.TiffIFD) as IFDTag;
        IFDStructure struc = tag.Structure;

        Console.WriteLine(structDumper(struc, (ushort)0));

        /*SubIFDEntry sub = struc.GetEntry(0, (ushort)IFDEntryTag.ExifIFD) as SubIFDEntry;
        IFDStructure exif_structure = sub.Structure;
        MakernoteIFDEntry makernote = exif_structure.GetEntry(0, (ushort)ExifEntryTag.MakerNote) as MakernoteIFDEntry;
        makernote = struc.GetEntry(0, (ushort)ExifEntryTag.MakerNote) as MakernoteIFDEntry;
        IFDStructure makernote_struct = makernote.Structure;
        IFDEntry entry = makernote_struct.GetEntry(0, (ushort)CanonMakerNoteEntryTag.LensModel);
        Console.WriteLine("Lens        : " + (entry as StringIFDEntry).Value);*/

		Console.WriteLine ("---------------------------------------");
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
                catch {  };
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

        return blsExt == null ? bld.ToString():string.Empty;
    }
}
