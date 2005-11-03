package rmg.rig;

import prc.autodoc.*;

public class rig {
	//constants
	private static final AFFIX_COUNT = 1300;
	private static final BASEITEM_COUNT = 125;
	//public data
	//private data
	private Data_2da rig2da;
	private Data_2da rigIP2da;
	private Data_2da baseitem2da;
	private int rootID        = 0;
	private int prefixID      = 0;
	private int suffixID      = 0;
	private String itemName   = "";
	private String itemTag    = "";
	private String itemRefRef = "";

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
		itemName = rig2da.getEntry("Text", prefixID) + rig2da.getEntry("Text", suffixID);
		itemTag  = prefixID+"_"+rootID+"_"+suffixID;
		//print it
		outputToFile();
	}

	private void outputToFile(){
	}
}
