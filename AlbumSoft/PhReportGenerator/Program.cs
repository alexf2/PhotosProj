using Alexf.PhotoReportGenerator.Generators;
using CommandLine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;

namespace Alexf.PhotoReportGenerator
{
    /// <summary>
    /// Файлы должны быть 
    /// </summary>
	public sealed class Program
    {
        [STAThread]
        static int Main(string[] args)
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;
            Console.InputEncoding = System.Text.Encoding.UTF8;

            var res = Parser.Default.ParseArguments<CommandLineOptions>(args)
               .MapResult(
                   (options) => Run(options),

                   errs => HandleParseError(errs)
               );
            Environment.ExitCode = res;

            return res;
        }

        static int HandleParseError(IEnumerable<Error> errs)
        {
            if (errs.IsVersion())
            {
                var assembly = Assembly.GetExecutingAssembly();
                var version = assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion
                           ?? assembly.GetName().Version?.ToString(3)
                           ?? "dev";

                Console.WriteLine($"PhotoReportGenerator - v{version}");
                return 0;
            }

            if (errs.IsHelp())
            {
                return 0;
            }
            return -1;
        }

        static int Run(CommandLineOptions opts)
        {
            var generator = new CatalogGenerator(
                opts.Ascx ?
                    new AscxGalleryGenerator() as IGalleryGenerator : new HtmlGalleryGenerator()
             );

            try
            {
                ValidateAndAdjustArgs(opts);

                Console.WriteLine("Albom catalog generation has been started...");
                var res = generator.Process(opts.PathWithImages, opts.OutFileName);
                Console.WriteLine("✅ Albom catalog generation finished OK");
                return res;
            }
            catch (DirectoryNotFoundException ex)
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine($"⚠️  Folder is not found: {ex.Message}");
                Console.ResetColor();
                return -3;
            }
            catch (FileNotFoundException ex)
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine($"⚠️  File not found: {ex.Message}");
                Console.ResetColor();
                return -4;
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"\n❌ Ошибка:");
                Console.WriteLine($"   {ex.GetType().Name}");
                Console.WriteLine($"   Message: {ex.Message}");

#if DEBUG
                    Console.WriteLine($"\n📋 Stack trace:\n{ex.StackTrace}");
#endif

                Console.ResetColor();
                return -2;
            }
        }

        static void ValidateAndAdjustArgs(CommandLineOptions opts)
        {
            opts.PathWithImages = Path.GetFullPath(opts.PathWithImages);
            if (!Directory.Exists(opts.PathWithImages))
            {
                throw new DirectoryNotFoundException($"Source directory '{opts.PathWithImages}' not found.");
            }

            if (!Path.IsPathRooted(opts.OutFileName))
            {
                if (opts.OutFileName.Contains(Path.DirectorySeparatorChar) || opts.OutFileName.Contains(Path.AltDirectorySeparatorChar))
                    opts.OutFileName = Path.GetFullPath(opts.OutFileName);
                else
                    opts.OutFileName = Path.Combine(opts.PathWithImages, opts.OutFileName);
            }

            if (string.IsNullOrEmpty(Path.GetExtension(opts.OutFileName)))
                opts.OutFileName = Path.ChangeExtension(opts.OutFileName, opts.Ascx ? ".ascx" : ".htm");

            string dir = Path.GetDirectoryName(opts.OutFileName);
            if (!Directory.Exists(dir))
            {
                throw new DirectoryNotFoundException($"Output directory '{dir}' not found.");
            }
        }
    }
}
