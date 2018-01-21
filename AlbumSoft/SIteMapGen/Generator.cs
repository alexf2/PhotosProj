using System;
using System.Collections.Generic;
using System.Text;

using System.Xml;
using System.Xml.XPath;
using System.IO;
using System.Linq;
using System.Configuration;

using System.Text.RegularExpressions;

namespace Alexf.SiteMapGen
{
    using Alexf.PhotoUtils;

    public sealed class Generator
    {
        private enum Mode
        {
            DerivateXml,
            DerivateXmlPreserving,
            RenumerateNodes
        };

        readonly string _pathToGather; //полный путь к директории откуда собирать структуру (для режима /r = null)
        readonly string _catalogBase; //базовый каталог SiteMap Web-приложения
        readonly string _siteMapName; //имя Sitemap-файла, который надо создать
        
        private XmlDocument _outDoc;
        private const String ROOT_URI = @"http://schemas.microsoft.com/AspNet/SiteMap-File-1.0";
        private Int32 _currId = 0;
        int _rootID;

        private Mode _mode;

        static void Main (string[] args)
        {
            if (args.Length != 2 && args.Length != 3)
                Console.WriteLine("Bad number of arguments. You should pass a\r\n\t1) key: /gp (generate but preserve old Titles and Descriptions), /r (renum IDs) or /g (generate new metadata);\r\n\t2) directory to gather from (not required for /r) and\r\n\t3) name of the sitemap to create. File will be put into catalogBase.\r\n" +
                    "Example to create sitemap:     SiteMapGen /g d:\\Photos\\India Italy-en\r\n" +
                    "Example to renum existing sitemap:     SiteMapGen /r Italy-en"
                );
            else
            {
                try
                {
                    //где лежат Sitemaps
                    string catBase = ConfigurationManager.AppSettings["catalogBase"];
                    if (catBase != null)
                        catBase = catBase.Trim();
                    if (string.IsNullOrEmpty(catBase))
                        throw new Exception("'catalogBase' is not specified in appSettings");

                    //базовый ID для нового альбома (должны быть уникальными, одинаковые только для разных локалей одного каталога)
                    string rootID = ConfigurationManager.AppSettings["rootID"];
                    if (rootID != null)
                        rootID = rootID.Trim();
                    if (string.IsNullOrEmpty(rootID))
                        throw new Exception("'rootID' is not specified in appSettings");

                    string dirToGather = null;
                    string siteMapName = null;

                    if (args.Length == 2) //ключ + sitemap_name (для /r)
                    {
                        siteMapName = args[ 1 ];
                    }
                    else //ключ + путь + sitemap_name
                    {
                        dirToGather = Path.GetFullPath(args[1]);
                        siteMapName = args[ 2 ];
                    }
                    
                    if (siteMapName != null)
                        siteMapName = siteMapName.Trim();
                    if (string.IsNullOrEmpty(siteMapName))
                        throw new Exception("siteMapName is not specified in appSettings");

                    if (!siteMapName.ToLower().EndsWith(".sitemap"))
                        siteMapName += ".sitemap";

                    new Generator(args[0], dirToGather, catBase, int.Parse(rootID), siteMapName).Run();
                }
                catch( Exception ex )
                {
                    Generator.resportEx( ex );
                }
            }
        }

