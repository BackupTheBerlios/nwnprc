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
					err_pr.println(e.toString());
					temp = null;
				}catch(TwoDAReadException e){
					err_pr.println(e.toString());
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
				err_pr.println("Failed to read settings file. Exception:\n" + e + "\nAborting");
				System.exit(1);
			}
		}
	}
	
	/** A convenience object for printing both to log and System.err */
	public static ErrorPrinter err_pr = new ErrorPrinter();
	
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
	private static String classTemplate                 = null,
	                      domainTemplate                = null,
	                      featTemplate                  = null,
	                      mFeatTemplate                 = null,
	                      menuTemplate                  = null,
	                      menuItemTemplate              = null,
	                      prereqANDFeatHeaderTemplate   = null,
	                      prereqORFeatHeaderTemplate    = null,
	                      spellTemplate                 = null,
	                      skillTemplate                 = null,
	                      successorFeatHeaderTemplate   = null;
	                      
	
	/* Data structure used for determining if a previous write has failed
	 * Required in order to be able to skip generating dead links in the
	 * manual
	 */
	private static final Object presenceIndicator = new Object();
	private static HashMap<Integer, Object> failedSkills = new HashMap<Integer, Object>(),
	                                        failedSpells = new HashMap<Integer, Object>();
	
	/* A freaking pile of these for eventually building links.
	 *Take up space, but simplify the code.
	 */
	private static HashMap<Integer, FeatEntry> masterFeats,
	                                           feats/*,
	                                           generalFeats,
	                                           generalEpicFeats,
	                                           classFeats,
	                                           classEpicFeats*/;
	public static void main(String[] args){
		/* Argument parsing */
		for(String opt : args){
			if(opt.equals("--help"))
				readMe();
			
			if(opt.startsWith("-")){
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
				err_pr.println("Failure while reading TLKs for language: " + curLanguage +". Exception: \n" + e);
				continue;
			}
			
			readTemplates();
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
		                   "  java prc/autodoc/Main [--help][-qs?]\n"+
		                   "\n"+
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
	private static void readTemplates(){
		String templatePath = "templates" + fileSeparator + curLanguage + fileSeparator;
		
		classTemplate                 = readTemplate(templatePath + "class.html");
		domainTemplate                = readTemplate(templatePath + "domain.html");
		featTemplate                  = readTemplate(templatePath + "feat.html");
		mFeatTemplate                 = readTemplate(templatePath + "masterfeat.html");
		menuTemplate                  = readTemplate(templatePath + "menu.html");
		menuItemTemplate              = readTemplate(templatePath + "menuitem.html");
		prereqANDFeatHeaderTemplate   = readTemplate(templatePath + "prerequisiteandfeatheader.html");
		prereqORFeatHeaderTemplate    = readTemplate(templatePath + "prerequisiteorfeatheader.html");
		spellTemplate                 = readTemplate(templatePath + "spell.html");
		skillTemplate                 = readTemplate(templatePath + "skill.html");
		successorFeatHeaderTemplate   = readTemplate(templatePath + "successorfeatheader.html");
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
			
			while(reader.hasNextLine()) temp.append(reader.nextLine() + "\n");
			
			return temp.toString();
		}catch(Exception e){
			err_pr.println("Failed to read template file. Exception:\n" + e + "\nAborting");
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
		buildDir(dirPath + "class_epic_feats");
		buildDir(dirPath + "class_feats");
		buildDir(dirPath + "domains");
		buildDir(dirPath + "epic_feats");
		buildDir(dirPath + "epic_spells");
		buildDir(dirPath + "feats");
		buildDir(dirPath + "master_feats");
		buildDir(dirPath + "prestige_classes");
		buildDir(dirPath + "psionic_powers");
		buildDir(dirPath + "races");
		buildDir(dirPath + "skills");
		buildDir(dirPath + "spells");
		
		buildDir(mainPath + "menus");
		
		System.gc();
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
				err_pr.println("Failure creating directory:\n" + builder.getPath());
				System.exit(1);
			}
		}
	}
	
	
	private static void createPages(){
		/* First, do the pages that do not require linking to other pages */
		doSkills();
		doSpells();
		
		/* Then, build the feats */
		preliMasterFeats();
		preliFeats();
		linkFeats();
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
				// If we have a bad name, just toss a notice and skip to next entry
				if(name.equals(badStrRef)) throw new PageGenerationException("Invalid name entry for skill " + i);
				if(verbose) System.out.println("Printing page for " + name);
				
				// Build the entry data
				entry = skillTemplate;
				entry = entry.replaceAll("~~~SkillName~~~",
				                         name);
				entry = entry.replaceAll("~~~SkillTLKDescription~~~",
				                         htmlizeTLK(tlk.get(skills.getEntry("Description", i))));
				
				printPage(skillPath + i + ".html", entry);
			}catch(Exception e){
				err_pr.println("Failed to print page for skill " + i + ": " + name + "\nException:\n" + e);
				// Note the failure, so this page isn't used elsewhere in the manual
				failedSkills.put(i, presenceIndicator);
			}
		}
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
					// If we have a bad name, just toss a notice and skip to next entry
					if(name.equals(badStrRef)) throw new PageGenerationException("Invalid name entry for spell " + i);
					if(verbose) System.out.println("Printing page for " + name);
					
					// Build the entry data
					entry = spellTemplate;
					entry = entry.replaceAll("~~~SpellName~~~",
					                         name);
					entry = entry.replaceAll("~~~SpellTLKDescription~~~",
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
				err_pr.println("Failed to print page for spell " + i + ": " + name + "\nException:\n" + e);
				// Note the failure, so this page isn't used elsewhere in the manual
				failedSpells.put(i, presenceIndicator);
			}
		}
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
	
	
	/**
	 * Build the preliminary list of master feats, without the child feats
	 * linked in.
	 */
	private static void preliMasterFeats(){
		String mFeatPath = contentPath + "master_feats" + fileSeparator;
		String name     = null,
		       text     = null;
		FeatEntry entry = null;
		
		masterFeats = new HashMap<Integer, FeatEntry>();
		Data_2da masterFeats2da = twoDA.get("masterfeats");
		
		for(int i = 0; i < masterFeats2da.getEntryCount(); i++){
			// Skip blank rows
			if(masterFeats2da.getEntry("LABEL", i).equals("****")) continue;
			
			try{
				name = tlk.get(masterFeats2da.getEntry("STRREF", i));
				// If we have a bad name, just toss a notice and skip to next entry
				if(name.equals(badStrRef)) throw new PageGenerationException("Invalid name entry for masterfeat " + i);
				if(verbose) System.out.println("Generating preliminary data for " + name);
				
				// Build the entry data
				text = mFeatTemplate;
				text = text.replaceAll("~~~FeatName~~~",
				                       name);
				text = text.replaceAll("~~~FeatTLKDescription~~~",
				                       htmlizeTLK(tlk.get(masterFeats2da.getEntry("DESCRIPTION", i))));
				entry = new FeatEntry(name , text, mFeatPath + i + ".html", i, false, false);
				
				// Store the entry to wait for further processing
				masterFeats.put(i, entry);
			}catch(Exception e){
				err_pr.println("Failed to print page for masterfeat " + i + ": " + name + "\nException:\n" + e);
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
		feats            = new HashMap<Integer, FeatEntry>();
/*		generalFeats     = new HashMap<Integer, FeatEntry>();
		generalEpicFeats = new HashMap<Integer, FeatEntry>();
		classFeats       = new HashMap<Integer, FeatEntry>();
		classEpicFeats   = new HashMap<Integer, FeatEntry>();*/
		Data_2da feats2da = twoDA.get("feat");
		
		for(int i = 0; i < feats2da.getEntryCount(); i++){
			// Skip blank rows
			if(feats2da.getEntry("LABEL", i).equals("****")) continue;
			// Skip the ISC & Epic spell markers
			if(feats2da.getEntry("LABEL", i).equals("ReservedForISCAndESS")) continue;
			try{
				name = tlk.get(feats2da.getEntry("FEAT", i));
				// If we have a bad name, just toss a notice and skip to next entry
				if(name.equals(badStrRef)) throw new PageGenerationException("Invalid name entry for feat " + i);
				if(verbose) System.out.println("Generating preliminary data for " + name);
				
				// Build the entry data
				text = featTemplate;
				text = text.replaceAll("~~~FeatName~~~",
				                       name);
				text = text.replaceAll("~~~FeatTLKDescription~~~",
				                       htmlizeTLK(tlk.get(feats2da.getEntry("DESCRIPTION", i))));
				
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
				
				// Create the entry data structure
				entry = new FeatEntry(name , text, path, i, isEpic, isClassFeat);
				
				// Store the entry to wait for further processing
				feats.put(i, entry);
			}catch(Exception e){
				err_pr.println("Failed to print page for feat " + i + ": " + name + "\nException:\n" + e);
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
			// Link to master
			if(!feats2da.getEntry("MASTERFEAT", check.entryNum).equals("****")){
				try{
					other = masterFeats.get(Integer.parseInt(feats2da.getEntry("MASTERFEAT", check.entryNum)));
					//check.master = other;
					other.childFeats.add(check);
				}catch(NumberFormatException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.entryName + " contains an invalid masterfeat link");
				}catch(NullPointerException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.entryName + " contains a link to nonexistent masterfeat");
			}}
			
			// Print prerequisites into the entry
			temp = buildPrerequisites(check, feats2da);
			check.entryText.replaceAll("~~~PrerequisiteFeatList~~~", temp);
			
			// Print the successor, if any, into the entry
			temp = "";
			if(!feats2da.getEntry("SUCCESSOR", check.entryNum).equals("****")){
				try{
					other = feats.get(Integer.parseInt(feats2da.getEntry("MASTERFEAT", check.entryNum)));
					temp += ("<div>\n" + successorFeatHeaderTemplate + "<br /><a href=" + other.filePath.replace(contentPath, "../") + " target=\"content\">" + other.entryName + "</a>\n</div>\n");
				}catch(NumberFormatException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.entryName + " contains an invalid masterfeat link");
				}catch(NullPointerException e){
					err_pr.println("Feat " + check.entryNum + ": " + check.entryName + " contains a link to nonexistent masterfeat");
			}}
			check.entryText.replaceAll("~~~SuccessorFeat~~~", temp);
		}
		
		// Add the child links to masterfeat texts
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
				preReqText += "<br /><a href=" + andReq1.filePath.replace(contentPath, "../") + " target=\"content\">" + andReq1.entryName + "</a>\n";
			if(andReq2 != null)
				preReqText += "<br /><a href=" + andReq2.filePath.replace(contentPath, "../") + " target=\"content\">" + andReq2.entryName + "</a>\n";
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
						preReqText += "<br /><a href=" + orReq.filePath.replace(contentPath, "../") + " target=\"content\">" + orReq.entryName + "</a>\n";
					}
				}
			}
			// End the <div> if we printed anything
			if(headerDone) preReqText += "</div>\n";
		}
		
		return preReqText;
	}
}
