package prc.autodoc;

/**
 * Data structure for a class entry.
 */
public class ClassEntry implements Comparable<ClassEntry>{
	public String name;
	public String filePath;
	
	boolean isBase;
	public int entryNum;

	public ClassEntry(String name, String filePath, boolean isBase, int entryNum){
		this.name       = name;
		this.filePath   = filePath;
		this.isBase     = isBase;
		this.entryNum   = entryNum;
	}
	
	public int compareTo(ClassEntry other){
		return name.compareTo(other.name);
	}
}