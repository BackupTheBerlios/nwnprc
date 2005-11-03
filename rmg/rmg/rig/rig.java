package rmg.rig;

import prc.autodoc.*;
import rmg.rig.*;

public class rig {
	//constants
	private static final AFFIX_COUNT = 1300;
	private static final BASEITEM_COUNT = 125;
	//public data
	private static Data_2da rig2da         = load2da("rig.2da");
	private static Data_2da rigIP2da       = load2da("rig_ip.2da");
	private static Data_2da baseitem2da    = load2da("baseitems.2da");
	private static Data_2da itempropdef2da = load2da("itempropdef.2da");
	//private data
	private int rootID        = 0;
	private int prefixID      = 0;
	private int suffixID      = 0;
	private String itemName   = "";
	private String itemTag    = "";
	private String itemRefRef = "";
	private itemproperty[] itemproperties = new itemproperty[10];
	private int itempropertyCount = 0;

	//main method
	public void main(String[] args){

		//load 2das
		rig2da      = load2da("rig.2da");
		rigIP2da    = load2da("rig_ip.2da");
		baseitem2da = load2da("baseitems.2da");

		//loop over the roots
		for(rootID = 0; rootID < BASEITEM_COUNT; rootID+){
			//loop over the prefixs
			for(prefixID = 0; prefixID < AFFIX_COUNT; prefixID+){
				//loop over the suffixs
				for(suffixID = 0; suffixID < AFFIX_COUNT; suffixID+){
						assembleItem();
				}
			}
		}
	}

	//public methods

	//private methods
	private void assembleItem(){
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
		}
		for(int i = 1 ; i<=5;i++){
		}
		//print it
		outputToFile();
	}

	private void outputToFile(){
	}
}
