using System;
using System.IO;
using Microsoft.Win32;

namespace NWN
{
	/// <summary>
	/// This class encapsulates various information about the NWN application.
	/// </summary>
	public class NWNInfo
	{
		#region public static properties/methods
		/// <summary>
		/// Gets whether or not NWN is installed on this PC.
		/// </summary>
		public static bool IsInstalled { get { return singleton.installed; } }

		/// <summary>
		/// Returns true if XP1 is installed.
		/// </summary>
		public static bool IsXP1Installed { get { return singleton.isXP1Installed; } }

		/// <summary>
		/// Returns true if XP2 is installed.
		/// </summary>
		public static bool IsXP2Installed { get { return singleton.isXP2Installed; } }
	
		/// <summary>
		/// Returns true if NWN2 is installed.
		/// </summary>
		public static bool IsNWN2Installed { get { return singleton.isNWN2Installed; } }

		/// <summary>
		/// Returns true if the OC modules are installed.
		/// </summary>
		public static bool IsOCModsInstalled
		{
			get
			{
				// Return true if all of the modules are on disk.
				string[] ocMods;

				if (singleton.modeNWN1)
					ocMods = ocModules;
				else
					ocMods = oc2Modules;


				foreach (string module in ocModules)
				{
					string file = Path.Combine(NWMPath, module);
					if (!File.Exists(file)) return false;
				}
				return true;
			}
		}

		/// <summary>
		/// Returns true if the XP1 modules are installed.
		/// </summary>
		public static bool IsXP1ModsInstalled
		{
			get
			{
				if (!singleton.modeNWN1)
					return false;

				// Return true if all of the modules are on disk.
				foreach (string module in xp1Modules)
				{
					string file = Path.Combine(NWMPath, module);
					if (!File.Exists(file)) return false;
				}
				return true;
			}
		}

		/// <summary>
		/// Returns true if the XP2 modules are installed.
		/// </summary>
		public static bool IsXP2ModsInstalled
		{
			get
			{
				if (!singleton.modeNWN1)
					return false;

				// Return true if all of the modules are on disk.
				foreach (string module in xp2Modules)
				{
					string file = Path.Combine(NWMPath, module);
					if (!File.Exists(file)) return false;
				}
				return true;
			}
		}

		/// <summary>
		/// Gets the list of OC modules.
		/// </summary>
		public static string[] OCModules 
		{ 
			get 
			{
				if (singleton.modeNWN1)
					return ocModules; 
				else
					return oc2Modules;
			} 
		}

		/// <summary>
		/// Gets the list of XP1 modules
		/// </summary>
		public static string[] XP1Modules 
		{ 
			get 
			{ 
				if (singleton.modeNWN1)
					return xp1Modules; 
				else
					return null;
			} 
		}

		/// <summary>
		/// Gets the list of XP2 modules.
		/// </summary>
		public static string[] XP2Modules 
		{ 
			get 
			{ 
				if (singleton.modeNWN1)
					return xp2Modules; 
				else
					return null;
			} 
		}

		/// <summary>
		/// Gets/sets the path that NWN is installed in.  The path may be set to
		/// allow for the manipulation of NWN on remote installs or for multiple
		/// installs.  If the path is set to string.Empty, then the value will
		/// revert back to the install path in the registry.
		/// </summary>
		public static string InstallPath
		{
			get
			{
				if (singleton.modeNWN1)
				{
					return string.Empty == singleton.overridePath ?
						singleton.installPath : singleton.overridePath;
				}
				else
				{
					return string.Empty == singleton.overrideNWN2Path ?
						singleton.installNWN2Path : singleton.overrideNWN2Path;
				}
			}
			set
			{
				if (singleton.modeNWN1)
					singleton.overridePath = value;
				else
					singleton.overrideNWN2Path = value;
			}
		}
		
