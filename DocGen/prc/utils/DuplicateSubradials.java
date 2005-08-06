package prc.utils;

import prc.autodoc.Data_2da;
import java.util.*;
import java.io.File;

public class DuplicateSubradials{
	public static void main(String[] args){
		Data_2da feats = Data_2da.load2da("." + File.separator + "2da" + File.separator + "spells.2da");
		HashSet<Integer> subrads = new HashSet<Integer>();
		ArrayList<Integer> duplicates = new ArrayList<Integer>();
		String entry;
		int subnum;
		for(int i = 0; i < feats.getEntryCount(); i++){
			entry = feats.getEntry("FeatID", i);
			if(entry.equals("****")) continue;
			subnum = Integer.parseInt(entry);
			if(subnum < 0x10000) continue;
			subnum = subnum >>> 16;
			
			if(subrads.contains(subnum)) duplicates.add(subnum);
			else subrads.add(subnum);
		}
		
		for(int dup : duplicates){
			for(int i = 0; i < feats.getEntryCount(); i++){
				entry = feats.getEntry("FeatID", i);
				if(entry.equals("****")) continue;
				subnum = Integer.parseInt(entry);
				if(subnum < 0x10000) continue;
				subnum = subnum >>> 16;
				
				if(subnum == dup) System.out.println("Duplicate subradial: " + subnum + " on row " + i);
			}
		}
	}
}