package prc.utils;

import prc.autodoc.*;

import java.io.*;
import java.lang.Math.*;

//for the spinner
import static prc.Main.*;

public final class SpellbookMaker{
	private SpellbookMaker(){}

	private static int spells2daRow = 0;
	private static int feat2daRow   = 0;
	private static int iprp_feats2daRow   = 0;
	private static int tlkRow       = 0;
	private static Data_2da classes2da;
	private static Data_2da spells2da;
	private static Data_2da feat2da;
	private static Data_2da iprp_feats2da;
	private static Data_TLK customtlk;
	private static Data_TLK dialogtlk;

	/**
	 * The main method, as usual.
	 *
	 * @param args do I really need to explain this?
	 * @throws Exception this is a simple tool, just let all failures blow up
	 */
	public static void main(String[] args) throws Exception{
		//load all the data files in advance
		//this is quite slow, but needed
		classes2da = Data_2da.load2da("2das\\classes.2da", true);
		spells2da = Data_2da.load2da("2das\\spells.2da", true);
		feat2da = Data_2da.load2da("2das\\feat.2da", true);
		iprp_feats2da = Data_2da.load2da("2das\\iprp_feats.2da", true);
		customtlk = new Data_TLK("tlk\\prc_consortium.tlk");
		dialogtlk = new Data_TLK("tlk\\dialog.tlk");
		//get the start/end rows for each file for the reserved blocks
		getFirstSpells2daRow();
		getFirstFeat2daRow();
		getFirstIPRPFeat2daRow();
		getFirsttlkRow();
		System.out.println("First free spells.2da row is "+spells2daRow);
		System.out.println("First free feat.2da row is "+feat2daRow);
		System.out.println("First free tlk row is "+tlkRow);
		//now process each class in turn
		for(int i = 0; i<255;i++){
			//the feat file is the root of the file naming layout
			String classfilename = classes2da.getEntry("FeatsTable", i);
			//check its a real class not padding
			if(classfilename != null
				&& classfilename != "****"
				&& classfilename != ""
				&& classfilename.length() > 9){
				classfilename = classfilename.substring(9, classfilename.length());
				String classCoreFilename = "cls_spell_"+classfilename+"_core";
				//check the file exists
				File classCoreFile = new File("2das\\"+classCoreFilename+".2da");
				if(classCoreFile.exists()){
					//open the core spell file
					Data_2da classCoreSpell2da = Data_2da.load2da("2das\\"+classCoreFilename+".2da", true);
					//get the new filename
					String classSpellFilename = "cls_spell_"+classfilename;
					Data_2da classSpell2da = Data_2da.load2da("2das\\"+classSpellFilename+".2da", true);
					//get the class name
					String className = getCheckedTlkEntry(classes2da.getBiowareEntryAsInt("Name", i))+" ";
					//loop over all the spells
					for(int row = 0; row < classCoreSpell2da.getEntryCount(); row ++) {
						//get the real spellID
						int spellID = classCoreSpell2da.getBiowareEntryAsInt("SpellID", row);
						//get the name of the spell
						String spellName = getCheckedTlkEntry(spells2da.getBiowareEntryAsInt("Name", spellID));
						//get the metamagic reference to know what types work
						int metamagic = spells2da.getBiowareEntryAsInt("Metamagic", spellID);
						//now loop over the metamagic varients
						//-1 represents no metamagic
						for(int metamagicNo = -1; metamagicNo < 6; metamagicNo++){
							/*
							    * 0x01 = 1 = Empower
							    * 0x02 = 2 = Extend
							    * 0x04 = 4 = Maximize
							    * 0x08 = 8 = Quicken
							    * 0x10 = 16 = Silent
                                * 0x20 = 32 = Still
                            */
                            int hexValue = 0;
                            if(metamagicNo != -1){
                            	hexValue = (int) Math.pow(2, metamagicNo);
							}
                            //bitwise check for the flag
                            //or no metamagic
                            if((metamagic & hexValue) != 0
                            	|| (hexValue == 0)){
								String spellNameMetamagic = "";
								if(metamagicNo == -1){
									spellNameMetamagic = "";
								} else if(metamagicNo == 0){
									spellNameMetamagic = "Empowered ";
								} else if(metamagicNo == 1){
									spellNameMetamagic = "Extended ";
								} else if(metamagicNo == 2){
									spellNameMetamagic = "Maximized ";
								} else if(metamagicNo == 3){
									spellNameMetamagic = "Quickened ";
								} else if(metamagicNo == 4){
									spellNameMetamagic = "Silent ";
								} else if(metamagicNo == 5){
									spellNameMetamagic = "Still ";
								}
								String name = className+spellNameMetamagic+spellName;
								System.out.println(name);
							}
						}

					}
				} else {
					//System.out.println(classfilename+" does not exist.");
				}
			}
		}
	}

	private static void getFirstSpells2daRow(){
		while(!spells2da.getEntry("Label", spells2daRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			spells2daRow++;
		}
	}
	private static void getNextSpells2daRow(){
		while(spells2da.getEntry("Label", spells2daRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			spells2daRow++;
		}
	}

	private static void getFirstFeat2daRow(){
		while(!feat2da.getEntry("Label", feat2daRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			feat2daRow++;
		}
	}
	private static void getNextFeat2daRow(){
		while(feat2da.getEntry("Label", feat2daRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			feat2daRow++;
		}
	}

	private static void getFirstIPRPFeat2daRow(){
		while(!iprp_feats2da.getEntry("Label", iprp_feats2daRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			iprp_feats2daRow++;
		}
	}
	private static void getNextIPRPFeat2daRow(){
		while(iprp_feats2da.getEntry("Label", iprp_feats2daRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			iprp_feats2daRow++;
		}
	}

	private static void getFirsttlkRow(){
		while(!customtlk.getEntry(tlkRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			tlkRow++;
		}
	}
	private static void getNexttlkRow(){
		while(customtlk.getEntry(tlkRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			tlkRow++;
		}
	}

	private static String getCheckedTlkEntry(int entryNo){
		if(entryNo > 16777216){
			return customtlk.getEntry(entryNo-16777216);
		}
		return dialogtlk.getEntry(entryNo);
	}
}