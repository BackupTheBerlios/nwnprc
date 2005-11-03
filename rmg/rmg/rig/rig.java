package rmg.rig;

import prc.autodoc.*;
import rmg.rig.*;

public class rig {
	//constants
	private static final int AFFIX_COUNT = 1300;
	private static final int BASEITEM_COUNT = 125;
	//public data
	public static Data_2da rig2da         = Data_2da.load2da("rig.2da");
	public static Data_2da rigIP2da       = Data_2da.load2da("rig_ip.2da");
	public static Data_2da baseitem2da    = Data_2da.load2da("baseitems.2da");
	public static Data_2da itempropdef2da = Data_2da.load2da("itempropdef.2da");
	//private data
	private static int rootID        = 0;
	private static int prefixID      = 0;
	private static int suffixID      = 0;
	private static String itemName   = "";
	private static String itemTag    = "";
	private static String itemRefRef = "";
	private static itemproperty[] itemproperties = new itemproperty[10];
	private static int itempropertyCount = 0;

	//main method
	public static void main(String[] args){

		//loop over the roots
		for(rootID = 0; rootID < BASEITEM_COUNT; rootID++){
			//loop over the prefixs
			for(prefixID = 0; prefixID < AFFIX_COUNT; prefixID++){
				//loop over the suffixs
				for(suffixID = 0; suffixID < AFFIX_COUNT; suffixID++){
						assembleItem();
				}
			}
		}
	}

	//public methods

	//private methods
	private static void assembleItem(){
		//abort if same suffix as prefix
		//except for no prefix/suffix
		if(prefixID == suffixID
			&& prefixID != 0)
			return;
		//setup name tag resref
		itemName    = rig2da.getEntry("Text", prefixID) + rig2da.getEntry("Text", suffixID);
		itemTag     = prefixID+"_"+rootID+"_"+suffixID;
		itemRefRef  = prefixID+"_"+rootID+"_"+suffixID;
		//add itemproperties to array
		for(int i = 1 ; i<=5;i++){
				int itempropertyID = Integer.decode(rig2da.getEntry("Property"+i, prefixID));
				if(itempropertyID != 0){
					itempropertyCount++;
					itemproperties[itempropertyCount] = new itemproperty(itempropertyID);
				}
		}
		for(int i = 1 ; i<=5;i++){
				int itempropertyID = Integer.decode(rig2da.getEntry("Property"+i, suffixID));
				if(itempropertyID != 0){
					itempropertyCount++;
					itemproperties[itempropertyCount] = new itemproperty(itempropertyID);
				}
		}
		//print it
		outputToFile();
	}

	private static void outputToFile(){
		System.out.println("itemName = "+itemName);
	}
}
