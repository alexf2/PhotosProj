using System;
using System.Security.Cryptography;
using System.Text;

namespace Alexf.Helpers
{
	/// <summary>
	/// Утилиты для работы с паролем, хранимым в невосстанавливаемом виде (в форме хэша).
	/// </summary>
	public static class PasswordHelper
	{
		/// <summary>
		/// Длина соли.
		/// </summary>
		public const int DefSaltSize = 7;

		/// <summary>
		/// Создаёт мусор.
		/// </summary>
		/// <param name="size">Длина мусора.</param>
		/// <returns></returns>
		public static string CreateSalt (int size)
		{
			// Generate a cryptographic random number using the cryptographic
			// service provider
			byte[] buff = new byte[ size ];
			using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
			{
				rng.GetBytes(buff);
			}

			// Return a Base64 string representation of the random number
			string code = Convert.ToBase64String(buff);
			return code.Length > size ? code.Substring(0, size):code;
		}

		/// <summary>
		/// Создаёт SHA1 хэш пароля.
		/// </summary>
		/// <param name="pwd">Пароль.</param>
		/// <param name="salt">Мусор.</param>		
		public static string CreatePasswordHash (string pwd, string salt)
		{
			string saltAndPwd = string.Concat(pwd, salt);
			//string hashedPwd = FormsAuthentication.HashPasswordForStoringInConfigFile(saltAndPwd, "SHA1");
            return string.Concat(HashString(saltAndPwd, "SHA1"), salt);
		}

        public static string HashString (string inputString, string hashName)
        {
            HashAlgorithm algorithm = HashAlgorithm.Create(hashName);
            if (algorithm == null)
            {
                throw new ArgumentException("Unrecognized hash name", "hashName");
            }
            byte[] hash = algorithm.ComputeHash(Encoding.UTF8.GetBytes(inputString));
            return Convert.ToBase64String(hash);
        }

		public static string GetPasswordHash (string password, int soltLength = DefSaltSize)
		{
			return CreatePasswordHash(password, CreateSalt(soltLength));
		}

		/// <summary>
		/// Проверяет пароль на соответствие хэшу.
		/// </summary>
		public static bool VerifyPasswordHash (string password, string paswHash, int soltLength = DefSaltSize)
		{
			if (paswHash.Length <= soltLength)
			{
				throw new Exception("Can't verify the password: password is shorter than the solt.");
			}
			string salt = paswHash.Substring(paswHash.Length - soltLength);
			string newHash = CreatePasswordHash(password, salt);
			return paswHash == newHash;
		}
	}
}
