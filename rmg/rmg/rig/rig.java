package rmg.rig;

import prc.autodoc.*;
import rmg.rig.*;
import java.io.*;
import java.util.*;

public class rig {
	//constants
	public static Data_2da rig2da         = Data_2da.load2da("rig.2da");
	public static Data_2da rigIP2da       = Data_2da.load2da("rig_ip.2da");
	public static Data_2da rigbase2da     = Data_2da.load2da("rig_base.2da");
	public static Data_2da baseitem2da    = Data_2da.load2da("2das/baseitems.2da");
	public static Data_2da itempropdef2da = Data_2da.load2da("2das/itempropdef.2da");
	public static Data_2da itemprops2da   = Data_2da.load2da("2das/itemprops.2da");
	//private data
	private static int rootID        = 0;
	private static int prefixID      = 0;
	private static int suffixID      = 0;
	private static long totalCount    = 0;
	private static item item;

	//main method
	public static void main(String[] args){

		System.out.print("Generating blueprints : ");
		//loop over the roots
		for(rootID = 0; rootID < rigbase2da.getEntryCount(); rootID++){
			//loop over the prefixs
			for(prefixID = 0; prefixID < rig2da.getEntryCount(); prefixID++){
			//for(prefixID = 0; prefixID < 5; prefixID++){
				//loop over the suffixs
				//dont loop over suffixes, too many products
				//for(suffixID = 0; suffixID < rig2da.getEntryCount(); suffixID++){
				//for(suffixID = 0; suffixID < 5; suffixID++){
						assembleItem();
						updateProgress();
				//}
			}
		}
		System.out.print("\n");
		System.out.println("Done.");
	}

	//public methods

	//private methods
	private static void assembleItem(){
		boolean print = true;
		//abort if same suffix as prefix
		//except for no prefix/suffix
		if(prefixID == suffixID
			&& prefixID != 0)
			print = false;
		//get names from 2da
		String prefixName = rig2da.getBiowareEntry("Text", prefixID);
		//String suffixName = rig2da.getBiowareEntry("Text", suffixID);
		String rootName = rigbase2da.getBiowareEntry("Name", rootID);
		String combinedName;
		if(prefixName != "")
			combinedName = prefixName +" "+rootName;
		else
			combinedName = rootName;
		//sanity checks
		//if(prefixName.equals(""))
		//	print = false;
		//if(suffixName.equals(null))
		//	return;
		//setup name tag resref etc
		item = new item();
		item.name    = combinedName;// + suffixName;
		item.tag     = "rig_"+prefixID+"_"+rootID;//+"_"+suffixID;
		item.resRef  = item.tag;
		item.baseItem = rigbase2da.getBiowareEntryAsInt("BaseItem", rootID);
		//add itemproperties to array
		//dont do this, it can be done in NWScript
		/*
		for(int i = 1 ; i<=5;i++){
				int itempropertyID = rig2da.getBiowareEntryAsInt("Property"+i, prefixID);
				if(itempropertyID != 0){
					item.addItemproperty(new itemproperty(itempropertyID));
				}
		}
		for(int i = 1 ; i<=5;i++){
				int itempropertyID = rig2da.getBiowareEntryAsInt("Property"+i, suffixID);
				if(itempropertyID != 0){
					item.addItemproperty(new itemproperty(itempropertyID));
				}
		}
		*/
		//test if the itemproperties are allowed
		String itempropsdefcolumn = getPropsColumnForValue(baseitem2da.getBiowareEntryAsInt("PropColumn", item.baseItem));
		for(int i = 1 ; i <= 5 ; i ++){
			int itemproperty = rig2da.getBiowareEntryAsInt("Property"+i, prefixID);
			int itempropertytype = rigIP2da.getBiowareEntryAsInt("Type", itemproperty);
			if(itemprops2da.getBiowareEntryAsInt(itempropsdefcolumn, itempropertytype) != 1
				&& rig2da.getBiowareEntry("Property"+i, prefixID) != ""){

				print = false;
				//System.out.println("rig2da.getBiowareEntry(\"Property\"+i, prefixID)="+rig2da.getBiowareEntry("Property"+i, prefixID));
				//System.out.println("itemprops2da.getBiowareEntry(itempropsdefcolumn, itempropertytype)="+itemprops2da.getBiowareEntry(itempropsdefcolumn, itempropertytype));
			}
		}
		//print it
		if(print)
			outputToFile(item);
	}

	private static void outputToFile(item item){
		try {

			//System.out.println("itemName = "+itemName);
			File target = new File("in/"+item.resRef+".uti.xml");
			// Creater the writer and print
			FileWriter writer = new FileWriter(target, true);
			writer.write(item.toXML());
			// Clean up
			writer.flush();
			writer.close();
			totalCount++;

		} catch (IOException ioe) {
			System.err.println("The following error ocured: "+ioe);
		}
	}


	private static void updateProgress(){
		String progress = String.format("%1$5d %2$5d %3$5d (%4$10d)", prefixID, rootID, suffixID, totalCount);
		int length = progress.length();
		for(int i = 0 ; i < length ; i++){
			progress += "\u0008";
		}
		System.out.print(progress);
	}

	private static String getPropsColumnForValue(int value){
		switch(value){
			case 0: return "0_Melee";
			case 1:	return "1_Ranged";
			case 2:	return "2_Thrown";
			case 3:	return "3_Staves";
			case 4:	return "4_Rods";
			case 5:	return "5_Ammo";
			case 6:	return "6_Arm_Shld";
			case 7:	return "7_Helm";
			case 8:	return "8_Potions";
			case 9:	return "9_Scrolls";
			case 10:return "10_Wands";
			case 11:return "11_Thieves";
			case 12:return "12_TrapKits";
			case 13:return "13_Hide";
			case 14:return "14_Claw";
			case 15:return "15_Misc_Uneq";
			case 16:return "16_Misc";
			case 17:return "17_No_Props";
			case 18:return "18_Containers";
			case 19:return "19_HealerKit";
			case 20:return "20_Torch";
			case 21:return "21_Glove";
		}
		return "17_No_Props";
	}
}
