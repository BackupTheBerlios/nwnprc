package prc.autodoc;

/**
 * Data structure for a class entry.
 */
public class ClassEntry implements Comparable<ClassEntry>{
	public String name;
	public String filePath;
	
	boolean isPrestige;
	public int entryNum;

	public ClassEntry(String name, String filePath, boolean isPrestige, int entryNum){
		this.name       = name;
		this.filePath   = filePath;
		this.isPrestige = isPrestige;
		this.entryNum   = entryNum;
	}
	
	public int compareTo(ClassEntry other){
		return name.compareTo(other.name);
	}
}