package prc.autodoc;

import java.util.*;
/**
 * Data structure for a feat entry.
 */
public class FeatEntry implements Comparable<FeatEntry>{
	/*public FeatEntry predecessor = null,
	                 successor = null,
	                 master = null;*/
	
	public ArrayList<FeatEntry> childFeats = new ArrayList<FeatEntry>();
	
	public String entryName;
	public String entryText;
	public String filePath;
	public int entryNum;
	public boolean isEpic;
	public boolean isClassFeat;
	
	public FeatEntry(String entryName, String entryText, String filePath,
	                 int entryNum, boolean isEpic, boolean isClassFeat){
		this.entryName   = entryName;
		this.entryText   = entryText;
		this.filePath    = filePath;
		this.entryNum    = entryNum;
		this.isEpic      = isEpic;
		this.isClassFeat = isClassFeat;
	}
	
	public int compareTo(FeatEntry other){
		return entryName.compareTo(other.entryName);
	}
}