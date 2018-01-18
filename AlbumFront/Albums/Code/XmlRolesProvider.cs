using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Xml.Linq;
using System.Web;
using System.Web.Security;


public sealed class XmlRolesProvider: RoleProvider
{
	Dictionary<string, HashSet<string>> _users;
	string _appName;

	public override void Initialize (string name, NameValueCollection config)
	{
		
		if (config == null)
			throw new ArgumentNullException("config");

		if (string.IsNullOrEmpty(name)) 
		{
			name = "XmlRolesProvider";
		}

		if (string.IsNullOrEmpty(config["description"]))
		{
			config.Remove("description");
			config.Add("description", "XML roles provider");
		}
		if (!string.IsNullOrEmpty(config["ApplicationName"]))
		{			
			_appName = config[ "ApplicationName" ];
			config.Remove("ApplicationName");	
		}
		else
		{
			_appName = "xxx";
		}
		

		base.Initialize(name, config);

		string path = config[ "xmlFileName" ];
		config.Remove("xmlFileName");
		
		if (String.IsNullOrEmpty(path))
		  path = "~/App_Data/Users.xml";

		string xmlPath = HttpContext.Current.Server.MapPath(path);
		

		XDocument doc = XDocument.Load(xmlPath);
		var usersInfos = from t in doc.Root.Element("users").Elements("user")
						let groups = (from g in doc.Root.Element("membership").Elements("member") where g.Attribute("user").Value == t.Attribute("name").Value select g.Attribute("group").Value).Distinct()
						select new  {
							Name = t.Attribute("name").Value,
							Roles = new HashSet<string>( (from gn in doc.Root.Element("groups").Elements("group") join g in groups on gn.Attribute("id").Value equals g select gn.Attribute("name").Value).Distinct())};

		_users = new Dictionary<string, HashSet<string>>(StringComparer.InvariantCultureIgnoreCase);

		foreach (var ui in usersInfos)
		{
			_users.Add(ui.Name, ui.Roles);
		}
	}

	public override string ApplicationName
	{
		get
		{
			return _appName;
		}
		set
		{
			_appName = value;
		}
	}

	public override void AddUsersToRoles (string[] usernames, string[] roleNames)
	{
		throw new NotImplementedException();
	}
	public override void CreateRole (string roleName)
	{
		throw new NotImplementedException();
	}
	public override bool DeleteRole (string roleName, bool throwOnPopulatedRole)
	{
		throw new NotImplementedException();
	}
	public override string[] FindUsersInRole (string roleName, string usernameToMatch)
	{
		return (from r in _users where r.Value.Contains(roleName) && r.Key == usernameToMatch select r.Key).ToArray();
	}
	public override string[] GetAllRoles ()
	{
		return _users.SelectMany(r => r.Value).Distinct().ToArray();
	}
	public override string[] GetRolesForUser (string username)
	{
		HashSet<string> h;
		if (_users.TryGetValue(username, out h))
		{
			return h.ToArray();
		}
		return new string[ 0 ];
	}
	public override string[] GetUsersInRole (string roleName)
	{
		return (from u in _users where u.Value.Contains(roleName) select u.Key).ToArray();
	}
	public override bool IsUserInRole (string username, string roleName)
	{
		HashSet<string> h;
		if (_users.TryGetValue(username, out h))
		{
			return h.Contains(roleName);
		}
		return false;
	}
	public override void RemoveUsersFromRoles (string[] usernames, string[] roleNames)
	{
		throw new NotImplementedException();
	}
	public override bool RoleExists (string roleName)
	{
		return (from u in _users where u.Value.Contains(roleName) select u).Any();
	}

}
