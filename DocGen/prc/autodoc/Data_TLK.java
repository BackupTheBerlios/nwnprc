package prc.autodoc;

import java.io.*;
import java.util.*;

import static prc.autodoc.Main.*;

/**
 * This class forms an interface for accessing TLK files in the
 * PRC automated manual generator.
 */
public class Data_TLK{
	private HashMap<Integer, String> mainData = new HashMap<Integer, String>();
	
	
	/**
	 * Creates a new Data_TLK on the TLK file specified.
	 *
	 * @param filePath The path of the TLK file to be loaded
	 *
	 * @throws IllegalArgumentException  fileName does not filePath a TLK file
	 * @throws TLKReadException          reading the TLK file specified does not succeed
	 */
	public Data_TLK(String filePath) throws Exception{
		// Some paranoia checking for bad parameters
		if(!filePath.toLowerCase().endsWith("tlk"))
			throw new IllegalArgumentException("Non-tlk filename passed to Data_TLK: " + filePath);
		
		File baseFile = new File(filePath);
		if(!baseFile.exists())
			throw new IllegalArgumentException("Nonexistent file passed to Data_TLK: " + filePath);
		if(!baseFile.isFile())
			throw new IllegalArgumentException("Nonfile passed to Data_TLK: " + filePath);
		
		
		// Create a RandomAccessFile for reading the TLK. Read-only
		RandomAccessFile reader = new RandomAccessFile(baseFile, "r");
		byte[] bytes4 = new byte[4],
		       bytes8 = new byte[8];
		
		// Drop the path from the filename
		String fileName = baseFile.getName();
		
		// Tell the user what we are doing
		if(verbose) System.out.print("Reading TLK file: " + fileName + " ");
		
		// Check the header
		reader.readFully(bytes4);
		if(!new String(bytes4).equals("TLK "))
			throw new TLKReadException("Wrong file type field in: " + fileName);
		
		// Check the version
		reader.readFully(bytes4);
		if(!new String(bytes4).equals("V3.0"))
			throw new TLKReadException("Wrong TLK version number in: " + fileName);
		
		// Skip the language ID
		reader.skipBytes(4);
		
		// Read the entrycount
		int stringCount  = readLittleEndianInt(reader, bytes4);
		int stringOffset = readLittleEndianInt(reader, bytes4);
		
		try{
			// Read the entry lengths
			int[] stringLengths = readStringLengths(reader, stringCount);
		
			// Read the strings themselves
			readStrings(reader, stringLengths, stringOffset);
		}catch(IOException e){
			throw new TLKReadException("IOException while reading TLK file: " + fileName, e);
		}
		
		if(verbose) System.out.println("- Done");
	}
	
	
	/**
	 * Get the given TLK entry.
	 *
	 * @param strRef  the number of the entry to get
	 * 
	 * @return the entry string or "Bad StrRef" if the entry wasn't in the TLK
	 */
	public String getEntry(int strRef){
		if(strRef > 0x01000000) strRef -= 0x01000000;
		String toReturn = mainData.get(strRef);
		if(toReturn == null) toReturn = "Bad StrRef";
		return toReturn;
	}
	
	/**
	 * Reads the string lengths from this TLK's string data elements.
	 *
	 * @param reader       RandomAccessFile read from
	 * @param stringCount  number of strings in the TLK
	 *
	 * @return an array of integers containing the lengths of the strings in this TLK
	 */
	private int[] readStringLengths(RandomAccessFile reader, int stringCount) throws IOException{
		int[] toReturn = new int[stringCount];
		byte[] bytes4 = new byte[4];
		int curOffset = 20; // The number of bytes in the TLK header section
		
		for(int i = 0; i < stringCount; i++){
			// Skip everything up to the length
			curOffset += 32;
			reader.seek(curOffset);
			// Read the value
			toReturn[i] = readLittleEndianInt(reader, bytes4);
			// Skip to the end of the record
			curOffset += 8;
			
			if(verbose) spinner.spin();
		}
		return toReturn;
	}
	
	/**
	 * Reads the strings from the TLK into the hashmap.
	 *
	 * @param reader         RandomAccessFile read from
	 * @param stringLengths  an array of integers containing the lengths of the strings in this TLK
	 * @param curOffset      the offset to start reading from in the file
	 */
	private void readStrings(RandomAccessFile reader, int[] stringLengths, int curOffset) throws IOException{
		StringBuffer buffer = new StringBuffer(200);
		reader.seek(curOffset);
		
		for(int i = 0; i < stringLengths.length; i++){
			if(stringLengths[i] > 0){
				// Read the specified number of bytes, convert them into chars
				// and put them in the buffer
				for(int j = 0; j < stringLengths[i]; j++)
					buffer.append((char)(reader.readByte() & 0xff));
				// Store the buffer contents
				mainData.put(i, buffer.toString());
				// Wipe the buffer for next round
				buffer.delete(0, buffer.length());
			}
			if(verbose) spinner.spin();
		}	
	}
	
	/**
	 * Reads the next 4 bytes into the given array from the TLK and then
	 * writes them into an integer in inverse order.
	 *
	 * @param reader     RandomAccessFile read from
	 * @param readArray  array of bytes read to. For efficiency of not having to create a new array every time
	 *
	 * @return integer read
	 */
	private int readLittleEndianInt(RandomAccessFile reader, byte[] readArray) throws IOException{
		int toReturn = 0;
		reader.readFully(readArray);
		for(int i = readArray.length - 1; i >= 0; i--){
			// What's missing here is the implicit promotion of readArray[i] to
			// int. A byte is a signed element, and as such, has max value of 0x7f.
			toReturn = (toReturn << 8) | readArray[i] & 0xff; 
		}
		return toReturn;
	}
	
	public static void main(String[] args) throws Exception{
		Data_TLK test = new Data_TLK(args[0]);
	}
}