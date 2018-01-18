using System;

using Alexf.Helpers;

namespace Alexf.CreatePasswordHash
{
	class Program
	{
		static void Main (string[] args)
		{
			if (args.Length < 1)
			{
				Console.WriteLine("Specify password and solt length.");
			}
			else
			{
				string pwd = args[ 0 ].Trim();
				if (args.Length == 2)
				{
					Console.WriteLine("{0} + {1}", pwd, int.Parse(args[1]));
					Console.WriteLine(PasswordHelper.GetPasswordHash(pwd), int.Parse(args[1]));
				}
				else
				{
					Console.WriteLine("{0} + {1}", pwd, PasswordHelper.DefSaltSize);
					Console.WriteLine(PasswordHelper.GetPasswordHash(pwd));
				}
			}
		}
	}
}
