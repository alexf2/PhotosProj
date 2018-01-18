<%@ Import Namespace="System.Reflection" %>
<%@ Page Language="C#" %>

<%
  // Unique framework assembly
  string fw30assembly = "PresentationCore, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35";
  string fw35assembly = "System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089";
  string fw35sp1assembly = "System.Data.Entity, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089";
  
  Version frameworkVersion = Environment.Version;
  string frameworkUpdate = "";

  if (frameworkVersion.Major == 2)
  {
    try
    {
      // try load 3.0 assembly...
      frameworkVersion = AssemblyName.GetAssemblyName(Assembly.Load(fw30assembly).Location).Version;
      // ... 3.5
      frameworkVersion = AssemblyName.GetAssemblyName(Assembly.Load(fw35assembly).Location).Version;
      // ... 3.5 sp1
      frameworkVersion = AssemblyName.GetAssemblyName(Assembly.Load(fw35sp1assembly).Location).Version;
      frameworkUpdate = "SP1";
    }
    catch
    {
      // Assembly load filed
    }
  }
	
  string ver = string.Format(".NET Framework version is {0}.{1} {2}",
    frameworkVersion.Major, 
    frameworkVersion.Minor, 
    frameworkUpdate);
    
  Response.Write(ver);
  Response.Write("<br/>");
  Response.Write(string.Format("Version Information: Microsoft .NET Framework Version: {0}; ASP.NET Version: {1}",
                    MyVersionInfo.DotNetFrameworkVersion,
                    MyVersionInfo.AspNetVersion
  ));

  Response.Write("<br/>");
  Response.Write(HttpContext.Current.Request.ServerVariables["SERVER_SOFTWARE"]);
  Response.Write("<br/>");
  Response.Write(OsUtil.GetOS());
  Response.Write("<br/>");

  Response.Write(string.Format("64bit OS: {0}", Environment.Is64BitOperatingSystem));
  Response.Write("<br/>");
  Response.Write(string.Format("IIS process is 64bit: {0}", Environment.Is64BitProcess));
  
%>

<script language="c#" runat="server">
    public class MyVersionInfo
    {

        [System.Runtime.InteropServices.DllImport("kernel32.dll", CharSet = System.Runtime.InteropServices.CharSet.Unicode)]
        private static extern IntPtr GetModuleHandle(string strModuleName);

        [System.Runtime.InteropServices.DllImport("kernel32.dll", CharSet = System.Runtime.InteropServices.CharSet.Unicode)]
        private static extern int GetModuleFileName(IntPtr ptrHmodule, System.Text.StringBuilder strFileName, int szeSize);



        private static string GetFileNameFromLoadedModule(string strModuleName)
        {
            IntPtr hModule = GetModuleHandle(strModuleName);
            if (hModule == IntPtr.Zero)
            {
                return null;
            }

            System.Text.StringBuilder sb = new System.Text.StringBuilder(256);

            if (GetModuleFileName(hModule, sb, 256) == 0)
            {
                return null;
            }

            string strRetVal = sb.ToString();
            if (strRetVal != null && strRetVal.StartsWith("\\\\?\\"))
                strRetVal = strRetVal.Substring(4);

            sb.Length = 0;
            sb = null;

            return strRetVal;
        }


        private static string GetVersionFromFile(string strFilename)
        {
            string strRetVal = null;

            try
            {
                System.Diagnostics.FileVersionInfo fviVersion = System.Diagnostics.FileVersionInfo.GetVersionInfo(strFilename);
                strRetVal = string.Format(System.Globalization.CultureInfo.InvariantCulture, "{0}.{1}.{2}.{3}", new object[] {
                    fviVersion.FileMajorPart,
                    fviVersion.FileMinorPart,
                    fviVersion.FileBuildPart,
                    fviVersion.FilePrivatePart
                });
            }
            catch
            {
                strRetVal = "";
            }

            return strRetVal;
        }


        private static string GetVersionOfLoadedModule(string strModuleName)
        {            
            string strFileNameOfLoadedModule = GetFileNameFromLoadedModule(strModuleName);            

            if (strFileNameOfLoadedModule == null)
                return null;

            return GetVersionFromFile(strFileNameOfLoadedModule);
        }


        public static string SystemWebVersion
        {
            get
            {
                return GetVersionFromFile(typeof(System.Web.HttpRuntime).Module.FullyQualifiedName);
            }
        }


        public static bool IsMono
        {
            get
            {
                return Type.GetType("Mono.Runtime") != null;
            }
        }


        public static string MonoVersion
        {
            get
            {
                string strMonoVersion = "";

                Type tMonoRuntime = Type.GetType("Mono.Runtime");
                if (tMonoRuntime != null)
                {
                    System.Reflection.MethodInfo displayName = tMonoRuntime.GetMethod("GetDisplayName", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Static);
                    if (displayName != null)
                        strMonoVersion = (string)displayName.Invoke(null, null);
                }

                return strMonoVersion;
            }
        }


        public static string DotNetFrameworkVersion
        {
            get
            {
                // values.Add(ExceptionPageTemplate.Template_RuntimeVersionInformationName, RuntimeHelpers.MonoVersion);
                if (IsMono)
                    return MonoVersion;

                // Return System.Environment.Version.ToString()
                return GetVersionOfLoadedModule("mscoree.dll"); //mscorwks.dll
            }
        }


        public static string AspNetVersion
        {
            get
            {
                //values.Add(ExceptionPageTemplate.Template_AspNetVersionInformationName, Environment.Version.ToString());
                if (IsMono)
                    return System.Environment.Version.ToString();

                return GetVersionOfLoadedModule("webengine.dll");
            }
        }


        public static bool IsVistaOrHigher
        {
            get
            {
                System.OperatingSystem osWindowsVersion = System.Environment.OSVersion;
                return osWindowsVersion.Platform == System.PlatformID.Win32NT && osWindowsVersion.Version.Major >= 6;
            }
        }


        /*public static void Test()
        {
            string ErrorPageInfo = 
                string.Format("Version Information: Microsoft .NET Framework Version: {0}; ASP.NET Version: {1}"
                    ,DotNetFrameworkVersion
                    ,AspNetVersion
            );

            Console.WriteLine(ErrorPageInfo);
        }*/


    } // End Class MyVersionInfo

    public static class OsUtil
    {
        public static string GetOS()
        {
            string os = null;

            if (Environment.OSVersion.ToString().IndexOf("Windows NT 5.1") > 0)
                os = "Windows XP";
            else if (Environment.OSVersion.ToString().IndexOf("Windows NT 6.0") > 0)
                os = "Windows Vista";
            else if (Environment.OSVersion.ToString().IndexOf("Windows NT 6.1") > 0)
                os = "Windows 7";
            else if (Environment.OSVersion.ToString().IndexOf("Windows NT 6.2") > 0)
                os = "Windows 8";
            else if (Environment.OSVersion.ToString().IndexOf("Intel Mac OS X") > 0)
            {
                //os = "Mac OS or older version of Windows";
                os = "Intel Mac OS X";
            }
            else
                os = "You are using older version of Windows or Mac OS";

            return os;
        }
    }

</script>
