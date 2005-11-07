package rmg.rig;

import prc.autodoc.*;
import rmg.rig.*;
import java.io.*;

public class rig {
	//constants
	private static final int AFFIX_COUNT = 1300;
	private static final int BASEITEM_COUNT = 125;
	//public data
	public static Data_2da rig2da         = Data_2da.load2da("2das/rig.2da");
	public static Data_2da rigIP2da       = Data_2da.load2da("2das/rig_ip.2da");
	public static Data_2da baseitem2da    = Data_2da.load2da("2das/baseitems.2da");
	public static Data_2da itempropdef2da = Data_2da.load2da("2das/itempropdef.2da");
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

		System.out.print("Generating blueprints : ");
		//loop over the roots
		for(rootID = 0; rootID < BASEITEM_COUNT; rootID++){
			//loop over the prefixs
			for(prefixID = 0; prefixID < rig2da.getEntryCount(); prefixID++){
				//loop over the suffixs
				for(suffixID = 0; suffixID < rig2da.getEntryCount(); suffixID++){
						assembleItem();
						rmg.Main.spinner.spin();
				}
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
		//setup name tag resref
		itemName    = prefixName + suffixName;
		itemTag     = prefixID+"_"+rootID+"_"+suffixID;
		itemRefRef  = prefixID+"_"+rootID+"_"+suffixID;
		//clear itemproperty array
		itemproperty[] itemproperties = new itemproperty[10];
		itempropertyCount = 0;
		//add itemproperties to array
		for(int i = 1 ; i<=5;i++){
				int itempropertyID = rig2da.getBiowareEntryAsInt("Property"+i, prefixID);
				if(itempropertyID != 0){
					itempropertyCount++;
					itemproperties[itempropertyCount] = new itemproperty(itempropertyID);
				}
		}
		for(int i = 1 ; i<=5;i++){
				int itempropertyID = rig2da.getBiowareEntryAsInt("Property"+i, suffixID);
				if(itempropertyID != 0){
					itempropertyCount++;
					itemproperties[itempropertyCount] = new itemproperty(itempropertyID);
				}
		}
		//print it
		outputToFile();
	}

	private static void outputToFile(){
		try {

			//System.out.println("itemName = "+itemName);
			File target = new File("hak/"+itemRefRef+".uti.xml");
			// Creater the writer and print
			FileWriter writer = new FileWriter(target, true);
			writer.write("Hello World!");
			// Clean up
			writer.flush();
			writer.close();

		} catch (IOException ioe) {
			System.err.println("The following error ocured: "+ioe);
		}
	}
}
