/*
 * Finalize.java
 *
 * This file is an interface between the program and the BIC creation stuff.
 *
 * Created on March 11, 2003, 1:37 PM
 */

package CharacterCreator;

import java.awt.Cursor;
import CharacterCreator.bic.BICFile;
import CharacterCreator.bic.BICEntry;
import javax.swing.*;
import java.util.*;
import java.io.*;
import CharacterCreator.defs.*;
/**
 *
 * @author  James
 *
 */
public class FinalizeChar {
    
    /** Creates a new instance of Finalize */
    public FinalizeChar() {
        
        menucreate = TLKFactory.getCreateMenu();
        ResVer rv = new ResVer();
        int tst = rv.VerifyResources();
        //if(menucreate.XP1) {
        //    numskills = 23;
        //} else {
        //    numskills = 20;
        // }
        //Cursor wait = (Cursor)java.awt.Cursor.WAIT_CURSOR;
        //menucreate.getContentPane().setCursor(java.awt.Cursor.WAIT_CURSOR);
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.WAIT_CURSOR));
        menucreate.FinalizeButton.setEnabled(false);
        
        //menucreate.setCursor(3);
        TLKFAC = menucreate.getTLKFactory();
        RESFAC = menucreate.getResourceFactory();
        equipment = new LinkedList();
        featlist = new LinkedList();
        skilllist = new LinkedList();
        spellsknown0 = new LinkedList();
        spellsknown1 = new LinkedList();
        reflexmod = 0;
        willmod = 0;
        fortitudemod = 0;
        try {
            targetbic = new BICFile();
            targetbic.BICFile();
            writedata();
            BICEntry tmpbc = (BICEntry)targetbic.EntryMap.get(0);
            targetbic.write();
        }
        catch (IOException err) {
            JOptionPane.showMessageDialog(null, "Try again!", "Error", 0);
            System.exit(0);
        }
