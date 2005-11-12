package prc.utils;

import prc.autodoc.Data_2da;
import java.util.*;

/**
 * A class that performs some validation on spell.2da by checking if it contains duplicated
 * subradial IDs.
 */
public class DuplicateSubradials{
	
	/**
	 * Main method
	 * 
	 * @param args The program arguments
	 */
	public static void main(String[] args){
		if(args.length == 0) readMe();
		String pathtospells2da = null;
		
		// parse args
		for(String param : args){//[--help] | pathtospells2da
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
				if(pathtospells2da == null)
					pathtospells2da = param;
			}
		}
		
		// Load the 2da to memory
		Data_2da feats = Data_2da.load2da(pathtospells2da);
		HashSet<Integer> subrads = new HashSet<Integer>();
		ArrayList<Integer> duplicates = new ArrayList<Integer>();
		String entry;
		int subnum;
		// Parse through the 2da, looking for FeatID references that contain a subradial ID
		for(int i = 0; i < feats.getEntryCount(); i++){
			entry = feats.getEntry("FeatID", i);
			// Skip blanks
			if(entry.equals("****")) continue;
			subnum = Integer.parseInt(entry);
			// Skip non-subradial FeatIDs
			if(subnum < 0x10000) continue;
			subnum = subnum >>> 16;
			
			if(subrads.contains(subnum)) duplicates.add(subnum);
			else subrads.add(subnum);
		}
		
		// Print the results
		for(int dup : duplicates){
			for(int i = 0; i < feats.getEntryCount(); i++){
				entry = feats.getEntry("FeatID", i);
				if(entry.equals("****")) continue;
				subnum = Integer.parseInt(entry);
				if(subnum < 0x10000) continue;
				subnum = subnum >>> 16;
				
				if(subnum == dup) System.out.println("Duplicate subradial ID: " + subnum + " on row " + i);
			}
		}
	}
	
	private static void readMe(){
		System.out.println("Usage:\n"+
                           "  [--help] | pathtospells2da\n"+
                           "\n" +
                           " pathtospells2da  path of the spells.2da to check\n"+
                           "\n" +
                           "  --help  prints this text\n" +
                           "\n" +
                           "\n" +
                           "Looks for duplicate subradial IDs in the FeatID column of the given\n" +
                           "spells.2da\n"
                );
		System.exit(0);
	}
}