/*
 * ResVer.java
 *
 * This is the verification checks to make sure the files are what they should be
 *
 * Created on October 13, 2003, 4:20 PM
 */

package CharacterCreator;

import CharacterCreator.util.CKSum;
import java.util.zip.CRC32;
import java.util.*;
import java.net.*;
import javax.swing.JOptionPane;
/**
 *
 * @author  James
 */
public class ResVer {
    
    /** Creates a new instance of ResVer */
    public ResVer() {
    }
    
    public int VerifyResources() {
        for(Iterator i = infomap.keySet().iterator(); i.hasNext();)
        {
            String key = (String)i.next();
            //if(((String)infomap.get(type)).equalsIgnoreCase(extension))
            //    return type.intValue();
            String name = (String)infomap.get(key);
            //System.out.println(key + " : " + name);
            String resname = "/CharacterCreator/resource/"+name;
            URL resurl = getClass().getResource(resname);
            CRC32 test = CKSum.getCRC(resurl);
            if(!((String)Long.toHexString(test.getValue())).equalsIgnoreCase(key)) {
                JOptionPane.showMessageDialog(null, "Fatal Error - Resource files corrupt. Please download a fresh copy of the CharacterCreator.\nError in file: " + name +", looking for "+key+", found "+test.getValue(), "Error", 0);
                System.exit(0);                
                //System.out.println("Error: "+name+" has incorrect CRC.");
                //System.out.println("File CRC: "+(String)Long.toHexString(test.getValue()));
                //System.out.println("Required CRC: "+key);
                return -1;
            }
        }

        return 1;        
    }    
    
    private CRC32 crc;
    private static HashMap infomap;
    static 
    {   
        infomap = new HashMap();
        //Place any file you want checked here, along with 32 bit CRC
        infomap.put("57539486", "up.gif");
        infomap.put("97efb60e", "blank.jpg");
        infomap.put("51a66b49", "charpic.jpg");
        infomap.put("8316d30c", "creditspic.jpg");
        infomap.put("c089f104", "down.gif");
        infomap.put("62c2c70c", "exitpic.jpg");
        infomap.put("7296477f", "folder.gif");
        infomap.put("90b3b8ef", "isk_aniemp.jpg");
        infomap.put("2da2c1b8", "minus1.gif");
        infomap.put("7db0328a", "plus1.gif");
        infomap.put("38180a17", "portrait2.jpg");
        infomap.put("8dcb419e", "portrait.jpg");
        infomap.put("426e2601", "Save16.gif");
        infomap.put("28263ad", "settingspic.jpg");
        infomap.put("158d408f", "splashbottom.jpg");
        infomap.put("93d6d481", "splashleft.jpg");
        infomap.put("81506415", "splashmiddle1.jpg");
        infomap.put("edb96b35", "splashmiddle2.jpg");
        infomap.put("69487730", "splashmiddle3.jpg");
        infomap.put("e79973c7", "splashright.jpg");
        infomap.put("1bc2c478", "splashtop.jpg");
        infomap.put("4ba1372d", "Undo16.gif");
        infomap.put("c3d69a14", "first.gif");
        infomap.put("debfcf5", "last.gif");
        infomap.put("88119533", "forward.gif");
        infomap.put("19722224", "back.gif");
    }
}