/*        catch (NullPointerException err) {
            JOptionPane.showMessageDialog(null, "Try again: " + err, "Error", 0);
            System.exit(0);
        }       */
    }
    
    private void handlepackages() {
        int i;
        //This file takes the data in packages and assigns them. Nuff said.
        Boolean tmp = (Boolean)menucreate.MainCharData[6].get(new Integer(0));
        String[] packagesmap = menucreate.MainCharDataAux[7];
        //Note.. Arcane Spellcasters are the only classes that get memorized/knownspells.
        //Currently, that's bards and wizards; but we're gonna set up anyone with the stuff in the packages.

        spellcaster = (packagesmap[packages.School] != null);
        domains = (packagesmap[packages.Domain1] != null || packagesmap[packages.Domain2] != null);
        wizardclass = (menucreate.MainCharDataAux[3][classes.SpellGainTable] != null || packagesmap[packages.SpellPref2DA] != null);

        //Equipment start
        String equip2da = packagesmap[packages.Equip2DA];
        try {
            String[][] equip2damap = RESFAC.getResourceAs2DA(equip2da);

			//Converts the 3d into 2d, for easy use later
			for(i = 0; i<equip2damap.length; i++)
				equipment.add(equip2damap[i][1].toLowerCase());
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + equip2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        //Equipment End
		
        String sv2da = menucreate.MainCharDataAux[3][classes.SavingThrowTable];
        try {
            String[][] savingthrowmap = RESFAC.getResourceAs2DA(sv2da);

			reflexmod = Integer.parseInt(savingthrowmap[0][svthrow.RefSave]);
			willmod = Integer.parseInt(savingthrowmap[0][svthrow.WillSave]);
			fortitudemod = Integer.parseInt(savingthrowmap[0][svthrow.FortSave]);
        }
        catch(IOException err) {
            JOptionPane.showMessageDialog(null, "Fatal Error - " + sv2da + " not found. Your data files might be corrupt.", "Error", 0);
            System.exit(0);
        }
        
        //Spec ability initialization
        String racefeat = menucreate.MainCharDataAux[1][racialtypes.FeatsTable].toUpperCase();
        //Spec ability end
        
        // Above this is necessary, below this can be handled by other menus
        //Everything after this part sets feats, spells and skills. Not needed if we're not using a package.
        //if(tmp.equals(Boolean.FALSE)) {
        //System.out.println("No package: handled by menus");
        //Set the featlist, skilllist to the proper values
        //Set school, domain1, domain2 correctly
        if(spellcaster && wizardclass) {
            school = (((Integer)menucreate.MainCharData[16].get(new Integer(0)))).intValue();
        }
        if(domains) {
            domain1 = (((Integer)menucreate.MainCharData[16].get(new Integer(1)))).intValue();
            domain2 = (((Integer)menucreate.MainCharData[16].get(new Integer(2)))).intValue();
        }
        featlist.clear();
        int numfeats = ((Integer)menucreate.MainCharData[9].get(new Integer(0))).intValue();
        for(int q = 0; q<numfeats; q++) {
            featlist.add(((Integer)menucreate.MainCharData[9].get(new Integer(1+q))));
        }
        skilllist.clear();
        for(int s = 0; s < menucreate.MainCharData[8].size(); s++) {
            skilllist.add(((Integer)menucreate.MainCharData[8].get(new Integer(s))));
        }
        //Initialization of numskills
        numskills = skilllist.size();
        if(featlist.contains(new Integer(303))) { // Set info about familiar
            famtype = (((Integer)menucreate.MainCharData[14].get(new Integer(1)))).intValue();
            famname = ((String)menucreate.MainCharData[14].get(new Integer(0)));
        }
        if(featlist.contains(new Integer(199))) { // Set info about companion
            comptype = (((Integer)menucreate.MainCharData[14].get(new Integer(3)))).intValue();
            compname = ((String)menucreate.MainCharData[14].get(new Integer(2)));
        }
        if(spellcaster) {
            spellsknown0.clear();
            spellsknown1.clear();
            int spellsknown0num = ((Integer)menucreate.MainCharData[10].get(new Integer(0))).intValue();
            int spellsknown1num = ((Integer)menucreate.MainCharData[11].get(new Integer(0))).intValue();
            for(int tt = 0; tt<spellsknown0num; tt++) {
                spellsknown0.add(((Integer)menucreate.MainCharData[10].get(new Integer(1+tt))));
            }
            for(int tt = 0; tt<spellsknown1num; tt++) {
                spellsknown1.add(((Integer)menucreate.MainCharData[11].get(new Integer(1+tt))));
            }
        }
        return;
    }
       
    private void writedata() {
        handlepackages();
        
        // THIS IS THE MAIN CREATION OF ALL DATA IN THE BIC.
        // IT IS VITALLY IMPORTANT THAT THE ORDER OF THIS DATA NOT CHANGE.
        // DON'T MUCK ABOUT WITH IT UNLESS YOU ARE 110% SURE OF WHAT YOU ARE DOING.
        
        // First thing to test, spellcaster or non spellcaster?
        //spellcaster = false; // Change this to actual test later on, pointer to classes.2da
        
        int varnum = 0;
        int listnum = 0;
        int empty = 0;
        int entry = 0;
        
        
        //FirstName
        String firstname = ((String)menucreate.MainCharData[15].get(new Integer(7)));
        //String firstname = "Andrassa";
        targetbic.addVarname("FirstName");
        targetbic.addElementToEntry(0, 12, varnum++, firstname);
        
        //LastName
        String lastname = ((String)menucreate.MainCharData[15].get(new Integer(8)));
        //String lastname = "D'Morte";
        targetbic.addVarname("LastName");
        targetbic.addElementToEntry(0, 12, varnum++, lastname);
        
        //Description
        
        String desc = ((String)menucreate.MainCharData[15].get(new Integer(13)));
        targetbic.addVarname("Description");
        targetbic.addElementToEntry(0, 12, varnum++, desc);
        
        //Gold
        //Based on package
        int gold = Integer.parseInt(menucreate.MainCharDataAux[7][packages.Gold]);
        //int gold = 50;
        targetbic.addVarname("Gold");
        targetbic.addElementToEntry(0, 4, varnum++, new Integer(gold));
        
        //Conversation
        //STATIC ""
        String convo = "";
        targetbic.addVarname("Conversation");
        targetbic.addElementToEntry(0, 11, varnum++, convo);
        
        //Age
        //racialtypes.2da, can be modified
        int age = ((Integer)menucreate.MainCharData[15].get(new Integer(9))).intValue();
        //int age = 18;
        targetbic.addVarname("Age");
        targetbic.addElementToEntry(0, 5, varnum++, new Integer(age));
        
        //Gender
        //result of gender button
        int gender = ((Integer)menucreate.MainCharData[0].get(new Integer(0))).intValue();
        //int gender = 1;
        targetbic.addVarname("Gender");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(gender));
        
        //Race
        //result of race button
        int race = Integer.parseInt(menucreate.MainCharDataAux[1][0]);
        //int race = 28;
        targetbic.addVarname("Race");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(race));
        
        //Subrace
        //Blank, can be modified on customization button
        String subrace = ((String)menucreate.MainCharData[15].get(new Integer(12)));
        //String subrace = "";
        targetbic.addVarname("Subrace");
        targetbic.addElementToEntry(0, 10, varnum++, subrace);
        
        //StartingPackage
        //result of packages button
        byte startpackage = Byte.parseByte(menucreate.MainCharDataAux[7][0]);
        //byte startpackage = 8;
        targetbic.addVarname("StartingPackage");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(startpackage));
        
        //Deity
        //blank, can be modified on customization button
        String deity = ((String)menucreate.MainCharData[15].get(new Integer(10)));
        //String deity = "Random Deity X";
        targetbic.addVarname("Deity");
        targetbic.addElementToEntry(0, 10, varnum++, deity);
        
        //ArmorClass
        //result of dex
        int dexbonus = new Integer(((String)menucreate.MainCharData[5].get(new Integer(13)))).intValue();
        int AC = 10 + dexbonus;
        targetbic.addVarname("ArmorClass");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(AC));
        
        //ResSaveThrow
        //result of dex
        int ressave = dexbonus + reflexmod;
        targetbic.addVarname("RefSaveThrow");
        targetbic.addElementToEntry(0, 1, varnum++, new Integer(ressave));
        
        //WillSaveThrow
        //result of wisdom
        int wisbonus = new Integer(((String)menucreate.MainCharData[5].get(new Integer(16)))).intValue();
        int willsave = wisbonus + willmod;
        targetbic.addVarname("WillSaveThrow");
        targetbic.addElementToEntry(0, 1, varnum++, new Integer(willsave));
        
        //FortSaveThrow
        //result of con
        int conbonus = new Integer(((String)menucreate.MainCharData[5].get(new Integer(14)))).intValue();
        int fortsave = conbonus + fortitudemod;
        targetbic.addVarname("FortSaveThrow");
        targetbic.addElementToEntry(0, 1, varnum++, new Integer(fortsave));
        
        //MClassLevUpIn
        //STATIC 0
        int mclasslev = 0;
        targetbic.addVarname("MClassLevUpIn");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(mclasslev));
        
        //SoundSetFile
        //result of customization button
        int soundset = ((Integer)menucreate.MainCharData[15].get(new Integer(11))).intValue();
        //int soundset = 244;
        targetbic.addVarname("SoundSetFile");
        targetbic.addElementToEntry(0, 2, varnum++, new Integer(soundset));
        
        //ClassList
        //LIST 0
        //LIST - 1 ENTRY
        targetbic.addVarname("ClassList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        int classlistentry = ++entry;
        targetbic.addEntryToList(listnum++, 0);
        targetbic.MMEntries.add(new Integer(targetbic.entrynum - 1));
        //Static 1- one level of class
        int classlevel = 1;
        targetbic.addVarname("ClassLevel");
        targetbic.addElementToEntry(classlistentry, 3, varnum++, new Integer(classlevel));
        int classn = Integer.parseInt(menucreate.MainCharDataAux[3][0]);
        //int classn = 8;
        targetbic.addVarname("Class");
        targetbic.addElementToEntry(classlistentry, 5, varnum++, new Integer(classn));
        
        if(spellcaster && wizardclass) {
            //int school = 0;
            targetbic.addVarname("School");
            targetbic.addElementToEntry(classlistentry, 0, varnum++, new Integer(school));
        }
        if(domains) {
            //int school = 0;
            targetbic.addVarname("Domain1");
            targetbic.addElementToEntry(classlistentry, 0, varnum++, new Integer(domain1));
            targetbic.addVarname("Domain2");
            targetbic.addElementToEntry(classlistentry, 0, varnum++, new Integer(domain2));
            
            // May have to add some quick memorized crap here - have to test
        }
        int spellvarnum = 0;
        int knownlist0 = 0;
        int knownlist1 = 0;
        if(spellcaster) {
            targetbic.addVarname("KnownList0");
            knownlist0 = varnum;
            targetbic.addElementToEntry(classlistentry, 15, varnum++, new Integer(empty));
            targetbic.addVarname("Spell");
            spellvarnum = varnum;
            for(int n=0;n<spellsknown0.size();n++) {
                targetbic.addEntryToList(listnum, 0);
                targetbic.addNONMMElementToEntry(++entry, 2, spellvarnum, ((Integer)spellsknown0.get(n)));
            }
            listnum++;
            //varnum++;
            if(spellsknown1.size() != 0) {
                targetbic.addVarname("KnownList1");
                targetbic.addElementToEntry(classlistentry, 15, ++varnum, new Integer(empty));
                knownlist1 = varnum;
                //targetbic.addVarname("Spell");
                for(int y=0;y<spellsknown1.size();y++) {
                    targetbic.addEntryToList(listnum, 0);
                    targetbic.addNONMMElementToEntry(++entry, 2, spellvarnum, ((Integer)spellsknown1.get(y)));
                }
                listnum++;
            }
            varnum++;
        }
        if(spellcaster) {
        }
        //END OF CLASSLIST
        
        //FamiliarType
        //selected on customization button
        //Check for Familiar feat
        if(featlist.contains(new Integer(303))) {
            targetbic.addVarname("FamiliarType");
            targetbic.addElementToEntry(0, 5, varnum++, new Integer(famtype));
            
            targetbic.addVarname("FamiliarName");
            targetbic.addElementToEntry(0, 10, varnum++, famname);
        }
        //CompanionType
        //Selected on Customization button
        //Check for Animal Companion feat
        if(featlist.contains(new Integer(199))) {
            targetbic.addVarname("CompanionType");
            targetbic.addElementToEntry(0, 5, varnum++, new Integer(comptype));
            
            targetbic.addVarname("CompanionName");
            targetbic.addElementToEntry(0, 10, varnum++, compname);
        }
        //SkillPoints
        //STATIC 0
        //int skillpts = 0;
        int skillpts = menucreate.skillPointsLeft;
        targetbic.addVarname("SkillPoints");
        targetbic.addElementToEntry(0, 2, varnum++, new Integer(skillpts));
        
        //SkillList
        //LIST 1
        //LIST - 20 ENTRIES
        targetbic.addVarname("SkillList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        targetbic.addVarname("Rank");
        
        for(int j=0; j < skilllist.size(); j++) {
            targetbic.addEntryToList(listnum, 0);
            targetbic.addNONMMElementToEntry(++entry, 0, varnum, ((Integer)skilllist.get(j)));
        }
        
        varnum++;
        listnum++; //END OF SKILLLIST
        
        //FeatList
        //LIST 2
        //LIST - DIFFERENT NUMBER OF ENTRIES
        targetbic.addVarname("FeatList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        targetbic.addVarname("Feat");
        
        
        
        for(int p = 0; p < featlist.size(); p++) {
            targetbic.addEntryToList(listnum, 0);
            targetbic.addNONMMElementToEntry(++entry, 2, varnum, ((Integer)featlist.get(p)));
        }
        
        varnum++;
        listnum++; //END OF FEATLIST
        //Str
        //number from stats button
        int str = new Integer(((String)menucreate.MainCharData[5].get(new Integer(6)))).intValue();
        //short str = 12;
        targetbic.addVarname("Str");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(str));
        
        //Dex
        //number from stats button
        int dex = new Integer(((String)menucreate.MainCharData[5].get(new Integer(7)))).intValue();
        //short dex = 16;
        targetbic.addVarname("Dex");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(dex));
        
        //Con
        //number from stats button
        int con = new Integer(((String)menucreate.MainCharData[5].get(new Integer(8)))).intValue();
        //short con = 14;
        targetbic.addVarname("Con");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(con));
        
        //Int
        //number from stats button
        int intel = new Integer(((String)menucreate.MainCharData[5].get(new Integer(9)))).intValue();
        //short intel = 14;
        targetbic.addVarname("Int");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(intel));
        
        //Wis
        //number from stats button
        int wis = new Integer(((String)menucreate.MainCharData[5].get(new Integer(10)))).intValue();
        //short wis = 8;
        targetbic.addVarname("Wis");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(wis));
        
        //Cha
        //number from stats button
        int cha = new Integer(((String)menucreate.MainCharData[5].get(new Integer(11)))).intValue();
        //short cha = 12;
        targetbic.addVarname("Cha");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(cha));
        
        //CurrentHitPoints
        //number based on hitdie * level
        int currenthp = Integer.parseInt(menucreate.MainCharDataAux[3][classes.HitDie]);
        //int currenthp = 6;
        targetbic.addVarname("CurrentHitPoints");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(currenthp));
        
        //HitPoints
        //number based on hitdie * level
        int hp = currenthp;
        targetbic.addVarname("HitPoints");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(hp));
        
        //MaxHitPoints
        //number based on (hitdie+con bonus)* level
        int maxhp = currenthp + conbonus;
        targetbic.addVarname("MaxHitPoints");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(maxhp));
        
        //PregameCurrent
        //number based on (hitdie+con bonus)* level
        int pregamecurrent = maxhp;
        targetbic.addVarname("PregameCurrent");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(pregamecurrent));
        
        //LvlStatList
        //LIST 3 - from here on out, it can change depending on whether the char is caster or no
        //LIST - 1 ENTRY
        targetbic.addVarname("LvlStatList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        int extranum;
        //If we add memorized lists, change this to 28
        if(spellcaster) {
            if(spellsknown1.size() == 0) {
                extranum = 22;
            } else {
                if(wizardclass) {
                    extranum = 26;
                } else {
                    extranum = 25;
                }
            }
        } else {
            if(domains) {
                extranum = 22;
            } else {
                extranum = 20;
            }
        }
        int baseentry = ++entry;
        targetbic.addEntryToList(listnum++, 0);
        targetbic.MMEntries.add(new Integer(targetbic.entrynum - 1));
        int lvstat = currenthp;
        targetbic.addVarname("LvlStatHitDie");
        targetbic.addElementToEntry(baseentry, 0, varnum++, new Integer(lvstat));
        int lvclass = classn;
        targetbic.addVarname("LvlStatClass");
        targetbic.addElementToEntry(baseentry, 0, varnum++, new Integer(lvclass));
        //if(domains) {
        //    //int school = 0;
        //targetbic.addVarname("Domain1");
        //    targetbic.addElementToEntry(baseentry, 0, extranum++, new Integer(domain1));
        //targetbic.addVarname("Domain2");
        //    targetbic.addElementToEntry(baseentry, 0, extranum++, new Integer(domain2));
        
        // May have to add some quick memorized crap here - have to test
        //}
        
        if(spellcaster) {
            //targetbic.addVarname("KnownList0");
            //knownlist0 = varnum;
            targetbic.addElementToEntry(baseentry, 15, knownlist0, new Integer(empty));
            //targetbic.addVarname("Spell");
            //spellvarnum = varnum;
            for(int n=0;n<spellsknown0.size();n++) {
                targetbic.addEntryToList(listnum, 0);
                targetbic.addNONMMElementToEntry(++entry, 2, spellvarnum, ((Integer)spellsknown0.get(n)));
            }
            listnum++;
            //varnum++;
            //targetbic.addVarname("KnownList1");
            //knownlist1 = varnum;
            
            if(spellsknown1.size() != 0) {
                targetbic.addElementToEntry(baseentry, 15, knownlist1, new Integer(empty));
                //targetbic.addVarname("Spell");
                for(int y=0;y<spellsknown1.size();y++) {
                    targetbic.addEntryToList(listnum, 0);
                    targetbic.addNONMMElementToEntry(++entry, 2, spellvarnum, ((Integer)spellsknown1.get(y)));
                }
                listnum++;
            }
            //varnum++;
        }
        
        
        int skillpt = 0;
        targetbic.addElementToEntry(baseentry, 2, extranum++, new Integer(skillpt));
        //DOMAINS
        
        //
        
        //Nasty part
        //SKILL LIST
        int baseskilllistentry = baseentry;
        targetbic.addElementToEntry(baseskilllistentry, 15, extranum++, new Integer(empty));
        for(int q = 0; q<skilllist.size(); q++) {
            //for(int q=0;q<numskills;q++) {
            targetbic.addEntryToList(listnum, 0);
            targetbic.addNONMMElementToEntry(++entry, 0, extranum, ((Integer)skilllist.get(q)));
        }
        listnum++;
        extranum++;
        //END OF SKILLLIST
        //FEAT LIST
        targetbic.addElementToEntry(baseskilllistentry, 15, extranum++, new Integer(empty));
        
        for(int r = 0; r < featlist.size(); r++) {
            targetbic.addEntryToList(listnum, 0);
            targetbic.addNONMMElementToEntry(++entry, 2, extranum, ((Integer)featlist.get(r)));
        }
        
        listnum++;
        //END OF FEATLIST
        
        
        //END OF LVLSTATLIST
        
        //Experience
        //STATIC 0
        int exp = 0;
        targetbic.addVarname("Experience");
        targetbic.addElementToEntry(0, 4, varnum++, new Integer(exp));
        
        //Portrait
        //selected at portrait button
        String portrait = ((String)menucreate.MainCharData[2].get(new Integer(0)));
        //String portrait = "po_hu_f_21_";
        targetbic.addVarname("Portrait");
        targetbic.addElementToEntry(0, 11, varnum++, portrait);
        
        //GoodEvil
        //selected at alignment button
        int gevil = ((Integer)menucreate.MainCharData[4].get(new Integer(1))).intValue();
        //short gevil = 50;
        targetbic.addVarname("GoodEvil");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(gevil));
        
        //LawfulChaotic
        //selected at alignment button
        int lchaos = ((Integer)menucreate.MainCharData[4].get(new Integer(0))).intValue();
        //short lchaos = 15;
        targetbic.addVarname("LawfulChaotic");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lchaos));
        
        //Color_Skin
        int skin = ((Integer)menucreate.MainCharData[15].get(new Integer(0))).intValue();
        //byte skin = 16;
        targetbic.addVarname("Color_Skin");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(skin));
        
        //Color_Hair
        int hair = ((Integer)menucreate.MainCharData[15].get(new Integer(1))).intValue();
        //byte hair = 6;
        targetbic.addVarname("Color_Hair");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(hair));
        
        //Color_Tattoo1
        int tattoo1 = ((Integer)menucreate.MainCharData[15].get(new Integer(2))).intValue();
        //byte tattoo1 = 20;
        targetbic.addVarname("Color_Tattoo1");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(tattoo1));
        
        //Color_Tattoo2
        int tattoo2 = ((Integer)menucreate.MainCharData[15].get(new Integer(3))).intValue();
        //byte tattoo2 = 52;
        targetbic.addVarname("Color_Tattoo2");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(tattoo2));
        
        //Phenotype
        int phenotype = ((Integer)menucreate.MainCharData[15].get(new Integer(6))).intValue();
        //int phenotype = 0;
        targetbic.addVarname("Phenotype");
        targetbic.addElementToEntry(0, 5, varnum++, new Integer(phenotype));
        
        //Appearance_Type
        int apptype = ((Integer)menucreate.MainCharData[15].get(new Integer(5))).intValue();
        //short apptype = 407;
        targetbic.addVarname("Appearance_Type");
        targetbic.addElementToEntry(0, 2, varnum++, new Integer(apptype));
        
        //Appearance_Head
        int head = ((Integer)menucreate.MainCharData[15].get(new Integer(4))).intValue();
        //int head = 160;
        targetbic.addVarname("Appearance_Head");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(head));
        
        //Wings
        int wng = ((Integer)menucreate.MainCharData[15].get(new Integer(14))).intValue();
        targetbic.addVarname("Wings");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(wng));
        
        //Tail
        int tl = ((Integer)menucreate.MainCharData[15].get(new Integer(15))).intValue();
        targetbic.addVarname("Tail");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(tl));
        
        //BodyPart_Neck
        byte neck = 1;
        targetbic.addVarname("BodyPart_Neck");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(neck));
        
        //BodyPart_Torso
        int torso = ((Integer)menucreate.MainCharData[17].get(new Integer(0))).intValue();
        //byte torso = 1;
        targetbic.addVarname("BodyPart_Torso");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(torso));
        
        //BodyPart_Belt
        byte belt = 0;
        targetbic.addVarname("BodyPart_Belt");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(belt));
        
        //BodyPart_Pelvis
        byte pelvis = 1;
        targetbic.addVarname("BodyPart_Pelvis");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(pelvis));
        
        //BodyPart_LShoul
        byte lshoul = 0;
        targetbic.addVarname("BodyPart_LShoul");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lshoul));
        
        //BodyPart_LBicep
        int lbicep = ((Integer)menucreate.MainCharData[17].get(new Integer(1))).intValue();
        //byte lbicep = 1;
        targetbic.addVarname("BodyPart_LBicep");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lbicep));
        
        //BodyPart_LFArm
        int lfarm  = ((Integer)menucreate.MainCharData[17].get(new Integer(3))).intValue();
        //byte lfarm = 1;
        targetbic.addVarname("BodyPart_LFArm");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lfarm));
        
        //BodyPart_LHand
        byte lhand = 1;
        targetbic.addVarname("BodyPart_LHand");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lhand));
        
        //BodyPart_LThigh
        int lthigh = ((Integer)menucreate.MainCharData[17].get(new Integer(5))).intValue();
        //byte lthigh = 1;
        targetbic.addVarname("BodyPart_LThigh");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lthigh));
        
        //BodyPart_LShin
        int lshin = ((Integer)menucreate.MainCharData[17].get(new Integer(7))).intValue();
        //byte lshin = 1;
        targetbic.addVarname("BodyPart_LShin");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lshin));
        
        //BodyPart_LFoot
        byte lfoot = 1;
        targetbic.addVarname("BodyPart_LFoot");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lfoot));
        
        //BodyPart_RShoul
        byte rshoul = 0;
        targetbic.addVarname("BodyPart_RShoul");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rshoul));
        
        //BodyPart_RBicep
        int rbicep = ((Integer)menucreate.MainCharData[17].get(new Integer(2))).intValue();
        //short rbicep = 1;
        targetbic.addVarname("BodyPart_RBicep");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rbicep));
        
        //BodyPart_RFArm
        int rfarm = ((Integer)menucreate.MainCharData[17].get(new Integer(4))).intValue();
        //byte rfarm = 1;
        targetbic.addVarname("BodyPart_RFArm");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rfarm));
        
        //BodyPart_RHand
        byte rhand = 1;
        targetbic.addVarname("BodyPart_RHand");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rhand));
        
        //BodyPart_RThigh
        int rthigh = ((Integer)menucreate.MainCharData[17].get(new Integer(6))).intValue();
        //byte rthigh = 1;
        targetbic.addVarname("BodyPart_RThigh");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rthigh));
        
        //BodyPart_RShin
        int rshin = ((Integer)menucreate.MainCharData[17].get(new Integer(8))).intValue();
        //byte rshin = 1;
        targetbic.addVarname("BodyPart_RShin");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rshin));
        
        //ArmorPart_RFoot
        byte rfoot = 1;
        targetbic.addVarname("ArmorPart_RFoot");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rfoot));
        
        //Equip_ItemList
        targetbic.addVarname("Equip_ItemList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        
        targetbic.addEntryToList(listnum, 2);
        String eq = "nw_cloth001";
        targetbic.addVarname("EquippedRes");
        targetbic.addNONMMElementToEntry(++entry, 11, varnum++, eq);
        
        listnum++; //END OF EQUIPITEMLIST
        
        
        //ItemList
        targetbic.addVarname("ItemList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        targetbic.addVarname("InventoryRes");
        for(int q = 0; q < equipment.size() ; q++) {
            targetbic.addEntryToList(listnum, 0);
            eq = (String)equipment.get(q);
            targetbic.addNONMMElementToEntry(++entry, 11, varnum, eq);
        }
        
        varnum++;
        listnum++; //END OF ITEMLIST
        
        
        menucreate.GenderButton.setEnabled(false);
        menucreate.RaceButton.setEnabled(false);
        menucreate.AbilitiesButton.setEnabled(false);
        menucreate.AlignmentButton.setEnabled(false);
        menucreate.PortraitButton.setEnabled(false);
        menucreate.PackagesButton.setEnabled(false);
        menucreate.ClassButton.setEnabled(false);
        menucreate.CustomizeButton.setEnabled(false);
        menucreate.ResetButton.setEnabled(false);
        
        menucreate.DoneLabel.setVisible(true);
        //menucreate.setCursor(0);
        menucreate.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.DEFAULT_CURSOR));
    }
    
    private TLKFactory TLKFAC;
    private ResourceFactory RESFAC;
    private CreateMenu menucreate;
    boolean domains;
    boolean spellcaster;
    BICFile targetbic;
    
    //public LinkedList featlist;
    public LinkedList classfeatlist;
    public LinkedList ccskill;
    public LinkedList startfeatlist;
    
    LinkedList equipment;
    LinkedList featlist;
    LinkedList skilllist;
    LinkedList spellsknown0;
    LinkedList spellsknown1;
    boolean wizardclass;
    String[][] specabilitymap;
    int willmod;
    int reflexmod;
    int fortitudemod;
    int school;
    int domain1;
    int domain2;
    int famtype;
    String famname;
    int comptype;
    String compname;
    int numskills;
}
