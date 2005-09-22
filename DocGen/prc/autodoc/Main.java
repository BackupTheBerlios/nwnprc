package prc.autodoc;

import java.io.*;
import java.util.*;
import java.util.regex.*;
import java.util.concurrent.*;

/* Static import in order to let me use the enum constants in switches */
import static prc.autodoc.Main.SpellType.*;

/* Mutual static import to make the file sizes manageable */
import static prc.autodoc.PageGeneration.*;
import static prc.autodoc.MenuGeneration.*;

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
	public static class TLKStore{
		private Data_TLK normal,
		                 custom;
		
		/**
		 * Creates a new TLKStore around the given two filenames.
		 *
		 * @param normalName dialog.tlk or equivalent for the given language
		 * @param customName prc_consortium.tlk or equivalent for the given languag
		 *
		 * @throws TLKReadException if there are any problems reading either TLK
		 */
		public TLKStore(String normalName, String customName){
			this.normal = new Data_TLK("tlk" + fileSeparator + normalName);
			this.custom = new Data_TLK("tlk" + fileSeparator + customName);
		}
		
		/**
		 * Returns the TLK entry for the given StrRef. If there is nothing
		 * at the location, returns Bad StrRef. Automatically picks between
		 * normal and custom TLKs.
		 *
		 * @param num the line number in TLK
		 *
		 * @return the contents of the given TLK slot, or Bad StrRef
		 */
		public String get(int num){
			return num < 0x01000000 ? normal.getEntry(num) : custom.getEntry(num);
		}
		
		/**
		 * See above, except that this one automatically parses the string for
		 * the number.
		 * 
		 * @param num the line number in TLK as string
		 *
		 * @return as above, except it returns Bad StrRef in case parsing failed
		 */
		public String get(String num){
			try{
				return get(Integer.parseInt(num));
			}catch(NumberFormatException e){ return Main.badStrRef; }
		}
	}
	
	/**
	 * Another data structure class. Stores 2das and handles loading them.
	 */
	public static class TwoDAStore{
		private static class Loader implements Runnable{
			private String pathToLoad;
			private List<Data_2da> list;
			private CountDownLatch latch;
			/**
			 * Creates a new Loader to load the given 2da file
			 * @param pathToLoad path of the 2da to load
			 * @param list       list to store the loaded data into
			 * @param latch      latch to countdown on once loading is complete
			 */
			public Loader(String pathToLoad, List<Data_2da> list, CountDownLatch latch){
				this.pathToLoad = pathToLoad;
				this.list       = list;
				this.latch      = latch;
			}
			
			/**
			 * @see java.lang.Runnable#run()
			 */
			public void run(){
				try{
					Data_2da data = Data_2da.load2da(pathToLoad, true);
					list.add(data);
					latch.countDown();
				}catch(Exception e){
					System.err.println("Failure while reading main 2das. Exception data:\n");
					e.printStackTrace();
					System.exit(1);
				}
			}
		}
		private HashMap<String, Data_2da> data = new HashMap<String, Data_2da>();
		
		/**
		 * Generates a new TwoDAStore with all the main 2das preread in.
		 * On a read failure, kills program execution, since there's nothing
		 * that could be done anyway.
		 */
		public TwoDAStore(){
			//long start = System.currentTimeMillis();
			if(verbose) System.out.print("Loading main 2da files ");
			boolean oldVerbose = verbose;
			verbose = false;
			
			CountDownLatch latch = new CountDownLatch(7);
			List<Data_2da> list = Collections.synchronizedList(new ArrayList<Data_2da>());
			// Read the main 2das
			new Thread(new Loader("2da" + fileSeparator + "classes.2da",     list, latch)).start();
			new Thread(new Loader("2da" + fileSeparator + "domains.2da",     list, latch)).start();
			new Thread(new Loader("2da" + fileSeparator + "feat.2da",        list, latch)).start();
			new Thread(new Loader("2da" + fileSeparator + "masterfeats.2da", list, latch)).start();
			new Thread(new Loader("2da" + fileSeparator + "racialtypes.2da", list, latch)).start();
			new Thread(new Loader("2da" + fileSeparator + "skills.2da",      list, latch)).start();
			new Thread(new Loader("2da" + fileSeparator + "spells.2da",      list, latch)).start();
			
			try {
				latch.await();
			} catch (InterruptedException e) {
				System.err.println("Interrupted while reading main 2das. Exception data:\n");
				e.printStackTrace();
				System.exit(1);
			}
			
			for(Data_2da entry : list)
				data.put(entry.getName(), entry);
			verbose = oldVerbose;
			if(verbose) System.out.println("- Done");
			/*
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
			*/
			//System.out.println("Time taken: "  + (System.currentTimeMillis() - start));
		}
		
		/**
		 * Gets a Data_2da structure wrapping the given 2da. If it hasn't been loaded
		 * yet, the loading is done now.
		 *
		 * @param name name of the 2da to get. Without the file end ".2da".
		 *
		 * @return a Data_2da structure
		 *
		 * @throws TwoDAReadException if any errors are encountered while reading
		 */
		public Data_2da get(String name){
			if(data.containsKey(name))
				return data.get(name);
			else{
				Data_2da temp = null;
				try{
					temp = Data_2da.load2da("2da" + fileSeparator + name + ".2da", true);
				}catch(IllegalArgumentException e){
					throw new TwoDAReadException("Problem with filename when trying to read from 2da:\n" + e);
				}
				data.put(name, temp);
				return temp;
			}
		}
	}
	
	/**
	 * A class for handling the settings file.
	 */
	public static class Settings{
		/* Some pattern matchers for use when parsing the settings file */
		private Matcher mainMatch = Pattern.compile("\\S+:").matcher(""),
		                paraMatch = Pattern.compile("\"[^\"]+\"").matcher(""),
		                langMatch = Pattern.compile("\\w+=\"[^\"]+\"").matcher("");
		/* An enumeration of the possible setting types */
		private enum Modes{
			/**
			 * The parser is currently working on lines specifying languages used.
			 */
			LANGUAGE,
			/**
			 * The parser is currently working on lines containing string patterns that are
			 * used in differentiating between entries in spells.2da. 
			 */
			SIGNATURE,
			/**
			 * The parser is currently working on lines listing spells.2da entries that contain
			 * a significantly modified BW spell.
			 */
			MODIFIED_SPELL};
		
		/* Settings data read in */
		/** The settings for languages. An ArrayList of String[] containing setting for a specific language */
		public ArrayList<String[]> languages     = new ArrayList<String[]>();
		/** An ArrayList of Integers. Indices to spells.2da of standard spells modified by the PRC*/
		public ArrayList<Integer> modifiedSpells = new ArrayList<Integer>();
		/** A set of script name prefixes used to find epic spell entries in spells.2da */
		public String[] epicspellSignatures    = null;
		/** A set of script name prefixes used to find psionic power entries in spells.2da */
		public String[] psionicpowerSignatures = null;
		
		/**
		 * Read the settings file in and store the data for later access.
		 * Terminates execution on any errors.
		 */
		public Settings(){
			try{
				// The settings file should be present in the directory this is run from 
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
						else if(mainMatch.group().equals("modified_spell:")) mode = Modes.MODIFIED_SPELL;
						else{
							throw new Exception("Unrecognized setting detected");
						}
						
						continue;
					}
					
					// Take action based on current mode
					if(mode == Modes.LANGUAGE){
						String[] temp = new String[4];
						String result;
						langMatch.reset(check);
						// parse the language entry
						for(int i = 0; i < 4; i++){
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
							else if(result.startsWith("allfeats")){
								paraMatch.reset(result);
								paraMatch.find();
								temp[3] = paraMatch.group().substring(1, paraMatch.group().length() - 1);
							}
							else
								throw new Exception("Unknown language parameter encountered\n" + check);
						}
						languages.add(temp);
					}
					// Parse the spell script name signatures
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
					// Parse the spell modified spell indices
					if(mode == Modes.MODIFIED_SPELL){
						modifiedSpells.add(Integer.parseInt(check.trim()));
					}
				}
			}catch(Exception e){
				err_pr.println("Failed to read settings file:\n" + e + "\nAborting");
				System.exit(1);
			}
		}
	}
	
	/**
	 * A small enumeration for use in spell printing methods
 	 */
	public enum SpellType{
		/**
		 * The spell is not a real spell or psionic power, instead specifies some feat's spellscript.
		 */
		NONE,
		/**
		 * The spell is a normal spell.
		 */
		NORMAL,
		/**
		 * The spell is an epic spell.
		 */
		EPIC,
		/**
		 * The spell is a psionic power.
		 */
		PSIONIC
		};
	
	/** A convenience object for printing both to log and System.err */
	public static ErrorPrinter err_pr = new ErrorPrinter();
	
	/** A switche determinining how errors are handled */
	public static boolean tolErr = true;
	
	/** A boolean determining whether to spam the user with progress information */
	public static boolean verbose = true;
	
	/** A boolean determining whether to print icons for the pages or not */
	public static boolean icons = false;
	
	/** A decorative spinner to look at while the program is loading big files */
	public static Spinner spinner = new Spinner();
	
	/** A constant signifying Bad StrRef */
	public static final String badStrRef = "Bad StrRef";
	
	/**  The container object for general configuration data read from file */
	public static Settings settings;// = new Settings();
	
	/** The file separator, given it's own constant for ease of use */
	public static final String fileSeparator = System.getProperty("file.separator");
	
	/** Array of the settings for currently used language */
	public static String[] curLanguageData = null;
	
	/** Current language name */
	public static String curLanguage = null;
	
	/** The base path.                  <code>"manual" + fileSeparator + curLanguage + fileSeparator</code> */
	public static String mainPath     = null;
	/** The path to content directory.  <code>mainPath + "content" + fileSeparator</code> */
	public static String contentPath  = null;
	/** The path to menu directory.     <code>mainPath + "mainPath" + fileSeparator</code> */
	public static String menuPath     = null;
	/** The path to the image directory. <code>"manual" + fileSeparator + "images" + fileSeparator</code>*/
	public static String imagePath    = "manual" + fileSeparator + "images" + fileSeparator;
	
	/** Data structures for accessing TLKs */
	public static TwoDAStore twoDA;
	/** Data structures for accessing TLKs */
	public static TLKStore tlk;
	
	
	/** The template files */
	public static String babAndSavthrTableHeaderTemplate = null,
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
	                     successorFeatHeaderTemplate     = null,
	                     iconTemplate                    = null,
	                     listEntrySetTemplate            = null,
	                     listEntryTemplate               = null,
	                     alphaSortedListTemplate         = null,
						 requiredForFeatHeaderTemplate   = null,
						 featPageLinkTemplate            = null;
	
	
	/* Data structures to store generated entry data in */
	public static HashMap<Integer, SpellEntry> spells;
	public static HashMap<Integer, FeatEntry> masterFeats,
	                                          feats;
	public static HashMap<Integer, ClassEntry> classes;
	public static HashMap<Integer, GenericEntry> skills,
	                                             domains,
	                                             races;
	
	
	/**
	 * Ye olde maine methode
	 * @param args
	 */
	public static void main(String[] args){
		/* Argument parsing */
		for(String opt : args){
			if(opt.equals("--help"))
				readMe();
			
			if(opt.startsWith("-")){
				if(opt.contains("a"))
					tolErr = true;
				if(opt.contains("q")){
					verbose = false;
					spinner.disable();
				}
				if(opt.contains("i"))
					icons = true;
				if(opt.contains("s"))
					spinner.disable();
				if(opt.contains("?"))
					readMe();
			}
		}
		
		// Load the settings
		settings = new Settings();
		
		// Initialize the 2da container data structure
		twoDA = new TwoDAStore();
		
		
		// Print the manual files for each language specified
		for(int i = 0; i < settings.languages.size(); i++){
			// Set language, path and load TLKs
			curLanguageData = settings.languages.get(i);
			curLanguage = curLanguageData[0];
			mainPath    = "manual" + fileSeparator + curLanguage + fileSeparator;
			contentPath = mainPath + "content" + fileSeparator;
			menuPath    = mainPath + "menus" + fileSeparator;
			
			// If we fail on a language, skip to next one
			try{
				tlk = new TLKStore(curLanguageData[1], curLanguageData[2]);
			}catch(TLKReadException e){
				err_pr.println("Failure while reading TLKs for language: " + curLanguage +":\n" + e);
				continue;
			}
			
			// Skip to next if there is any problem with directories or templates
			if(!(readTemplates() && buildDirectories())) continue;
			
			// Do the actual work
			createPages();
			createMenus();
		}
		
		// Wait for the image conversion to finish before exiting main
		if (Icons.executor != null){
			Icons.executor.shutdown();
			try{
				Icons.executor.awaitTermination(120, TimeUnit.SECONDS);
			}catch(InterruptedException e){
				err_pr.println("Interrupted while waiting for image conversion to finish");
			}finally{
				System.exit(0);
			}
		}
	}
	
	/**
	 * Prints the use instructions for this program and kills execution.
	 */
	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "  java prc/autodoc/Main [--help][-aiqs?]\n"+
		                   "\n"+
		                   "-a     forces aborting printing on errors\n"+
		                   "-i     adds icons to pages\n"+
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
	 *
	 * @return <code>true</code> if all the reads succeeded, <code>false</code> otherwise
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
			iconTemplate                    = readTemplate(templatePath + "icon.html");
			listEntrySetTemplate            = readTemplate(templatePath + "listpageentryset.html");
            listEntryTemplate               = readTemplate(templatePath + "listpageentry.html");
            alphaSortedListTemplate         = readTemplate(templatePath + "alphasorted_listpage.html");
			requiredForFeatHeaderTemplate   = readTemplate(templatePath + "reqforfeatheader.html");
			featPageLinkTemplate            = readTemplate(templatePath + "featpagelink.html");
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
			if(!builder.isDirectory()){
				err_pr.println(builder.getPath() + " already exists as a file!");
				return false;
		}}
		return true;
	}
	
	
	/**
	 *Replaces each line break in the given TLK entry with
	 *a line break followed by <code>&lt;br /&gt;</code>.
	 *
	 * @param toHTML tlk entry to convert
	 * @return the modified string
	 */
	public static String htmlizeTLK(String toHTML){
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
	public static void printPage(String path, String content){
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
	 * Page creation. Calls all the specific functions for different page types
	 */
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
	 * Menu creation. Calls the specific functions for different menu types
	 */
	private static void createMenus(){
		/* First, the types that do not need any extra data beyond name & path
		 * and use GenericEntry
		 */
		doGenericMenu(skills, "Skills", "manual_menus_skills.html");
		doGenericMenu(domains, "Domains", "manual_menus_domains.html");
		doGenericMenu(races, "Races", "manual_menus_races.html");
		/* Then the more specialised data where it needs to be split over several
		 * menu pages
		 */
		doSpellMenus();
		doFeatMenus();
		doClassMenus();
	}
}
