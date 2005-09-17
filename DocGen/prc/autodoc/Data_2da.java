package prc.autodoc;

import java.io.*;
import java.util.*;
import java.util.regex.*;

//import javax.swing.text.LabelView;

import static prc.autodoc.Main.*;

/**
 * This class forms an interface for accessing 2da files in the
 * PRC automated manual generator.
 */
public class Data_2da{
	// String matching pattern. Gets a block of non-whitespace (tab is not counted as whitespace here) OR " followed by any characters until the next "
	private static Pattern pattern = Pattern.compile("[[\\S&&[^\"]][\t]]+|\"[^\"]+\"");//"[\\S&&[^\"]]+|\"[^\"]+\"");
	private static Matcher matcher = pattern.matcher("");

	private HashMap<String, ArrayList<String>> mainData = new LinkedHashMap<String, ArrayList<String>>();
	//private int entries = 0;
	private String name;
	private String defaultValue;
	/** Used for storing the original case of the labels. The ones used in the hashmap are lowercase */
	private String[] realLabels;

	
	/**
	 * Creates a new, empty Data_2da with the specified name.
	 * 
	 * @param name The new 2da file's name.
	 */
	public Data_2da(String name){
		this(name, "");
	}
	
	/**
	 * Creates a new, empty Data_2da with the specified name and default value.
	 * 
	 * @param name         the new 2da file's name
	 * @param defaultValue the new 2da file's default value
	 */
	public Data_2da(String name, String defaultValue){
		this.name = name;
		this.defaultValue = defaultValue;
	}
	
	/**
	 * Saves the 2da represented by this object to file. Equivalent to calling 
	 * <code>save2da(path, false, false)</code>.
	 * 
	 * @param path the directory to save the file in. If this is "" or null,
	 *              the current directory is used.
	 * @throws IOException if <code>true</code> and a file with the same name as this 2da 
	 *                         exists at <code>path</code>, it is overwritten.
	 *                         If <code>false</code> and in the same situation, an IOException is
	 *                         thrown.
	 */
	public void save2da(String path) throws IOException{
		save2da(path, false, false);
	}
	
	/**
	 * Saves the 2da represented by this object to file.
	 * 
	 * @param path the directory to save the file in. If this is "" or null,
	 *              the current directory is used.
	 * @param allowOverWrite if <code>true</code> and a file with the same name as this 2da 
	 *                         exists at <code>path</code>, it is overwritten.
	 *                         If <code>false</code> and in the same situation, an IOException is
	 *                         thrown.
	 * @param evenColumns if <code>true</code>, every entry in a column will be padded until they
	 *                         start from the same position
	 * 
	 * @throws IOException if cannot overwrite, or the underlying IO throws one 
	 */
	public void save2da(String path, boolean allowOverWrite, boolean evenColumns) throws IOException{
		String CRLF = "\r\n";
		if(path == null || path.equals(""))
			path = "." + File.separator;
		
		File file = new File(path + name + ".2da");
		if(file.exists() && !allowOverWrite)
			throw new IOException("File existst already: " + file.getAbsolutePath());
		
		// Inform user
		if(verbose) System.out.print("Saving 2da file: " + name + " ");
		
		FileWriter fw = new FileWriter(file, false);
		String[] labels = this.getLabels();
		String toWrite;
		
		// Get the amount of padding used, if any
		int[] widths = new int[labels.length + 1];
		if(evenColumns){
			ArrayList<String> column;
			int pad;
			for(int i = 0; i < labels.length; i++){
				pad = labels[i].length();
				column = mainData.get(labels[i]);
				for(int j = 0; j < this.getEntryCount(); j++){
					toWrite = column.get(j);
					if(toWrite.indexOf(" ") != -1)
						toWrite = "\"" + toWrite + "\"";
					if(toWrite.length() > pad) pad = toWrite.length();
				}
				/*
				buf = new StringBuffer();
				for(; pad > 0; pad--) buf.append(" ");
				paddings[i] = buf.toString();
				*/
				widths[i] = pad;
			}
			widths[widths.length - 1] = new Integer(this.getEntryCount()).toString().length();
			
			//for(int i = 0; i < widths.length; i++) if(widths[i] > 0) widths[i] -= 2;
		}/*
		else
			for(int i = 0; i < paddings.length; i++) paddings[i] = "";
		*/
		
		// Write the header and default lines
		fw.write("2DA V2.0" + CRLF);
		if(!defaultValue.equals(""))
			fw.write("DEFAULT: " + defaultValue + CRLF);
		else
			fw.write(CRLF);
		
		// Write the labels row using the original case
		for(int i = 0; i < widths[widths.length - 1]; i++) fw.write(" ");
		for(int i = 0; i < realLabels.length; i++){
			fw.write(" " + realLabels[i]);
			for(int j = 0; j < widths[i] - realLabels[i].length(); j++) fw.write(" ");
		}
		fw.write(CRLF);
		
		// Write the data
		for(int i = 0; i < this.getEntryCount(); i++){
			fw.write("" + i);
			for(int j = 0; j < widths[widths.length - 1] - new Integer(i).toString().length(); j++) fw.write(" ");
			for(int j = 0; j < labels.length; j++){
				toWrite = mainData.get(labels[j]).get(i);
				if(toWrite.indexOf(" ") != -1)
					toWrite = "\"" + toWrite + "\"";
				fw.write(" " + toWrite);
				for(int k = 0; k < widths[j] - toWrite.length(); k++) fw.write(" ");
			}
			fw.write(CRLF);
			
			if(verbose) spinner.spin();
		}
		
		fw.flush();
		fw.close();
		
		if(verbose) System.out.println("- Done");
	}
	
