package prc.autodoc;

/**
 * Data structure for a skill /domain / race / class / whatever that doesn't need
 * the extra fields used for feats & spells & skills
 */
public class GenericEntry implements Comparable<GenericEntry>{
	/**
	 * The name of this entry.
	 */
	public final String name;
	
	/**
	 * The path of the html file that has been written for this entry.
	 */
	public final String filePath;
	
	/**
	 * Index of the entry in whichever 2da defines it.
	 */
	public final int entryNum;

	public GenericEntry(String name, String filePath, int entryNum){
		this.name     = name;
		this.filePath = filePath;
		this.entryNum = entryNum;
	}
	
	public int compareTo(GenericEntry other){
		return name.compareTo(other.name);
	}
}