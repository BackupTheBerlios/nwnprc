package prc.utils;

import prc.autodoc.Data_2da;
import java.util.*;

/**
 * A class that performs some validation on spell.2da by checking if it contains duplicated
 * subradial IDs.
 */
public class DuplicateSubradials{
	private static class DuplicateData {
		int subnum;
		//Set<Integer> indices = new HashSet<Integer>();
		List<Integer> indices = new ArrayList<Integer>();
		DuplicateData(int subnum) {
			this.subnum = subnum;
		}
	}
	
	/**
	 * Main method
	 * 
	 * @param args The program arguments
	 */
	public static void main(String[] args){
		if(args.length == 0) readMe();
		String pathtospells2da = null;
		boolean fixduplicates = false;
		int replacementstart = -1;
		
		// parse args
		for(String param : args){//[--help] | [-f replacestart] pathtospells2da
			// Parameter parseage
			if(param.startsWith("-")){
				if(param.equals("--help")) readMe();
				else{
					for(char c : param.substring(1).toCharArray()){
						switch(c){
						/*case 'f':
							fixduplicates = true;
							break;*/
						default:
							System.out.println("Unknown parameter: " + c);
							readMe();
						}
					}
				}
			}
			else{
				// The option to attempt fixing the duplicates is on and the first replacement number hasn't been given yet
				/*if(fixduplicates == true && replacementstart == -1) {
					try {
						replacementstart = Integer.parseInt(param);
					} catch (NumberFormatException e) {
						System.out.println("replacestart value given is not numeric: " + param);
						readMe();
					}
					if(replacementstart < 0 || replacementstart > 9999) {
						System.out.println("replacestart value given is not in valid range");
						readMe();
					}
				}
				// It's a pathname
				else */if(pathtospells2da == null)
					pathtospells2da = param;
			}
		}
		
		// Load the 2da to memory
		Data_2da spells = Data_2da.load2da(pathtospells2da);
		Map<Integer, Integer> subrads = new HashMap<Integer, Integer>(); // Map of subradial # to the first line it occurs on
		Map<Integer, DuplicateData> duplicates = new HashMap<Integer, DuplicateData>();
		String entry;
		int subnum = 0;
		// Parse through the 2da, looking for FeatID references that contain a subradial ID
		for(int i = 0; i < spells.getEntryCount(); i++){
			entry = spells.getEntry("FeatID", i);
			// Skip blanks
			if(entry.equals("****")) continue;
			try {
				subnum = Integer.parseInt(entry);
			} catch (NumberFormatException e) {
				System.out.println("Corrupt value in FeatID on row " + i + ": " + entry);
				continue;
			}
			// Skip non-subradial FeatIDs
			if(subnum < 0x10000) continue;
			subnum = subnum >>> 16;
			
			if(subrads.containsKey(subnum)){
				if(!duplicates.containsKey(subnum))
					duplicates.put(subnum, new DuplicateData(subnum));
				
				duplicates.get(subnum).indices.add(i);
			}
			else subrads.put(subnum, i);
		}
		
		// Print the results
		for(DuplicateData dup : duplicates.values()){
			System.out.println("Duplicate subradial ID: " + dup.subnum + " first occurrence on row " + subrads.get(dup.subnum));
			for(int i : dup.indices)
				System.out.println("Duplicate subradial ID: " + dup.subnum + " on row " + i);
		}
		if(duplicates.size() > 0) {
			int requiredtofix = 0;
			for(DuplicateData dup : duplicates.values())
				requiredtofix += dup.indices.size();
			
			System.out.println("\nNumber of new subradial IDs required to make all unique: " + requiredtofix);
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