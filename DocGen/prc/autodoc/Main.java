package prc.autodoc;

import java.io.*;
import java.util.*;
import java.util.regex.*;

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
		
		public String getEntry(int num){
			return num < 0x01000000 ? normal.getEntry(num) : custom.getEntry(num);
		}
		
		public String getEntry(String num){
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
	
	public static Settings settings = new Settings();
	
	private static String fileSeparator = System.getProperty("file.separator");
	
	private static String curLanguage = null;
	private static String mainPath = null;
	
	private static TwoDAStore twoDA;
	private static TLKStore tlk;
	
	/* The template files */
	private static final String classTemplate    = readTemplate("templates" + fileSeparator + "class.html"),
	                            domainTemplate   = readTemplate("templates" + fileSeparator + "domain.html"),
	                            featTemplate     = readTemplate("templates" + fileSeparator + "feat.html"),
	                            menuTemplate     = readTemplate("templates" + fileSeparator + "menu.html"),
	                            menuItemTemplate = readTemplate("templates" + fileSeparator + "menuitem.html"),
	                            spellTemplate    = readTemplate("templates" + fileSeparator + "spell.html");
	
	
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
		
		throw new UnknownError("This message should not be seen");
	}
	
	/**
	 * Creates the directory structure for the current language
	 * being processed.
	 * Kills execution if any creation operations fail.
	 */
	private static void buildDirectories(){
		File builder;
		String contentPath = mainPath + "content";
		
		builder = new File(contentPath);
		if(!builder.mkdirs()) buildDirAbort(builder);
		contentPath += fileSeparator;
		
		builder = new File(contentPath + "base_classes");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "class_epic_feat");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "class_feat");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "domains");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "epic_feat");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "epic_spells");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "feat");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "master_feat");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "prestige_classes");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "races");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "skills");
		if(!builder.mkdirs()) buildDirAbort(builder);
		builder = new File(contentPath + "spells");
		if(!builder.mkdirs()) buildDirAbort(builder);
		
		builder = new File(mainPath + "menus");
		if(!builder.mkdirs()) buildDirAbort(builder);
	}
	
	private static void buildDirAbort(File dir){
		System.err.println("Failure creating directory:\n" + dir.getPath());
		System.exit(1);
	}
	
	
	private static void createPages(){
		// Do spells
		doSpells();
		// Do epicspells
		// Do psionicpowers
		
		// Do masterfeats
		// Do feats
		// Link feats
		
		// Do domains
		// Do skills
		// Do classes
	}
	
}