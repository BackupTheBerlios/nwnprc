/*
 * Finalize.java
 *
 * This file is an interface between the program and the BIC creation stuff.
 *
 * Created on March 11, 2003, 1:37 PM
 */

package CharacterCreator;

import CharacterCreator.bic.BICFile;
import CharacterCreator.bic.BICEntry;
import javax.swing.*;
import java.util.*;
import java.io.*;
/**
 *
 * @author  James
 *
 */
public class FinalizeCharByHand {
    
    /** Creates a new instance of Finalize */
    public FinalizeCharByHand() {
        try {
            //System.out.println("Initialized");
            targetbic = new BICFile();
            targetbic.BICFile();
            writedata();
            BICEntry tmpbc = (BICEntry)targetbic.EntryMap.get(0);
            //System.out.println(tmpbc.getnum());
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
    
    private void writedata() {
        
        // THIS IS THE MAIN CREATION OF ALL DATA IN THE BIC.
        // IT IS VITALLY IMPORTANT THAT THE ORDER OF THIS DATA NOT CHANGE.
        // DON'T MUCK ABOUT WITH IT UNLESS YOU ARE 110% SURE OF WHAT YOU ARE DOING.
        
        // First thing to test, spellcaster or non spellcaster?
        spellcaster = false; // Change this to actual test later on, pointer to classes.2da
        specabilities = true;
        int varnum = 0;
        int listnum = 0;
        int empty = 0;
        int entry = 0;
        
        
        //FirstName
        String firstname = "Andrassa";
        targetbic.addVarname("FirstName");
        targetbic.addElementToEntry(0, 12, varnum++, firstname);
        
        //LastName
        String lastname = "D'Morte";
        targetbic.addVarname("LastName");
        targetbic.addElementToEntry(0, 12, varnum++, lastname);
        
        //Description
        String desc = "Your only hope for fame and fortune, and to escape the life of a commoner, was to become an adventurer. Guided by your goals and dreams, you have set off in search of excitement.";
        targetbic.addVarname("Description");
        targetbic.addElementToEntry(0, 12, varnum++, desc);
        
        //Gold
        //STATIC 50
        int gold = 50;
        targetbic.addVarname("Gold");
        targetbic.addElementToEntry(0, 4, varnum++, new Integer(gold));
        
        //Conversation
        //STATIC ""
        String convo = "";
        targetbic.addVarname("Conversation");
        targetbic.addElementToEntry(0, 11, varnum++, convo);
        
        //Age
        //racialtypes.2da, can be modified
        int age = 18;
        targetbic.addVarname("Age");
        targetbic.addElementToEntry(0, 5, varnum++, new Integer(age));
        
        //Gender
        //result of gender button
        int gender = 1;
        targetbic.addVarname("Gender");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(gender));
        
        //Race
        //result of race button
        int race = 28;
        targetbic.addVarname("Race");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(race));
        
        //Subrace
        //Blank, can be modified on customization button
        String subrace = "";
        targetbic.addVarname("Subrace");
        targetbic.addElementToEntry(0, 10, varnum++, subrace);
        
        //StartingPackage
        //result of packages button
        byte startpackage = 8;
        targetbic.addVarname("StartingPackage");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(startpackage));
        
        //Deity
        //blank, can be modified on customization button
        String deity = "Random Deity X";
        targetbic.addVarname("Deity");
        targetbic.addElementToEntry(0, 10, varnum++, deity);
        
