package prc.autodoc;

import java.util.*;
import prc.autodoc.Main.SpellType;
import static prc.autodoc.Main.SpellType.*;

/**
 * Data structure for a spell entry.
 */
public class SpellEntry implements Comparable<SpellEntry>{
	public final SpellType type;
	public String name;
	public String text;
	public String filePath;
	
	public int entryNum;

	
	public SpellEntry(String name, String text, String filePath,
	                 int entryNum, SpellType type){
		this.name        = name;
		this.text        = text;
		this.filePath    = filePath;
		this.entryNum    = entryNum;
		this.type        = type;
	}
	
	public int compareTo(SpellEntry other){
		return name.compareTo(other.name);
	}
}