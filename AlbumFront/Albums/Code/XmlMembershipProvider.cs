using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Xml.Linq;
using System.Web;
using System.Web.Security;
using Alexf.Helpers;

public sealed class XmlMembershipProvider: MembershipProvider
{
	struct UserInfo
	{
		public string Name;
		public string Password;
	}

	Dictionary<string, UserInfo> _users;
	string _fileName;	
	bool _hashedPassword;

	public override string ApplicationName
	{
		get { throw new NotSupportedException(); }
		set { throw new NotSupportedException(); }
	}

	public override bool EnablePasswordRetrieval
	{
		get { return false; }
	}

	public override bool EnablePasswordReset
	{
		get { return false; }
	}

	public override int MaxInvalidPasswordAttempts
	{
		get { return 5; }
	}

	public override int MinRequiredNonAlphanumericCharacters
	{
		get { return 0; }
	}

	public override int MinRequiredPasswordLength
	{
		get { return 8; }
	}

	public override int PasswordAttemptWindow
	{
		get { throw new NotSupportedException(); }
	}

	public override MembershipPasswordFormat PasswordFormat
	{
		get { return MembershipPasswordFormat.Clear; }
	}

	public override string PasswordStrengthRegularExpression
	{
		get { throw new NotSupportedException(); }
	}

	public override bool RequiresQuestionAndAnswer
	{
		get { return false; }
	}

	public override bool RequiresUniqueEmail
	{
		get { return false; }
	}


	public override void Initialize (string name, NameValueCollection config)
	{
		if (config == null)
			throw new ArgumentNullException("config");

		if (string.IsNullOrEmpty(name)) 
		{
			name = "XmlMembershipProvider";
		}

		if (string.IsNullOrEmpty(config["description"]))
		{
			config.Remove("description");
			config.Add("description", "XML membership provider");
		}

		base.Initialize(name, config);

		string path = config[ "xmlFileName" ];
		config.Remove("xmlFileName");

		string hashedPwd = config[ "hashedPassword" ];
		if (!string.IsNullOrEmpty(hashedPwd))
		{
			config.Remove("hashedPassword");
			_hashedPassword = bool.Parse(hashedPwd);
		}
		
		if (String.IsNullOrEmpty(path))
		  path = "~/App_Data/Users.xml";

		string xmlPath = HttpContext.Current.Server.MapPath(path);
		_users = new Dictionary<string, UserInfo>(StringComparer.InvariantCultureIgnoreCase);

		XDocument doc = XDocument.Load(xmlPath);
		var usersInfos = from t in doc.Root.Element("users").Elements("user")						
						select new UserInfo {
							Name = t.Attribute("name").Value,
							Password = t.Attribute("password").Value
						};

		foreach (var ui in usersInfos)
		{
			_users.Add(ui.Name, ui);
		}
	}

	public override bool ValidateUser (string username, string password)
	{
		if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
		{
			return false;
		}

		UserInfo info;
		if (_users.TryGetValue(username, out info))
		{
			return _hashedPassword ? PasswordHelper.VerifyPasswordHash(password, info.Password):password == info.Password;
		}
		return false;
	}

	public override MembershipUser GetUser (string username, bool userIsOnline)
	{
		if (string.IsNullOrEmpty(username))
		{
			return null;
		}
		UserInfo info;
		if (_users.TryGetValue(username, out info))
		{
			return new MembershipUser(Name, username, username, null, null, info.Password, true, false, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.MaxValue);
		}
		return null;
	}

	public override MembershipUserCollection GetAllUsers (int pageIndex, int pageSize, out int totalRecords)
	{
		totalRecords = _users.Count;
		MembershipUserCollection res = new MembershipUserCollection();
		foreach (UserInfo usr in (from u in _users.Values.Skip(pageIndex * pageSize).Take(pageIndex) select u))
		{
			res.Add (
				new MembershipUser(Name, usr.Name, usr.Name, null, null, usr.Password, true, false, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.MaxValue)
			);
		}
		return res;
	}

	public override MembershipUser GetUser (object providerUserKey, bool userIsOnline)
	{
		if (providerUserKey == null || !(providerUserKey is string))
		{
			return GetUser((string)providerUserKey, true);
		}
		return null;
	}

	public override string GetUserNameByEmail (string email)
	{
		throw new NotSupportedException();
	}
	public override void UpdateUser (MembershipUser user)
	{
		throw new NotSupportedException();
	}

	public override bool ChangePassword (string username, string oldPassword, string newPassword)
	{
		throw new NotSupportedException();
	}
	public override MembershipUser CreateUser (string username, string password, string email, string passwordQuestion, string passwordAnswer, bool isApproved, object providerUserKey, out MembershipCreateStatus status)
	{
		throw new NotSupportedException();
	}
	public override bool DeleteUser (string username, bool deleteAllRelatedData)
	{
		throw new NotSupportedException();
	}

	public override string ResetPassword(string username, string answer)
	{
		throw new NotSupportedException();
	}

	public override bool UnlockUser(string userName)
	{
		throw new NotSupportedException();
	}

	public override MembershipUserCollection FindUsersByEmail(string emailToMatch, int pageIndex, int pageSize, out int totalRecords)
	{
		throw new NotSupportedException();
	}

	public override MembershipUserCollection FindUsersByName(string usernameToMatch, int pageIndex, int pageSize, out int totalRecords)
	{
		throw new NotSupportedException();
	}

	public override int GetNumberOfUsersOnline()
	{
		throw new NotSupportedException();
	}

	public override bool ChangePasswordQuestionAndAnswer(string username, string password, string newPasswordQuestion, string newPasswordAnswer)
	{
		throw new NotSupportedException();
	}

	public override string GetPassword(string username, string answer)
	{
		throw new NotSupportedException();
	}
}