        //ArmorClass
        //result of dex
        int AC = 13;
        targetbic.addVarname("ArmorClass");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(AC));
        
        //ResSaveThrow
        //result of dex
        int ressave = 3;
        targetbic.addVarname("RefSaveThrow");
        targetbic.addElementToEntry(0, 1, varnum++, new Integer(ressave));
        
        //WillSaveThrow
        //result of wisdom
        int willsave = -1;
        targetbic.addVarname("WillSaveThrow");
        targetbic.addElementToEntry(0, 1, varnum++, new Integer(willsave));
        
        //FortSaveThrow
        //result of con
        int fortsave = 2;
        targetbic.addVarname("FortSaveThrow");
        targetbic.addElementToEntry(0, 1, varnum++, new Integer(fortsave));
        
        //MClassLevUpIn
        //STATIC 0
        int mclasslev = 0;
        targetbic.addVarname("MClassLevUpIn");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(mclasslev));
        
        //SoundSetFile
        //result of customization button
        int soundset = 244;
        targetbic.addVarname("SoundSetFile");
        targetbic.addElementToEntry(0, 2, varnum++, new Integer(soundset));
        
        //ClassList
        //LIST 0
        //LIST - 1 ENTRY
        targetbic.addVarname("ClassList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        
        targetbic.addEntryToList(listnum++, 0);
        targetbic.MMEntries.add(new Integer(targetbic.entrynum - 1));
        int classlevel = 1;
        targetbic.addVarname("ClassLevel");
        targetbic.addElementToEntry(++entry, 3, varnum++, new Integer(classlevel));
        int classn = 8;
        targetbic.addVarname("Class");
        targetbic.addElementToEntry(entry, 5, varnum++, new Integer(classn));
        
        if(spellcaster) {
            int school = 0;
            targetbic.addVarname("Class");
            targetbic.addElementToEntry(entry, 5, varnum++, new Integer(school));
            
        }
        
        //END OF CLASSLIST
        
        //FamiliarType
        //selected on customization button
        //SPELLCASTER ONLY
        if(spellcaster) {
            int famtype = 0;
            targetbic.addVarname("FamiliarType");
            targetbic.addElementToEntry(0, 5, varnum++, new Integer(famtype));
        }
        //FamiliarName
        //selected on customization button
        //SPELLCASTER ONLY
        if(spellcaster) {
            String famname = "Weirdo";
            targetbic.addVarname("FamiliarName");
            targetbic.addElementToEntry(0, 10, varnum++, famname);
        }
        //SkillPoints
        //STATIC 0
        int skillpts = 0;
        targetbic.addVarname("SkillPoints");
        targetbic.addElementToEntry(0, 2, varnum++, new Integer(skillpts));
        
        //SkillList
        //LIST 1
        //LIST - 20 ENTRIES
        targetbic.addVarname("SkillList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        
        targetbic.addEntryToList(listnum, 0);
        targetbic.addVarname("Rank");  //1
        int rank1 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank1));
        
        targetbic.addEntryToList(listnum, 0);  //2
        int rank2 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank2));
        
        targetbic.addEntryToList(listnum, 0);//3
        int rank3 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank3));
        
        targetbic.addEntryToList(listnum, 0);//4
        int rank4 = 2;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank4));
        
        targetbic.addEntryToList(listnum, 0);//5
        int rank5 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank5));
        
        targetbic.addEntryToList(listnum, 0);//6
        int rank6 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank6));
        
        targetbic.addEntryToList(listnum, 0);//7
        int rank7 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank7));
        
        targetbic.addEntryToList(listnum, 0);//8
        int rank8 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank8));
        
        targetbic.addEntryToList(listnum, 0);//9
        int rank9 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank9));
        
        targetbic.addEntryToList(listnum, 0);//10
        int rank10 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank10));
        
        targetbic.addEntryToList(listnum, 0);//11
        int rank11 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank11));
        
        targetbic.addEntryToList(listnum, 0);//12
        int rank12 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank12));
        
        targetbic.addEntryToList(listnum, 0);//13
        int rank13 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank13));
        
        targetbic.addEntryToList(listnum, 0);//14
        int rank14 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank14));
        
        targetbic.addEntryToList(listnum, 0);//15
        int rank15 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank15));
        
        targetbic.addEntryToList(listnum, 0);//16
        int rank16 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank16));
        
        targetbic.addEntryToList(listnum, 0);//17
        int rank17 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank17));
        
        targetbic.addEntryToList(listnum, 0);//18
        int rank18 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank18));
        
        targetbic.addEntryToList(listnum, 0);//19
        int rank19 = 0;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum, new Integer(rank19));
        
        targetbic.addEntryToList(listnum, 0);//20
        int rank20 = 4;
        targetbic.addNONMMElementToEntry(++entry, 0, varnum++, new Integer(rank20));
        
        
        listnum++; //END OF SKILLLIST
        
        //FeatList
        //LIST 2
        //LIST - DIFFERENT NUMBER OF ENTRIES
        targetbic.addVarname("FeatList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        
        targetbic.addEntryToList(listnum, 0);
        //FIGHTER

        targetbic.addVarname("Feat");
        int feat1 = 3;
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat1));
        
        targetbic.addEntryToList(listnum, 0);
        int feat2 = 50;
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat2));
        
        targetbic.addEntryToList(listnum, 0);
        int feat3 = 221;
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat3));
        
        //targetbic.addEntryToList(listnum, 0);
        //int feat4 = 258;
        //targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat4));
        
        //targetbic.addEntryToList(listnum, 0);
        //int feat5 = 45;
        //targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat5));
        
        targetbic.addEntryToList(listnum, 0);
        int feat6 = 46;
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat6));
        //RACIAL
        targetbic.addEntryToList(listnum, 0);
        int feat7 = 178;
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat7));
        
        targetbic.addEntryToList(listnum, 0);
        int feat7a = 185;
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat7a));
        targetbic.addEntryToList(listnum, 0);
        int feat7b = 228;
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat7b));
        
        //CLASS
        //targetbic.addEntryToList(listnum, 0);
        //int feat8 = 28;
        //targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat8));
        
        targetbic.addEntryToList(listnum, 0);
        int feat9 = 0;
        targetbic.addNONMMElementToEntry(++entry, 2, varnum++, new Integer(feat9));
        
        //targetbic.addEntryToList(listnum, 0);
        //int feat10 = 10;
        //targetbic.addNONMMElementToEntry(++entry, 2, varnum++, new Integer(feat10));
        
        
        listnum++; //END OF FEATLIST
        //Str
        //number from stats button
        short str = 12;
        targetbic.addVarname("Str");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(str));
        
        //Dex
        //number from stats button
        short dex = 16;
        targetbic.addVarname("Dex");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(dex));
        
        //Con
        //number from stats button
        short con = 14;
        targetbic.addVarname("Con");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(con));
        
        //Int
        //number from stats button
        short intel = 14;
        targetbic.addVarname("Int");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(intel));
        
        //Wis
        //number from stats button
        short wis = 8;
        targetbic.addVarname("Wis");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(wis));
        
        //Cha
        //number from stats button
        short cha = 12;
        targetbic.addVarname("Cha");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(cha));
        
        //CurrentHitPoints
        //number based on hitdie * level
        int currenthp = 6;
        targetbic.addVarname("CurrentHitPoints");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(currenthp));
        
        //HitPoints
        //number based on hitdie * level
        int hp = 6;
        targetbic.addVarname("HitPoints");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(hp));
        
        //MaxHitPoints
        //number based on (hitdie+con bonus)* level
        int maxhp = 8;
        targetbic.addVarname("MaxHitPoints");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(maxhp));
        
        //PregameCurrent
        //number based on (hitdie+con bonus)* level
        int pregamecurrent = 8;
        targetbic.addVarname("PregameCurrent");
        targetbic.addElementToEntry(0, 3, varnum++, new Integer(pregamecurrent));
        
        //LvlStatList
        //LIST 3 - from here on out, it can change depending on whether the char is caster or no
        //LIST - 1 ENTRY
        targetbic.addVarname("LvlStatList");
        targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
        int extranum;
        if(spellcaster) { extranum = 28; } else { extranum = 20; }
        
        targetbic.addEntryToList(listnum++, 0);
        targetbic.MMEntries.add(new Integer(targetbic.entrynum - 1));
        int lvstat = 6;
        targetbic.addVarname("LvlStatHitDie");
        targetbic.addElementToEntry(++entry, 0, varnum++, new Integer(lvstat));
        int lvclass = 8;
        targetbic.addVarname("LvlStatClass");
        targetbic.addElementToEntry(entry, 0, varnum++, new Integer(lvclass));
        int skillpt = 0;
        targetbic.addElementToEntry(entry, 2, extranum++, new Integer(skillpt));
        //Nasty part
        //SKILL LIST
        int baseskilllistentry = entry;
        targetbic.addElementToEntry(baseskilllistentry, 15, extranum++, new Integer(empty));
        targetbic.addEntryToList(listnum, 0);
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank1));
        
        targetbic.addEntryToList(listnum, 0); //2
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank2));
        
        targetbic.addEntryToList(listnum, 0);//3
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank3));
        
        targetbic.addEntryToList(listnum, 0);//4
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank4));
        
        targetbic.addEntryToList(listnum, 0);//5
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank5));
        
        targetbic.addEntryToList(listnum, 0);//6
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank6));
        
        targetbic.addEntryToList(listnum, 0);//7
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank7));
        
        targetbic.addEntryToList(listnum, 0);//8
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank8));
        
        targetbic.addEntryToList(listnum, 0);//9
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank9));
        
        targetbic.addEntryToList(listnum, 0);//10
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank10));
        
        targetbic.addEntryToList(listnum, 0);//11
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank11));
        
        targetbic.addEntryToList(listnum, 0);//12
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank12));
        
        targetbic.addEntryToList(listnum, 0);//13
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank13));
        
        targetbic.addEntryToList(listnum, 0);//14
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank14));
        
        targetbic.addEntryToList(listnum, 0);//15
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank15));
        
        targetbic.addEntryToList(listnum, 0);//16
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank16));
        
        targetbic.addEntryToList(listnum, 0);//17
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank17));
        
        targetbic.addEntryToList(listnum, 0);//18
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank18));
        
        targetbic.addEntryToList(listnum, 0);//19
        targetbic.addNONMMElementToEntry(++entry, 0, extranum, new Integer(rank19));
        
        targetbic.addEntryToList(listnum++, 0);//20
        targetbic.addNONMMElementToEntry(++entry, 0, extranum++, new Integer(rank20));
        
        
        //END OF SKILLLIST
        //FEAT LIST
        targetbic.addElementToEntry(baseskilllistentry, 15, extranum++, new Integer(empty));
        
        targetbic.addEntryToList(listnum, 0);
        targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat1));
        
        targetbic.addEntryToList(listnum, 0);
        targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat2));
        
        targetbic.addEntryToList(listnum, 0);
        targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat3));
        
        //targetbic.addEntryToList(listnum, 0);
        //targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat4));
        
        //targetbic.addEntryToList(listnum, 0);
        //targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat5));
        
        targetbic.addEntryToList(listnum, 0);
        targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat6));
        
        targetbic.addEntryToList(listnum, 0);
        targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat7));
        
        targetbic.addEntryToList(listnum, 0);
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat7a));
        targetbic.addEntryToList(listnum, 0);
        targetbic.addNONMMElementToEntry(++entry, 2, varnum, new Integer(feat7b));
        
        //targetbic.addEntryToList(listnum, 0);
        //targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat8));
        
        targetbic.addEntryToList(listnum++, 0);
        targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat9));
        
        //targetbic.addEntryToList(listnum++, 0);
        //targetbic.addNONMMElementToEntry(++entry, 2, extranum, new Integer(feat10));
        
        //END OF FEATLIST
        
        
        //END OF LVLSTATLIST
        
        //Experience
        //STATIC 0
        int exp = 0;
        targetbic.addVarname("Experience");
        targetbic.addElementToEntry(0, 4, varnum++, new Integer(exp));
        
        //Portrait
        //selected at portrait button
        String portrait = "po_hu_f_21_";
        targetbic.addVarname("Portrait");
        targetbic.addElementToEntry(0, 11, varnum++, portrait);
        
        //GoodEvil
        //selected at alignment button
        short gevil = 50;
        targetbic.addVarname("GoodEvil");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(gevil));
        
        //LawfulChaotic
        //selected at alignment button
        short lchaos = 15;
        targetbic.addVarname("LawfulChaotic");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lchaos));
        
        //Color_Skin
        byte skin = 16;
        targetbic.addVarname("Color_Skin");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(skin));
        
        //Color_Hair
        byte hair = 6;
        targetbic.addVarname("Color_Hair");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(hair));
        
        //Color_Tattoo1
        byte tattoo1 = 20;
        targetbic.addVarname("Color_Tattoo1");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(tattoo1));
        
        //Color_Tattoo2
        byte tattoo2 = 52;
        targetbic.addVarname("Color_Tattoo2");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(tattoo2));
        
        //Phenotype
        int phenotype = 0;
        targetbic.addVarname("Phenotype");
        targetbic.addElementToEntry(0, 5, varnum++, new Integer(phenotype));
        
        //Appearance_Type
        short apptype = 407;
        targetbic.addVarname("Appearance_Type");
        targetbic.addElementToEntry(0, 2, varnum++, new Integer(apptype));
        
        //Appearance_Head
        int head = 160;
        targetbic.addVarname("Appearance_Head");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(head));
        
        //Tail
        byte tail = 0;
        targetbic.addVarname("Tail");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(tail));
        
        //Wings
        byte wings = 0;
        targetbic.addVarname("Wings");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(wings));
        
        //BodyPart_Neck
        byte neck = 1;
        targetbic.addVarname("BodyPart_Neck");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(neck));
        
        //BodyPart_Torso
        byte torso = 1;
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
        byte lbicep = 1;
        targetbic.addVarname("BodyPart_LBicep");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lbicep));
        
        //BodyPart_LFArm
        byte lfarm = 1;
        targetbic.addVarname("BodyPart_LFArm");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lfarm));
        
        //BodyPart_LHand
        byte lhand = 1;
        targetbic.addVarname("BodyPart_LHand");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lhand));
        
        //BodyPart_LThigh
        byte lthigh = 1;
        targetbic.addVarname("BodyPart_LThigh");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(lthigh));
        
        //BodyPart_LShin
        byte lshin = 1;
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
        short rbicep = 1;
        targetbic.addVarname("BodyPart_RBicep");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rbicep));
        
        //BodyPart_RFArm
        byte rfarm = 1;
        targetbic.addVarname("BodyPart_RFArm");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rfarm));
        
        //BodyPart_RHand
        byte rhand = 1;
        targetbic.addVarname("BodyPart_RHand");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rhand));
        
        //BodyPart_RThigh
        byte rthigh = 1;
        targetbic.addVarname("BodyPart_RThigh");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rthigh));
        
        //BodyPart_RShin
        byte rshin = 1;
        targetbic.addVarname("BodyPart_RShin");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rshin));
        
        //ArmorPart_RFoot
        byte rfoot = 1;
        targetbic.addVarname("ArmorPart_RFoot");
        targetbic.addElementToEntry(0, 0, varnum++, new Integer(rfoot));
        
        //SPEC ABILITIES
        if(specabilities) {
            targetbic.addVarname("SpecAbilityList");
            targetbic.addElementToEntry(0, 15, varnum++, new Integer(empty));
            //int basespec = entry;
            targetbic.addEntryToList(listnum, 4);
            
            targetbic.MMEntries.add(new Integer(targetbic.entrynum - 1));
            int specspell = 36;
            targetbic.addVarname("Spell");
            targetbic.addElementToEntry(++entry, 2, varnum++, new Integer(specspell));
            int specflag = 1;
            targetbic.addVarname("SpellFlags");
            targetbic.addElementToEntry(entry, 0, varnum++, new Integer(specflag));
            int speclevel = 3;
            targetbic.addVarname("SpellCasterLevel");
            targetbic.addElementToEntry(entry, 0, varnum++, new Integer(speclevel));            
            
            targetbic.addEntryToList(listnum, 4);
            targetbic.MMEntries.add(new Integer(targetbic.entrynum - 1));
            targetbic.addElementToEntry(++entry, 2, varnum - 3, new Integer(specspell));
            targetbic.addElementToEntry(entry, 0, varnum - 2, new Integer(specflag));
            targetbic.addElementToEntry(entry, 0, varnum - 1, new Integer(speclevel));       
            
            listnum++;
        } //END SPEC ABILITIES
        
        
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
        
        targetbic.addEntryToList(listnum, 0);
        eq = "nw_wswss001";
        targetbic.addVarname("InventoryRes");
        targetbic.addNONMMElementToEntry(++entry, 11, varnum, eq);
        
        targetbic.addEntryToList(listnum, 0);
        eq = "nw_aarcl002";
        targetbic.addNONMMElementToEntry(++entry, 11, varnum, eq);
        
        targetbic.addEntryToList(listnum, 0);
        eq = "nw_it_torch001";
        targetbic.addNONMMElementToEntry(++entry, 11, varnum, eq);
        
        targetbic.addEntryToList(listnum, 0);
        eq = "nw_it_mpotion001";
        targetbic.addNONMMElementToEntry(++entry, 11, varnum, eq);
        
        targetbic.addEntryToList(listnum, 0);
        eq = "nw_it_mpotion001";
        targetbic.addNONMMElementToEntry(++entry, 11, varnum, eq);
        
        targetbic.addEntryToList(listnum, 0);
        eq = "nw_it_mpotion001";
        targetbic.addNONMMElementToEntry(++entry, 11, varnum++, eq);
        
        listnum++; //END OF ITEMLIST
        
        
        
        
    }
    
    public static void main(String args[]) {
        FinalizeCharByHand stuff = new FinalizeCharByHand();
    }
    
    boolean specabilities;
    boolean spellcaster;
    BICFile targetbic;
}
