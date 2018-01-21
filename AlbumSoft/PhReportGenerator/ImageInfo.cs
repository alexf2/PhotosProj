using System;
using System.Text;
using System.Text.RegularExpressions;

namespace Alexf.PhotoUtils
{
    public struct ImageInfo
    {
        //basic
        public string Caption;
        public DateTime Shot;
        public double? Latitude, Longitude, Altitude;
        public int W, H;
        public int FileSize;
        public bool FileNameIsUsed; //empty description/title/comment

        //extended
        public string Camera;
        public string Lens;
        public string Description;

        public string IsoSpeed;
        public string Aperture;
        public string FocalLength;
        public string Exposure;
        public bool Flash;

        public string GetShotCaption (bool withCamera)
        {
            StringBuilder bld = new StringBuilder();

            bool hasCamera = false;
            if (withCamera && !string.IsNullOrEmpty(Camera))
            {
                bld.Append(Camera);
                hasCamera = true;
            }

            if (!string.IsNullOrEmpty(Lens))
            {
                if (hasCamera)
                    bld.Append("; ");
                bld.Append(_ex.Replace(Lens, string.Empty));
            }

            bool brackets = false;
            if (bld.Length > 0)
            {
                brackets = true;
                bld.Append(" (");
            }

            bool added = false;
            if (!string.IsNullOrEmpty(IsoSpeed))
            {
                bld.AppendFormat("ISO {0}", IsoSpeed);
                added = true;
            }

            if (!string.IsNullOrEmpty(Aperture))
            {
                if (added) bld.Append(", ");
                bld.AppendFormat("f/{0}", Aperture);
                added = true;
            }

            if (!string.IsNullOrEmpty(FocalLength))
            {
                if (added) bld.Append(", ");
                bld.AppendFormat("{0} mm", FocalLength);
                added = true;
            }

            if (!string.IsNullOrEmpty(Exposure))
            {
                if (added) bld.Append(", ");
                bld.AppendFormat("{0}", Exposure);
                added = true;
            }

            if (Flash)
            {
                if (added) bld.Append(" ");
                bld.Append("+ Flash");
                added = true;
            }

            if (brackets)
                bld.Append(")");

            return bld.ToString();
        }

        static Regex _ex = new Regex(@"[A-Za-z\s]", RegexOptions.CultureInvariant | RegexOptions.ExplicitCapture | RegexOptions.Singleline);
    };
}
