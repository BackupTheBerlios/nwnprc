//package DocumentCreator;

import java.io.*;
import java.util.*;
import java.util.regex.*;
//import DocumentorMain.pattern;

/**
 * This class forms an interface for accessing 2da files in the
 * PRC automated manual generator.
 */
public class Data_2da{
	private HashMap<String, ArrayList<String>> mainData;
	private int entries = 0;
	
	// String matching pattern. Gets a block of non-whitespace OR " followed by any characters until the next "
	//private static Pattern pattern = Pattern.compile("\\S+|\"[.&&[^\"]]+\"");
	private static Pattern pattern = Pattern.compile("([\\w[\\*]]+)|\"[^\"]+\"");
	private static Matcher matcher = pattern.matcher("");
	
	/**
	 * Creates a new Data_2da on the 2da file specified.
	 *
	 * @param fileName The relative location of the 2da file to be loaded
	 *
	 * @throws IllegalArgumentException If fileName does not specify a 2da file
	 * @throws IOException If reading the 2da file specified does not succeed, or the file does not contain any data
	 */
	public Data_2da(String fileName) throws IOException{
		if(!fileName.toLowerCase().endsWith("2da"))
			throw new IllegalArgumentException("Non-2da filename passed to Data_2da: " + fileName);
		
		File baseFile = new File(fileName);
		if(!baseFile.exists())
			throw new IllegalArgumentException("Nonexistent file passed to Data_2da: " + fileName);
		if(!baseFile.isFile())
			throw new IllegalArgumentException("Nonfile passed to Data_2da: " + fileName);
		
		// Create a Scanner for reading the 2da
		Scanner reader = new Scanner(baseFile);
		
		// Check the 2da header
		String data = getNextNonEmptyRow(reader);
		if(!data.contains("2DA V2.0"))
			throw new IOException("No 2da header found in: " + fileName);
		
		/* Done with the preliminary paranoia, do the actual reading */
		try{
			CreateData(reader);
		}catch(Exception e){
			System.err.println("Exception occurred when reading 2da file: \n" + fileName + "\n" + e.getMessage());
//			e.printStackTrace();
			System.err.println("Aborting");
			System.exit(0);
		}
	}
	
	/**
	 * Reads the data rows from the 2da into the hashmap and
	 * does validity checking on the 2da while doing so.
	 *
	 * @throws IOException If there is something wrong with the 2da file
	 */
	private void CreateData(Scanner reader) throws IOException{
		mainData = new HashMap<String, ArrayList<String>>();
		Scanner rowParser;
		int line = 0;
		
		// Find the labels row
		String data = getNextNonEmptyRow(reader);
		if(data == null)
			throw new IOException("No labels found in 2da file!");
		
		// Parse the labels
		String[] labels = data.trim().split("\\p{javaWhitespace}+");
		
		// Create the row containers and the main store
		for(int i = 0; i < labels.length; i++){
			labels[i] = labels[i].toLowerCase();
			mainData.put(labels[i],  new ArrayList<String>());
		}
		
		// Skip empty rows until the data starts
		data = getNextNonEmptyRow(reader);
		if(data == null)
			throw new IOException("No data in 2da file!");
		
		while(true){
			//rowParser = new Scanner(data);
			matcher.reset(data);
			matcher.find();
			
			// Check for the presence of the row number
			try{
				line = Integer.parseInt(matcher.group());
			}catch(NumberFormatException e){
				throw new IOException("Numberless 2da line: " + line);
			}
			
			// Start parsing the row
			for(int i = 0; i < labels.length; i++){
				// Find the next match and check for too short rows
				if(!matcher.find())
					throw new IOException("Too short 2da line: " + line);
					
				/*
				String foo = matcher.group();//rowParser.next(pattern);
				System.out.print(labels[i] + ":\t\t");
				System.out.println(foo);
				mainData.get(labels[i]).add(foo);
				*/
				
				// Get the next element and add it to the data structure
				mainData.get(labels[i]).add(matcher.group());
			}
			
			// Check for too long rows
			if(matcher.find())
				throw new IOException("Too long 2da line: " + line);
			
			// Increment the entry counter
			entries++;
			
			/* Get the next line if there is one, or break the loop
			 * A bit ugly, but I couldn't figure an easy way of making the loop go right
			 * even for 2das with only one row without biggish changes
			 */
			if(reader.hasNextLine()){
				data = reader.nextLine();
				if(data.trim().equals(""))
					break;
			}
			else
				break;
		}
		
		// Some validity checking on the 2da. Empty rows allowed only in the end
		if(getNextNonEmptyRow(reader) != null)
			throw new IOException("Empty row in the middle of 2da. After row: " + line);
	}
	
	/**
	 * Reads rows from the 2da until it finds a row containing non-whitespace characters.
	 *
	 * return The row found, or null if none were found.
	 */
	private String getNextNonEmptyRow(Scanner reader){
		String toReturn = null;
		while(reader.hasNextLine()){
			toReturn = reader.nextLine();
			if(!toReturn.trim().equals(""))
				break;
		}
		
		if(toReturn == null || toReturn.trim().equals(""))
			return null;
		
		return toReturn;
	}
	
	/**
	 * Get the list of column labels in this 2da.
	 *
	 * @return an array of Strings containing the column labels
	 */
	public String[] getLabels(){
		// For some reason, it won't let me cast the keyset directly into a String[]
		Object[] temp = mainData.keySet().toArray();
		String[] toReturn = new String[temp.length];
		for(int i = 0; i < temp.length; i++) toReturn[i] = (String)temp[i];
		return toReturn;
	}
	
	/**
	 * Get the 2da entry on the given row and column
	 *
	 * @return String represeting the 2da entry
	 */
	public String getEntry(String label, int row){
		return mainData.get(label.toLowerCase()).get(row);
	}
	
	/**
	 * Get number of entries in this 2da
	 *
	 * @return integer equal to the number of entries in this 2da
	 */
	public int getEntryCount(){
		return entries;
	}
	
	public static void main(String[] args) throws Throwable{
		Data_2da test = new Data_2da(args[0]);
		
		String[] labels = test.getLabels();
		for(String elem : labels) System.out.print(elem + "\t");
		System.out.println("\n");
		
		int entryCount = test.getEntryCount();
		
		for(int i = 0; i < entryCount; i++){
			for(String elem : labels)
				System.out.print(test.getEntry(elem, i) + "\t");
			System.out.println();
		}
	}
}