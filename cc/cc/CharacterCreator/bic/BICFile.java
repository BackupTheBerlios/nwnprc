/*
 * BICFile.java
 *
 * Created on March 10, 2003, 11:34 PM
 */

package CharacterCreator.bic;

import CharacterCreator.bic.*;
import CharacterCreator.bic.BICElement;
import CharacterCreator.bic.BICEntry;
import CharacterCreator.io.*;
import java.io.*;
import java.util.*;
import java.util.HashMap;
import java.util.Map;
import java.util.prefs.Preferences;
import javax.swing.*;

/**
 *
 * @author  James
 */
public class BICFile {
    
    /** Creates a new instance of BICFile */
    public void BICFile() {
        //Initialization of all maps
        //System.out.println("Initialization of BIC");
        ElementMap = new LinkedList();
        EntryMap = new LinkedList();
        VarName = new LinkedList();
        MultiMap = new LinkedList();
        MultiMap2 = new LinkedList();
        Lists = new LinkedList();
        Listlists = new LinkedList();
        MMEntries = new LinkedList();
        VarData = new byte[0];
        entryoffset = 0;
        entrynum = 0;
        elementoffset = 0;
        elementnum = 0;
        varnameoffset = 0;
        vardataendoffset = 0;
        varnamenum = 0;
        vardataoffset = 0;
        vardatabytes = 0;
        multimapoffset = 0;
        multimapbytes = 0;
        listoffset = 0;
        numlists = 0;
        listbytes = 0;
        //if(!Lists.isEmpty()) Lists.clear();
        //if(!MultiMap.isEmpty()) MultiMap.clear();
        //if(!VarName.isEmpty()) VarName.clear();
        
        //The first entry is a zero entry
        addBICEntry(-1, 0, 0);
        //The above entry will be updated with how many elements are in the file.
    }
    
    public void addVarname(String name) {
        VarName.add(name);
        varnamenum++;
        return;
    }
    /**
     *This creates a new entry in the BIC. Use addElement() instead.
     */
    public void addBICEntry(int entitycode, int offset, int numelements) {
        entrynum++;
        EntryMap.add(new BICEntry(entitycode,offset,numelements));
        return;
    }
    
    /**
     *This changes the entry specified, and updates it with new data.
     */
    public void changeEntry(int entry, int entitycode, int offset, int numelements) {
        EntryMap.set(entry, new BICEntry(entitycode,offset,numelements));
        return;
    }
    
