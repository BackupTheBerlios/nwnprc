package prc.autodoc;

import java.io.*;
import java.util.*;
import java.util.regex.*;

import static prc.autodoc.Main.SpellType.*;


public class Main{
	/**
	 * A small data structure class that gives access to both normal and custom
	 * TLK with the same method
	 */
	private static class TLKStore{
		private Data_TLK normal,
		                 custom;
		
		public TLKStore(String normalName, String customName) throws TLKReadException{
			this.normal = new Data_TLK("tlk" + fileSeparator + normalName);
			this.custom = new Data_TLK("tlk" + fileSeparator + customName);
		}
		
		public String get(int num){
			return num < 0x01000000 ? normal.getEntry(num) : custom.getEntry(num);
		}
		
		public String get(String num){
			return Integer.parseInt(num) < 0x01000000 ? normal.getEntry(num) : custom.getEntry(num);
		}
	}
	
	/**
	 * Another data structure class. Stores 2das and handles loading them.
	 */
	private static class TwoDAStore{
		private HashMap<String, Data_2da> data = new HashMap<String, Data_2da>();
		
		public TwoDAStore(){
			// Read the main 2das
			try{
				data.put("classes",     new Data_2da("2da" + fileSeparator + "classes.2da"));
				data.put("domains",     new Data_2da("2da" + fileSeparator + "domains.2da"));
				data.put("feat",        new Data_2da("2da" + fileSeparator + "feat.2da"));
				data.put("masterfeats", new Data_2da("2da" + fileSeparator + "masterfeats.2da"));
				data.put("racialtypes", new Data_2da("2da" + fileSeparator + "racialtypes.2da"));
				data.put("skills",      new Data_2da("2da" + fileSeparator + "skills.2da"));
				data.put("spells",      new Data_2da("2da" + fileSeparator + "spells.2da"));
			}catch(Exception e){
				System.err.println("Failure while reading main 2das. Exception data:\n");
				e.printStackTrace();
				System.exit(0);
			}
		}
		
		public Data_2da get(String name){
			if(data.containsKey(name))
				return data.get(name);
			else{
				Data_2da temp = null;
				try{
					temp = new Data_2da("2da" + fileSeparator + name + ".2da");
				}catch(IllegalArgumentException e){
					System.err.println(e);
					temp = null;
				}catch(TwoDAReadException e){
					System.err.println(e);
					temp = null;
				}
				data.put(name, temp);
				return temp;
			}
		}
	}
	
	/**
	 * A class for handling the settings file.
	 */
	private static class Settings{
		private Matcher mainMatch = Pattern.compile("\\S+:").matcher(""),
		                paraMatch = Pattern.compile("\"[^\"]+\"").matcher(""),
		                langMatch = Pattern.compile("\\w+=\"[^\"]+\"").matcher("");
		private enum Modes{LANGUAGE, SIGNATURE};
		
		public ArrayList<String[]> languages = new ArrayList<String[]>();
		public String[] epicspellSignatures = null;
		public String[] psionicpowerSignatures = null;
		
		
		public Settings(){
			try{
				Scanner reader = new Scanner(new File("settings"));
				String check;
				Modes mode = null;
				while(reader.hasNextLine()){
					check = reader.nextLine();
					
					// Skip comments and blank lines
					if(check.startsWith("#") || check.trim().equals("")) continue;
					
					// Check if a new rule is starting
					mainMatch.reset(check);
					if(mainMatch.find()){
						if(mainMatch.group().equals("language:")) mode = Modes.LANGUAGE;
						else if(mainMatch.group().equals("signature:")) mode = Modes.SIGNATURE;
						else{
							throw new Exception("Unrecognized setting detected");
						}
						
						continue;
					}
					
					// Take action based on current mode
					if(mode == Modes.LANGUAGE){
						String[] temp = new String[3];
						String result;
						langMatch.reset(check);
						// parse the language entry
						for(int i = 0; i < 3; i++){
							if(!langMatch.find())
								throw new Exception("Missing language parameter");
							result = langMatch.group();
							
							if(result.startsWith("name")){
								paraMatch.reset(result);
								paraMatch.find();
								temp[0] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
							}
							else if(result.startsWith("base")){
								paraMatch.reset(result);
								paraMatch.find();
								temp[1] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
							}
							else if(result.startsWith("prc")){
								paraMatch.reset(result);
								paraMatch.find();
								temp[2] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
							}
							else
								throw new Exception("Unknown language parameter encountered\n" + check);
						}
						languages.add(temp);
					}
					if(mode == Modes.SIGNATURE){
						String[] temp = check.trim().split("=");
						if(temp[0].equals("epicspell")){
							epicspellSignatures = temp[1].replace("\"", "").split("\\|");
						}
						else if(temp[0].equals("psionicpower")){
							psionicpowerSignatures = temp[1].replace("\"", "").split("\\|");
						}
						else
							throw new Exception("Unknown signature parameter encountered:\n" + check);
					}
				}
			}catch(Exception e){
				System.err.println("Failed to read settings file. Exception:\n" + e + "\nAborting");
				System.exit(1);
			}
		}
	}
	
