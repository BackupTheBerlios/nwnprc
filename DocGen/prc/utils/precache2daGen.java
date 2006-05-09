package prc.utils;

import prc.autodoc.*;
import java.io.*;
import java.util.*;

import static prc.Main.*;

/**
 * A class that parses 2das and determines which rows need to be
 * cached for the spells / powers to work fast.
 * 
 * @author Heikki 'Ornedan' Aitakangas
 */
public class precache2daGen {
	private static String path2daDir = null;
	private static Data_2da output   = new Data_2da("precacherows");
	static {
		output.addColumn("Label");
		output.addColumn("RowNum");
		output.addColumn("Type");
	}
	private static Data_2da spells = null/*,
	                        feat   = null*/;
	
	private static int normalSpellMaxRow = 5000;
	
	/**
	 * Ye olde maine methode.
	 * 
	 * @param args
	 */
	public static void main(String[] args) throws Throwable {
//		 parse args
		for(int i = 0; i < args.length; i++){//[--help] | [--normalspellsmax #] pathto2dadir
			// Parameter parseage
			String param = args[i];
			if(param.startsWith("-")){
				if(param.equals("--help")) readMe();
				else if(param.equals("--normalspellsmax")){
					try {
						normalSpellMaxRow = Integer.parseInt(args[i++]);
					} catch(NumberFormatException e) {
						err_pr.println("Invalid number given with parameter --normalspellsmax");
						readMe();
					}
				}
				else{
					for(char c : param.substring(1).toCharArray()){
						switch(c){
						default:
							System.out.println("Unknown parameter: " + c);
							readMe();
						}
					}
				}
			}
			else{
				// It's a pathname
				if(path2daDir == null)
					path2daDir = param;
			}
		}
		
		if(path2daDir == null)
			readMe();
		
		// Load a directory listing
		File dir = new File(path2daDir);
		if(!dir.isDirectory()) {
			err_pr.println("Not a directory: " + path2daDir);
			System.exit(1);
		}
		
		// Load the main 2das
		spells = Data_2da.load2da(dir.getPath() + File.separator + "spells.2da");
		//feat   = Data_2da.load2da(dir.getPath() + File.separator + "feat.2da");
		
		handleNormalSpells();
		handlePsionics(dir);
		
		output.appendRow();
		output.setEntry("Label", output.getEntryCount() - 1, "Stop");
		
		output.save2da(".", false, true);
	}

	private static void readMe(){
		//					0        1         2         3         4         5         6         7         8
		//					12345678901234567890123456789012345678901234567890123456789012345678901234567890
		System.out.println("Usage:\n"+
	                       "  [--help] | [--normalspellsmax #] pathto2dadir\n"+
	                       "\n" +
	                       " pathto2dadir  path of the directory containing the 2das that will be parsed\n" +
	                       "\n" +
	                       " normalspellsmax    The greatest index to which the normal spells seek will\n" +
	                       "                    reach to. Defaults to 5000\n" +
	                       "\n" +
	                       "\n" +
	                       "  --help  prints this text\n"
	            );
		System.exit(0);
	}
	
	private static void handleNormalSpells() {
		int temp;
		for(int i = 0; i < normalSpellMaxRow; i++) {
			if(// Check the row i itself
			   !spells.getEntry("Bard",     i).equals("****") ||
			   !spells.getEntry("Cleric",   i).equals("****") ||
			   !spells.getEntry("Druid",    i).equals("****") ||
			   !spells.getEntry("Paladin",  i).equals("****") ||
			   !spells.getEntry("Ranger",   i).equals("****") ||
			   !spells.getEntry("Wiz_Sorc", i).equals("****") ||
			   // Check the master
			   (// Make sure a master entry exists
			    !spells.getEntry("Master", i).equals("****") &&
			    (// See if it's a normal spell
				 !spells.getEntry("Bard",     temp = Integer.parseInt(spells.getEntry("Master", i))).equals("****") ||
			     !spells.getEntry("Cleric",   temp).equals("****") ||
			     !spells.getEntry("Druid",    temp).equals("****") ||
			     !spells.getEntry("Paladin",  temp).equals("****") ||
			     !spells.getEntry("Ranger",   temp).equals("****") ||
			     !spells.getEntry("Wiz_Sorc", temp).equals("****")
			     )
			    )
			   ){
				// It's a normal spell or a subradial of one
				output.appendRow();
				temp = output.getEntryCount() - 1;
				output.setEntry("Label",  temp, "****");
				output.setEntry("RowNum", temp, Integer.toString(i));
				output.setEntry("Type",   temp, "N");
			}
		}
	}
	
	private static void handlePsionics(File dir) {
		File[] files = dir.listFiles(new FileFilter(){
			public boolean accept(File file){
				return file.getName().toLowerCase().startsWith("cls_psipw_") &&
				       file.getName().toLowerCase().endsWith(".2da");
			}
		});
		
		Data_2da[] cls_psipw_2das = new Data_2da[files.length];
		for(int i = 0; i < files.length; i++)
			cls_psipw_2das[i] = Data_2da.load2da(files[i].getPath());
		
		int temp;
		Set<Integer> realEntriesHandled = new HashSet<Integer>();
		for(Data_2da cls_psipw : cls_psipw_2das) {
			for(int i = 0; i < cls_psipw.getEntryCount(); i++) {
				// Add the feat-linked power's data
				if(!cls_psipw.getEntry("SpellID", i).equals("****")) {
					output.appendRow();
					temp = output.getEntryCount() - 1;
					output.setEntry("Label",  temp, "****");
					output.setEntry("RowNum", temp, cls_psipw.getEntry("SpellID", i));
					output.setEntry("Type",   temp, "P");
				}
				// The feat's data
				if(!cls_psipw.getEntry("FeatID", i).equals("****")) {
					output.appendRow();
					temp = output.getEntryCount() - 1;
					output.setEntry("Label",  temp, "****");
					output.setEntry("RowNum", temp, cls_psipw.getEntry("FeatID", i));
					output.setEntry("Type",   temp, "F");
				}
				// Add the real entry's data
				if(!cls_psipw.getEntry("RealSpellID", i).equals("****")) {
					temp = Integer.parseInt(cls_psipw.getEntry("RealSpellID", i));
					if(!realEntriesHandled.contains(temp)) {
						realEntriesHandled.add(temp);
						output.appendRow();
						temp = output.getEntryCount() - 1;
						output.setEntry("Label",  temp, "****");
						output.setEntry("RowNum", temp, cls_psipw.getEntry("RealSpellID", i));
						output.setEntry("Type",   temp, "N");
					}
				}
			}
		}
	}
}
