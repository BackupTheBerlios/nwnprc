/*
 * KeyFile.java
 *
 * Created on February 23, 2003, 6:15 PM
 */

package CharacterCreator.key;

import CharacterCreator.io.Byteconvert;
import CharacterCreator.io.Filereader;
import java.io.*;
import java.util.*;
import java.util.prefs.Preferences;
import javax.swing.JOptionPane;

// Referenced classes of package CharacterCreator.key:
//            BIFFile, ResourceFile

public class PatchKeyFile
{

    public PatchKeyFile()
    {
    }

    public void KeyFile()
        throws IOException
    {
        Preferences prefs = Preferences.userRoot().node("/CharacterCreator");
        String NWNDir = prefs.get("GameDir", null);
        if(NWNDir == null || !(new File(NWNDir)).exists())
        {
            if(NWNDir == null)
                System.out.println("NULL NWNDIR.");
            if(!(new File(NWNDir)).exists())
                System.out.println("NWNDIR doesn't exist.");
            JOptionPane.showMessageDialog(null, "Fatal Error - No NWN Installation found. Rerun Settings.", "Error", 0);
            System.exit(0);
        }
        if(!(new File(NWNDir, keyname)).exists())
        {
            JOptionPane.showMessageDialog(null, "Fatal Error - Patch.key missing. Rerun Settings, or patch NWN to current version.", "Error", 0);
            System.exit(0);
        }
        keyfile = new File(NWNDir, keyname);
        BufferedInputStream is = new BufferedInputStream(new FileInputStream(keyfile));
        byte buffer[] = Filereader.readBytes(is, (int)keyfile.length());
        is.close();
        signature = new String(buffer, 0, 4);
        version = new String(buffer, 4, 4);
        if(!signature.equals("KEY ") || !version.equals("V1  "))
        {
            JOptionPane.showMessageDialog(null, "Unsupported keyfile: " + keyfile, "Error", 0);
            throw new IOException();
        }
        int numbif = Byteconvert.convertInt(buffer, 8);
        int numres = Byteconvert.convertInt(buffer, 12);
        int bifoff = Byteconvert.convertInt(buffer, 16);
        int resoff = Byteconvert.convertInt(buffer, 20);
		BIFmap = new BIFFile[numbif];
        for(int i = 0; i < numbif; i++)
        {
            int offset = bifoff + 12 * i;
			BIFmap[i] = new BIFFile(i, buffer, offset);
        }

        for(int i = 0; i < numres; i++)
        {
            int offset = resoff + 22 * i;
            ResourceFile res = new ResourceFile(i, buffer, offset);
            resourcemap.put(res.getfilename() + "." + getExtension(res.gettype()), res);
        }

    }

    public static int getExtensionType(String extension)
    {
        for(Iterator i = endmap.keySet().iterator(); i.hasNext();)
        {
            Integer type = (Integer)i.next();
            if(((String)endmap.get(type)).equalsIgnoreCase(extension))
                return type.intValue();
        }

        return -1;
    }
    
    public boolean testkey() {
        Preferences prefs = Preferences.userRoot().node("/CharacterCreator");
        String NWNDir = prefs.get("GameDir", null);
        if(NWNDir == null || !(new File(NWNDir)).exists())
        {
            if(NWNDir == null)
                System.out.println("NULL NWNDIR.");
            if(!(new File(NWNDir)).exists())
                System.out.println("NWNDIR doesn't exist.");
            JOptionPane.showMessageDialog(null, "Fatal Error - No NWN Installation found. Rerun Settings.", "Error", 0);
            System.exit(0);
        }
        if(!(new File(NWNDir, keyname)).exists())
        {
            return false;
            //JOptionPane.showMessageDialog(null, "Fatal Error - Patch.key missing. Rerun Settings, or patch NWN to current version.", "Error", 0);
            //System.exit(0);
        } else {
            return true;
        }
    }
    
	public static String getExtension(int type) {
		String ext = (String)endmap.get(new Integer(type));
		if (ext != null)
			ext = ext.toLowerCase();

        return ext;
    }


    public static final String keyname = "patch.key";
    public File keyfile;
    private static Map endmap;
    public static BIFFile[] BIFmap;
    public static Map resourcemap = new HashMap();
    private String signature;
    private String version;

    static 
    {
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