	/**
	 * A boolean determining whether to print progress information
	 * and use the decorative spinner.
	 */
	public static boolean verbose = true;
	public static Spinner spinner = new Spinner();
	
	/**
	 * The container object for general configuration data
	 * read from file
	 */
	public static Settings settings = new Settings();
	
	private static String fileSeparator = System.getProperty("file.separator");
	
	private static String curLanguage = null;
	private static String mainPath = null,
	                      contentPath = null,
	                      menuPath = null;
	
	private static TwoDAStore twoDA;
	private static TLKStore tlk;
	
	/** The template files */
	private static final String classTemplate    = readTemplate("templates" + fileSeparator + "class.html"),
	                            domainTemplate   = readTemplate("templates" + fileSeparator + "domain.html"),
	                            featTemplate     = readTemplate("templates" + fileSeparator + "feat.html"),
	                            menuTemplate     = readTemplate("templates" + fileSeparator + "menu.html"),
	                            menuItemTemplate = readTemplate("templates" + fileSeparator + "menuitem.html"),
	                            spellTemplate    = readTemplate("templates" + fileSeparator + "spell.html"),
	                            skillTemplate    = readTemplate("templates" + fileSeparator + "skill.html");
	
	private static final Object presenceIndicator = new Object();
	private static final HashMap<Integer, Object> failedSkills = new HashMap<Integer, Object>(),
	                                              failedSpells = new HashMap<Integer, Object>();
	public static void main(String[] args){
		/* Argument parsing */
		for(String opt : args){
			if(opt.equals("--help"))
				readMe();
			
			if(opt.startsWith("-")){
				if(opt.contains("q"))
					verbose = false;
				if(opt.contains("?"))
					readMe();
			}
		}
		
		// Initialize the 2da container data structure
		twoDA = new TwoDAStore();
		
		
		// Print the manual files for each language specified
		for(int i = 0; i < settings.languages.size(); i++){
			// Set language, path and load TLKs
			curLanguage = settings.languages.get(i)[0];
			mainPath = "manual" + fileSeparator + curLanguage + fileSeparator;
			contentPath = mainPath + "content" + fileSeparator;
			menuPath = mainPath + "menus" + fileSeparator;
			tlk = new TLKStore(settings.languages.get(i)[1], settings.languages.get(i)[2]);
			
			buildDirectories();
			
			
			createPages();
			//createMenus();
		}
	}
	
