package prc.autodoc;

import java.io.*;
import java.util.*;
import java.util.regex.*;

import static prc.autodoc.Main.*;

/**
 * This class forms an interface for accessing 2da files in the
 * PRC automated manual generator.
 */
public class Data_2da{
	private HashMap<String, ArrayList<String>> mainData = new HashMap<String, ArrayList<String>>();
	private int entries = 0;
	private String name;
	
	// String matching pattern. Gets a block of non-whitespace OR " followed by any characters until the next "
	private static Pattern pattern = Pattern.compile("[\\S&&[^\"]]+|\"[^\"]+\"");
	private static Matcher matcher = pattern.matcher("");
	
	/**
	 * Creates a new Data_2da on the 2da file specified.
	 *
	 * @param fileName The relative location of the 2da file to be loaded
	 *
	 * @throws IllegalArgumentException <code>filePath</code> does not specify a 2da file
	 * @throws TwoDAReadException       reading the 2da file specified does not succeed,
	 *                                    or the file does not contain any data
	 */
	public Data_2da(String filePath){
		// Some paranoia checking for bad parameters
		if(!filePath.toLowerCase().endsWith("2da"))
			throw new IllegalArgumentException("Non-2da filename passed to Data_2da: " + filePath);
		
		// Create the file handle
		File baseFile = new File(filePath);
		// More paraoia
		if(!baseFile.exists())
			throw new IllegalArgumentException("Nonexistent file passed to Data_2da: " + filePath);
		if(!baseFile.isFile())
			throw new IllegalArgumentException("Nonfile passed to Data_2da: " + filePath);
		
		// Drop the path from the filename
		name = baseFile.getName().substring(0, baseFile.getName().length() - 4);
		
		// Tell the user what we are doing
		if(verbose) System.out.print("Reading 2da file: " + name + " ");
		
		// Create a Scanner for reading the 2da
		Scanner reader = null;
		try{
			reader = new Scanner(baseFile);
		}catch(FileNotFoundException e){
			err_pr.println("2da file removed while program was running. Aborting");
			//System.err.println("2da file removed while program was running. Aborting");
			System.exit(1);
		}
		
		// Check the 2da header
		String data = getNextNonEmptyRow(reader);
		if(!data.contains("2DA V2.0"))
			throw new TwoDAReadException("2da header missing or invalid: " + name);
		
		// Start the actual reading
		try{
			CreateData(reader);
		}catch(TwoDAReadException e){
			throw new TwoDAReadException("Exception occurred when reading 2da file: " + name, e);
		}
		
		if(verbose) System.out.println("- Done");
	}
	
