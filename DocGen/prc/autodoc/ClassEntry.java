package prc.autodoc;

/**
 * Data structure for a class entry.
 */
public class ClassEntry implements Comparable<ClassEntry>{
	/**
	 * The name of this class
	 */
	public String name;
	
	/**
	 * The path the html file will be written to
	 */
	public String filePath;
	
	/**
	 * If <code>true</code>, this class is a base class. 
	 */
	public boolean isBase;
	
	public int entryNum;

	public ClassEntry(String name, String filePath, boolean isBase, int entryNum){
		this.name       = name;
		this.filePath   = filePath;
		this.isBase     = isBase;
		this.entryNum   = entryNum;
	}
	
	
	/**
	 * @see java.lang.Comparable#compareTo(T)
	 */
	public int compareTo(ClassEntry other){
		return name.compareTo(other.name);
	}
}