		// NWN2 saves all the stuff in My Documents\NeverWinterNights 2
		public static string DocumentPath
		{
			get
			{
				if (!singleton.modeNWN1)
					return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Personal),"Neverwinter Nights 2");
				else
					return null;
			}
		}

		/// <summary>
		/// Gets the path for the bioware modules.
		/// </summary>
		public static string NWMPath 
		{ 
			get 
			{ 
				if (singleton.modeNWN1)
					return Path.Combine(InstallPath, "nwm"); 
				else
					return Path.Combine(InstallPath, "modules");
			} 
		}

		/// <summary>
		/// Gets the path for the tools subdirectory.
		/// </summary>
		public static string ToolsPath 
		{ 
			get 
			{ 
				if (singleton.modeNWN1)
					return Path.Combine(InstallPath, "Utils"); 
				else
					return Path.Combine(InstallPath, "Utils");
			} 
		}

		/// <summary>
		/// Gets the path for the modules subdirectory.
		/// </summary>
		public static string ModulesPath 
		{ 
			get 
			{ 
				if (singleton.modeNWN1)
					return Path.Combine(InstallPath, "Modules"); 
				else
					return Path.Combine(InstallPath, "Modules");
			} 
		}

		/// <summary>
		/// Gets the path for the hak info files.
		/// </summary>
		public static string HakInfoPath 
		{ 
			get 
			{
				if (singleton.modeNWN1)
					return HakPath; 
				else
					return HakPath;
			} 
		}

		/// <summary>
		/// Gets the path for the hak .
		/// </summary>
		public static string HakPath 
		{ 
			get 
			{ 
				if (singleton.modeNWN1)
					return Path.Combine(InstallPath, "hak"); 
				else
					return Path.Combine(DocumentPath,"hak");
			} 
		}

		/// <summary>
		/// Gets the installed NWN version.
		/// </summary>
		public static string Version 
		{ 
			get 
			{ 
				if (singleton.modeNWN1)
					return singleton.version; 
				else
					return singleton.versionNWN2;
			} 
		}

		public static bool ModeNWN1
		{ 
			get 
			{
				return singleton.modeNWN1;
			}
			set
			{
				singleton.modeNWN1 = value;
			}
		}

		/// <summary>
		/// Gets the full path for the specified NWN file.
		/// </summary>
		/// <param name="file">The NWM file to get the full path for.</param>
		/// <returns>The full path to the NWM file.</returns>
		public static string GetFullFilePath(string file)
		{
			return Path.Combine(GetPathForFile(file), file);
		}

		/// <summary>
		/// Gets the partial path (relative to the NWN install directory) of
		/// the file, i.e. hak\foo.hak, etc.
		/// </summary>
		/// <param name="file">The NWM file to get the full path for.</param>
		/// <returns>The partial path to the NWM file.</returns>
		public static string GetPartialFilePath(string file)
		{
			// Determine the path based on the file's extension.  Hif files are
			// a new file type (hack info) that we use to store information about
			// what files are contained in a 'hak'.
			FileInfo info = new FileInfo(file);
			switch (info.Extension.ToLower())
			{
				case ".tlk":
					return Path.Combine("tlk", file);
				case ".erf":
					return Path.Combine("erf", file);
				case ".hif":
				case ".hak":
					return Path.Combine("hak", file);
				case ".mod":
					return Path.Combine("modules", file);
				case ".nwm":
					return Path.Combine("nwm", file);
				default:
					return file;
			}
		}

		/// <summary>
		/// This method gets the path that the specified NWN file should be
		/// installed in.  It supports .mod, .nwm, .tlk, .erf, .hak file types.
		/// </summary>
		/// <param name="file">The file to get the path for</param>
		/// <returns>The path that the file should be installed in</returns>
		public static string GetPathForFile(string file)
		{
			// Determine the path based on the file's extension.  Hif files are
			// a new file type (hack info) that we use to store information about
			// what files are contained in a 'hak'.
			FileInfo info = new FileInfo(file);

			string daPath;
			if (singleton.modeNWN1)
				daPath = InstallPath;
			else
				daPath = DocumentPath;

			switch (info.Extension.ToLower())
			{
				case ".tlk":
					return Path.Combine(daPath, "tlk");
				case ".erf":
					return Path.Combine(daPath, "erf");
				case ".hif":
				case ".hak":
					return Path.Combine(daPath, "hak");
				case ".mod":
					// OC modules for NWN2 are in InstallPath and not module path
					if (!singleton.modeNWN1)
					{
						foreach (string module in oc2Modules)
						{
							if (info.Name == module)
								daPath = InstallPath;
						}
					}
					return Path.Combine(daPath, "modules");
				case ".nwm":
					return Path.Combine(daPath, "nwm");
			}

			// If we get here the file is something we don't know about, return
			// string.Empty.
			return string.Empty;
		}
		#endregion

		#region private fields/properties/methods
		/// <summary>
		/// Class constructor implemented as private, since the object is a singleton
		/// and can only be created internally.
		/// </summary>
		private NWNInfo()
		{
			RegistryKey key = Registry.LocalMachine.OpenSubKey(regPath);

			// If we were able to open up the NWN registry key then NWW is
			// installed on the PC, save the important registration information.
			if (null != key)
			{
				installed = true;
				installPath = key.GetValue(regLocation) as string;
				version = key.GetValue(regVersion) as string;
			}

			// Check for the XP1 Guid registry entry, if it's there then
			// mark XP1 as being installed.
			key = Registry.LocalMachine.OpenSubKey(regXP1Path);
			if (null != key && null != key.GetValue(regGuid)) isXP1Installed = true;

			// Check for the XP2 Guid registry entry, if it's there then
			// mark XP2 as being installed.
			key = Registry.LocalMachine.OpenSubKey(regXP2Path);
			if (null != key && null != key.GetValue(regGuid)) isXP2Installed = true;

			// Check for NWN2
			key = Registry.LocalMachine.OpenSubKey(regNWN2Path);
			if (null != key)
			{
				isNWN2Installed = true;
				installNWN2Path = key.GetValue(regNWN2Location) as string;
				versionNWN2 = key.GetValue(regNWN2Version) as string;
			}
		}

		// Module lists for the various modules in the OC/XP1/XP2
		private static string[] ocModules = new string[] { "Prelude.nwm", "Chapter1.nwm", "Chapter1E.nwm", 
			"Chapter2.nwm", "Chapter2E.nwm", "Chapter3.nwm", "Chapter4.nwm" };
		private static string[] xp1Modules = new string[] 
			{ "XP1-Chapter 1.nwm", "XP1-Interlude.nwm", "XP1-Chapter 2.nwm" };
		private static string[] xp2Modules = new string[] 
			{ "XP2_Chapter1.nwm", "XP2_Chapter2.nwm", "XP2_Chapter3.nwm" };

		private const string regPath = @"SOFTWARE\BioWare\NWN\Neverwinter";
		private const string regXP1Path = @"SOFTWARE\BioWare\NWN\Undrentide";
		private const string regXP2Path = @"SOFTWARE\BioWare\NWN\Underdark";
		private const string regGuid = "Guid";
		private const string regLocation = "Location";
		private const string regVersion = "Version";

		private static NWNInfo singleton = new NWNInfo();

		private string installPath = string.Empty;
		private string overridePath = string.Empty;
		private string version = string.Empty;
		private bool installed = false;
		private bool isXP1Installed = false;
		private bool isXP2Installed = false;
		private bool isNWN2Installed = false;

		// Module lists for the various modules in NWN2
		private static string[] oc2Modules = new string[] { "0_Tutorial.mod", "0100_UninvitedGuests.mod", "1000_Neverwinter_A1.mod", "1100_West_Harbor.mod", 
															  "1200_Highcliff.mod", "1300_Old_Owl_Well.mod", "1600_Githyanki_Caves.mod", "1700_Merchant_Quarter.mod", 
															  "1800_Skymirror.mod", "1900_Slums.mod", "2000_Neverwinter.mod", "2100_Crossroad_Keep_A2.mod", "2200_Port_Llast.mod",
															  "2300_Crossroad_Keep_Adv.mod", "2400_Illefarn_Ruins.mod", "2600_AJ_Haven.mod", "3000_Neverwinter_A3.mod",
															  "3400_Merdelain.mod", "3500_Crossroad_Keep_Siege.mod"};

		private const string regNWN2Path = @"SOFTWARE\Obsidian\NWN 2\Neverwinter";
		private const string regNWN2Guid = "Guid";
		private const string regNWN2Location = "Location";
		private const string regNWN2Version = "Version";

		private string installNWN2Path = string.Empty;
		private string overrideNWN2Path = string.Empty;
		private string versionNWN2 = string.Empty;

		// true = NWN1 info, false = NWN2 info
		private bool modeNWN1 = true;

		#endregion
	}
}