	/**
	 * Creates a new Data_2da on the 2da file specified.
	 * 
	 * @param filePath path to the 2da file to load 
	 * @return a Data_2da instance containing the read 2da
	 *  
	 * @throws IllegalArgumentException <code>filePath</code> does not specify a 2da file
	 * @throws TwoDAReadException       reading the 2da file specified does not succeed,
	 *                                    or the file does not contain any data
	 */
	public static Data_2da load2da(String filePath) throws IllegalArgumentException, TwoDAReadException{
		Data_2da toReturn;
		String name, defaultValue = "";
		
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
		//toReturn = new Data_2da(baseFile.getName().substring(0, baseFile.getName().length() - 4));
		
		// Tell the user what we are doing
		if(verbose) System.out.print("Reading 2da file: " + name + " ");
		
		// Create a Scanner for reading the 2da
		Scanner reader = null;
		try{
			// Fully read the file into a byte array
			RandomAccessFile raf = new RandomAccessFile(baseFile, "r");
			byte[] bytebuf = new byte[(int)raf.length()];
			raf.readFully(bytebuf);
			//reader = new Scanner(baseFile);
			reader = new Scanner(new String(bytebuf));
		}catch(Exception e){
			err_pr.println("File operation failed. Aborting.\nException data:\n" + e);
			System.exit(1);
		}
		
		// Check the 2da header
		//String data = getNextNonEmptyRow(reader);
		if(!reader.hasNextLine())
			throw new TwoDAReadException("Empty file: " + name + "!");
		String data = reader.nextLine();
		if(!data.contains("2DA V2.0"))
			throw new TwoDAReadException("2da header missing or invalid: " + name);
		
		// Get the default - though it's not used by this implementation, it should not be lost by opening and resaving a file
		if(!reader.hasNextLine())
			throw new TwoDAReadException("No contents after header in 2da file " + name + "!");
		data = reader.nextLine();
		matcher.reset(data);
		if(matcher.find()){ // Non-blank default line
			data = matcher.group();
			if(data.trim().equalsIgnoreCase("DEFAULT:")){
				if(matcher.find())
					defaultValue = matcher.group();
				else
					throw new TwoDAReadException("Malformed default line in 2da file " + name + "!");
			}
			else
				throw new TwoDAReadException("Malformed default line in 2da file " + name + "!");
		}
		
		// Initialise the return object
		toReturn = new Data_2da(name, defaultValue);
		
		// Start the actual reading
		try{
			toReturn.createData(reader);
		}catch(TwoDAReadException e){
			throw new TwoDAReadException("Exception occurred when reading 2da file: " + toReturn.getName() + "\n" + e, e);
		}
		
		if(verbose) System.out.println("- Done");
		return toReturn;
	}
	