	/**
	 * Prints the use instructions for this program and kills execution.
	 */
	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "  java prc/autodoc/Main [--help][-q?]\n"+
		                   "\n"+
		                   "-q     quiet mode. Does not print any progress info, only failure messages\n"+
		                   "\n"+
		                   "--help prints this info you are reading\n"+
		                   "-?     see --help\n"
		                  );
		System.exit(0);
	}
	
	/**
	 * Reads the template file given as parameter and returns a string with it's contents
	 * Kills execution if any operations fail.
	 *
	 * @param filePath string representing the path of the template file
	 *
	 * @return the contents of the template file as a string
	 */
	private static String readTemplate(String filePath){
		try{
			Scanner reader = new Scanner(new File(filePath));
			StringBuffer temp = new StringBuffer();
			
			while(reader.hasNextLine()) temp.append(reader.nextLine());
			
			return temp.toString();
		}catch(Exception e){
			System.err.println("Failed to read template file. Exception:\n" + e + "\nAborting");
			System.exit(1);
		}
		
		throw new AssertionError("This message should not be seen");
	}
	
	/**
	 * Creates the directory structure for the current language
	 * being processed.
	 * Kills execution if any creation operations fail.
	 */
	private static void buildDirectories(){
		String dirPath = mainPath + "content";
		
		buildDir(dirPath);
		dirPath += fileSeparator;
		
		buildDir(dirPath + "base_classes");
		buildDir(dirPath + "class_epic_feat");
		buildDir(dirPath + "class_feat");
		buildDir(dirPath + "domains");
		buildDir(dirPath + "epic_feat");
		buildDir(dirPath + "epic_spells");
		buildDir(dirPath + "feat");
		buildDir(dirPath + "master_feat");
		buildDir(dirPath + "prestige_classes");
		buildDir(dirPath + "psionic_powers");
		buildDir(dirPath + "races");
		buildDir(dirPath + "skills");
		buildDir(dirPath + "spells");
		
		buildDir(mainPath + "menus");
	}
	
	/**
	 * Does the actual work of building the directories
	 *
	 * @param path the target directory to create
	 */
	private static void buildDir(String path){
		File builder = new File(path);
		if(!builder.exists()){
			if(!builder.mkdirs()){
				System.err.println("Failure creating directory:\n" + builder.getPath());
				System.exit(1);
			}
		}
	}
	
	
	private static void createPages(){
		/* First, do the pages that do not require linking to other pages */
		doSkills();
		// Do spells
		doSpells();
		// Do epicspells
		// Do psionicpowers
		
		// Do masterfeats
		// Do feats
		// Link feats
		
		// Do domains
		
		// Do classes
	}
	
	/**
	 *Replaces each line break in the given TLK entry with
	 *a line break followed by <code>&lt;br /&gt;</code>.
	 *
	 * @param toHTML tlk entry to convert
	 * @return the modified string
	 */
	private static String htmlizeTLK(String toHTML){
		return toHTML.replaceAll("\n", "\n<br />");
	}
	
	/**
	 * Creates a new file at the given <code>path</code>, erasing previous file if present.
	 * Prints the given <code>content</code> string into the file.
	 *
	 * @param path    the path of the file to be created
	 * @param content the string to be printed into the file
	 *
	 * @throws IOException if one of the file operations fails
	 */
	private static void printPage(String path, String content) throws IOException{
		File target = new File(path);
		// Clean up old version if necessary
		if(target.exists()){
			if(verbose) System.out.println("Deleting previous version of " + path);
			target.delete();
		}
		target.createNewFile();
		
		// Creater the writer and print
		FileWriter writer = new FileWriter(target, false);
		writer.write(content);
		// Clean up
		writer.flush();
		writer.close();
	}
	
	/**
	 * Handles creation of the skill pages.
	 */
	private static void doSkills(){
		String skillPath = contentPath + "skills" + fileSeparator;
		String name     = null,
		       entry    = null;
			
		Data_2da skills = twoDA.get("skills");
		
		for(int i = 0; i < skills.getEntryCount(); i++){
			try{
				name = tlk.get(skills.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				
				// Build the entry data
				entry = skillTemplate;
				entry = entry.replaceAll("~~~SkillName~~~",
				                         name);
				entry = entry.replaceAll("~~~SkillTLKDescription~~~",
				                         htmlizeTLK(tlk.get(skills.getEntry("Description", i))));
				//name = tlk.get(skills2da.getEntry("Name", i));
				//entry = htmlizeTLK(tlk.get(skills2da.getEntry("Description", i)));
				printPage(skillPath + i + ".html", entry);
			}catch(Exception e){
				System.err.println("Failed to print page for skill " + i + ": " + name + "\nException:\n" + e);
				// Note the failure, so this page isn't used elsewhere in the manual
				failedSkills.put(i, presenceIndicator);
			}
		}
		
	}
	
	/**
	 * A small enumeration for use in spell printing methods
 	 */
	enum SpellType{NONE, NORMAL, EPIC, PSIONIC};
	
	/**
	 * Prints normal & epic spells and psionic powers.
	 * As of now, all of these are similar enough to share the same
	 * template, so they can be done here together.
	 *
	 * The enumeration class used here is found at the end of the file
	 */
	private static void doSpells(){
		String spellPath = contentPath + "spells" + fileSeparator,
		       epicPath  = contentPath + "epic_spells" + fileSeparator,
		       psiPath   = contentPath + "psionic_powers" + fileSeparator;
		
		String pathToUse = null,
		       name      = null,
		       entry     = null;
		
		SpellType spelltype = NONE;
		
		Data_2da spells = twoDA.get("spells");
		
		for(int i = 0; i < spells.getEntryCount(); i++){
			spelltype = NONE;
			try{
				if(isNormalSpell(spells, i))       spelltype = NORMAL;
				else if(isEpicSpell(spells, i))    spelltype = EPIC;
				else if(isPsionicPower(spells, i)) spelltype = PSIONIC;
				
				if(spelltype != NONE){
					name = tlk.get(spells.getEntry("Name", i));
					if(verbose) System.out.println("Printing page for " + name);
					
					// Build the entry data
					entry = spellTemplate;
					entry = entry.replaceAll("~~~SpellName~~~",
					                         name);
					entry = entry.replaceAll("~~~SpelllTLKDescription~~~",
					                         htmlizeTLK(tlk.get(spells.getEntry("SpellDesc", i))));
					
					// Build the path and print
					switch(spelltype){
						case NORMAL:
							pathToUse = spellPath + i + ".html";
							break;
						case EPIC:
							pathToUse = epicPath + i + ".html";
							break;
						case PSIONIC:
							pathToUse = psiPath + i + ".html";
							break;
						
						default:
							throw new AssertionError("This message should not be seen");
					}
					
					printPage(pathToUse, entry);
				}
			}catch(Exception e){
				System.err.println("Failed to print page for spell " + i + ": " + name + "\nException:\n" + e);
				// Note the failure, so this page isn't used elsewhere in the manual
				failedSpells.put(i, presenceIndicator);
			}
		}
		
	}
	
	/**
	 * A small convenience method for wrapping all the normal spell checks into
	 * one.
	 *
	 * @param spells   the Data_2da entry containing spells.2da
	 * @param entryNum the line number to use for testing
	 *
	 * @return <code>true</code> if any of the class spell level columns contain a number,
	 *           <code>false</code> otherwise
	 */
	private static boolean isNormalSpell(Data_2da spells, int entryNum){
		if(!spells.getEntry("Bard", entryNum).equals("****"))     return true;
		if(!spells.getEntry("Cleric", entryNum).equals("****"))   return true;
		if(!spells.getEntry("Druid", entryNum).equals("****"))    return true;
		if(!spells.getEntry("Paladin", entryNum).equals("****"))  return true;
		if(!spells.getEntry("Ranger", entryNum).equals("****"))   return true;
		if(!spells.getEntry("Wiz_Sorc", entryNum).equals("****")) return true;
		
		return false;
	}
	
	
	/**
	 * A small convenience method for testing if the given entry contains a
	 * epic spell.
	 *
	 * @param spells   the Data_2da entry containing spells.2da
	 * @param entryNum the line number to use for testing
	 *
	 * @return <code>true</code> if the impactscript name starts with strings specified in settings,
	 *           <code>false</code> otherwise
	 */
	private static boolean isEpicSpell(Data_2da spells, int entryNum){
		for(String check : settings.epicspellSignatures)
			if(spells.getEntry("ImpactScript", entryNum).startsWith(check)) return true;
		return false;
	}
	
	/**
	 * A small convenience method for testing if the given entry contains a
	 * psionic power
	 *
	 * @param spells   the Data_2da entry containing spells.2da
	 * @param entryNum the line number to use for testing
	 *
	 * @return <code>true</code> if the impactscript name starts with strings specified in settings,
	 *           <code>false</code> otherwise
	 */
	private static boolean isPsionicPower(Data_2da spells, int entryNum){
		for(String check : settings.psionicpowerSignatures)
			if(spells.getEntry("ImpactScript", entryNum).startsWith(check)) return true;
		return false;
	}
}