        internal Generator (string commandSwitch, string pathToGathercatalogFrom, string catalogBase, int rootID, string siteMapName)
        {
            _pathToGather = pathToGathercatalogFrom;  //для режима /r - null          
            _catalogBase = catalogBase;
            _rootID = rootID;
            _siteMapName = siteMapName;

            commandSwitch = commandSwitch.ToLower().Trim();
            switch( commandSwitch )
            {
                case "/g": //создавать новый каталог (если такой уже есть, то в новый будут добавлены старые Title и Description), далее, накатываются новые НЕПУСТЫЕ Title
                    _mode = Mode.DerivateXml;
                    break;
                case "/gp": //создавать новый каталог (если такой уже есть, то в новый будут добавлены старые Title и Description)
                    _mode = Mode.DerivateXmlPreserving;
                    break;
                case "/r":
                    _mode = Mode.RenumerateNodes;
                    if (_pathToGather != null)
                        throw new Exception("You shouldn't specify the path with /r. Specify only file name without any path.");
                    break;
                default:
                    throw new Exception( "Unrecognized key: '" + commandSwitch + "'." );                    
            }

            if (!Directory.Exists(_catalogBase))
                throw new Exception(string.Format("Base sitemap directory '{0}', specified in app.config, is not found", _catalogBase));
            if (!string.IsNullOrEmpty(_pathToGather) && !Directory.Exists(_pathToGather))
                throw new Exception(string.Format("Path to gather '{0}' is not found", _pathToGather));
        }

        static string getLastDir (string str)
        {
            if (string.IsNullOrEmpty(str))
                return str;

            str = str.Trim();

            int idx = str.LastIndexOf('\\');
            if (idx == -1)
                return str;

            int dec = 1;
            if (idx == str.Length - 1)
            {
                idx = str.LastIndexOf('\\', str.Length - 2);
                dec = 2;
            }

            return idx == -1 ? str:str.Substring(idx + 1, str.Length - idx - dec);
        }

        /// <summary>
        /// Sitemap в каталоге Web-приложения, который будет обрабатываться
        /// </summary>
        string SiteMapFullName
        {
            get {
                return Path.Combine(_catalogBase, _siteMapName);
            }
        }

        private void Run()
        {
            if (_mode == Mode.DerivateXml || _mode == Mode.DerivateXmlPreserving)
                ExecDerivateXml();
            else
                ExecRenum();
        }

        /// <summary>
        /// Пересчитать IDs существующего Sitemap (стартовый ID должен быть вписан в корневой siteMapNode).
        /// </summary>
        private void ExecRenum ()
        {
            if (!File.Exists(SiteMapFullName))
                throw new ApplicationException(string.Format("Site map '{0}' does not exists.", SiteMapFullName));

            XmlDocument doc = new XmlDocument();
            doc.Load(SiteMapFullName);
            XmlNamespaceManager mgr = new XmlNamespaceManager( doc.NameTable );
            mgr.AddNamespace( "st", "http://schemas.microsoft.com/AspNet/SiteMap-File-1.0" );

            String rootUrl = doc.SelectSingleNode( "/st:siteMap/st:siteMapNode/@url", mgr ).Value;
            rootUrl = rootUrl.Replace( "-", "" ); //удаляем минус

            foreach( XmlElement el in doc.SelectNodes("/st:siteMap/st:siteMapNode//st:siteMapNode", mgr) )
                el.SetAttribute( "url", rootUrl + el.GetAttribute("url") );

            doc.Save(SiteMapFullName); 
        }

        /// <summary>
        /// Достаёт из старого документа стартовый ID узлов. Если документа нет, то используется ID из app.config.
        /// </summary>        
        private void FetchRootId (string oldFileName)
        {
            if (!File.Exists(oldFileName))
                return;            

            using (FileStream stm = File.OpenRead(oldFileName))
            {
                XPathDocument xp = new XPathDocument(stm);
                XPathNavigator nav = xp.CreateNavigator();

                XmlNamespaceManager mgr = new XmlNamespaceManager(nav.NameTable);
                mgr.AddNamespace("st", "http://schemas.microsoft.com/AspNet/SiteMap-File-1.0");

                XPathNavigator nav2 = nav.SelectSingleNode("/st:siteMap/st:siteMapNode/@url", mgr);

                if (nav2 == null)
                    Console.WriteLine(string.Format("Warning: in [{0}] thereis no root siteMapNode", oldFileName));
                else
                    _rootID = nav2.ValueAsInt;
            }
        }

