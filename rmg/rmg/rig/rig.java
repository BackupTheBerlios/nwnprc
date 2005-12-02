package rmg.rig;

import prc.autodoc.*;
import rmg.rig.*;
import java.io.*;
import java.util.*;

public class rig {
	//constants
	private static final int BASEITEM_COUNT = 5;//125;
	//public data
	public static Data_2da rig2da         = Data_2da.load2da("2das/rig.2da");
	public static Data_2da rigIP2da       = Data_2da.load2da("2das/rig_ip.2da");
	public static Data_2da baseitem2da    = Data_2da.load2da("2das/baseitems.2da");
	public static Data_2da itempropdef2da = Data_2da.load2da("2das/itempropdef.2da");
	//private data
	private static int rootID        = 0;
	private static int prefixID      = 0;
	private static int suffixID      = 0;
	private static int totalCount    = 0;
	private static item item;

	//main method
	public static void main(String[] args){

		System.out.print("Generating blueprints : ");
		//loop over the roots
		for(rootID = 0; rootID < BASEITEM_COUNT; rootID++){
			//loop over the prefixs
			//for(prefixID = 0; prefixID < rig2da.getEntryCount(); prefixID++){
			for(prefixID = 0; prefixID < 5; prefixID++){
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
		//abort if same suffix as prefix
		//except for no prefix/suffix
		if(prefixID == suffixID
			&& prefixID != 0)
			return;
		//get names from 2da
		String prefixName = rig2da.getBiowareEntry("Text", prefixID);
		String suffixName = rig2da.getBiowareEntry("Text", suffixID);
		//sanity checks
		if(prefixName.equals(null))
			return;
		if(suffixName.equals(null))
			return;
		//setup name tag resref etc
		item = new item();
		item.name    = prefixName + suffixName;
		item.tag     = prefixID+"_"+rootID+"_"+suffixID;
		item.resRef  = prefixID+"_"+rootID+"_"+suffixID;
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
		//print it
		outputToFile(item);
	}

	private static void outputToFile(item item){
		try {

			//System.out.println("itemName = "+itemName);
			File target = new File("temp/"+item.resRef+".uti.xml");
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
}
