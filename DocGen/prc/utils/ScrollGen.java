package prc.utils;

import java.io.*;
import java.util.*;

import prc.autodoc.*;
import prc.autodoc.Main.TwoDAStore;

import static prc.Main.*;

/**
 * Creates scrolls based on iprp_spells.2da and spells.2da.
 * 
 * @author Ornedan
 */
public class ScrollGen {

	/**
	 * Ye olde maine methode.
	 * 
	 * @param args         The arguments
	 * @throws IOException Just toss any exceptions encountered
	 */
	public static void main(String[] args) throws IOException {
		if(args.length == 0) readMe();
		String twoDAPath = null;
		String outPath   = null;

		// parse args
		for(String param : args) {//2dadir outdir | [--help]
			// Parameter parseage
			if(param.startsWith("-")) {
				if(param.equals("--help")) readMe();
				else{
					for(char c : param.substring(1).toCharArray()) {
						switch(c) {
						default:
							System.out.println("Unknown parameter: " + c);
							readMe();
						}
					}
				}
			}
			else {
				// It's a pathname
				if(twoDAPath == null)
					twoDAPath = param;
				else if(outPath == null)
					outPath = param;
				else{
					System.out.println("Unknown parameter: " + param);
					readMe();
				}
			}
		}
		
		// Load data
		TwoDAStore twoDA = new TwoDAStore(twoDAPath);
		Data_2da          spells = twoDA.get("spells"),
		         des_crft_scroll = twoDA.get("des_crft_scroll"),
		         des_crft_spells = twoDA.get("des_crft_spells"),
		             iprp_spells = twoDA.get("iprp_spells");
		
		// For each spells.2da entry, find the iprp_spells.2da entry with lowest CasterLvl value
		Map<Integer, Tuple<Integer, Integer>> lowestIndex = new HashMap<Integer, Tuple<Integer, Integer>>(); // Map of spells.2da index -> (iprp_spells.2da index, CasterLvl value)
		int spellID, casterLvl;
		for(int i = 0; i < iprp_spells.getEntryCount(); i++) {
			if(!iprp_spells.getEntry("SpellIndex", i).equals("****")) { // Only lines that are connected to spells.2da are scanned
				spellID   = Integer.parseInt(iprp_spells.getEntry("SpellIndex", i));
				casterLvl = Integer.parseInt(iprp_spells.getEntry("CasterLvl", i));
				
				if(lowestIndex.get(spellID) == null || lowestIndex.get(spellID).e2 > casterLvl)
					lowestIndex.put(spellID, new Tuple<Integer, Integer>(i, casterLvl));
			}
		}
		
		// Generate lists of arcane and divine scrolls
		// Map of spells.2da index -> (iprp_spells.2da index, list of classes.2da index)
		Map<Integer, Tuple<Integer, List<Integer>>> arcaneScrolls = new HashMap<Integer, Tuple<Integer, List<Integer>>>();
		Map<Integer, Tuple<Integer, List<Integer>>> divineScrolls = new HashMap<Integer, Tuple<Integer, List<Integer>>>();
		int iprpIndex;
		for(int spellsIndex : lowestIndex.keySet()) {
			iprpIndex = lowestIndex.get(spellsIndex).e1;
			List<Integer> arcaneClasses = new ArrayList<Integer>();
			List<Integer> divineClasses = new ArrayList<Integer>();
			
			// HACK!
			// Hardcoded classes.2da indexes
			if(!spells.getEntry("Bard",     spellsIndex).equals("****"))
				arcaneClasses.add(1);
			if(!spells.getEntry("Cleric",   spellsIndex).equals("****"))
				divineClasses.add(2);
			if(!spells.getEntry("Druid",    spellsIndex).equals("****"))
				divineClasses.add(3);
			if(!spells.getEntry("Paladin",  spellsIndex).equals("****"))
				divineClasses.add(6);
			if(!spells.getEntry("Ranger",   spellsIndex).equals("****"))
				divineClasses.add(7);
			if(!spells.getEntry("Wiz_Sorc", spellsIndex).equals("****")) {
				arcaneClasses.add(9);
				arcaneClasses.add(10);
			}
			
			if(arcaneClasses.size() > 0)
				arcaneScrolls.put(spellsIndex, new Tuple<Integer, List<Integer>>(iprpIndex, arcaneClasses));
			if(divineClasses.size() > 0)
				divineScrolls.put(spellsIndex, new Tuple<Integer, List<Integer>>(iprpIndex, divineClasses));
		}
		
		// Do the scrolls
		for(int spellsIndex : arcaneScrolls.keySet()) {
			String scrollName = "prc_scr_ar_" + arcaneScrolls.get(spellsIndex).e1.toString();
			String scrollXml = doScroll(spells, scrollName, spellsIndex, arcaneScrolls.get(spellsIndex).e1, arcaneScrolls.get(spellsIndex).e2);
			
			// Print the scroll
			printScroll(outPath, scrollName, scrollXml);
			
			// Update des_crft_scrolls accordingly
			List<Integer> classes = arcaneScrolls.get(spellsIndex).e2;
			if(classes.contains(1))
				des_crft_scroll.setEntry("Bard", spellsIndex, scrollName);
			if(classes.contains(9) || classes.contains(10))
				des_crft_scroll.setEntry("Wiz_Sorc", spellsIndex, scrollName);
		}
		for(int spellsIndex : divineScrolls.keySet()) {
			String scrollName = "prc_scr_dv_" + divineScrolls.get(spellsIndex).e1.toString();
			String scrollXml = doScroll(spells, scrollName, spellsIndex, divineScrolls.get(spellsIndex).e1, divineScrolls.get(spellsIndex).e2);
			
			// Print the scroll
			printScroll(outPath, scrollName, scrollXml);
			
			// Update des_crft_scrolls accordingly
			List<Integer> classes = divineScrolls.get(spellsIndex).e2;
			if(classes.contains(2))
				des_crft_scroll.setEntry("Cleric", spellsIndex, scrollName);
			if(classes.contains(3))
				des_crft_scroll.setEntry("Druid", spellsIndex, scrollName);
			if(classes.contains(6))
				des_crft_scroll.setEntry("Paladin", spellsIndex, scrollName);
			if(classes.contains(7))
				des_crft_scroll.setEntry("Ranger", spellsIndex, scrollName);
		}
		
		// Save updated des_crft_scrolls.2da
		des_crft_scroll.save2da(twoDAPath, true, true);
	}
	
