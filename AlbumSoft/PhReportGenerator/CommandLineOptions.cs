using CommandLine;
using CommandLine.Text;
using System.Collections.Generic;

namespace Alexf.PhotoReportGenerator
{
    internal sealed class CommandLineOptions
    {
        [Option("ascx", Required = false, HelpText = "Если указано, то генерируем новый формат микро-альбома:" +
            " UserControl ascx для GalleryGen.aspx, иначе генерируем старый статический htm.")]
        public bool Ascx { get; set; }

        [Value(0, MetaName = "path_with_images", Required = true,
            HelpText = "Путь к папке микроальбома.")]
        public string PathWithImages { get; set; }

        [Value(1, MetaName = "out_file_name", Required = true,
        HelpText = "Имя выходного файла с именем, расширенее необязательно.")]
        public string OutFileName { get; set; }

        [Usage(ApplicationAlias = "PhotoReportGenerator.exe")]
        public static IEnumerable<Example> Examples
        {
            get
            {
                yield return new Example("Генерация статической страницы микро альбома htm (legacy)", new CommandLineOptions
                {
                    PathWithImages = "D:\\PhotosProj\\AlbumFront\\Pub\\DivnoGorie2020\\",
                    OutFileName = "Divnogorie2020"
                });
                yield return new Example("Генерация страницы микро альбома в виде ascx UserControl для GalleryGen.aspx", new CommandLineOptions
                {
                    PathWithImages = "D:\\PhotosProj\\AlbumFront\\Pub\\DivnoGorie2020\\",
                    OutFileName = "Divnogorie2020.ascx",
                    Ascx = true
                });
            }
        }
    }
}
