/*
 * HakFile.java
 *
 * Created on March 9, 2003, 10:12 AM
 */

package CharacterCreator.key;

import CharacterCreator.io.Byteconvert;
import CharacterCreator.io.Filereader;
import CharacterCreator.key.*;
import java.io.*;
import java.util.*;
/**
 *
 * @author  James
 */
public class HakFile {
    
    /** Creates a new instance of HakFile */
    public HakFile(String HakFile) throws IOException {
		if (HakFile == null)
			throw new IOException();

        File hakfileptr = new File(HakFile);
		if(!hakfileptr.exists())
			throw new IOException();
        
        //filename = hakfileptr.getName();
        filename = HakFile;
        hak = new RandomAccessFile(hakfileptr, "r");
        String signature = Filereader.readString(hak, 4);
        String version = Filereader.readString(hak, 4);
        if((!signature.equals("HAK ")) || (!version.equals("V1.0"))) {
            //System.out.println("File is not a valid HAK file.");
            throw new IOException();
        } else {
            //System.out.println("File is a valid HAK file.");
        }
        int numstrings = 0;
        numstrings = Filereader.readInt(hak); // NOT USED
        //System.out.println("Number of strings in description: " + numstrings);
        int strlength = 0;
        strlength = Filereader.readInt(hak); // NOT USED
        numresources = 0;
        numresources = Filereader.readInt(hak); // Retrieves the number of resources in file
        //System.out.println("Number of resources in hak file: " + numresources);
        int stroffset = 0;
        stroffset = Filereader.readInt(hak); // NOT USED
        resoffset = 0;
        resoffset = Filereader.readInt(hak); // Resource name offset
        posoffset = 0;
        posoffset = Filereader.readInt(hak); // Offset position of first resource
        // END of info required; there are still some records remaining, but are not needed
        hak.seek(resoffset);
		HAKMap = new HashMap();
        for(int i = 0; i < numresources; i++) {
            int offset = resoffset + 24 * i;
            String resname = (String)Filereader.readString(hak,16);
            resname = resname.trim();
            int resindex = Filereader.readInt(hak);
            int restype = Filereader.readInt(hak);

			// Don't overwrite keys.  Haks will be instantiated by priority
			HAKMap.put(resname.toLowerCase() + "." + getExtension(restype),new HakResource(resname,resindex,restype));
        }
		hak.close();
    }
    
    //    public byte[] getdataatindex(int index) {
    //
    //    }
    
    //    public int getindex() {
    //        return index;
    //    }
    
    public int getposoffset() {
        return posoffset;
    }
    
    public String getHAKname() {
        return filename;
    }
    
    public int getHAKlength() {
        return filelength;
    }

	public static String getExtension(int type) {
		String ext = (String)endmap.get(new Integer(type));
		if (ext != null)
			ext = ext.toLowerCase();

        return ext;
    }
 
    public boolean FileExists(String filename) {
        if (HAKMap != null && HAKMap.containsKey(filename.toLowerCase()))
            return true;

		return false;
    }
    
    private int posoffset;
    private int numresources;
    //    private int index;
    private int filelength;
    private int resoffset;
    private short stringlength;
    private String filename;
    public Map HAKMap;
    //public static Map resourcemap = new HashMap();
    //public File hak;
    RandomAccessFile hak;
    private static Map endmap;
    
    static {
        endmap = new HashMap();
        endmap.put(new Integer(0), "RES");
        endmap.put(new Integer(1), "BMP");
        endmap.put(new Integer(2), "MVE");
        endmap.put(new Integer(3), "TGA");
        endmap.put(new Integer(4), "WAV");
        endmap.put(new Integer(6), "PLT");
        endmap.put(new Integer(7), "INI");
        endmap.put(new Integer(2002), "MDL");
        endmap.put(new Integer(2009), "NSS");
        endmap.put(new Integer(2010), "NCS");
        endmap.put(new Integer(2011), "MOD");
        endmap.put(new Integer(2012), "ARE");
        endmap.put(new Integer(2013), "SET");
        endmap.put(new Integer(2014), "IFO");
        endmap.put(new Integer(2015), "BIC");
        endmap.put(new Integer(2016), "WOK");
        endmap.put(new Integer(2017), "2DA");
        endmap.put(new Integer(2029), "DLG");
        endmap.put(new Integer(2022), "TXI");
        endmap.put(new Integer(2023), "GIT");
        endmap.put(new Integer(2025), "UTI");
        endmap.put(new Integer(2026), "BTI");
        endmap.put(new Integer(2027), "UTC");
        endmap.put(new Integer(2030), "ITP");
        endmap.put(new Integer(2032), "UTT");
        endmap.put(new Integer(2033), "DDS");
        endmap.put(new Integer(2035), "UTS");
        endmap.put(new Integer(2036), "LTR");
        endmap.put(new Integer(2037), "GFF");
        endmap.put(new Integer(2038), "FAC");
        endmap.put(new Integer(2039), "BTE");
        endmap.put(new Integer(2040), "UTE");
        endmap.put(new Integer(2041), "BTD");
        endmap.put(new Integer(2042), "UTD");
        endmap.put(new Integer(2043), "BTP");
        endmap.put(new Integer(2044), "UTP");
        endmap.put(new Integer(2045), "DTF");
        endmap.put(new Integer(2046), "GIC");
        endmap.put(new Integer(2047), "GUI");
        endmap.put(new Integer(2048), "CSS");
        endmap.put(new Integer(2049), "CCS");
        endmap.put(new Integer(2050), "BTM");
        endmap.put(new Integer(2051), "UTM");
        endmap.put(new Integer(2052), "DWK");
        endmap.put(new Integer(2053), "PWK");
        endmap.put(new Integer(2054), "BTG");
        endmap.put(new Integer(2055), "UTG");
        endmap.put(new Integer(2056), "JRL");
        endmap.put(new Integer(2057), "SAV");
        endmap.put(new Integer(2058), "UTW");
        endmap.put(new Integer(2059), "4PC");
        endmap.put(new Integer(2060), "SSF");
        endmap.put(new Integer(10), "TXT");
    }
}
