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
	
	private static class Settings{
		private Matcher mainMatch = Pattern.compile("\\S+:").matcher(""),
		                paraMatch = Pattern.compile("\"[^\"]+\"").matcher(""),
		                langMatch = Pattern.compile("\\w+=\"[^\"]+\"").matcher("");
		public ArrayList<String[]> languages = new ArrayList<String[]>();
		
		private enum Modes{LANGUAGE};
		
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
						if(mainMatch.group().equals("languages:")) mode = Modes.LANGUAGE;
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
								throw new Exception("Unknown language parameter encountered");
						}
						languages.add(temp);
					}
				}
			}catch(Exception e){
				System.err.println("Failed to read settings file. Exception:\n" + e + "\nAborting");
				System.exit(1);
			}
		}
	}
	
	public static final boolean verbose = true;
	public static final Spinner spinner = new Spinner();
	
	public static final Settings settings = new Settings();
	
	private static final String fileSeparator = System.getProperty("file.separator");
	private static String curLanguage = null;
	
	private static HashMap<String, Data_2da> twoDAStore = new HashMap<String, Data_2da>();
	private static TLKStore TLK;
	
	
	public static void main(String[] args){
		/* Argument parsing, once I add it */
		
		// Read the main 2das
		try{
			twoDAStore.put("classes",     new Data_2da("2da" + fileSeparator + "classes.2da"));
			twoDAStore.put("domains",     new Data_2da("2da" + fileSeparator + "domains.2da"));
			twoDAStore.put("feat",        new Data_2da("2da" + fileSeparator + "feat.2da"));
			twoDAStore.put("masterfeats", new Data_2da("2da" + fileSeparator + "masterfeats.2da"));
			twoDAStore.put("racialtypes", new Data_2da("2da" + fileSeparator + "racialtypes.2da"));
			twoDAStore.put("skills",      new Data_2da("2da" + fileSeparator + "skills.2da"));
			twoDAStore.put("spells",      new Data_2da("2da" + fileSeparator + "spells.2da"));
		}catch(Exception e){
			System.err.println("Failure while reading main 2das. Exception data:\n");
			e.printStackTrace();
			System.exit(0);
		}
		
		for(int i = 0; i < settings.languages.size(); i++){
			curLanguage = settings.languages.get(i)[0];
			TLK = new TLKStore(settings.languages.get(i)[1], settings.languages.get(i)[2]);
		}
	}
	
}