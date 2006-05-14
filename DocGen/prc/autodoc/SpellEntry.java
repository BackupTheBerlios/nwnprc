package prc.autodoc;

import prc.autodoc.Main.SpellType;

/**
 * Data structure for a spell entry.
 */
public class SpellEntry implements Comparable<SpellEntry>{
	/** Type of this spell entry */
	public final SpellType type;
	/** Name of the spell */
	public String name;
//	public String text;
	/** Path of the html file describing this spell */
	public String filePath;
	
	/** spells.2da index of this spell */
	public int entryNum;

	/**
	 * The constructor.
	 * 
	 * @param name     Name of the spell
	 * @param filePath Path of the html file describing the spell.
	 * @param entryNum spells.2da index
	 * @param type     Type of the spell: Normal / Epic / Psionic / whatever
	 */
	public SpellEntry(String name, /*String text, */String filePath,
	                 int entryNum, SpellType type){
		this.name        = name;
//		this.text        = text;
		this.filePath    = filePath;
		this.entryNum    = entryNum;
		this.type        = type;
	}
	
	/**
	 * Comparable implementation. Uses the name fields for comparison.
	 * 
	 * @param other SpellEntry to compare this one to
	 * @return      @see java.lang.Comparable#compareTo
	 */
	public int compareTo(SpellEntry other){
		return name.compareTo(other.name);
	}
}