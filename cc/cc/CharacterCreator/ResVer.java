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
        infomap.put("c089f104", "down.gif");

        infomap.put("7296477f", "folder.gif");
        infomap.put("90b3b8ef", "isk_aniemp.jpg");
        infomap.put("2da2c1b8", "minus1.gif");
        infomap.put("7db0328a", "plus1.gif");
        infomap.put("38180a17", "portrait2.jpg");
        infomap.put("8dcb419e", "portrait.jpg");
        infomap.put("426e2601", "Save16.gif");

        infomap.put("1f2758e7", "charpic.jpg");
        infomap.put("d0f36592", "charpic2.jpg");
        infomap.put("7fa9720e", "creditspic.jpg");
        infomap.put("dd410937", "creditspic2.jpg");
        infomap.put("459e3138", "exitpic.jpg");
        infomap.put("74516779", "exitpic2.jpg");
        infomap.put("1f307eb2", "settingspic.jpg");
        infomap.put("bb3333bd",  "settingspic2.jpg");

        infomap.put("e2bc6bfa", "splashbottom.jpg");
        infomap.put("62546e2f", "splashleft.jpg");
        infomap.put("77ebf74d", "splashmiddle1.jpg");
        infomap.put("4f0d259c", "splashmiddle2.jpg");
        infomap.put("3e65c9ed", "splashmiddle3.jpg");
        infomap.put("dba62976", "splashright.jpg");
        infomap.put("e39573c4", "splashtop.jpg");

        infomap.put("4ba1372d", "Undo16.gif");
        infomap.put("c3d69a14", "first.gif");
        infomap.put("debfcf5", "last.gif");
        infomap.put("88119533", "forward.gif");
        infomap.put("19722224", "back.gif");
    }
}