	private static final String xmlPrefix =
"<gff name=\"~~~Name~~~.uti\" type=\"UTI \" version=\"V3.2\" >"                   + "\n" +
"    <struct id=\"-1\" >"                                                         + "\n" +
"        <element name=\"TemplateResRef\" type=\"11\" value=\"~~~Name~~~\" />"    + "\n" +
"        <element name=\"BaseItem\" type=\"5\" value=\"75\" />"                   + "\n" +
"        <element name=\"LocalizedName\" type=\"12\" value=\"~~~TLKName~~~\" />"  + "\n" +
"        <element name=\"Description\" type=\"12\" value=\"-1\" />"               + "\n" +
"        <element name=\"DescIdentified\" type=\"12\" value=\"~~~TLKDesc~~~\" />" + "\n" +
"        <element name=\"Tag\" type=\"10\" value=\"~~~Tag~~~\" />"                + "\n" +
"        <element name=\"Charges\" type=\"0\" value=\"0\" />"                     + "\n" +
"        <element name=\"Cost\" type=\"4\" value=\"0\" />"                        + "\n" +
"        <element name=\"Stolen\" type=\"0\" value=\"0\" />"                      + "\n" +
"        <element name=\"StackSize\" type=\"2\" value=\"1\" />"                   + "\n" +
"        <element name=\"Plot\" type=\"0\" value=\"0\" />"                        + "\n" +
"        <element name=\"AddCost\" type=\"4\" value=\"0\" />"                     + "\n" +
"        <element name=\"Identified\" type=\"0\" value=\"1\" />"                  + "\n" +
"        <element name=\"Cursed\" type=\"0\" value=\"0\" />"                      + "\n" +
"        <element name=\"ModelPart1\" type=\"0\" value=\"1\" />"                  + "\n" +
"        <element name=\"PropertiesList\" type=\"15\" >"                          + "\n" +
"            <struct id=\"0\" >"                                                  + "\n" +
"                <element name=\"PropertyName\" type=\"2\" value=\"15\" />"       + "\n" +
"                <element name=\"Subtype\" type=\"2\" value=\"~~~IPIndex~~~\" />" + "\n" +
"                <element name=\"CostTable\" type=\"0\" value=\"3\" />"           + "\n" +
"                <element name=\"CostValue\" type=\"2\" value=\"1\" />"           + "\n" +
"                <element name=\"Param1\" type=\"0\" value=\"255\" />"            + "\n" +
"                <element name=\"Param1Value\" type=\"0\" value=\"0\" />"         + "\n" +
"                <element name=\"ChanceAppear\" type=\"0\" value=\"100\" />"      + "\n" +
"            </struct>"                                                           + "\n";
	private static final String xmlClass = 
"            <struct id=\"0\" >"                                                  + "\n" +
"                <element name=\"PropertyName\" type=\"2\" value=\"63\" />"       + "\n" +
"                <element name=\"Subtype\" type=\"2\" value=\"~~~Class~~~\" />"   + "\n" +
"                <element name=\"CostTable\" type=\"0\" value=\"0\" />"           + "\n" +
"                <element name=\"CostValue\" type=\"2\" value=\"0\" />"           + "\n" +
"                <element name=\"Param1\" type=\"0\" value=\"255\" />"            + "\n" +
"                <element name=\"Param1Value\" type=\"0\" value=\"0\" />"         + "\n" +
"                <element name=\"ChanceAppear\" type=\"0\" value=\"100\" />"      + "\n" +
"            </struct>"                                                           + "\n";
	private static final String xmlSuffix =
"        </element>"                                                              + "\n" +
"        <element name=\"PaletteID\" type=\"0\" value=\"26\" />"                  + "\n" +
"        <element name=\"Comment\" type=\"10\" value=\"1\" />"                    + "\n" +
"    </struct>"                                                                   + "\n" +
"</gff>";
	
