/*
 * HakResource.java
 *
 * Created on March 10, 2003, 12:13 AM
 */

package CharacterCreator.key;

import java.util.*;
/**
 *
 * @author  James
 */
public class HakResource {
    
    /** Creates a new instance of HakResource */
    public HakResource(String name, int index, int extension) {
        resname = name;
        resindex = index;
        extnum = extension;
    }
    
    public int getindex() {
        return resindex;
    }
    
    public int getintextension() {
        return extnum;
    }
    
    public String getstrextension() {
        return (String)extmap.get(new Integer(extnum));
    }
    
    public String getfullfilename() {
        String ext = (String)extmap.get(new Integer(extnum));
        String fullfilename = resname + "." + ext;
        return fullfilename;
    }
    
    private int resindex;
    private String resname;
    private int extnum;
    private static Map extmap;    
    static 
    {
        extmap = new HashMap();
        extmap.put(new Integer(0), "RES");
        extmap.put(new Integer(1), "BMP");
        extmap.put(new Integer(2), "MVE");
        extmap.put(new Integer(3), "TGA");
        extmap.put(new Integer(4), "WAV");
        extmap.put(new Integer(6), "PLT");
        extmap.put(new Integer(7), "INI");
        extmap.put(new Integer(2002), "MDL");
        extmap.put(new Integer(2009), "NSS");
        extmap.put(new Integer(2010), "NCS");
        extmap.put(new Integer(2011), "MOD");
        extmap.put(new Integer(2012), "ARE");
        extmap.put(new Integer(2013), "SET");
        extmap.put(new Integer(2014), "IFO");
        extmap.put(new Integer(2015), "BIC");
        extmap.put(new Integer(2016), "WOK");
        extmap.put(new Integer(2017), "2DA");
        extmap.put(new Integer(2029), "DLG");
        extmap.put(new Integer(2022), "TXI");
        extmap.put(new Integer(2023), "GIT");
        extmap.put(new Integer(2025), "UTI");
        extmap.put(new Integer(2026), "BTI");
        extmap.put(new Integer(2027), "UTC");
        extmap.put(new Integer(2030), "ITP");
        extmap.put(new Integer(2032), "UTT");
        extmap.put(new Integer(2033), "DDS");
        extmap.put(new Integer(2035), "UTS");
        extmap.put(new Integer(2036), "LTR");
        extmap.put(new Integer(2037), "GFF");
        extmap.put(new Integer(2038), "FAC");
        extmap.put(new Integer(2039), "BTE");
        extmap.put(new Integer(2040), "UTE");
        extmap.put(new Integer(2041), "BTD");
        extmap.put(new Integer(2042), "UTD");
        extmap.put(new Integer(2043), "BTP");
        extmap.put(new Integer(2044), "UTP");
        extmap.put(new Integer(2045), "DTF");
        extmap.put(new Integer(2046), "GIC");
        extmap.put(new Integer(2047), "GUI");
        extmap.put(new Integer(2048), "CSS");
        extmap.put(new Integer(2049), "CCS");
        extmap.put(new Integer(2050), "BTM");
        extmap.put(new Integer(2051), "UTM");
        extmap.put(new Integer(2052), "DWK");
        extmap.put(new Integer(2053), "PWK");
        extmap.put(new Integer(2054), "BTG");
        extmap.put(new Integer(2055), "UTG");
        extmap.put(new Integer(2056), "JRL");
        extmap.put(new Integer(2057), "SAV");
        extmap.put(new Integer(2058), "UTW");
        extmap.put(new Integer(2059), "4PC");
        extmap.put(new Integer(2060), "SSF");
        extmap.put(new Integer(10), "TXT");
    }    
}
