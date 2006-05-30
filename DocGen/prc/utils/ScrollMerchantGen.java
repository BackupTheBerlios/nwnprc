package prc.utils;

import static prc.Main.verbose;

import java.util.*;
import java.io.*;
import prc.autodoc.*;


/**
 *  A little tool that parses des_crft_scroll, extracts unique item resrefs from it and
 *  makes a merchant selling those resrefs.
 *
 * @author Heikki 'Ornedan' Aitakangas
 */
public class ScrollMerchantGen {

	/**
	 * Ye olde maine methode.
	 * 
	 * @param args         The arguments
	 * @throws IOException If the writing fails, just die on the exception
	 */
	public static void main(String[] args) throws IOException{
		if(args.length == 0) readMe();
		String filePath = null;

		// parse args
		for(String param : args){//[--help] | path_to_des_crft_scroll.2da
			// Parameter parseage
			if(param.startsWith("-")){
				if(param.equals("--help")) readMe();
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
				if(filePath == null)
					filePath = param;
				else{
					System.out.println("Unknown parameter: " + param);
					readMe();
				}
			}
		}

		// Load the 2da file
		Data_2da scrolls2da = Data_2da.load2da(filePath);

		// Loop over the scroll entries and get a list of unique resrefs
		Set<String> scrollResRefs = new TreeSet<String>();
		String entry;
		for(int i = 0; i < scrolls2da.getEntryCount(); i++) {
			if(!(entry = scrolls2da.getEntry("Wiz_Sorc", i)).equals("****"))
				scrollResRefs.add(entry.toUpperCase());
			if(!(entry = scrolls2da.getEntry("Cleric", i)).equals("****"))
				scrollResRefs.add(entry.toUpperCase());
			if(!(entry = scrolls2da.getEntry("Paladin", i)).equals("****"))
				scrollResRefs.add(entry.toUpperCase());
			if(!(entry = scrolls2da.getEntry("Druid", i)).equals("****"))
				scrollResRefs.add(entry.toUpperCase());
			if(!(entry = scrolls2da.getEntry("Ranger", i)).equals("****"))
				scrollResRefs.add(entry.toUpperCase());
			if(!(entry = scrolls2da.getEntry("Bard", i)).equals("****"))
				scrollResRefs.add(entry.toUpperCase());
		}

		String xmlPrefix =
"<gff name=\"prc_wiz_recipe.utm\" type=\"UTM \" version=\"V3.2\" >"     + "\n" +
"    <struct id=\"-1\" >"                                               + "\n" +
"        <element name=\"ResRef\" type=\"11\" value=\"prc_scrolls\" />" + "\n" +
"        <element name=\"LocName\" type=\"12\" value=\"64113\" >"       + "\n" +
"            <localString languageId=\"0\" value=\"prc_scrolls\" />"    + "\n" +
"        </element>"                                                    + "\n" +
"        <element name=\"Tag\" type=\"10\" value=\"prc_scrolls\" />"    + "\n" +
"        <element name=\"MarkUp\" type=\"5\" value=\"100\" />"          + "\n" +
"        <element name=\"MarkDown\" type=\"5\" value=\"100\" />"        + "\n" +
"        <element name=\"BlackMarket\" type=\"0\" value=\"0\" />"       + "\n" +
"        <element name=\"BM_MarkDown\" type=\"5\" value=\"15\" />"      + "\n" +
"        <element name=\"IdentifyPrice\" type=\"5\" value=\"-1\" />"    + "\n" +
"        <element name=\"MaxBuyPrice\" type=\"5\" value=\"-1\" />"      + "\n" +
"        <element name=\"StoreGold\" type=\"5\" value=\"-1\" />"        + "\n" +
"        <element name=\"OnOpenStore\" type=\"11\" value=\"\" />"       + "\n" +
"        <element name=\"OnStoreClosed\" type=\"11\" value=\"\" />"     + "\n" +
"        <element name=\"WillNotBuy\" type=\"15\" />"                   + "\n" +
"        <element name=\"WillOnlyBuy\" type=\"15\" >"                   + "\n" +
"            <struct id=\"97869\" >"                                    + "\n" +
"                <element name=\"BaseItem\" type=\"5\" value=\"29\" />" + "\n" +
"            </struct>"                                                 + "\n" +
"        </element>"                                                    + "\n" +
"        <element name=\"StoreList\" type=\"15\" >"                     + "\n" +
"            struct id=\"0\" />"                                        + "\n" +
"            <struct id=\"4\" />"                                       + "\n" +
"            <struct id=\"2\" >"                                        + "\n" +
"                <element name=\"ItemList\" type=\"15\" >"              + "\n";
		String xmlSuffix =
"                </element>"                                            + "\n" +
"			 </struct>"                                                 + "\n" +
"            <struct id=\"3\" />"                                       + "\n" +
"            <struct id=\"1\" />"                                       + "\n" +
"        </element>"                                                    + "\n" +
"        <element name=\"ID\" type=\"0\" value=\"0\" />"                + "\n" +
"        <element name=\"Comment\" type=\"10\" value=\"\" />"           + "\n" +
"    </struct>"                                                         + "\n" +
"</gff>"                                                                + "\n";

		StringBuffer xmlString = new StringBuffer();
		int posCounter = 0;
		for(String resref : scrollResRefs){
			xmlString.append(
"                    <struct id=\"0\" >"                                                                 + "\n" +
"                        <element name=\"InventoryRes\" type=\"11\" value=\"" + resref + "\" />"         + "\n" +
"                        <element name=\"Infinite\" type=\"0\" value=\"1\" />"                           + "\n" +
"                        <element name=\"Repos_PosX\" type=\"0\" value=\"" + (posCounter % 10) + "\" />" + "\n" +
"                        <element name=\"Repos_Posy\" type=\"0\" value=\"" + (posCounter / 10) + "\" />" + "\n" +
"                    </struct>"                                                                          + "\n"
					);
			posCounter++;
		}
		
		File target = new File("prc_scrolls.utm.xml");
		// Clean up old version if necessary
		if(target.exists()){
			if(verbose) System.out.println("Deleting previous version of " + target.getName());
			target.delete();
		}
		if(verbose) System.out.println("Writing brand new version of " + target.getName());
		target.createNewFile();

		// Creater the writer and print
		FileWriter writer = new FileWriter(target, true);
		writer.write(xmlPrefix + xmlString.toString() + xmlSuffix);
		// Clean up
		writer.flush();
		writer.close();
		// Force garbage collection
		System.gc();
	}

	/**
	 * Prints the use instructions for this program and kills execution.
	 */
	private static void readMe(){
		//                  0        1         2         3         4         5         6         7         8
		//					12345678901234567890123456789012345678901234567890123456789012345678901234567890
		System.out.println("Usage:\n"+
		                   "  java -jar prc.jar [--help] | path_to_des_crft_scroll.2da\n"+
		                   "\n"+
		                   "path_to_des_crft_scroll.2da Path to the version of des_crft_scroll.2da to\n" +
		                   "                            create scroll merchant from\n"+
						   "\n"+
		                   "--help      prints this info you are reading\n" +
		                   "\n" +
		                   "\n" +
		                   "Generates a merchant file - prc_scrolls.utm - based on the given scroll list\n" +
		                   "2da file. The merchant file will be written to current directory in Pspeed's\n" +
		                   "XML <-> Gff -xml format\n"
		                  );
		System.exit(0);
	}
}