	private static String doScroll(Data_2da spells, String name, int spellsIndex, int iprpIndex, List<Integer> classes) {
		// Determine TLK references
		int tlkName = Integer.parseInt(spells.getEntry("Name",      spellsIndex));
		int tlkDesc = Integer.parseInt(spells.getEntry("SpellDesc", spellsIndex));
		
		// Build the string
		String toReturn = xmlPrefix.replaceAll("~~~Name~~~", name)
		                           .replaceAll("~~~Tag~~~", name.toUpperCase())
		                           .replaceAll("~~~IPIndex~~~", "" + iprpIndex)
		                           .replaceAll("~~~TLKName~~~", "" + tlkName)
		                           .replaceAll("~~~TLKDesc~~~", "" + tlkDesc);
		
		for(Integer classIndex : classes)
			toReturn += xmlClass.replaceAll("~~~Class~~~", classIndex.toString());
		
		toReturn += xmlSuffix;
		return toReturn;
	}
	
	private static void printScroll(String outDir, String scrollName, String scrollXml) {
		String path = outDir + File.separator + scrollName + ".uti.xml";
		try {
			File target = new File(path);
			// Clean up old version if necessary
			if(target.exists()){
				if(verbose) System.out.println("Deleting previous version of " + path);
				target.delete();
			}
			target.createNewFile();
			
			// Creater the writer and print
			FileWriter writer = new FileWriter(target, false);
			writer.write(scrollXml);
			// Clean up
			writer.flush();
			writer.close();
		} catch(IOException e) {
			err_pr.println("IOException when printing " + path + ":\n" + e);
		}
	}
	
	/**
	 * Prints the use instructions for this program and kills execution.
	 */
	private static void readMe() {
		//                  0        1         2         3         4         5         6         7         8
		//					12345678901234567890123456789012345678901234567890123456789012345678901234567890
		System.out.println("Usage:\n"+
		                   "  java -jar prc.jar scrollgen 2dadir outdir | [--help]\n"+
		                   "\n"+
		                   "2dadir   Path to a directory containing 2da files\n" +
		                   "outdir   Path to the directory to save the new scroll xml files in\n" +
						   "\n"+
		                   "--help      prints this info you are reading\n" +
		                   "\n" +
		                   "\n" +
		                   "A tool for automatically creating spell scrolls based on iprp_spells.2da\n" +
		                   "and spells.2da. Generates pspeed's modpacker -compatible XML\n" +
		                   "Also updates des_crft_scrolls with the new scroll resrefs.\n"
		                  );
		System.exit(0);
	}
}