        private void ExecDerivateXml ()
        {
           _outDoc = new XmlDocument();
           _outDoc.LoadXml( String.Format("<?xml version=\"1.0\" encoding=\"utf-8\" ?><siteMap xmlns=\"{0}\" />", ROOT_URI) );
            
            FetchRootId(SiteMapFullName);

            XmlElement el = _outDoc.CreateElement( "siteMapNode", ROOT_URI );//root node
            el.SetAttribute( "url", _rootID.ToString() );
            string subj = getLastDir(_pathToGather);            
            el.SetAttribute( "title", subj );
            //el.SetAttribute( "description", "" );
            setMetadata(el, _pathToGather, true );
            //path2 добавляем позже, чтобы в setMetadata клеился правильный путь к папке: так же, мы выполняем вставку после url
            el.Attributes.InsertAfter(_outDoc.CreateAttribute("path2"), el.Attributes["url"]);
            el.Attributes["path2"].Value = subj;
            
            _outDoc.DocumentElement.AppendChild( el );

            DateTime? filesDt = generate( el, _pathToGather ); //генерирует Xml для одного уровня
            if (filesDt.HasValue)
                el.SetAttribute("date", XmlConvert.ToString(filesDt.Value, XmlDateTimeSerializationMode.Local));

            if (loadOldDescriptions(SiteMapFullName)) //забираем дескрипшены из старого файла (если он есть), а затем переписываем новым файлом            
                File.Move(SiteMapFullName, SiteMapFullName + ".bak");

            _outDoc.Save(SiteMapFullName);
        }

        bool loadOldDescriptions (string oldFileName) //надо забрать description и title
        {
            XmlDocument doc = new XmlDocument();
            XmlNamespaceManager mgr = new XmlNamespaceManager(doc.NameTable);
            mgr.AddNamespace("st", "http://schemas.microsoft.com/AspNet/SiteMap-File-1.0");

            bool res = false;
            if (File.Exists(oldFileName))            
            {
                res = true;
                doc.Load(oldFileName);

                Dictionary<String, XmlElement> srcNodes = new Dictionary<String, XmlElement>(); //индексируем ноды
                foreach (XmlElement el in doc.SelectNodes("//st:siteMapNode", mgr))
                {
                    String k = getKey(el);
                    if (!srcNodes.ContainsKey(k))
                        srcNodes.Add(k, el);
                }


                Boolean hasNew = false;
                foreach (XmlElement el in _outDoc.SelectNodes("//st:siteMapNode", mgr))
                {
                    String k = getKey(el);
                    XmlElement oldEl;
                    if (srcNodes.TryGetValue(k, out oldEl))
                        copyAttrs(el, oldEl, el.HasChildNodes, "title", "description", "roles");
                    else
                    {
                        if (!hasNew)
                        {
                            hasNew = true;
                            Console.WriteLine("Found new images:");
                        }
                        Console.WriteLine(k);
                    }
                }
            }            

            foreach (XmlElement nd in _outDoc.SelectNodes("//st:*[@f]", mgr)) //удаляем метки title, взятых из имени файла
                nd.RemoveAttribute("f");

            return res;
        }

        void copyAttrs (XmlElement el, XmlElement oldEl, bool isDir, params string[] names)
        {
            foreach (string prm in names)
            {
                string oldVal = oldEl.GetAttribute(prm);
                if (!string.IsNullOrEmpty(oldVal))
                {
                    if (isDir || _mode == Mode.DerivateXmlPreserving || string.IsNullOrEmpty(el.GetAttribute(prm)) || (prm == "title" && el.HasAttribute("f")) )                        
                        el.SetAttribute(prm, oldVal); //копируем старый атрибут
                }
            }
        }

        static string getKey (IXPathNavigable el)
        {
            XPathNavigator nav = el.CreateNavigator();
            
            XPathNavigator navRoot = nav.Clone();
            navRoot.MoveToRoot(); navRoot.MoveToFirstChild(); //DocumentElement

            StringBuilder bld = new StringBuilder();

            do{
                if( bld.Length > 0 )
                    bld.Insert( 0, '/' );

                bld.Insert(0, nav.GetAttribute("path2", string.Empty));
            } while (nav.MoveToParent() && nav.ComparePosition(navRoot) != XmlNodeOrder.Same);

            return bld.ToString().ToLower();
        }

