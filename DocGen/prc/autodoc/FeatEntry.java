package prc.autodoc;

import java.util.*;
/**
 * Data structure for a feat entry.
 */
public class FeatEntry implements Comparable<FeatEntry>{
	public ArrayList<FeatEntry> childFeats = new ArrayList<FeatEntry>();
	
	public String name;
	public String text;
	public String filePath;
	public int entryNum;
	public boolean isEpic;
	public boolean isClassFeat;
	
	public FeatEntry(String name, String text, String filePath,
	                 int entryNum, boolean isEpic, boolean isClassFeat){
		this.name        = name;
		this.text        = text;
		this.filePath    = filePath;
		this.entryNum    = entryNum;
		this.isEpic      = isEpic;
		this.isClassFeat = isClassFeat;
	}
	
	public int compareTo(FeatEntry other){
		return name.compareTo(other.name);
	}
}