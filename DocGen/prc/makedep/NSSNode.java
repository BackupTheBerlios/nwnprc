/**
 * 
 */
package prc.makedep;

import java.io.*;
import java.util.*;

/**
 * @author heikki
 *
 */
public class NSSNode {
	public static enum STATES{UNSTARTED, WORKING, DONE};
	
	public STATES state = STATES.UNSTARTED;
	
	private HashSet<NSSNode> adjenct = new LinkedHashSet<NSSNode>();
	public HashSet<NSSNode> includes = new LinkedHashSet<NSSNode>();
	
	private LinkedList<NSSNode> mergeLater = new LinkedList<NSSNode>();
	
	public String fileName;
	//private NSSNode parent;
	
	/**
	 * Creates a new, unlinked NSSNode
	 * 
	 * @param fileName
	 */
	public NSSNode(String fileName) {
		// Make sure the file exists
		if(!new File(fileName).exists()){
			Main.error = true;
			System.err.println("Missing script file: " + fileName);
			return;
		}
		
//		 Each node is dependent on itself
		includes.add(this);
		
		this.fileName = fileName;
	}
	
	/**
	 * Link this script file to those files it directly includes.
	 */
	public void linkDirect(){
		// Load the text for this file
		File file = new File(fileName);
		char[] cArray = new char[(int)file.length()];
		try{
			FileReader fr = new FileReader(fileName);
			fr.read(cArray);
			fr.close();
		}catch(Exception e){
			System.err.println("Error while reading file: " + fileName);
			Main.error = true;
			return;
		}
		
		String[] directIncludes = NWScript.findIncludes(new String(cArray));
		
		for(String name : directIncludes){
			NSSNode adj = Main.scripts.get(name);
			if(adj != null)
				adjenct.add(adj);
			else{
				System.out.println("Script file not found: " + name);
				Main.error = true;
			}
		}
	}

	/**
	 * Builds the full list of files included by this script.
	 */
	public HashSet<NSSNode> linkFullyAndGetIncludes(NSSNode caller) {
		if(state != STATES.UNSTARTED)
			if(state == STATES.DONE)
				return includes;
			else{
				// TODO: Add to a list to merge include lists later once this node is done
				mergeLater.add(caller);
				return null;
			}
		
		// Mark the node as work-in-progress, so it won't be handled again
		state = STATES.WORKING;
		// Initialize the includes list for this script with the direct includes
		includes.addAll(adjenct);
		
		// See if we came to this node from another. If so, mark it for use during the recursion
		/*if(caller != null)
			parent = caller;*/
		
		HashSet<NSSNode> temp;
		for(NSSNode adj : adjenct){
			temp = adj.linkFullyAndGetIncludes(this);
			if(temp != null)
				includes.addAll(temp);
		}
		
		// Remove self node if it's gotten in somehow
		/*
		if(includes.contains(this)){
			System.err.println("Debug: File has itself in it's include list: " + fileName);
			includes.remove(this);
		}*/
		
		// Do the delayed include list merges
		for(NSSNode node : mergeLater)
			node.includes.addAll(this.includes);
		
		/*
		// Cleanup
		parent = null;
		*/
		state = STATES.DONE;
		return includes;
	}
	
	/**
	 * Gets the name used in include statements for the given filename.
	 * 
	 * @param path the path to parse
	 * @return     string, name used in include statements
	 */
	public static String getScriptName(String path) {
		// Cut out the .nss
		path = path.substring(0, path.indexOf(".nss"));
		
		// Cut out the directories, if present
		if(path.indexOf(File.separator) != -1)
			path = path.substring(path.lastIndexOf(File.separator) + 1, path.length());
		
		return path;
	}
	
	public void printSelf(PrintStream strm, boolean append) {
		if(append){
			strm.append(fileName.replace(".nss", ".ncs") + ":"/* + fileName*/);
			for(NSSNode include : includes)
				strm.append(" " + include.fileName);
			strm.append("\n");
		}else{
			strm.print(fileName.replace(".nss", ".ncs") + ":"/* + fileName*/);
			for(NSSNode include : includes)
				strm.print(" " + include.fileName);
			strm.print("\n");
		}
	}
	
	/**
	 * A test main.
	 * 
	 * @param args Ye olde parameters. Doesn't accept any
	 */
	public static void main(String[] args){
		System.out.println(getScriptName("C:\\foo\\bar\\meh.nss"));
		System.out.println(getScriptName("boo.nss"));
		System.out.println(getScriptName("lar\\floob.nss"));
	}
	
	public String toString(){return fileName;}
}
