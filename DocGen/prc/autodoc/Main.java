package prc.autodoc;

import java.io.*;
import java.util.*;
import java.util.regex.*;

import static prc.autodoc.Main.SpellType.*;

/**
 * The main purpose of this autodocumenter is to create parts of the manual for
 * the PRC pack from 2da and TLK files. As a side effect of doing so, it finds
 * many errors present in the 2das.
 */
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
			try{
				return get(Integer.parseInt(num));
			}catch(NumberFormatException e){ return Main.badStrRef; }
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
				System.exit(1);
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
					//err_pr.println(e.toString());
					throw new TwoDAReadException("Problem with filename when trying to read from 2da:\n" + e);
				}/* Seems it's better to let this cascade
				catch(TwoDAReadException e){
					// Just store a null and toss the exception onwards
					data.put(name, null);
					throw e;
				}*/
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
				err_pr.println("Failed to read settings file:\n" + e + "\nAborting");
				System.exit(1);
			}
		}
	}
	
	/** A convenience object for printing both to log and System.err */
	public static ErrorPrinter err_pr = new ErrorPrinter();
	
	/** A switche determinining how errors are handled */
	public static boolean tolErr = true;
	
	/**
	 * A boolean determining whether to print progress information
	 * and use the decorative spinner.
	 */
	public static boolean verbose = true;
	public static Spinner spinner = new Spinner();
	
	/** A constant signifying Bad StrRef */
	public static final String badStrRef = "Bad StrRef";
	
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
	private static String babAndSavthrTableHeaderTemplate = null,
	                      classFeatTableHeaderTemplate    = null,
	                      classTemplate                   = null,
	                      classTablesEntryTemplate        = null,
	                      domainTemplate                  = null,
	                      featTemplate                    = null,
	                      mFeatTemplate                   = null,
	                      menuTemplate                    = null,
	                      menuItemTemplate                = null,
	                      prereqANDFeatHeaderTemplate     = null,
	                      prereqORFeatHeaderTemplate      = null,
	                      raceTemplate                    = null,
	                      spellTemplate                   = null,
	                      skillTableHeaderTemplate        = null,
	                      skillTemplate                   = null,
	                      successorFeatHeaderTemplate     = null;
	
	
	/* Data structure used for determining if a previous write has failed
	 * Required in order to be able to skip generating dead links in the
	 * manual.
	 *
	 * A freaking pile of these, so they take up space, but simplify the code.
	 */
	private static HashMap<Integer, SpellEntry> spells;
	private static HashMap<Integer, FeatEntry> masterFeats,
	                                           feats;
	private static HashMap<Integer, GenericEntry> skills,
	                                              domains,
	                                              races,
	                                              classes;
	
	
	public static void main(String[] args){
		/* Argument parsing */
		for(String opt : args){
			if(opt.equals("--help"))
				readMe();
			
			if(opt.startsWith("-")){
				if(opt.contains("a"))
					tolErr = true;
				if(opt.contains("q"))
					verbose = false;
				if(opt.contains("s"))
					spinner.disable();
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
			mainPath    = "manual" + fileSeparator + curLanguage + fileSeparator;
			contentPath = mainPath + "content" + fileSeparator;
			menuPath    = mainPath + "menus" + fileSeparator;
			
			// If we fail on a language, skip to next one
			try{
				tlk = new TLKStore(settings.languages.get(i)[1], settings.languages.get(i)[2]);
			}catch(TLKReadException e){
				err_pr.println("Failure while reading TLKs for language: " + curLanguage +":\n" + e);
				continue;
			}
			
			// Skip to next if there is any problem with directories or templates
			if(!(readTemplates() && buildDirectories())) continue;
			
			createPages();
			createMenus();
		}
	}
	
	/**
	 * Prints the use instructions for this program and kills execution.
	 */
	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "  java prc/autodoc/Main [--help][-aqs?]\n"+
		                   "\n"+
		                   "-a     forces aborting printing on errors\n"+
		                   "-q     quiet mode. Does not print any progress info, only failure messages\n"+
		                   "-s     disable the spinner. Useful when logging to file\n"+
		                   "\n"+
		                   "--help prints this info you are reading\n"+
		                   "-?     see --help\n"
		                  );
		System.exit(0);
	}
	
	/**
	 * Reads all the template files for the current language.
	 */
	private static boolean readTemplates(){
		String templatePath = "templates" + fileSeparator + curLanguage + fileSeparator;
		
		try{
			babAndSavthrTableHeaderTemplate = readTemplate(templatePath + "babNsavthrtableheader.html");
			classFeatTableHeaderTemplate    = readTemplate(templatePath + "classfeattableheader.html");
			classTablesEntryTemplate        = readTemplate(templatePath + "classtablesentry.html");
			classTemplate                   = readTemplate(templatePath + "class.html");
			domainTemplate                  = readTemplate(templatePath + "domain.html");
			featTemplate                    = readTemplate(templatePath + "feat.html");
			mFeatTemplate                   = readTemplate(templatePath + "masterfeat.html");
			menuTemplate                    = readTemplate(templatePath + "menu.html");
			menuItemTemplate                = readTemplate(templatePath + "menuitem.html");
			prereqANDFeatHeaderTemplate     = readTemplate(templatePath + "prerequisiteandfeatheader.html");
			prereqORFeatHeaderTemplate      = readTemplate(templatePath + "prerequisiteorfeatheader.html");
			raceTemplate                    = readTemplate(templatePath + "race.html");
			spellTemplate                   = readTemplate(templatePath + "spell.html");
			skillTableHeaderTemplate        = readTemplate(templatePath + "skilltableheader.html");
			skillTemplate                   = readTemplate(templatePath + "skill.html");
			successorFeatHeaderTemplate     = readTemplate(templatePath + "successorfeatheader.html");
		}catch(IOException e){
			return false;
		}
		return true;
	}
	
	/**
	 * Reads the template file given as parameter and returns a string with it's contents
	 * Kills execution if any operations fail.
	 *
	 * @param filePath string representing the path of the template file
	 *
	 * @return the contents of the template file as a string
	 *
	 * @throws IOException if the reading fails
	 */
	private static String readTemplate(String filePath) throws IOException{
		try{
			Scanner reader = new Scanner(new File(filePath));
			StringBuffer temp = new StringBuffer();
			
			while(reader.hasNextLine()) temp.append(reader.nextLine() + "\n");
			
			return temp.toString();
		}catch(Exception e){
			err_pr.println("Failed to read template file:\n" + e);
			throw new IOException();
		}
	}
	
	/**
	 * Creates the directory structure for the current language
	 * being processed.
	 *
	 * @return <code>true</code> if all directories are successfully created,
	 *           <code>false</code> otherwise
	 */
	private static boolean buildDirectories(){
		String dirPath = mainPath + "content";
		
		boolean toReturn = buildDir(dirPath);
		dirPath += fileSeparator;
		
		toReturn = toReturn
		           && buildDir(dirPath + "base_classes")
		           && buildDir(dirPath + "class_epic_feats")
		           && buildDir(dirPath + "class_feats")
		           && buildDir(dirPath + "domains")
		           && buildDir(dirPath + "epic_feats")
		           && buildDir(dirPath + "epic_spells")
		           && buildDir(dirPath + "feats")
		           && buildDir(dirPath + "master_feats")
		           && buildDir(dirPath + "prestige_classes")
		           && buildDir(dirPath + "psionic_powers")
		           && buildDir(dirPath + "races")
		           && buildDir(dirPath + "skills")
		           && buildDir(dirPath + "spells")
		
		           && buildDir(mainPath + "menus");
		
		System.gc();
		
		return toReturn;
	}
	
	/**
	 * Does the actual work of building the directories
	 *
	 * @param path the target directory to create
	 *
	 * @return <code>true</code> if the directory was already present or was successfully created,
	 *           <code>false</code> otherwise
	 */
	private static boolean buildDir(String path){
		File builder = new File(path);
		if(!builder.exists()){
			if(!builder.mkdirs()){
				err_pr.println("Failure creating directory:\n" + builder.getPath());
				return false;
		}}
		else{
			if(builder.isDirectory()){
				err_pr.println(builder.getPath() + " already exists as a file!");
				return false;
		}}
		return true;
	}
	
	
	private static void createPages(){
		/* First, do the pages that do not require linking to other pages */
		doSkills();
		doSpells();
		
		/* Then, build the feats */
		preliMasterFeats();
		preliFeats();
		linkFeats();
		printFeats();
		
		/* Last, domains, races and classes, which all link to the previous */
		doDomains();
		doRaces();
		doClasses();
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
	 * @throws PageGenerationException if one of the file operations fails
	 */
	private static void printPage(String path, String content){
		try{
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
		}catch(IOException e){
			throw new PageGenerationException("IOException when printing " + path, e);
		}
	}
	
	/**
	 * Handles creation of the skill pages.
	 */
	private static void doSkills(){
		String skillPath = contentPath + "skills" + fileSeparator;
		String name      = null,
		       text      = null,
		       path      = null;
		boolean errored;
		
		skills = new HashMap<Integer, GenericEntry>();
		Data_2da skills2da = twoDA.get("skills");
		
		for(int i = 0; i < skills2da.getEntryCount(); i++){
			errored = false;
			try{
				// Get the name of the skill and check if it's valid
				name = tlk.get(skills2da.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for skill " + i);
					errored = true;
				}
				
				// Start building the entry data. First, place in the name
				text = skillTemplate;
				text = text.replaceAll("~~~SkillName~~~",
				                         name);
				// Then, put in the description
				text = text.replaceAll("~~~SkillTLKDescription~~~",
				                       htmlizeTLK(tlk.get(skills2da.getEntry("Description", i))));
				// Again, check if we had a valid description
				if(tlk.get(skills2da.getEntry("Description", i)).equals(badStrRef)){
					err_pr.println("Invalid description for skill " + i + ": " + name);
					errored = true;
				}
				
				// Build the final path
				path = skillPath + i + ".html";
				
				// Check if we had any errors. If we did, and the error tolerance flag isn't up, skip printing this page
				if(!errored || tolErr){
					printPage(path, text);
					// Store a data structure represeting the skill into a hashmap
					skills.put(i, new GenericEntry(name, path, i));
				}else
					throw new PageGenerationException("Error(s) encountered while creating page");
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for skill " + i + ": " + name + ":\n" + e);
			}
		}
		// Force a clean-up of dead objects. This will keep discarded objects from slowing down the program as it
		// hits the memory limit
		System.gc();
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
		
		String path = null,
		       name = null,
		       text = null;
		boolean errored;
		
		SpellType spelltype = NONE;
		
		spells = new HashMap<Integer, SpellEntry>();
		Data_2da spells2da = twoDA.get("spells");
		
		for(int i = 0; i < spells2da.getEntryCount(); i++){
			spelltype = NONE;
			errored = false;
			try{
				if(isNormalSpell(spells2da, i))       spelltype = NORMAL;
				else if(isEpicSpell(spells2da, i))    spelltype = EPIC;
				else if(isPsionicPower(spells2da, i)) spelltype = PSIONIC;
				
				if(spelltype != NONE){
					name = tlk.get(spells2da.getEntry("Name", i));
					if(verbose) System.out.println("Printing page for " + name);
					// Check the name for validity
					if(name.equals(badStrRef)){
						err_pr.println("Invalid name entry for spell " + i);
						errored = true;
					}
					
					// Start building the entry data. First, place in the name
					text = spellTemplate;
					text = text.replaceAll("~~~SpellName~~~",
					                         name);
					// Then, put in the description
					text = text.replaceAll("~~~SpellTLKDescription~~~",
					                       htmlizeTLK(tlk.get(spells2da.getEntry("SpellDesc", i))));
					// Check the description validity
					if(tlk.get(spells2da.getEntry("SpellDesc", i)).equals(badStrRef)){
						err_pr.println("Invalid description for spell " + i + ": " + name);
						errored = true;
					}
					
					// Build the path
					switch(spelltype){
						case NORMAL:
							path = spellPath + i + ".html";
							break;
						case EPIC:
							path = epicPath + i + ".html";
							break;
						case PSIONIC:
							path = psiPath + i + ".html";
							break;
						
						default:
							throw new AssertionError("This message should not be seen");
					}
					
					// Check if we had any errors. If we did, and the error tolerance flag isn't up, skip printing this page
					if(!errored || tolErr){
						// Print the page
						printPage(path, text);
						// Store a data structure represeting the entry into a hashmap
						spells.put(i, new SpellEntry(name, text, path, i, spelltype));
					}else
						throw new PageGenerationException("Error(s) encountered while creating page");
				}
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for spell " + i + ": " + name + ":\n" + e);
			}
		}
		// Force a clean-up of dead objects. This will keep discarded objects from slowing down the program as it
		// hits the memory limit
		System.gc();
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
	private static boolean isNormalSpell(Data_2da spells2da, int entryNum){
		if(!spells2da.getEntry("Bard", entryNum).equals("****"))     return true;
		if(!spells2da.getEntry("Cleric", entryNum).equals("****"))   return true;
		if(!spells2da.getEntry("Druid", entryNum).equals("****"))    return true;
		if(!spells2da.getEntry("Paladin", entryNum).equals("****"))  return true;
		if(!spells2da.getEntry("Ranger", entryNum).equals("****"))   return true;
		if(!spells2da.getEntry("Wiz_Sorc", entryNum).equals("****")) return true;
		
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
	private static boolean isEpicSpell(Data_2da spells2da, int entryNum){
		for(String check : settings.epicspellSignatures)
			if(spells2da.getEntry("ImpactScript", entryNum).startsWith(check)) return true;
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
	private static boolean isPsionicPower(Data_2da spells2da, int entryNum){
		for(String check : settings.psionicpowerSignatures)
			if(spells2da.getEntry("ImpactScript", entryNum).startsWith(check)) return true;
		return false;
	}
	
	
	/**
	 * Build the preliminary list of master feats, without the child feats
	 * linked in.
	 */
	private static void preliMasterFeats(){
		String mFeatPath = contentPath + "master_feats" + fileSeparator;
		String name     = null,
		       text     = null;
		FeatEntry entry = null;
		boolean errored;
		
		masterFeats = new HashMap<Integer, FeatEntry>();
		Data_2da masterFeats2da = twoDA.get("masterfeats");
		
		for(int i = 0; i < masterFeats2da.getEntryCount(); i++){
			// Skip blank rows
			if(masterFeats2da.getEntry("LABEL", i).equals("****")) continue;
			errored = false;
			
			try{
				name = tlk.get(masterFeats2da.getEntry("STRREF", i));
				if(verbose) System.out.println("Generating preliminary data for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for masterfeat " + i);
					errored = true;
				}
				
				// Build the entry data
				text = mFeatTemplate;
				text = text.replaceAll("~~~FeatName~~~",
				                       name);
				text = text.replaceAll("~~~FeatTLKDescription~~~",
				                       htmlizeTLK(tlk.get(masterFeats2da.getEntry("DESCRIPTION", i))));
				// Check the description validity
				if(tlk.get(masterFeats2da.getEntry("DESCRIPTION", i)).equals(badStrRef)){
					err_pr.println("Invalid description for masterfeat " + i + ": " + name);
					errored = true;
				}
				
				if(!errored || tolErr){
					// Store the entry to wait for further processing
					entry = new FeatEntry(name , text, mFeatPath + i + ".html", i, false, false);
					masterFeats.put(i, entry);
				}else
					throw new PageGenerationException("Error(s) encountered while creating entry data");
			}catch(PageGenerationException e){
				err_pr.println("Failed to generate page data for masterfeat " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}
	
	
	/**
	 * Build the preliminary list of feats, without master / successor / predecessor feats
	 * linked in.
	 */
	private static void preliFeats(){
		String featPath      = contentPath + "feats" + fileSeparator,
		       epicPath      = contentPath + "epic_feats" + fileSeparator,
		       classFeatPath = contentPath + "class_feats" + fileSeparator,
		       classEpicPath = contentPath + "class_epic_feats" + fileSeparator;
		String name     = null,
		       text     = null,
		       path     = null;
		FeatEntry entry = null;
		boolean isEpic      = false,
		        isClassFeat = false;
		boolean errored;
		
		feats = new HashMap<Integer, FeatEntry>();
		Data_2da feats2da = twoDA.get("feat");
		
		for(int i = 0; i < feats2da.getEntryCount(); i++){
			// Skip blank rows
			if(feats2da.getEntry("LABEL", i).equals("****")) continue;
			// Skip the ISC & Epic spell markers
			if(feats2da.getEntry("LABEL", i).equals("ReservedForISCAndESS")) continue;
			errored = false;
			
			try{
				name = tlk.get(feats2da.getEntry("FEAT", i));
				if(verbose) System.out.println("Generating preliminary data for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for feat " + i);
					errored = true;
				}
				
				// Build the entry data
				text = featTemplate;
				text = text.replaceAll("~~~FeatName~~~",
				                       name);
				text = text.replaceAll("~~~FeatTLKDescription~~~",
				                       htmlizeTLK(tlk.get(feats2da.getEntry("DESCRIPTION", i))));
				// Check the description validity
				if(tlk.get(feats2da.getEntry("DESCRIPTION", i)).equals(badStrRef)){
					err_pr.println("Invalid description for feat " + i + ": " + name);
					errored = true;
				}
				
				isEpic = feats2da.getEntry("PreReqEpic", i).equals("1");
				isClassFeat = !feats2da.getEntry("ALLCLASSESCANUSE", i).equals("1");
				
				// Get the path
				if(isEpic){
					if(isClassFeat) path = classEpicPath + i + ".html";
					else            path = epicPath + i + ".html";
				}else{
					if(isClassFeat) path = classFeatPath + i + ".html";
					else            path = featPath + i + ".html";
				}
				
				if(!errored || tolErr){
					// Create the entry data structure
					entry = new FeatEntry(name , text, path, i, isEpic, isClassFeat);
					// Store the entry to wait for further processing
					feats.put(i, entry);
				}else
					throw new PageGenerationException("Error(s) encountered while creating entry data");
			}catch(PageGenerationException e){
				err_pr.println("Failed to generate page data for feat " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}
	
	
	/**
	 * Builds the master - child, predecessor - successor and prerequisite links
	 * and modifies the entry texts accordingly.
	 */
	private static void linkFeats(){
		FeatEntry other = null;
		String temp = null;
		Data_2da feats2da = twoDA.get("feat");
		
		//path.replace(contentPath, "../");
		
		// Link normal feats to each other and to masterfeats
		for(FeatEntry check : feats.values()){
			if(verbose) System.out.println("Linking feat " + check.name);
			// Link to master
			if(!feats2da.getEntry("MASTERFEAT", check.entryNum).equals("****")){
				try{
					other = masterFeats.get(Integer.parseInt(feats2da.getEntry("MASTERFEAT", check.entryNum)));
					//check.master = other;
					other.childFeats.add(check);
				}catch(NumberFormatException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains an invalid masterfeat link");
				}catch(NullPointerException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains a link to nonexistent masterfeat");
			}}
			
			// Print prerequisites into the entry
			temp = buildPrerequisites(check, feats2da);
			check.text = check.text.replaceAll("~~~PrerequisiteFeatList~~~", temp);
			
			// Print the successor, if any, into the entry
			temp = "";
			if(!feats2da.getEntry("SUCCESSOR", check.entryNum).equals("****")){
				try{
					other = feats.get(Integer.parseInt(feats2da.getEntry("SUCCESSOR", check.entryNum)));
					temp += ("<div>\n" + successorFeatHeaderTemplate + "<br /><a href=\"" + other.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + other.name + "</a>\n</div>\n");
				}catch(NumberFormatException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains an invalid successor link");
				}catch(NullPointerException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.name + " contains a link to nonexistent successor");
			}}
			check.text = check.text.replaceAll("~~~SuccessorFeat~~~", temp);
		}
		
		// Add the child links to masterfeat texts
		for(FeatEntry check : masterFeats.values()){
			if(verbose) System.out.println("Linking masterfeat " + check.name);
			temp = "";
			boolean doOnce = false;
			for(FeatEntry child : check.childFeats){
				if(!doOnce){ temp += "<div>\n"; doOnce = true; }
				temp += "<br /><a href=\"" + child.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + child.name + "</a>\n";
			}
			if(doOnce) temp += "</div>\n";
			
			check.text = check.text.replaceAll("~~~MasterFeatChildList~~~", temp);
		}
		System.gc();
	}
	
	/**
	 * Constructs a text containing links to the prerequisite feats of the
	 * given feat. Separated from the linkFeats method for improved
	 * readability.
	 *
	 * @param check    the feat entry to be examined
	 * @param feats2da the data structure representing feat.2da
	 *
	 * @return string containing html links to such prerequisite feats that
	 *                  have FeatEntry data structures build for them
	 */
	private static String buildPrerequisites(FeatEntry check, Data_2da feats2da){
		FeatEntry andReq1 = null, andReq2 = null, orReq = null;
		String andReq1Num = feats2da.getEntry("PREREQFEAT1", check.entryNum),
		       andReq2Num = feats2da.getEntry("PREREQFEAT2", check.entryNum);
		String[] orReqs = {feats2da.getEntry("OrReqFeat0", check.entryNum),
		                   feats2da.getEntry("OrReqFeat1", check.entryNum),
		                   feats2da.getEntry("OrReqFeat2", check.entryNum),
		                   feats2da.getEntry("OrReqFeat3", check.entryNum),
		                   feats2da.getEntry("OrReqFeat4", check.entryNum)};
		String preReqText = "";
		
		/* Handle AND prerequisite feats */
		// Some paranoia about bad entries
		if(!andReq1Num.equals("****")){
			try{ andReq1 = feats.get(Integer.parseInt(andReq1Num)); }
			catch(NumberFormatException e){
				err_pr.println("Invalid PREREQFEAT1 link in feat " + check.entryNum);
		}}
		if(!andReq2Num.equals("****")){
			try{ andReq2 = feats.get(Integer.parseInt(andReq2Num)); }
			catch(NumberFormatException e){
				err_pr.println("Invalid PREREQFEAT2 link in feat " + check.entryNum);
		}}
		// Check if we had at least one valid entry
		if(andReq1 != null || andReq2 != null){
			preReqText = "<div>\n" + prereqANDFeatHeaderTemplate + "\n"; 
			if(andReq1 != null)
				preReqText += "<br /><a href=\"" + andReq1.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + andReq1.name + "</a>\n";
			if(andReq2 != null)
				preReqText += "<br /><a href=\"" + andReq2.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + andReq2.name + "</a>\n";
			preReqText += "</div>\n";
		}

		
		/* Handle OR prerequisite feats */
		// First, check if there are any
		boolean printOrReqs = false;
		for(String orReqCheck : orReqs)
			if(!orReqCheck.equals("****")) printOrReqs = true;
		
		if(printOrReqs){
			boolean headerDone = false;
			// Loop through each req and see if it's a valid link
			for(int i = 0; i < orReqs.length; i++){
				if(!orReqs[i].equals("****")){
					try{ orReq = feats.get(Integer.parseInt(orReqs[i])); }
					catch(NumberFormatException e){
						err_pr.println("Invalid OrReqFeat" + i + " link in feat " + check.entryNum);
					}
					if(orReq != null){
						if(!headerDone){
							preReqText = "<div>\n" + prereqORFeatHeaderTemplate + "\n";
							headerDone = true;
						}
						preReqText += "<br /><a href=\"" + orReq.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + orReq.name + "</a>\n";
					}
				}
			}
			// End the <div> if we printed anything
			if(headerDone) preReqText += "</div>\n";
		}
		
		return preReqText;
	}
	
	
	/**
	 * A simple method for printing out all the feat pages
	 */
	public static void printFeats(){
		for(FeatEntry toPrint : feats.values()){
			if(verbose) System.out.println("Printing page for " + toPrint.name);
			try{
				printPage(toPrint.filePath, toPrint.text);
			}catch(PageGenerationException e){
				err_pr.println("Exception when writing page for feat " + toPrint.entryNum + ": " + toPrint.name + ":\n" + e);
		}}
		System.gc();
		for(FeatEntry toPrint : masterFeats.values()){
			if(verbose) System.out.println("Printing page for " + toPrint.name);
			try{
				printPage(toPrint.filePath, toPrint.text);
			}catch(PageGenerationException e){
				err_pr.println("Exception when writing page for masterfeat " + toPrint.entryNum + ": " + toPrint.name + ":\n" + e);
		}}
		System.gc();
	}
	
	
	/**
	 * Handles creation of the domain pages.
	 * Kills page generation on bad strref for name.
	 * Other errors are logged and prevent page write
	 */
	public static void doDomains(){
		String domainPath = contentPath + "domains" + fileSeparator;
		String name      = null,
		       text      = null,
		       path      = null,
		       spellList = null;
		FeatEntry grantedFeat   = null;
		SpellEntry grantedSpell = null;
		boolean errored;
		
		domains = new HashMap<Integer, GenericEntry>();
		Data_2da domains2da = twoDA.get("domains");
		
		for(int i = 0; i < domains2da.getEntryCount(); i++){
			// Skip blank rows
			if(domains2da.getEntry("LABEL", i).equals("****")) continue;
			errored = false;
			try{
				name = tlk.get(domains2da.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for domain " + i);
					errored = true;
				}
				
				// Build the entry data
				text = domainTemplate;
				text = text.replaceAll("~~~DomainName~~~",
				                         name);
				text = text.replaceAll("~~~DomainTLKDescription~~~",
				                        htmlizeTLK(tlk.get(domains2da.getEntry("Description", i))));
				// Check the description validity
				if(tlk.get(domains2da.getEntry("Description", i)).equals(badStrRef)){
					err_pr.println("Invalid description for domain " + i + ": " + name);
					errored = true;
				}
				
				// Add a link to the granted feat
				try{
					grantedFeat = feats.get(Integer.parseInt(domains2da.getEntry("GrantedFeat", i)));
					text = text.replaceAll("~~~DomainFeat~~~",
					                       "<a href=\"" + grantedFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + grantedFeat.name + "</a>");
				}catch(NumberFormatException e){
					err_pr.println("Invalid entry in GrantedFeat of domain " + i + ": " + name);
					errored = true;
				}catch(NullPointerException e){
					err_pr.println("GrantedFeat entry for domain " + i + ": " + name + " points to non-existent feat: " + domains2da.getEntry("GrantedFeat", i));
					errored = true;
				}
				
				// Add links to the granted spells
				spellList = "";
				for(int j = 1; j <= 9; j++){
					// Skip blanks
					if(domains2da.getEntry("Level_" + j, i).equals("****")) continue;
					try{
						grantedSpell = spells.get(Integer.parseInt(domains2da.getEntry("Level_" + j, i)));
						spellList += ("<br /><a href=\"" + grantedSpell.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + grantedSpell.name + "</a>\n");
					}catch(NumberFormatException e){
						err_pr.println("Invalid entry in Level_" + j + " of domain " + i + ": " + name);
						errored = true;
					}catch(NullPointerException e){
						err_pr.println("Level_" + j + " entry for domain " + i + ": " + name + " points to non-existent spell: " + domains2da.getEntry("Level_" + j, i));
						errored = true;
					}
				}
				text = text.replaceAll("~~~DomainSpellList~~~", spellList);
				
				// Build path and print
				path = domainPath + i + ".html";
				if(!errored || tolErr){
					printPage(path, text);
					domains.put(i, new GenericEntry(name, path, i));
				}else
					throw new PageGenerationException("Error(s) encountered while creating page");
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for domain " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}
	
	
	/**
	 * Handles creation of the race pages.
	 */
	private static void doRaces(){
		String racePath = contentPath + "races" + fileSeparator;
		String name     = null,
		       text     = null,
		       path     = null,
		       featList = null;
		FeatEntry grantedFeat = null;
		Data_2da featTable    = null;
		boolean errored;
		
		races = new HashMap<Integer, GenericEntry>();
		Data_2da racialtypes2da = twoDA.get("racialtypes");
		
		for(int i = 0; i < racialtypes2da.getEntryCount(); i++){
			// Skip non-player races
			if(!racialtypes2da.getEntry("PlayerRace", i).equals("1")) continue;
			errored = false;
			try{
				name = tlk.get(racialtypes2da.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for race " + i);
					errored = true;
				}
				
				// Build the entry data
				text = raceTemplate;
				text = text.replaceAll("~~~RaceName~~~",
				                       name);
				text = text.replaceAll("~~~RaceTLKDescription~~~",
				                        htmlizeTLK(tlk.get(racialtypes2da.getEntry("Description", i))));
				// Check the description validity
				if(tlk.get(racialtypes2da.getEntry("Description", i)).equals(badStrRef)){
					err_pr.println("Invalid description for race " + i + ": " + name);
					errored = true;
				}
				
				
				// Add links to the racial feats
				featTable = twoDA.get(racialtypes2da.getEntry("FeatsTable", i));
				if(featTable == null){
					err_pr.println("Missing feat table for race " + i + ": " + name);
					errored = true;
				}
				
				featList = "";
				for(int j = 0; j < featTable.getEntryCount(); j++){
					try{
						grantedFeat = feats.get(Integer.parseInt(featTable.getEntry("FeatIndex", j)));
						featList += ("<br /><a href=\"" + grantedFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + grantedFeat.name + "</a>\n");
					}catch(NumberFormatException e){
						err_pr.println("Invalid entry in FeatIndex line " + j + " of " + featTable.getName());
						errored = true;
					}catch(NullPointerException e){
						err_pr.println("FeatIndex line " + j + " of " + featTable.getName() + " points to non-existent feat: " + featTable.getEntry("FeatIndex", j));
						errored = true;
					}
				}
				text = text.replaceAll("~~~RaceFeats~~~", featList);
				
				// Build path and print
				path = racePath + i + ".html";
				if(!errored || tolErr){
					printPage(path, text);
					races.put(i, new GenericEntry(name, path, i));
				}else
					throw new PageGenerationException("Error(s) encountered while creating page");
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for race " + i + ": " + name + ":\n" + e);
			}
		}
		System.gc();
	}
	
	
	/**
	 * Handles creation of the class pages.
	 * Subsections handled by several following methods.
	 */
	private static void doClasses(){
		String baseClassPath     = contentPath + "base_classes" + fileSeparator,
		       prestigeClassPath = contentPath + "prestige_classes" + fileSeparator;
		String name     = null,
		       text     = null,
		       path     = null,
		       featList = null;
		String[] tempArr = null;
		FeatEntry grantedFeat   = null;
		Data_2da featTable      = null,
		         bonusFeatTable = null,
		         
		         skillTable     = null;
		boolean errored;
		
		classes = new HashMap<Integer, GenericEntry>();
		Data_2da classes2da = twoDA.get("classes");
		
		for(int i = 0; i < classes2da.getEntryCount(); i++){
			// Skip non-player classes
			if(!classes2da.getEntry("PlayerClass", i).equals("1")) continue;
			errored = false;
			try{
				name = tlk.get(classes2da.getEntry("Name", i));
				if(verbose) System.out.println("Printing page for " + name);
				if(name.equals(badStrRef)){
					err_pr.println("Invalid name entry for class " + i);
					errored = true;
				}
				
				// Build the entry data
				text = classTemplate;
				text = text.replaceAll("~~~ClassName~~~",
				                       name);
				text = text.replaceAll("~~~ClassTLKDescription~~~",
				                        htmlizeTLK(tlk.get(classes2da.getEntry("Description", i))));
				// Check the description validity
				if(tlk.get(classes2da.getEntry("Description", i)).equals(badStrRef)){
					err_pr.println("Invalid description for class " + i + ": " + name);
					errored = true;
				}
				
				// Add in the BAB and saving throws table
				text = text.replaceAll("~~~ClassBABAndSavThrTable~~~", buildBabAndSaveTable(classes2da, i));
				
				// Add in the skills table
				text = text.replaceAll("~~~ClassSkillTable~~~", buildSkillTable(classes2da, i));
				
				// Add in the feat tables
				tempArr = buildClassFeatTables(classes2da, i);
				text = text.replaceAll("~~~ClassBonusFeatTable~~~", tempArr[0]);
				text = text.replaceAll("~~~ClassSelectableFeatTable~~~", tempArr[1]);
				
				/* Check whether this is a base or a prestige class. No prestige
				 * class should give exp penalty (nor should any base class not give it),
				 * so it gan be used as an indicator.
				 */
				if(classes2da.getEntry("XPPenalty", i).equals("1"))
					path = baseClassPath + i + ".html";
				else
					path = prestigeClassPath + i + ".html";
				
				if(!errored || tolErr){
					printPage(path, text);
					classes.put(i, new GenericEntry(name, path, i));
				}else
					throw new PageGenerationException("Error(s) encountered while creating page");
			}catch(PageGenerationException e){
				err_pr.println("Failed to print page for class " + i + ": " + name + ":\n" + e);
			}
		}
	}
	
	
	/**
	 * Constructs the html table of levels and their bab + saving throw bonus values.
	 *
	 * @param classes2da  data structure wrapping classes.2da
	 * @param entryNum    number of the entry to generate table for
	 *
	 * @return  string representation of the table
	 *
	 * @throws PageGenerationException if there is an error while generating the table and error tolerance is off
	 */
	private static String buildBabAndSaveTable(Data_2da classes2da, int entryNum){
		Data_2da babTable  = null,
		         saveTable = null;
		try{
			babTable = twoDA.get(classes2da.getEntry("AttackBonusTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_ATK_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return "";
			}
			else throw new PageGenerationException("Failed to read CLS_ATK_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}
		try{
			saveTable = twoDA.get(classes2da.getEntry("SavingThrowTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_SAVTHR_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return "";
			}
			else throw new PageGenerationException("Failed to read CLS_SAVTHR_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}
		
		String toReturn = "";
		
		/* Determine maximum level to print bab & save values to
		 * The maximum level of the class, or the last non-epic level
		 * whichever is lower
		 */
		int maxToPrint = 0, maxLevel = 0, epicLevel = 0;
		try{ maxLevel = Integer.parseInt(classes2da.getEntry("MaxLevel", entryNum)); }
		catch(NumberFormatException e){
			if(tolErr) err_pr.println("Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
			else throw new PageGenerationException("Invalid MaxLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
		}
		try{ epicLevel = Integer.parseInt(classes2da.getEntry("EpicLevel", entryNum)); }
		catch(NumberFormatException e){
			if(tolErr) err_pr.println("Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
			else throw new PageGenerationException("Invalid EpicLevel entry for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)));
		}
		
		// base classes have special notation for the epic level limit
		if(epicLevel == -1)
			maxToPrint = 20;
		else
			maxToPrint = maxLevel > epicLevel ? epicLevel : maxLevel;
		
		// If the class has any pre-epic levels
		if(maxToPrint > 0){
			toReturn += babAndSavthrTableHeaderTemplate + "\n";
			// Start building the table
			for(int i = 0; i < maxToPrint; i++){
				toReturn += "<tr>\n";
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", (i + 1) + "");
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", babTable.getEntry("BAB", i));
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", saveTable.getEntry("FortSave", i));
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", saveTable.getEntry("RefSave", i));
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", saveTable.getEntry("WillSave", i));
				toReturn += "</tr>\n";
			}
			toReturn += "</table>\n";
		}
		
		return toReturn;
	}
	
	/**
	 * Constructs the html table of the class & cross-class skills of this class.
	 * TreeMaps are used to arrange the printed skills in alphabetic order.
	 *
	 * @param classes2da  data structure wrapping classes.2da
	 * @param entryNum    number of the entry to generate table for
	 *
	 * @return  string representation of the table
	 *
	 * @throws PageGenerationException if there is an error while generating the table and error tolerance is off
	 */
	private static String buildSkillTable(Data_2da classes2da, int entryNum){
		Data_2da skillTable = null;
		try{
			skillTable = twoDA.get(classes2da.getEntry("SkillsTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_SKILL_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return "";
			}
			else throw new PageGenerationException("Failed to read CLS_SKILL_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}
		String toReturn = skillTableHeaderTemplate;
		String temp = null;
		GenericEntry tempSkill = null;
		TreeMap<String, GenericEntry> classSkills      = new TreeMap<String, GenericEntry>(),
		                              crossClassSkills = new TreeMap<String, GenericEntry>();
		
		for(int i = 0; i < skillTable.getEntryCount(); i++){
			temp = skillTable.getEntry("ClassSkill", i);
			// Yet more validity checking :P
			if(!(temp.equals("0") || temp.equals("1"))){
				if(tolErr){
					err_pr.println("Invalid ClassSkill entry in " + skillTable.getName() + " on row " + i);
					continue;
				}else throw new PageGenerationException("Invalid ClassSkill entry in " + skillTable.getName() + " on row " + i);
			}
			
			try{
				tempSkill = skills.get(Integer.parseInt(skillTable.getEntry("SkillIndex", i)));
			}catch(NumberFormatException e){
				if(tolErr){
					err_pr.println("Invalid SkillIndex entry in " + skillTable.getName() + " on row " + i);
					continue;
				}else throw new PageGenerationException("Invalid SkillIndex entry in " + skillTable.getName() + " on row " + i);
			}
			if(tempSkill == null){
				if(tolErr){
					err_pr.println("SkillIndex entry in " + skillTable.getName() + " on row " + i + " points to non-existent skill");
					continue;
				}else throw new PageGenerationException("SkillIndex entry in " + skillTable.getName() + " on row " + i + " points to non-existent skill");
			}
			
			if(temp.equals("0")) classSkills.put(tempSkill.name, tempSkill);
			else            crossClassSkills.put(tempSkill.name, tempSkill);
		}
		
		while(classSkills.size() > 0 || crossClassSkills.size() > 0){
			toReturn += "<tr>\n";
			
			if(classSkills.size() > 0){
				tempSkill = classSkills.remove(classSkills.firstKey());
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempSkill.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempSkill.name + "</a>");
			}else
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");
			
			if(crossClassSkills.size() > 0){
				tempSkill = crossClassSkills.remove(crossClassSkills.firstKey());
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempSkill.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempSkill.name + "</a>");
			}else
				toReturn += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");
			
			toReturn += "</tr>\n";
		}
		
		toReturn += "</table>\n";
		return toReturn;
	}
	
	
	/**
	 * Constructs the html table of the bonus and selectable class feats of the given class.
	 * TreeMaps are used to arrange the printed feats in alphabetic order.
	 *
	 * @param classes2da  data structure wrapping classes.2da
	 * @param entryNum    number of the entry to generate table for
	 *
	 * @return  an array of two strings. First one is the bonus feats, second is the selectable feats
	 *
	 * @throws PageGenerationException if there is an error while generating the table and error tolerance is off
	 */
	private static String[] buildClassFeatTables(Data_2da classes2da, int entryNum){
		Data_2da featTable = null;
		try{
			featTable = twoDA.get(classes2da.getEntry("FeatsTable", entryNum));
		}catch(TwoDAReadException e){
			if(tolErr){
				err_pr.println("Failed to read CLS_FEAT_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
				return new String[]{"", ""};
			}
			else throw new PageGenerationException("Failed to read CLS_FEAT_*.2da for class " + entryNum + ": " + tlk.get(classes2da.getEntry("Name", entryNum)) + ":\n" + e);
		}
		
		String[] toReturn = {classFeatTableHeaderTemplate,
		                     classFeatTableHeaderTemplate};
		String temp = null;
		FeatEntry tempFeat = null;
		TreeMap<String, FeatEntry> normalBonusFeats      = new TreeMap<String, FeatEntry>(),
		                           epicBonusFeats        = new TreeMap<String, FeatEntry>(),
		                           normalSelectableFeats = new TreeMap<String, FeatEntry>(),
		                           epicSelectableFeats   = new TreeMap<String, FeatEntry>();
		
		// Build alphabetic lists of all the feats
		for(int i = 0; i < featTable.getEntryCount(); i++){
			temp = featTable.getEntry("List", i);
			// Yet more validity checking :P
			if(!(temp.equals("0") || temp.equals("1") || temp.equals("2") || temp.equals("3"))){
				if(tolErr){
					err_pr.println("Invalid List entry in " + featTable.getName() + " on row " + i + ": " + temp);
					continue;
				}else throw new PageGenerationException("Invalid List entry in " + featTable.getName() + " on row " + i + ": " + temp);
			}
			
			try{
				tempFeat = feats.get(Integer.parseInt(featTable.getEntry("FeatIndex", i)));
			}catch(NumberFormatException e){
				if(tolErr){
					err_pr.println("Invalid FeatIndex entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("FeatIndex", i));
					continue;
				}else throw new PageGenerationException("Invalid FeatIndex entry in " + featTable.getName() + " on row " + i + ": " + featTable.getEntry("FeatIndex", i));
			}
			if(tempFeat == null){
				if(tolErr){
					err_pr.println("FeatIndex entry in " + featTable.getName() + " on row " + i + " points to non-existent feat: " + featTable.getEntry("FeatIndex", i));
					continue;
				}else throw new PageGenerationException("FeatIndex entry in " + featTable.getName() + " on row " + i + " points to non-existent feat: " + featTable.getEntry("FeatIndex", i));
			}
			
			if(temp.equals("3")){
				if(tempFeat.isEpic) epicBonusFeats.put(tempFeat.name, tempFeat);
				else              normalBonusFeats.put(tempFeat.name, tempFeat);
			}else{
				if(tempFeat.isEpic) epicSelectableFeats.put(tempFeat.name, tempFeat);
				else              normalSelectableFeats.put(tempFeat.name, tempFeat);
			}
			
		}
		
		// Build the bonus feat table
		while(normalBonusFeats.size() > 0 || epicBonusFeats.size() > 0){
			toReturn[0] += "<tr>\n";
			
			if(normalBonusFeats.size() > 0){
				tempFeat = normalBonusFeats.remove(normalBonusFeats.firstKey());
				toReturn[0] += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempFeat.name + "</a>");
			}else
				toReturn[0] += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");
			
			if(epicBonusFeats.size() > 0){
				tempFeat = epicBonusFeats.remove(epicBonusFeats.firstKey());
				toReturn[0] += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempFeat.name + "</a>");
			}else
				toReturn[0] += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");
			
			toReturn[0] += "</tr>\n";
		}
		
		// Build the selectable feat table
		while(normalSelectableFeats.size() > 0 || epicSelectableFeats.size() > 0){
			toReturn[1] += "<tr>\n";
			
			if(normalSelectableFeats.size() > 0){
				tempFeat = normalSelectableFeats.remove(normalSelectableFeats.firstKey());
				toReturn[1] += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempFeat.name + "</a>");
			}else
				toReturn[1] += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");
			
			if(epicSelectableFeats.size() > 0){
				tempFeat = epicSelectableFeats.remove(epicSelectableFeats.firstKey());
				toReturn[1] += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "<a href=\"" + tempFeat.filePath.replace(contentPath, "../").replaceAll("\\\\", "/") + "\" target=\"content\">" + tempFeat.name + "</a>");
			}else
				toReturn[1] += classTablesEntryTemplate.replaceAll("~~~Entry~~~", "&nbsp;");
			
			toReturn[1] += "</tr>\n";
		}
		
		toReturn[0] += "</table>\n";
		toReturn[1] += "</table>\n";
		
		return toReturn;
	}
	
	
	
	private static void createMenus(){
		
		doGenericMenu(skills, "Skills", "manual_menus_skills.html");
		doGenericMenu(domains, "Domains", "manual_menus_domains.html");
		doGenericMenu(races, "Races", "manual_menus_races.html");
		doSpellMenus();
		//doFeatMenus();
		//doClassMenus();
	}
	
	/**
	 * Sorts any of the pages for which GenericEntry is enough into alphabetic order
	 * using a TreeMap, and prints a menu page out of the results.
	 */
	private static void doGenericMenu(HashMap<Integer, GenericEntry> entries, String menuName, String menuFileName){
		TreeMap<String, String> links = new TreeMap<String, String>();
		StringBuffer toPrint = new StringBuffer();
		
		if(verbose) System.out.println("Printing menu for " + menuName);
		
		for(GenericEntry entry : entries.values()){
			links.put(entry.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
			                                                  entry.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
			                                      .replaceAll("~~~targetName~~~", entry.name));
		}
		
		while(links.size() > 0){
			toPrint.append(links.remove(links.firstKey()) + "\n");
		}
		
		printPage(menuPath + menuFileName, menuTemplate.replaceAll("~~~menuName~~~", menuName)
		                                               .replaceAll("~~~menuEntries~~~", toPrint.toString()));
	}
	
	/**
	 * Sorts the spells into alphabetic order using a TreeMap, and prints a menu
	 * page out of the results. Normal, epic and psionics get their own menus
	 */
	private static void doSpellMenus(){
		TreeMap<String, String> normalSpellLinks  = new TreeMap<String, String>(),
		                        epicSpellLinks    = new TreeMap<String, String>(),
		                        psionicPowerLinks = new TreeMap<String, String>(),
		                        toPut = null;
		StringBuffer normalPrint  = new StringBuffer(),
		             epicPrint    = new StringBuffer(),
		             psionicPrint = new StringBuffer();
		String temp = null;
		
		if(verbose) System.out.println("Printing spell menus");
		
		for(SpellEntry spell : spells.values()){
			switch(spell.type){
				case NORMAL:
					normalSpellLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
					                                                             spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
					                                                 .replaceAll("~~~targetName~~~", spell.name));
					break;
				case EPIC:
					temp = spell.name.startsWith("Epic Spell: ") ? spell.name.substring(12) : spell.name;
					epicSpellLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
					                                                           spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
					                                               .replaceAll("~~~targetName~~~", temp));
					break;
				case PSIONIC:
					psionicPowerLinks.put(spell.name, menuItemTemplate.replaceAll("~~~TargetPath~~~",
					                                                              spell.filePath.replace(mainPath, "../").replaceAll("\\\\", "/"))
					                                                  .replaceAll("~~~targetName~~~", spell.name));
					break;
				
				default: throw new AssertionError("This message should not be seen");
			}
		}
		
		while(normalSpellLinks.size() > 0)
			normalPrint.append(normalSpellLinks.remove(normalSpellLinks.firstKey()) + "\n");
		while(epicSpellLinks.size() > 0)
			epicPrint.append(epicSpellLinks.remove(epicSpellLinks.firstKey()) + "\n");
		while(psionicPowerLinks.size() > 0)
			psionicPrint.append(psionicPowerLinks.remove(psionicPowerLinks.firstKey()) + "\n");
		
		printPage(menuPath + "manual_menus_spells.html", menuTemplate.replaceAll("~~~menuName~~~", "Spells")
		                                                             .replaceAll("~~~menuEntries~~~", normalPrint.toString()));
		printPage(menuPath + "manual_menus_epic_spells.html", menuTemplate.replaceAll("~~~menuName~~~", "Epic Spells")
		                                                                  .replaceAll("~~~menuEntries~~~", epicPrint.toString()));
		printPage(menuPath + "manual_menus_psionic_powers.html", menuTemplate.replaceAll("~~~menuName~~~", "Psionic Powers")
		                                                                     .replaceAll("~~~menuEntries~~~", psionicPrint.toString()));
	}
}
