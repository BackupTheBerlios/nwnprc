/*
 * CRC.java
 *
 * Created on October 13, 2003, 1:23 PM
 */

package CharacterCreator.util;

/**
 *
 * @author  James
 */
import java.io.*;
import java.net.*;
import java.util.zip.CRC32;
import java.util.zip.CheckedInputStream;

public class CKSum {
    
    CKSum() {
    }
    
    
    public static CRC32 getCRC(File filename) {
        CRC32 crc32 = new CRC32();
        try {
            byte byte0 = 5;
            //File file = new File(filename);
            FileInputStream fileinputstream = new FileInputStream(filename);
            for(CheckedInputStream checkedinputstream = new CheckedInputStream(fileinputstream, crc32); checkedinputstream.read() != -1;);
            System.out.println(filename.getName() + ": Cksum=" + crc32.getValue());
        }
        catch(Exception e) {
            System.out.println("File not found. /nError: " + e);
        }
        return crc32;
    }
    
    public static CRC32 getCRC(URL filename) {
        CRC32 crc32 = new CRC32();
        try {
            byte byte0 = 5;
            //File file = new File(filename);
            InputStream fileinputstream = filename.openStream();
            for(CheckedInputStream checkedinputstream = new CheckedInputStream(fileinputstream, crc32); checkedinputstream.read() != -1;);
            //System.out.println(filename.getFile() + ": Cksum=" + crc32.getValue());
        }
        catch(Exception e) {
            System.out.println("File not found.");
        }
        return crc32;
    }    
}
