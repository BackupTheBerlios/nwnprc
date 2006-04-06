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
	private static int classSpellRow= 0;
	private static int classFeatRow = 0;
	private static int subradialID  = 7000;
	private static Data_2da classes2da;
	private static Data_2da spells2da;
	private static Data_2da feat2da;
	private static Data_2da iprp_feats2da;
	private static Data_TLK customtlk;
	private static Data_TLK dialogtlk;
	private static Data_2da classSpell2da;
	private static Data_2da classFeat2da;
	private static String[] spellLabels;

	private static int MAGIC_TLK = 16777216;

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
		spellLabels = spells2da.getLabels();
		//get the start/end rows for each file for the reserved blocks
		getFirstSpells2daRow();
		getFirstFeat2daRow();
		getFirstIPRPFeats2daRow();
		getFirstTlkRow();
		System.out.println("First free spells.2da row is "+spells2daRow);
		System.out.println("First free feat.2da row is "+feat2daRow);
		System.out.println("First free iprp_feats.2da row is "+iprp_feats2daRow);
		System.out.println("First free tlk row is "+tlkRow);
		//now process each class in turn
		for(int classRow = 0; classRow<255; classRow++){
			//the feat file is the root of the file naming layout
			String classfilename = classes2da.getEntry("FeatsTable", classRow);
			//check its a real class not padding
			if(classfilename != null
				&& classfilename != "****"
				&& classfilename != ""
				&& classfilename.length() > 9){
				classfilename = classfilename.substring(9, classfilename.length());
				String classCoreFilename = "cls_spcr_"+classfilename;
				//check the file exists
				File classCoreFile = new File("2das\\"+classCoreFilename+".2da");
				if(classCoreFile.exists()){
					//open the core spell file
					Data_2da classCoreSpell2da = Data_2da.load2da("2das\\"+classCoreFilename+".2da", true);
					//get the new filename
					String classSpellFilename = "cls_spell_"+classfilename;
					classSpell2da = Data_2da.load2da("2das\\"+classSpellFilename+".2da", true);
					String classFeatFilename = "cls_feat_"+classfilename;
					classFeat2da = Data_2da.load2da("2das\\"+classFeatFilename+".2da", true);
					getFirstClassFeat2daRow();
					//get the class name
					String className = getCheckedTlkEntry(classes2da.getBiowareEntryAsInt("Name", classRow))+" ";
					String classLabel = classes2da.getEntry("Label", classRow)+"_";
					//get the maximum spell level
					int maxLevel = 0;
					for(int row = 0; row < classCoreSpell2da.getEntryCount(); row ++) {
						int tempLevel = classCoreSpell2da.getBiowareEntryAsInt("Level", row);
						if(tempLevel>maxLevel){
							maxLevel = tempLevel;
						}
					}
					//clear the old cls_spell_*.2da file
					String[] originalClassSpellRow = classSpell2da.getLabels();
					for(int row = 0; row < classSpell2da.getEntryCount(); row ++) {
						for(int i=0; i < originalClassSpellRow.length; i++){
							classSpell2da.setEntry(originalClassSpellRow[i], row, "****");
						}
					}
					classSpellRow = 0;//number of rows in the cls_spell_*.2da file
					//add one blank row to tell which slots are blank
					//add a cls_spell_*.2da line if needed
					if(classSpellRow > classSpell2da.getEntryCount()){
							classSpell2da.appendRow();
					}
					//set its label
					classSpell2da.setEntry("Label", classSpellRow, "****");
					//make it point to the new spells.2da
					classSpell2da.setEntry("SpellID", classSpellRow, "****");
					//make it point to the old spells.2da
					classSpell2da.setEntry("RealSpellID", classSpellRow, "****");
					//make it point to the new feat.2da
					classSpell2da.setEntry("FeatID", classSpellRow, "****");
					//make it point to the new iprp_feats.2da
					classSpell2da.setEntry("IPFeatID", classSpellRow, "****");
					//add the metamagic checks
					classSpell2da.setEntry("ReqFeat", classSpellRow, "****");
					//set its level
					classSpell2da.setEntry("Level", classSpellRow, "****");
					classSpellRow++;
					//loop over all the spells
					for(int row = 0; row < classCoreSpell2da.getEntryCount(); row ++) {
						//check its not a null row

						if(classCoreSpell2da.getEntry("SpellID", row).equals("****")){
						}
						else
						{
						//get the real spellID
						int spellID = classCoreSpell2da.getBiowareEntryAsInt("SpellID", row);
						//get the level of the spell
						int spellLevel = classCoreSpell2da.getBiowareEntryAsInt("Level", row);
						//get the metamagic reference to know what types work
						int metamagic = spells2da.getBiowareEntryAsInt("Metamagic", spellID);
						if(metamagic == 0)
							System.out.println("Check metamagic for spell "+spellID);

						//need to handle subradials here too
						//subradials are handled within addNewSpellbookData()

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
								String spellLabelMetamagic = "";
								String metaScript = "";
								int metamagicLevel = 0;
								String metamagicFeat = "****";
								if(metamagicNo == -1){
									spellNameMetamagic = "";
									spellLabelMetamagic = "";
									metaScript = "sp";
									metamagicLevel = 0;
									metamagicFeat = "****";
								} else if(metamagicNo == 0){
									spellNameMetamagic = "Empowered ";
									spellLabelMetamagic = "Empowered_";
									metaScript = "em";
									metamagicLevel = 2;
									metamagicFeat = "11";
								} else if(metamagicNo == 1){
									spellNameMetamagic = "Extended ";
									spellLabelMetamagic = "Exteneded_";
									metaScript = "ex";
									metamagicLevel = 1;
									metamagicFeat = "12";
								} else if(metamagicNo == 2){
									spellNameMetamagic = "Maximized ";
									spellLabelMetamagic = "Maximized_";
									metaScript = "ma";
									metamagicLevel = 3;
									metamagicFeat = "25";
								} else if(metamagicNo == 3){
									spellNameMetamagic = "Quickened ";
									spellLabelMetamagic = "Quickened_";
									metaScript = "qu";
									metamagicLevel = 4;
									metamagicFeat = "29";
								} else if(metamagicNo == 4){
									spellNameMetamagic = "Silent ";
									spellLabelMetamagic = "Silent_";
									metaScript = "si";
									metamagicLevel = 1;
									metamagicFeat = "33";
								} else if(metamagicNo == 5){
									spellNameMetamagic = "Still ";
									spellLabelMetamagic = "Still_";
									metaScript = "st";
									metamagicLevel = 1;
									metamagicFeat = "37";
								}
								//check if the metamagic adjusted level is less than the maximum level
								if((metamagicLevel+spellLevel) <= maxLevel){
									//debug printout
									//System.out.println(name+" : "+label);
									addNewSpellbookData(spellID,
														classfilename,
														metaScript,
														metamagicNo,
														metamagicLevel,
														metamagicFeat,
														spellLevel,
														className,
														spellNameMetamagic,
														classLabel,
														spellLabelMetamagic,
														0);
								}//end of level check
							}//end of metamamgic check
						}//end of metamagic loop
						}
					}//end of cls_spells_*_core.2da loop
					//save the new cls_spell_*.2da file
					classSpell2da.save2da("2das", true, true);
					classFeat2da.save2da("2das", true, true);
				} else {
					//System.out.println(classfilename+" does not exist.");
				}
			}
		}
		//now resave the files we opened
		spells2da.save2da("2das", true, true);
		feat2da.save2da("2das", true, true);
		iprp_feats2da.save2da("2das", true, true);
		customtlk.saveAsXML("prc_consortium", "tlk", true);
	}

	private static void addNewSpellbookData(int spellID,
											String classfilename,
											String metaScript,
											int metamagicNo,
											int metamagicLevel,
											String metamagicFeat,
											int spellLevel,
											String className,
											String spellNameMetamagic,
											String classLabel,
											String spellLabelMetamagic,
											int subradialMaster){
		//get the name of the spell
		String spellName = getCheckedTlkEntry(spells2da.getBiowareEntryAsInt("Name", spellID));
		//get the label of the spell
		String spellLabel = spells2da.getEntry("Label", spellID);
		//assemble the name
		String name = className+spellNameMetamagic+spellName;
		//assemble the label
		String label = classLabel+spellLabelMetamagic+spellLabel;
		//set the next tlk line to the name
		customtlk.setEntry(tlkRow, name);

		//copy the original spells.2da line to the next free spells.2da line
		String[] originalSpellRow = spells2da.getRow(spellID);
		for(int i=0; i<originalSpellRow.length; i++){
			spells2da.setEntry(spellLabels[i], spells2daRow, spells2da.getEntry(spellLabels[i], spellID));
		}
		//change the ImpactScript
		String script = "prc_"+classfilename+"_"+metaScript+"_gen";
		spells2da.setEntry("ImpactScript", spells2daRow, script);
		//change the Label
		spells2da.setEntry("Label", spells2daRow, label);
		//change the Name
		spells2da.setEntry("Name", spells2daRow, Integer.toString(tlkRow+MAGIC_TLK));
		//if quickened, set oconjuring/casting duration to zero
		if(metamagicNo == 3){
			spells2da.setEntry("ConjTime", spells2daRow, "0");
			spells2da.setEntry("CastTime", spells2daRow, "0");
		}
		//if silenced, set it to no vocals
		if(metamagicNo == 4){
			spells2da.setEntry("ConjSoundVFX", spells2daRow, "****");
			spells2da.setEntry("ConjSoundMale", spells2daRow, "****");
			spells2da.setEntry("ConjSoundFemale", spells2daRow, "****");
			spells2da.setEntry("CastSound", spells2daRow, "****");
		}
		//if stilled, set it to no casting animations
		if(metamagicNo == 5){
			spells2da.setEntry("CastAnim", spells2daRow, "****");
			spells2da.setEntry("ConjAnim", spells2daRow, "****");
		}
		//set the level to the correct value, including metamagic
		spells2da.setEntry("Innate", spells2daRow, Integer.toString(metamagicLevel+spellLevel));
		//clear class levels
		spells2da.setEntry("Bard", 		spells2daRow, "****");
		spells2da.setEntry("Cleric", 	spells2daRow, "****");
		spells2da.setEntry("Druid", 	spells2daRow, "****");
		spells2da.setEntry("Paladin", 	spells2daRow, "****");
		spells2da.setEntry("Ranger", 	spells2daRow, "****");
		spells2da.setEntry("Wiz_Sorc", 	spells2daRow, "****");
		//set subradial master, if applicable
		if(subradialMaster != 0){
			spells2da.setEntry("Master", spells2daRow, Integer.toString(subradialMaster));
			//calculate the new feat id
			int subradialFeatID = spells2da.getBiowareEntryAsInt("FeatID", subradialMaster);
			//Set the FEATID on each of the subspells as follows: (65536 * subfeat) + feat ID.
			//The top 16 bits is used for subfeat, the bottom for feat.
			subradialFeatID = (65536*subradialID)+subradialFeatID;
			spells2da.setEntry("FeatID", spells2daRow, Integer.toString(subradialFeatID));
		} else {
			spells2da.setEntry("Master", spells2daRow, "****");
			//make it point to the new feat.2da line that will be added soon
			spells2da.setEntry("FeatID", spells2daRow, Integer.toString(feat2daRow));
		}
		//remove projectiles from firing because the real spell will do this
		spells2da.setEntry("Proj", 				spells2daRow, "0");
		spells2da.setEntry("ProjModel", 		spells2daRow, "****");
		spells2da.setEntry("ProjType", 			spells2daRow, "****");
		spells2da.setEntry("ProjSpwnPoint", 	spells2daRow, "****");
		spells2da.setEntry("ProjSound", 		spells2daRow, "****");
		spells2da.setEntry("ProjOrientation", 	spells2daRow, "****");
		spells2da.setEntry("HasProjectile", 	spells2daRow, "0");

		//add a feat.2da line
		if(subradialMaster == 0){
			//make it point to the new spells.2da line
			feat2da.setEntry("SPELLID", feat2daRow, Integer.toString(spells2daRow));
			//change the Name
			feat2da.setEntry("FEAT", feat2daRow, Integer.toString(tlkRow+MAGIC_TLK));
			//change the Label
			feat2da.setEntry("LABEL", feat2daRow, label);
			//change the description
			feat2da.setEntry("DESCRIPTION", feat2daRow, spells2da.getEntry("SpellDesc", spells2daRow));
			//change the icon
			feat2da.setEntry("ICON", feat2daRow, spells2da.getEntry("IconResRef", spells2daRow));
			//if spell is hostile, make feat hostile
			if(spells2da.getEntry("HostileSetting", spellID).equals("1")){
				feat2da.setEntry("HostileFeat", feat2daRow, "1");
			} else {
				feat2da.setEntry("HostileFeat", feat2daRow, "0");
			}
			//set the category to the same as the spell
			feat2da.setEntry("CATEGORY", feat2daRow, spells2da.getEntry("Category", spells2daRow));
		}


		//add an iprp_feats.2da line
		if(subradialMaster == 0){
			//set its label
			iprp_feats2da.setEntry("Label", iprp_feats2daRow, label);
			//set its name
			iprp_feats2da.setEntry("Name", iprp_feats2daRow, Integer.toString(tlkRow+MAGIC_TLK));
			//make it point to the new feat.2da line
			iprp_feats2da.setEntry("FeatIndex", iprp_feats2daRow, Integer.toString(feat2daRow));
			//set its cost to 0.0
			iprp_feats2da.setEntry("Cost", iprp_feats2daRow, "0.0");
		}

		//add a cls_spell_*.2da line if needed
		if(classSpellRow >= classSpell2da.getEntryCount()){
				classSpell2da.appendRow();
		}
		//set its label
		classSpell2da.setEntry("Label", classSpellRow, label);
		//make it point to the new spells.2da
		classSpell2da.setEntry("SpellID", classSpellRow, Integer.toString(spells2daRow));
		//make it point to the old spells.2da
		classSpell2da.setEntry("RealSpellID", classSpellRow, Integer.toString(spellID));
		//if its a subradial, dont do this
		if(subradialMaster == 0){
			//make it point to the new feat.2da
			classSpell2da.setEntry("FeatID", classSpellRow, Integer.toString(feat2daRow));
			//make it point to the new iprp_feats.2da
			classSpell2da.setEntry("IPFeatID", classSpellRow, Integer.toString(iprp_feats2daRow));
			//add the metamagic checks
			classSpell2da.setEntry("ReqFeat", classSpellRow, metamagicFeat);
			//set its level
			classSpell2da.setEntry("Level", classSpellRow, Integer.toString(metamagicLevel+spellLevel));
		} else {
			//make it point to the new feat.2da
			classSpell2da.setEntry("FeatID", classSpellRow, "****");
			//make it point to the new iprp_feats.2da
			classSpell2da.setEntry("IPFeatID", classSpellRow, "****");
			//add the metamagic checks
			classSpell2da.setEntry("ReqFeat", classSpellRow, "****");
			//set its level
			classSpell2da.setEntry("Level", classSpellRow, "****");
		}

		//cls_feat_*.2da
		if(subradialMaster == 0){
			classFeat2da.setEntry("FeatLabel", classFeatRow, label);
			classFeat2da.setEntry("FeatIndex", classFeatRow, Integer.toString(feat2daRow));
			classFeat2da.setEntry("List", classFeatRow, Integer.toString(0));
			classFeat2da.setEntry("GrantedOnLevel", classFeatRow, Integer.toString(99));
			classFeat2da.setEntry("OnMenu", classFeatRow, Integer.toString(1));
		}


		//move to next file lines
		getNextSpells2daRow();
		getNextTlkRow();
		//only need new ones of these if its not a subradial
		if(subradialMaster == 0){
			getNextFeat2daRow();
			getNextIPRPFeats2daRow();
			getNextClassFeat2daRow();
		}else{ //do this if it is a subradial
			// increase the subradial id ready for next one
			subradialID++;
		}
		classSpellRow++;

		//add subradial spells
		if(subradialMaster == 0){
			//store the spell row the master uses
			//will be incremented by subradials
			//the -1 is because you want the last used row, not the current blank row
			int masterSpellID = spells2daRow-1;
			for(int subradial = 1; subradial <= 5; subradial++){
				if(spells2da.getBiowareEntryAsInt("SubRadSpell"+subradial, spellID) != 0){
					addNewSpellbookData(spells2da.getBiowareEntryAsInt("SubRadSpell"+subradial, spellID),
										classfilename,
										metaScript,
										metamagicNo,
										metamagicLevel,
										metamagicFeat,
										spellLevel,
										className,
										spellNameMetamagic,
										classLabel,
										spellLabelMetamagic,
										masterSpellID);
					//update the master rows with the subradial spell rows
					//the -1 is because you want the last used row, not the current blank row
					spells2da.setEntry("SubRadSpell"+subradial, masterSpellID, Integer.toString(spells2daRow-1));
				}
			}
		}
	}

	private static void getFirstSpells2daRow(){
		System.out.print("Finding start of spells.2da ");
		while(!spells2da.getEntry("Label", spells2daRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			spells2daRow++;
			if(spells2daRow> spells2da.getEntryCount()){
				System.out.println("Spells.2da reached the end of the file.");
				System.exit(1);
			}
			spinner.spin();
		}
		spells2daRow++;
		System.out.println("- Done");
	}
	private static void getNextSpells2daRow(){
		spells2daRow++;
		if(spells2da.getEntry("Label", spells2daRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			getFirstSpells2daRow();
		}
	}

	private static void getFirstFeat2daRow(){
		System.out.print("Finding start of feat.2da ");
		while(!feat2da.getEntry("Label", feat2daRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			feat2daRow++;
			if(feat2daRow> feat2da.getEntryCount()){
				System.out.println("Feat.2da reached the end of the file.");
				System.exit(1);
			}
			spinner.spin();
		}
		feat2daRow++;
		System.out.println("- Done");
	}
	private static void getNextFeat2daRow(){
		feat2daRow++;
		if(feat2da.getEntry("Label", feat2daRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			getFirstFeat2daRow();
		}
	}

	private static void getFirstIPRPFeats2daRow(){
		System.out.print("Finding start of iprp_spells.2da ");
		while(!iprp_feats2da.getEntry("Label", iprp_feats2daRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			iprp_feats2daRow++;
			if(iprp_feats2daRow> iprp_feats2da.getEntryCount()){
				System.out.println("iprp_feats.2da reached the end of the file.");
				System.exit(1);
			}
			spinner.spin();
		}
		iprp_feats2daRow++;
		System.out.println("- Done");
	}
	private static void getNextIPRPFeats2daRow(){
		iprp_feats2daRow++;
		if(iprp_feats2da.getEntry("Label", iprp_feats2daRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			getFirstIPRPFeats2daRow();
		}
	}

	private static void getFirstClassFeat2daRow(){
		classFeatRow = 0;
		System.out.print("Finding start of cls_feat_*.2da ");
		while(!classFeat2da.getEntry("FeatLabel", classFeatRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			classFeatRow++;
			if(classFeatRow >= classFeat2da.getEntryCount()){
				System.out.println("cls_feat_*.2da reached the end of the file.");
				System.exit(1);
			}
			spinner.spin();
		}
		getNextClassFeat2daRow();
		System.out.println("- Done");
	}
	private static void getNextClassFeat2daRow(){
		classFeatRow++;
		if(classFeat2da.getEntry("FeatLabel", classFeatRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			classFeat2da.insertRow(classFeatRow);
		}
	}

	private static void getFirstTlkRow(){
		System.out.print("Finding start of prc_consortium.tlk ");
		while(!customtlk.getEntry(tlkRow).equals("####START_OF_NEW_SPELLBOOK_RESERVE")){
			tlkRow++;
			spinner.spin();
		}
		tlkRow++;
		System.out.println("- Done");
	}
	private static void getNextTlkRow(){
		tlkRow++;
		if(customtlk.getEntry(tlkRow).equals("####END_OF_NEW_SPELLBOOK_RESERVE")){
			getFirstTlkRow();
		}
	}

	private static String getCheckedTlkEntry(int entryNo){
		if(entryNo > MAGIC_TLK){
			return customtlk.getEntry(entryNo-16777216);
		}
		return dialogtlk.getEntry(entryNo);
	}
}