	/**
	 * Reads the data rows from the 2da into the hashmap and
	 * does validity checking on the 2da while doing so.
	 *
	 * @throws IOException If there is something wrong with the 2da file
	 */
	private void CreateData(Scanner reader){
		Scanner rowParser;
		int line = 0;
		
		// Find the labels row
		String data = getNextNonEmptyRow(reader);
		if(data == null)
			throw new TwoDAReadException("No labels found in 2da file!");
		
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
			throw new TwoDAReadException("No data in 2da file!");
		
		while(true){
			//rowParser = new Scanner(data);
			matcher.reset(data);
			matcher.find();
			
			// Check for the presence of the row number
			try{
				line = Integer.parseInt(matcher.group());
			}catch(NumberFormatException e){
				throw new TwoDAReadException("Numberless 2da line: " + line);
			}
			
			// Start parsing the row
			for(int i = 0; i < labels.length; i++){
				// Find the next match and check for too short rows
				if(!matcher.find())
					throw new TwoDAReadException("Too short 2da line: " + line);
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
				throw new TwoDAReadException("Too long 2da line: " + line);
			
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
			
			if(verbose) spinner.spin();
		}
		
		// Some validity checking on the 2da. Empty rows allowed only in the end
		if(getNextNonEmptyRow(reader) != null)
			throw new TwoDAReadException("Empty row in the middle of 2da. After row: " + line);
	}
	
	/**
	 * Reads rows from the 2da until it finds a row containing non-whitespace characters.
	 *
	 * @return The row found, or null if none were found.
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
	 * @param label the label of the column to get
	 * @param row   the number of the row to get
	 *
	 * @return String represeting the 2da entry
	 */
	public String getEntry(String label, int row){
		return mainData.get(label.toLowerCase()).get(row);
	}
	
	/**
	 * Get the 2da entry on the given row and column
	 *
	 * @param label the label of the column to get
	 * @param row   the number of the row to get, as string
	 *
	 * @return String represeting the 2da entry
	 *
	 * @throws NumberFormatException if <code>row</code> cannot be converted to an integer
	 */
	public String getEntry(String label, String row){
		return this.getEntry(label, Integer.parseInt(row));
	}
	
	/**
	 * Get number of entries in this 2da
	 *
	 * @return integer equal to the number of entries in this 2da
	 */
	public int getEntryCount(){
		return entries;
	}
	
	/**
	 * Get the name of this 2da
	 *
	 * @return String representing this 2da's name
	 */
	public String getName(){
		return name;
	}
	
	
	
	public static void main(String[] args) throws Throwable{
		if(args.length == 0) readMe();
		for(String elem : args) if(elem.equals("--help")) readMe();
		
		Data_2da file1,
		         file2;
		
		if(args[0].equals("-c")){
			if(args.length != 3){
				System.out.println("Invalid parameters");
				readMe();
			}
			file1 = new Data_2da(args[1]);
			file2 = new Data_2da(args[2]);
			
			doComparison(file1, file2);
		}
		else{
			if(args.length != 1){
				System.out.println("Invalid parameters");
				readMe();
			}
			file1 = new Data_2da(args[0]);
		}
	}
	
	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "  java Data_2da [-c] file1 [file2]\n"+
		                   "\n"+
		                   "  -c    prints the differing lines between the two given 2das.\n"+
		                   "        they must have the same label set and entrycount.\n"+
		                   "  file1 the 2da file tested for validity or to be compared with file2\n"+
		                   "  file2 the 2da file to be compared with file1\n");
		System.exit(0);
	}
	
	/**
	 * Compares the given two 2da files and prints differences it finds
	 * Differing number of rows, or row names will cause comparison to abort.
	 *
	 * @param file1  Data_2da containing one of the files to be compared
	 * @param file1  Data_2da containing the other file to be compared
	 */
	public static void doComparison(Data_2da file1, Data_2da file2){
		// Check labels
		String[] labels1 = file1.getLabels(),
		         labels2 = file2.getLabels();
		if(labels1.length != labels2.length){
			System.out.println("Differing amount of row labels\n"+
			                   file1.getName() + ": " + labels1.length + "\n" +
			                   file2.getName() + ": " + labels2.length);
			return;
		}
		for(int i = 0; i < labels1.length; i++){
			if(!labels1[i].equals(labels2[i])){
				System.out.println("Differing labels");
				return;
			}
		}
		
		// Check lengths
		int shortCount = file1.getEntryCount();
		if(file1.getEntryCount() != file2.getEntryCount()){
			System.out.println("Differing line counts.\n" +
			                   file1.getName() + ": " + file1.getEntryCount() + "\n" +
			                   file2.getName() + ": " + file2.getEntryCount());
			
			shortCount = shortCount > file2.getEntryCount() ? file2.getEntryCount() : shortCount;
		}
		
		// Check elements
		for(int i = 0; i < shortCount; i++){
			for(String label : labels1){
				if(!file1.getEntry(label, i).equals(file2.getEntry(label, i))){
					System.out.println("Differing entries on row " + i + ", column " + label + "\n" +
					                   file1.getName() + ": " + file1.getEntry(label, i) + "\n" +
					                   file2.getName() + ": " + file2.getEntry(label, i));
				}
			}
		}
	}
}