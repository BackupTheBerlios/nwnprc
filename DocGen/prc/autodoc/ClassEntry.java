package prc.autodoc;

/**
 * Data structure for a class entry.
 */
public class ClassEntry implements Comparable<ClassEntry>{
	/**
	 * The name of this class.
	 */
	public final String name;
	
	/**
	 * The path of the html file that has been written for this class.
	 */
	public final String filePath;
	
	/**
	 * If <code>true</code>, this class is a base class.
	 */
	public final boolean isBase;
	
	/**
	 * Index of the class in classes.2da.
	 */
	public final int entryNum;

	
	/**
	 * Create a new class entry.
	 * 
	 * @param name     The name of this class.
	 * @param filePath The path of the html file that has been written for this class.
	 * @param isBase   If <code>true</code>, this class is a base class.
	 * @param entryNum Index of the class in classes.2da.
	 */
	public ClassEntry(String name, String filePath, boolean isBase, int entryNum){
		this.name       = name;
		this.filePath   = filePath;
		this.isBase     = isBase;
		this.entryNum   = entryNum;
	}
	
	
	/**
	 * Class entries are considered to be comparable by their names
	 * 
	 * @param other Another ClassEntry
	 * @return      As java.lang.String#compareTo(String)
	 * @see java.lang.Comparable#compareTo(Object)
	 */
	public int compareTo(ClassEntry other){
		return this.name.compareTo(other.name);
	}
}