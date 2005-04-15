package prc.autodoc;

import java.util.*;
/**
 * Data structure for a feat entry.
 */
public class FeatEntry implements Comparable<FeatEntry>{
	public TreeMap<String, FeatEntry> childFeats       = new TreeMap<String, FeatEntry>(),
	                                  requiredForFeats = new TreeMap<String, FeatEntry>();

	public FeatEntry master;
	public String name;
	public String text;
	public String filePath;
	public int entryNum;
	public boolean isEpic;
	public boolean isClassFeat;
	public boolean isSuccessor;
	
	public FeatEntry(String name, String text, String filePath,
	                 int entryNum, boolean isEpic, boolean isClassFeat){
		this.name        = name;
		this.text        = text;
		this.filePath    = filePath;
		this.entryNum    = entryNum;
		this.isEpic      = isEpic;
		this.isClassFeat = isClassFeat;
		
		master = null;
		isSuccessor = false;
	}
	
	public int compareTo(FeatEntry other){
		return name.compareTo(other.name);
	}
}