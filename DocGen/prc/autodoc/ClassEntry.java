package prc.autodoc;

/**
 * Data structure for a class entry.
 */
public class ClassEntry extends GenericEntry {
	/**
	 * If <code>true</code>, this class is a base class.
	 */
	public final boolean isBase;

	
	/**
	 * Create a new class entry.
	 * 
	 * @param name     The name of this class.
	 * @param text     The description of this class.
	 * @param iconPath The path of this class's icon.
	 * @param filePath The path of the html file that has been written for this class.
	 * @param isBase   If <code>true</code>, this class is a base class.
	 * @param entryNum Index of the class in classes.2da.
	 */
	public ClassEntry(String name, String text, String iconPath, String filePath,
			          int entryNum, boolean isBase) {
		super(name, text, iconPath, filePath, entryNum);
		this.isBase     = isBase;
	}
}