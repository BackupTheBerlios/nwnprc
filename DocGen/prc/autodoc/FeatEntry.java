package prc.autodoc;

import java.util.*;

/**
 * Data structure for a feat or masterfeat entry.
 */
public class FeatEntry implements Comparable<FeatEntry>{
	/** A list of masterfeat's children */
	public TreeMap<String, FeatEntry> childFeats       = new TreeMap<String, FeatEntry>();
	/** A list of feats that have this feat as their prerequisite */
	public TreeMap<String, FeatEntry> requiredForFeats = new TreeMap<String, FeatEntry>();

	/** This feat's masterfeat, if any */
	public FeatEntry master;
	/** This feat's name */
	public String name;
	/** The html description of this feat */
	public String text;
	/** The path of the file where this feat's html description will be written to */
	public String filePath;
	/** feat.2da index of the feat */
	public int entryNum;
	/** Whether this feat is epic, as defined by feat.2da column PreReqEpic. For masterfeats, if any of the children are epic */
	public boolean isEpic;
	/** Whether all of a masterfeat's children are epic. This is used to determine which menus a link to it will be printed */
	public boolean allChildrenEpic;
	/** Whether the feat is a class-specific feat, as defined by feat.2da column ALLCLASSESCANUSE. For masterfeats, if any of the children are class-specific */
	public boolean isClassFeat;
	/** Whether all of a masterfeat's children are class-specific. This is used to determine which menus a link to it will be printed */
	public boolean allChildrenClassFeat;
	/** Whether this feat has a successor */
	public boolean isSuccessor;
	
	/**
	 * The constructor.
	 * 
	 * @param name        Name of the feat/masterfeat
	 * @param text        Work-In-Progress contents of the html page describing this feat
	 * @param filePath    Path where the html page for this feat will be written to
	 * @param entryNum    feat.2da / masterfeats.2da index
	 * @param isEpic      Whether the feat is an epic feat
	 * @param isClassFeat Whether the feat is a class-specific feat
	 */
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
		allChildrenClassFeat = false;
		allChildrenEpic = false;
	}
	
	/**
	 * Comparable implementation. Uses the name fields for comparison.
	 * 
	 * @param other FeatEntry to compare this one to
	 * @return      @see java.lang.Comparable#compareTo
	 */
	public int compareTo(FeatEntry other){
		return name.compareTo(other.name);
	}
}