        private static readonly Regex _rxThumb = new Regex( @"^.+_thumb(\..+){0,1}$",
            RegexOptions.CultureInvariant|RegexOptions.ExplicitCapture|RegexOptions.IgnoreCase|RegexOptions.Singleline
        );

        /// <summary>
        /// Забираем данные из Exif'а
        /// </summary>        
        static DateTime setMetadata (XmlElement el, String path, Boolean isFolder)
        {
            DateTime dt;
            var targetObj = Path.Combine( path, el.GetAttribute("path2") );

            ImageInfo info;
            if (isFolder)
                dt = Directory.GetCreationTime(targetObj);
            else
            {
                //dt = File.GetCreationTime(targetObj);
                info = ExifUtils.GetExifData(targetObj, true);
                dt = info.Shot;

                if (!info.FileNameIsUsed && !string.IsNullOrEmpty(info.Caption))
                {
                    el.SetAttribute("title", info.Caption);
                    el.RemoveAttribute("f");
                }
                if (!string.IsNullOrEmpty(info.Description))
                    el.SetAttribute("description", info.Description);

                string shotInfo = info.GetShotCaption(true);
                if (!string.IsNullOrEmpty(shotInfo))
                    el.SetAttribute("shot", shotInfo);

                if (info.Latitude.HasValue)
                {
                    el.SetAttribute("lat", XmlConvert.ToString(info.Latitude.Value));
                    el.SetAttribute("long", XmlConvert.ToString(info.Longitude.Value));
                }
            }

            el.SetAttribute( "date", XmlConvert.ToString(dt, XmlDateTimeSerializationMode.Local) );

            return dt;
        }

        DateTime? generate (XmlNode parent, string path)
        {
            var prefId = Math.Abs( _rootID );
            DateTime? res = null;
            foreach (string dir in Directory.EnumerateDirectories(path)) //проходим по вложенным директориям
            {
                XmlElement el = _outDoc.CreateElement( "siteMapNode", ROOT_URI );
                String subj = getLastDir( dir );
                el.SetAttribute( "url", prefId.ToString() + _currId++.ToString() );
                el.SetAttribute( "path2", subj );
                el.SetAttribute( "title", subj );
                setMetadata( el, path, true );
                parent.AppendChild( el );
                DateTime? filesDt = generate( el, dir ); //рекурсивно заполняем содержимым
                if (res == null || filesDt < res)
                    res = filesDt;
                if (filesDt.HasValue)
                    el.SetAttribute("date", XmlConvert.ToString(filesDt.Value, XmlDateTimeSerializationMode.Local));
            }
            
            foreach (string f in Directory.EnumerateFiles(path, "*.jpg").Union(Directory.EnumerateFiles(path, "*.jpeg")))
            {
                if( _rxThumb.IsMatch(f) ) //пропускаем превьюшки
                    continue;
                XmlElement el = _outDoc.CreateElement( "siteMapNode", ROOT_URI );
                String subj = Path.GetFileName( f );
                el.SetAttribute( "url", prefId.ToString() + _currId++.ToString() );
                el.SetAttribute( "path2", subj );
                el.SetAttribute( "title", Path.GetFileNameWithoutExtension(subj) );
                el.SetAttribute("f", string.Empty); //маркер, что title взят из имени файла
                DateTime dtCalc = setMetadata( el, path, false );
                parent.AppendChild( el );
                if (res == null || dtCalc < res)
                    res = dtCalc;
            }

            return res;
        }

        static void resportEx ( Exception ex )
        {
            Console.WriteLine( "\r\n***** Error from: [" + 
				ex.Source + "]\r\n" + ex.Message + "\r\n*****" );

			//Console.WriteLine( ex.StackTrace.ToString() );
        }
    }

}
