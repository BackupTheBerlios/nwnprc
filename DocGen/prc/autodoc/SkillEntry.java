package prc.autodoc;

/**
 * Data structure for a skill entry.
 */
public class SkillEntry implements Comparable<SkillEntry>{
	public String name;
	public String text;
	public String filePath;
	
	public int entryNum;

	
	public SkillEntry(String name, String text, String filePath, int entryNum){
		this.name        = name;
		this.text        = text;
		this.filePath    = filePath;
		this.entryNum    = entryNum;
	}
	
	public int compareTo(SkillEntry other){
		return name.compareTo(other.name);
	}
}