    public BICEntry getBICEntry(int entry) {
        return (BICEntry)EntryMap.get(entry);
    }
    /**
     *This creates a new element in the BIC - This is ONLY for base elements!
     *@param type This dictates the type of value used, as listed below:
     * 0 UINT8 Direct Unsigned byte
     * 1 INT8 Direct Signed byte
     * 2 UINT16 Direct Unsigned word
     * 3 INT16 Direct Signed word
     * 4 UINT32 Direct Unsigned longword
     * 5 INT32 Direct Signed longword
     * 6 UINT64 Indirect Unsigned quadword
     * 7 INT64 Indirect Signed quadword
     * 8 FLOAT Indirect Four byte floating point value
     * 9 DOUBLE Indirect Eight byte floating point value
     * 10 STRING Indirect Counted string
     * 11 RESREF Indirect Counted resource name
     * 12 STRREF Complex Multilingual capable string
     * 13 DATREF Complex Counted binary data
     * 14 CAPREF Complex List of child elements
     * 15 LIST Complex List of child entries
     *@param index Which variable this element uses on the variable list.
     *@param stuff The actual data
     */
    public void addElementToEntry(int targentry, int type, int index, Object stuff) {
        
        //SPECIFICALLY:
        // UINT8 & INT8 are Short
        // UINT16 & INT16 are Integer
        // UINT32 & INT32 are Long
        // UINT64 & INT64 NOT SUPPORTED (INDIRECT NUMBER!)
        // Float is Float
        // Double is Double
        if(type == 0 || type == 1) {  //UINT8 & INT8
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        if(type == 2 || type == 3) {  //UINT16 & INT16
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        if(type == 4 || type == 5) {  //UINT32 & INT32
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        if(type == 6 || type == 7) {
            System.out.println("UINT64 & INT64 Not supported");
            return;
        }
        if(type == 8) {   //FLOAT
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        if(type == 9) {   //DOUBLE
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        if(type == 10) {   //STRING
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            ElementMap.add(elementnum++, new BICElement(type, index, new Integer(vardataendoffset)));
            String tmpstrng = (String)stuff;
            byte[] tmpstrref = new byte[0];
            tmpstrng.trim();
            int strsz = tmpstrng.length();
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(strsz));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, tmpstrng.getBytes());
            vardataendoffset = vardataendoffset + tmpstrref.length;
            VarData = ArrayUtil.mergeArrays(VarData, tmpstrref);
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        if(type == 11) {   //RESREF
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            ElementMap.add(elementnum++, new BICElement(type, index, new Integer(vardataendoffset)));
            String tmpstrng = (String)stuff;
            byte[] tmpstrref = new byte[0];
            tmpstrng.trim();
            byte strsz = new Integer(tmpstrng.length()).byteValue();
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(strsz));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, tmpstrng.getBytes());
            vardataendoffset = vardataendoffset + tmpstrref.length;
            VarData = ArrayUtil.mergeArrays(VarData, tmpstrref);
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        if(type == 12) {   //STRREF
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            ElementMap.add(elementnum++, new BICElement(type, index, new Integer(vardataendoffset)));
            String tmpstrng = (String)stuff;
            byte[] tmpstrref = new byte[0];
            int numbytes = 0;
            int tlkid = 0xFFFFFFFF;
            int numstrs = 1;
            int language = 0;
            tmpstrng.trim();
            int strsz = tmpstrng.length();
            numbytes = 16 + strsz;
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(numbytes));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(tlkid));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(numstrs));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(language));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(strsz));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, tmpstrng.getBytes());
            vardataendoffset = vardataendoffset + tmpstrref.length;
            VarData = ArrayUtil.mergeArrays(VarData, tmpstrref);
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        if(type == 13) {   //DATREF
            System.out.println("DATREF Not supported");
            return;
        }
        if(type == 14) {   //CAPREF
            System.out.println("CAPREF Not supported");
            return;
        }
        if(type == 15) {   //LIST
            if(targentry == 0) {
                MultiMap.add(new Integer(elementnum));
            } else {
                MultiMap2.add(new Integer(elementnum));
            }
            Lists.add(new Integer(0));
            Listlists.add(new Integer(Lists.size() - 1));
            ElementMap.add(elementnum++, new BICElement(type, index, new Integer(Lists.size() - 1)));
            
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
            return;
        }
        // String
        // Resref
        // Strref
        // Datref
        // Capref
        // List should use the addBICList
        // Separate entries for each type, or each group of types
        return;
    }
    
    public void addNONMMElementToEntry(int targentry, int type, int index, Object stuff) {
        
        //SPECIFICALLY:
        // UINT8 & INT8 are Short
        // UINT16 & INT16 are Integer
        // UINT32 & INT32 are Long
        // UINT64 & INT64 NOT SUPPORTED (INDIRECT NUMBER!)
        // Float is Float
        // Double is Double
        if(type == 0 || type == 1) {  //UINT8 & INT8
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            return;
        }
        if(type == 2 || type == 3) {  //UINT16 & INT16
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            return;
        }
        if(type == 4 || type == 5) {  //UINT32 & INT32
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            return;
        }
        if(type == 6 || type == 7) {
            System.out.println("UINT64 & INT64 Not supported");
            return;
        }
        if(type == 8) {   //FLOAT
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            return;
        }
        if(type == 9) {   //DOUBLE
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, stuff));
            return;
        }
        if(type == 10) {   //STRING
            String tmpstrng = (String)stuff;
            byte[] tmpstrref = new byte[0];
            tmpstrng.trim();
            int strsz = tmpstrng.length();
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(strsz));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, tmpstrng.getBytes());
            vardataendoffset = vardataendoffset + tmpstrref.length;
            VarData = ArrayUtil.mergeArrays(VarData, tmpstrref);
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, new Integer(vardataendoffset)));
            return;
        }
        if(type == 11) {   //RESREF
            String tmpstrng = (String)stuff;
            byte[] tmpstrref = new byte[0];
            tmpstrng.trim();
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, new Integer(vardataendoffset)));            
            byte strsz = new Integer(tmpstrng.length()).byteValue();
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(strsz));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, tmpstrng.getBytes());
            vardataendoffset = vardataendoffset + tmpstrref.length;
            VarData = ArrayUtil.mergeArrays(VarData, tmpstrref);
            return;
        }
        if(type == 12) {   //STRREF
            String tmpstrng = (String)stuff;
            byte[] tmpstrref = new byte[0];
            int numbytes = 0;
            int tlkid = 0xFFFFFFFF;
            int numstrs = 1;
            int language = 0;
            tmpstrng.trim();
            int strsz = tmpstrng.length();
            numbytes = 16 + strsz;
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(numbytes));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(tlkid));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(numstrs));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(language));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, Byteconvert.convertBack(strsz));
            tmpstrref = ArrayUtil.mergeArrays(tmpstrref, tmpstrng.getBytes());
            vardataendoffset = vardataendoffset + tmpstrref.length;
            VarData = ArrayUtil.mergeArrays(VarData, tmpstrref);
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, new Integer(vardataendoffset)));
            return;
        }
        if(type == 13) {   //DATREF
            System.out.println("DATREF Not supported");
            return;
        }
        if(type == 14) {   //CAPREF
            System.out.println("CAPREF Not supported");
            return;
        }
        if(type == 15) {   //LIST
            Lists.add(new Integer(0));
            Listlists.add(new Integer(Lists.size() - 1));
            BICEntry tmpbic = getBICEntry(targentry);
            changeEntry(targentry, tmpbic.getcode(), elementnum, tmpbic.getnum() + 1);
            ElementMap.add(elementnum++, new BICElement(type, index, new Integer(Lists.size() - 1)));
            return;
        }
        // String
        // Resref
        // Strref
        // Datref
        // Capref
        // List should use the addBICList
        // Separate entries for each type, or each group of types
        return;
    }    
    
    // This adds an element to the selected list.
    public void addEntryToList(int targlist, int type) {
        int loc = ((Integer)Listlists.get(targlist)).intValue();
        int oldnum = ((Integer)Lists.get(loc)).intValue();
        Lists.set(loc, new Integer(oldnum + 1));
        Lists.add(loc + 1 + oldnum, new Integer(entrynum));
        incrementListsFrom(targlist);
        addBICEntry(type, 0, 0);
        return;
    }
    
    //    public void addElementToEntry(int targentry, int type, int index, Object stuff) {
    //    }
    
    // This argument adds a new list entry with elements and entries under it.
    //    public void addListToEntry(int entry) {
    //        MultiMap.add(new Integer(elementnum++));
    //        Lists.add(new Integer(0));
    //        Listlists.add(new Integer(Lists.size() - 1));
    //            BICEntry tmpbic = getBICEntry(targentry);
    //            changeEntry(targentry, tmpbic.getcode(), tmpbic.getoffset(), tmpbic.getnum() + 1);
    //    }
    
    //Takes the Listlists, and increments all the numbers after a certain point
    private void incrementListsFrom(int index) {
        for(int z = index + 1; z < Listlists.size(); z++) {
            int targ = ((Integer)Listlists.get(z)).intValue();
            Listlists.set(z, new Integer(targ + 1));
        }
/*        for(int i = 0; i < ElementMap.size(); i++) {
            boolean triggered = false;
            //Integer type = (Integer)i.next();
            BICElement elem = ((BICElement)ElementMap.get(i));
            if(elem.gettype() == 15) {
                Integer num = (Integer)elem.getdata();
                int listindex = ((Integer)Listlists.get(index)).intValue();
                if(triggered) {
                    ElementMap.set(i, new BICElement(elem.gettype(), elem.getindex(), new Integer(++listindex)));
                }
                if(listindex == num.intValue()) triggered = true;
            }
        } */
        return;
    }
    
    public void RepairMultiMaps() {
        int offset = MultiMap.size() * 4;
        for(int i = 0; i < MMEntries.size(); i++) {
            int entry = ((Integer)MMEntries.get(i)).intValue();
            //System.out.println("MMENTRY " + i + ": " + entry);
            BICEntry tmpentry = (BICEntry)EntryMap.get(entry);
            EntryMap.set(entry, new BICEntry(tmpentry.getcode(), offset, tmpentry.getnum()));
            offset = (tmpentry.getnum() * 4) + offset;
        }
        //System.out.println("Size of MM: " + MultiMap.size());
        MultiMap.addAll(MultiMap2);
    }
    /**
     *This creates the final BIC based on the contents of the maps.
     */
    public void write() throws IOException {
        //byte[] tmp = new byte[0];
        //tmp = ArrayUtil.mergeArrays(tmp, Signature.getBytes());
        //tmp = ArrayUtil.mergeArrays(tmp, Version.getBytes());
        //tmp = ArrayUtil.mergeArrays(tmp, new Integer(entryoffset));
        //Opening the file, getting ready
        int firstnameoffset = ((Integer)((BICElement)ElementMap.get(0)).getdata()).intValue();
        int lastnameoffset = ((Integer)((BICElement)ElementMap.get(1)).getdata()).intValue();
        int endoffset = ((Integer)((BICElement)ElementMap.get(2)).getdata()).intValue();
        int firstsize = lastnameoffset - firstnameoffset;
        int lastsize = endoffset - lastnameoffset;
        //System.out.println("First offset: " + firstnameoffset);
        //System.out.println("Last offset: " + lastnameoffset);
        byte[] firstbyte = ArrayUtil.getSubArray(VarData, firstnameoffset + 20, firstsize - 20);
        byte[] lastbyte = ArrayUtil.getSubArray(VarData, lastnameoffset + 20, lastsize - 20);
        String charname = Charconvert.convert(firstbyte) + Charconvert.convert(lastbyte);
        charname = charname.toLowerCase();
        charname.trim();
        if(charname.length() > 16) {
            charname = charname.substring(0,16);
        }
        
        //System.out.println("Charname: " + charname);
        
        String Filename = charname.concat(".bic");
        Preferences prefs = Preferences.userRoot().node("/CharacterCreator");
        String GameDir = prefs.get("GameDir", null);
        String BicDir = GameDir + "localvault\\";
        //System.out.println(BicDir + Filename);
        if(new File(BicDir + Filename).exists()) {
            do {
                String newfilename = charname;
                if(charname.length() == 16) { newfilename = charname.substring(0,15); }
                for(int i = 1; i < 10; i++) {
                    Filename = newfilename + i + ".bic";
                    if(!(new File(BicDir + Filename).exists())) break;
                }
                if(!(new File(BicDir + Filename).exists())) break;
                if(charname.length() == 15) { newfilename = charname.substring(0,14); }
                for(int i = 10; i < 100; i++) {
                    Filename = newfilename + i + ".bic";
                    if(!(new File(BicDir + Filename).exists())) break;
                }                
            }  while(new File(BicDir + Filename).exists());
        }
        RandomAccessFile targetbic = new RandomAccessFile(new File(BicDir, Filename), "rw");
        //File is ready to be written
        
        RepairMultiMaps();
        
        targetbic.writeBytes(Signature);
        targetbic.writeBytes(Version);
        
        entryoffset = 56; //Entry offset is ALWAYS 56!
        targetbic.write(Byteconvert.convertBack(entryoffset));
        targetbic.write(Byteconvert.convertBack(entrynum));
        
        elementoffset = entryoffset + (entrynum * 12); // Element offset is 12 * number of entries, + entryoffset
        targetbic.write(Byteconvert.convertBack(elementoffset));
        targetbic.write(Byteconvert.convertBack(elementnum));
        
        varnameoffset = elementoffset + (elementnum * 12); // Varnameoffset is 12 * number of elements, + elementoffset
        targetbic.write(Byteconvert.convertBack(varnameoffset));
        targetbic.write(Byteconvert.convertBack(varnamenum));
        
        vardataoffset = varnameoffset + (varnamenum * 16); // Vardata offset is 16 * the number of varname entries, + varname offset
        vardatabytes = VarData.length;
        targetbic.write(Byteconvert.convertBack(vardataoffset));
        targetbic.write(Byteconvert.convertBack(vardatabytes));
        
        multimapoffset = vardataoffset + vardatabytes;
        multimapbytes = MultiMap.size() * 4;
        targetbic.write(Byteconvert.convertBack(multimapoffset));
        targetbic.write(Byteconvert.convertBack(multimapbytes));
        
        listoffset = multimapoffset + multimapbytes;
        listbytes = Lists.size() * 4;
        targetbic.write(Byteconvert.convertBack(listoffset));
        targetbic.write(Byteconvert.convertBack(listbytes));
        
        //Create the entity datapacket
        for(int i = 0; i < EntryMap.size(); i++) {
            BICEntry tmpent = (BICEntry)EntryMap.get(i);
            targetbic.write(Byteconvert.convertBack(tmpent.getcode()));
            targetbic.write(Byteconvert.convertBack(tmpent.getoffset()));
            targetbic.write(Byteconvert.convertBack(tmpent.getnum()));
        }
        //Element data packet
        for(int i = 0; i < ElementMap.size(); i++) {
            //Integer type = (Integer)i.next();
            BICElement elem = ((BICElement)ElementMap.get(i));
            int elemtype = elem.gettype();
            targetbic.write(Byteconvert.convertBack(elem.gettype()));
            targetbic.write(Byteconvert.convertBack(elem.getindex()));
            Object data = elem.getdata();
            if(elemtype == 15) {
                targetbic.write(Byteconvert.convertBack(((Integer)data).intValue() * 4));
            } else {
                targetbic.write(Byteconvert.convertBack(((Integer)data).intValue()));
            }
        }
        
        //Varname data packet
        for(int i = 0; i < VarName.size(); i++) {
            String text = (String)VarName.get(i);
            text.trim();
            int numspaces = 16 - text.length();
            targetbic.writeBytes(text);
            byte b = 0;
            for(int j = 0; j < numspaces; j++) {
                targetbic.write(b);
            }
        }
        
        //Vardata packet
        targetbic.write(VarData);
        
        //Multimap data packet
        for(int i = 0; i < MultiMap.size(); i++) {
            int num = ((Integer)MultiMap.get(i)).intValue();
            targetbic.write(Byteconvert.convertBack(num));
        }
        
        //List data packet
        for(int i = 0; i < Lists.size(); i++) {
            int num = ((Integer)Lists.get(i)).intValue();
            targetbic.write(Byteconvert.convertBack(num));
        }
        
        
        //Ending the file operation
        targetbic.close();
        return;
    }
    
    
    // Declaration of private variables
    private static String Signature = "BIC ";
    private static String Version = "V3.2";
    private int entryoffset;
    public int entrynum;
    private int elementoffset;
    private int elementnum;
    private int varnameoffset;
    private int varnamenum;
    private int vardataoffset;
    private int vardataendoffset;
    private int vardatabytes;
    private int multimapoffset;
    private int multimapbytes;
    private int listoffset;
    private int numlists;
    private int listbytes;
    
    // Declaration of Maps and Lists
    public LinkedList Lists;
    public LinkedList Listlists;
    public LinkedList MultiMap;
    public LinkedList MultiMap2;
    public LinkedList VarName;
    public LinkedList MMEntries;
    //public HashMap ElementMap;
    public LinkedList ElementMap;
    public LinkedList EntryMap;
    public byte[] VarData;
    private byte[] FINALFILE;
    
    private static Map codemap;
    
    static {
        codemap = new HashMap();
        codemap.put(new Integer(0), "UINT8");
        codemap.put(new Integer(1), "INT8");
        codemap.put(new Integer(2), "UINT16");
        codemap.put(new Integer(3), "INT16");
        codemap.put(new Integer(4), "UINT32");
        codemap.put(new Integer(5), "INT32");
        codemap.put(new Integer(6), "UINT64");
        codemap.put(new Integer(7), "INT64");
        codemap.put(new Integer(8), "FLOAT");
        codemap.put(new Integer(9), "DOUBLE");
        codemap.put(new Integer(10), "STRING");
        codemap.put(new Integer(11), "RESREF");
        codemap.put(new Integer(12), "STRREF");
        codemap.put(new Integer(13), "DATREF");
        codemap.put(new Integer(14), "CAPREF");
        codemap.put(new Integer(15), "LIST");
    }
}
