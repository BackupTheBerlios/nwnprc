package prc.autodoc;

/**
 * Data structure for a domain / race / class / whatever that doesn't need
 * the extra fields used for feats & spells & skills
 */
public class GenericEntry implements Comparable<GenericEntry>{
	public String name;
	public String filePath;
	
	public int entryNum;

	public SpellEntry(String name, String filePath, int entryNum){
		this.name     = name;
		this.filePath = filePath;
		this.entryNum = entryNum;
	}
	
	public int compareTo(GenericEntry other){
		return name.compareTo(other.name);
	}
}