package prc.autodoc;

import java.util.*;
/**
 * Data structure for a feat entry.
 */
public class FeatEntry{
	private FeatEntry predecessor = null,
	                 successor = null,
	                 master = null;
	
	private ArrayList<FeatEntry> childFeats = new ArrayList<FeatEntry>();
	
	private int entryNum;
	private String entryText;
	private String filePath;
	
	public FeatEntry(int entryNum, String entryText, String filePath){
		this.entryNum  = entryNum;
		this.entryText = entryText;
		this.filePath  = filePath;
	}
	
	public String getEntryText(){
		return entryText;
	}
	
	public String filePath(){
		return filePath;
	}
	
	public void setPredecessor(FeatEntry predecessor){
		this.predecessor = predecessor;
	}
	
	public FeatEntry getPredecessor(){
		return predecessor;
	}
	
	public void setSuccessor(FeatEntry successor){
		this.successor = successor;
	}
	
	public FeatEntry getSuccessor(){
		return successor;
	}
	
	public void setMaster(FeatEntry master){
		this.master = master;
	}
	
	public FeatEntry getMaster(){
		return master;
	}
	
	public void addChild(FeatEntry childFeat){
		childFeats.add(childFeat);
	}
	
	public FeatEntry[] getChildFeats(){
		return (FeatEntry[])childFeats.toArray();
	}
		
}