	/**
	 * Reads the data rows from the 2da into the hashmap and
	 * does validity checking on the 2da while doing so.
	 * 
	 * @param reader Scanner that the method reads from 
	 */
	private void createData(Scanner reader){
		Scanner rowParser;
		String data;
		int line = 0;
		
		// Find the labels row
		//String data = getNextNonEmptyRow(reader);
		if(!reader.hasNextLine())
			throw new TwoDAReadException("No labels found in 2da file!");
		data = reader.nextLine();
		
		// Parse the labels
		realLabels = data.trim().split("\\p{javaWhitespace}+");
		String[] labels = new String[realLabels.length];
		System.arraycopy(realLabels, 0, labels, 0, realLabels.length);
		
		// Create the row containers and the main store
		for(int i = 0; i < labels.length; i++){
			labels[i] = labels[i].toLowerCase();
			mainData.put(labels[i],  new ArrayList<String>());
		}
		
		// Error if there are empty lines between the header and the data
		if(!reader.hasNextLine() ||
		   (data = reader.nextLine()).trim().equals(""))
			throw new TwoDAReadException("No data in 2da file or blank lines following labels row!");
		//data = reader.nextLine();
		//if(data.trim)
		
		while(true){
			//rowParser = new Scanner(data);
			matcher.reset(data);
			matcher.find();
			
			// Check for the presence of the row number
			try{
				line = Integer.parseInt(matcher.group());
			}catch(NumberFormatException e){
				throw new TwoDAReadException("Numberless 2da line: " + (line + 1));
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
				data = matcher.group();
				// Remove the surrounding quotes if they are present
				if(data.startsWith("\"")) data = data.substring(1, data.length() - 1);
				mainData.get(labels[i]).add(data);
			}
			
			// Check for too long rows
			if(matcher.find())
				throw new TwoDAReadException("Too long 2da line: " + line);
			
			// Increment the entry counter
			//entries++;
			
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
	 * Reads rows from a Scanner pointed at a 2da file until it finds a
	 * row containing non-whitespace characters.
	 * 
	 * @param reader Scanner that the method reads from
	 *
	 * @return The row found, or null if none were found.
	 */
	private static String getNextNonEmptyRow(Scanner reader){
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
//		return (String[])(mainData.keySet().toArray());
		Object[] temp = mainData.keySet().toArray();
		String[] toReturn = new String[temp.length];
		for(int i = 0; i < temp.length; i++) toReturn[i] = (String)temp[i];
		/*String[] toReturn = (String[])mainData.keySet().toArray();*/
		return toReturn;
	}
	
	/**
	 * Get the 2da entry on the given row and column
	 *
	 * @param label the label of the column to get
	 * @param row   the number of the row to get, as string
	 *
	 * @return String represeting the 2da entry or <code>null</code> if the column does not exist
	 *
	 * @throws NumberFormatException if <code>row</code> cannot be converted to an integer
	 */
	public String getEntry(String label, String row){
		return this.getEntry(label, Integer.parseInt(row));
	}
	
	/**
	 * Get the 2da entry on the given row and column
	 *
	 * @param label the label of the column to get
	 * @param row   the number of the row to get
	 *
	 * @return String represeting the 2da entry or <code>null</code> if the column does not exist
	 */
	public String getEntry(String label, int row){
		ArrayList<String> column = mainData.get(label.toLowerCase());
		return column != null ? column.get(row) : null;
	}
	
	/**
	 * Get number of entries in this 2da. Works by returning the size of one of the columns in the 2da.
	 *
	 * @return integer equal to the number of entries in this 2da
	 */
	public int getEntryCount(){
		Iterator<ArrayList<String>> iter = mainData.values().iterator();
		if(!iter.hasNext())
			return 0;
		return iter.next().size(); 
	}
	
	/**
	 * Get the name of this 2da
	 *
	 * @return String representing this 2da's name
	 */
	public String getName(){
		return name;
	}
	
	/**
	 * Sets the 2da entry on the given row and column
	 *
	 * @param label the label of the column to get
	 * @param row   the number of the row to get, as string
	 * @param entry the new contents of the entry. If this is null or empty, it is replaced with ****
	 *
	 * @throws NumberFormatException if <code>row</code> cannot be converted to an integer
	 */
	public void setEntry(String label, String row, String entry){
		this.setEntry(label, Integer.parseInt(row), entry);
	}
	
	/**
	 * Sets the 2da entry on the given row and column
	 *
	 * @param label the label of the column to get
	 * @param row   the number of the row to get, as string
	 * @param entry the new contents of the entry. If this is null or empty, it is replaced with ****
	 */
	public void setEntry(String label, int row, String entry){
		if(entry == null || entry.equals(""))
			entry = "****";
		mainData.get(label.toLowerCase()).set(row, entry);
	}
	
	/**
	 * Appends a new, empty row to the end of the 2da file, with entries defaulting to ****
	 */
	public void appendRow(){
		String[] labels = this.getLabels();
		
		for(String label : labels){
			mainData.get(label).add("****");
		}
	}
	
	/**
	 * Adds a new, empty row to the given index in the 2da file. The row currently at the index and all
	 * subsequent rows have their index increased by one.
	 * The entries default to ****.
	 * 
	 * @param index the index where the new row will be located
	 * 
	 * @throws NumberFormatException if <code>index</code> cannot be converted to an integer
	 */
	public void insertRow(String index){
		insertRow(Integer.parseInt(index));
	}
	
	/**
	 * Adds a new, empty row to the given index in the 2da file. The row currently at the index and all
	 * subsequent rows have their index increased by one.
	 * The entries default to ****.
	 * 
	 * @param index the index where the new row will be located
	 */
	public void insertRow(int index){
		String[] labels = this.getLabels();
		
		for(String label : labels){
			mainData.get(label).add(index, "****");
		}
	}
	
	/**
	 * Removes the row at the given index. All subsequent rows have their indexed shifted down by one.
	 * 
	 * @param index the index of the row to remove
	 * 
	 * @throws NumberFormatException if <code>index</code> cannot be converted to an integer
	 */
	public void removeRow(String index){
		removeRow(Integer.parseInt(index));
	}
	
	/**
	 * Removes the row at the given index. All subsequent rows have their indexed shifted down by one.
	 * 
	 * @param index the index of the row to remove
	 */
	public void removeRow(int index){
		String[] labels = this.getLabels();
		
		for(String label : labels){
			mainData.get(label).remove(index);
		}
	}
	
	/**
	 * Adds a new column to the 2da file.
	 * 
	 * @param label the name of the column to add
	 */
	public void addColumn(String label){
		ArrayList<String> column = new ArrayList<String>();
		mainData.put(label, column);
		
		for(int i = 0; i < this.getEntryCount(); i++){
			column.add("****");
		}
	}
	
	/**
	 * Removes the column with the given label from the 2da.
	 * 
	 * @param label the name of the column to remove
	 */
	public void removeColumn(String label){
		mainData.remove(label);
	}
	
	
	
	/**
	 * The main method, as usual
	 * 
	 * @param args
	 */
	public static void main(String[] args){
		if(args.length == 0) readMe();
		List<String> fileNames = new ArrayList<String>();
		boolean compare = false;
		boolean resave = false;
		boolean minimal = false;
		boolean ignoreErrors = false;
		boolean readStdin = false;
		
		for(String param : args){//[-crmnqs] file... | -
			// Parameter parseage
			if(param.startsWith("-")){
				if(param.equals("-"))
					readStdin = true;
				else if(param.equals("--help")) readMe();
				else{
					for(char c : param.substring(1).toCharArray()){
						switch(c){
						case 'c':
							compare = true;
							if(resave) resave = false;
							break;
						case 'r':
							resave = true;
							if(compare) compare = false;
							break;
						case 'm':
							minimal = true;
							break;
						case 'n':
							ignoreErrors = true;
							break;
						case 'q':
							verbose = false;
							break;
						case 's':
							spinner.disable();
							break;
						default:
							System.out.println("Unknown parameter: " + c + "!");
							readMe();
						}
					}
				}
			}
			else
				// It's a filename
				fileNames.add(param);
		}
		
		// Read files from stdin is specified
		Scanner scan = new Scanner(System.in);
		while(scan.hasNext())
			fileNames.add(scan.next());
		
		// Run the specified operation
		if(compare){
			Data_2da file1, file2;
			file1 = load2da(args[1]);
			file2 = load2da(args[2]);
			
			doComparison(file1, file2);
		}
		else if(resave){
			Data_2da temp;
			for(String fileName : fileNames){
				try{
					temp = load2da(fileName);
					temp.save2da(new File(fileName).getCanonicalFile().getParent() + File.separator, true, !minimal);
				}catch(Exception e){
					// Print the error
					e.printStackTrace();
					// If ignoring errors, and this error is of expected type, continue
					if(e instanceof IllegalArgumentException ||
					   e instanceof TwoDAReadException ||
					   e instanceof IOException)
						if(ignoreErrors)
							continue;
					System.exit(1);
				}
			}
		}
		else{
			// Validify by loading
			for(String fileName : fileNames){
				try{
					load2da(fileName);
				}catch(Exception e){
					// Print the error
					e.printStackTrace();
					// If ignoring errors, and this error is of expected type, continue
					if(e instanceof IllegalArgumentException || e instanceof TwoDAReadException)
						if(ignoreErrors)
							continue;
					System.exit(1);
				}
			}
		}
	}
	
	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "  [-crmnqs] file... | -\n"+
		                   "\n"+
		                   "  -c    prints the differing lines between the 2das given as first two\n"+
		                   "        parameters. They must have the same label set and entrycount.\n" +
		                   "        Mutually exclusive with -r\n"+
						   "  -r    resaves the 2das given as parameters. Mutually exclusive with -c\n"+
						   "  -m    saves the files with minimal spaces. Only relevant when resaving\n"+
		                   "  -n    ignores errors that occur during validity testing and resaving,\n" +
		                   "        just skips to the next file\n"+
		                   "  -q    quiet mode\n"+
		                   "  -s    no spinner\n"+
		                   "  -     a line given as a lone parameter means that the list of files is\n" +
		                   "        read from stdin in addition to the ones passed from command line\n"+
						   "\n"+
						   "  --help  prints this text\n"+
						   "\n"+
						   "\n"+
						   "if neither -c or -r is specified, performs validity testing on the given files"
		                   );
		System.exit(0);
	}
	
	/**
	 * Compares the given two 2da files and prints differences it finds
	 * Differing number of rows, or row names will cause comparison to abort.
	 *
	 * @param file1  Data_2da containing one of the files to be compared
	 * @param file2  Data_2da containing the other file to be compared
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