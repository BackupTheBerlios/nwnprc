package prc.utils;

import prc.autodoc.*;

import java.io.*;

//for the spinner
import static prc.Main.*;

public final class SpellbookMaker{
	private SpellbookMaker(){}

	private static int spells2daRow = 0;
	private static int feat2daRow   = 0;
	private static int tlkRow       = 0;
	private static Data_2da classes2da;
	private static Data_2da spells2da;
	private static Data_2da feat2da;
	private static Data_TLK tlk;

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
		tlk = new Data_TLK("tlk\\prc_consortium.tlk");
		//get the start/end rows for each file for the reserved blocks
		getFirstSpells2daRow();
		getFirstFeat2daRow();
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
				classfilename = "cls_spell_"+classfilename+"_core";
				//check the file exists
				File classFile = new File(classfilename);
				if(classFile.exists()){
					Data_2da classspells2da = Data_2da.load2da("2das\\"+classfilename+".2da", true);
					System.out.println(classfilename+" exists.");
				} else {
					//System.out.println(classfilename+" does not exist.");
				}
			}
		}
	}

	private static void getFirstSpells2daRow(){
		String label = spells2da.getEntry("Label", spells2daRow);
		while(label != "####START_OF_NEW_SPELLBOOK_RESERVE"){
			spells2daRow++;
			label = spells2da.getEntry("Label", spells2daRow);
		}
		//increase it once more to start with the next row
		spells2daRow++;
	}
	private static void getNextSpells2daRow(){
		spells2daRow++;
		String label = spells2da.getEntry("Label", spells2daRow);
		while(label == "####END_OF_NEW_SPELLBOOK_RESERVE"){
			spells2daRow++;
			label = spells2da.getEntry("Label", spells2daRow);
		}
	}

	private static void getFirstFeat2daRow(){
		String label = feat2da.getEntry("Label", feat2daRow);
		while(label != "####START_OF_NEW_SPELLBOOK_RESERVE"){
			feat2daRow++;
			label = feat2da.getEntry("Label", feat2daRow);
		}
		//increase it once more to start with the next row
		feat2daRow++;
	}
	private static void getNextFeat2daRow(){
		feat2daRow++;
		String label = feat2da.getEntry("Label", feat2daRow);
		while(label == "####END_OF_NEW_SPELLBOOK_RESERVE"){
			feat2daRow++;
			label = feat2da.getEntry("Label", feat2daRow);
		}
	}


}