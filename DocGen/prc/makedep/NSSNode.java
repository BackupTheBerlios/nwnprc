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
	
	private HashSet<NSSNode> adjenct = new HashSet<NSSNode>();
	public HashSet<NSSNode> includes;// = new HashSet<NSSNode>();
	
	public String fileName;
	//private NSSNode parent;
	
	/**
	 * Creates a new, unlinked NSSNode
	 * 
	 * @param fileName
	 */
	public NSSNode(String fileName) {
		// Make sure the file exists
		if(new File(fileName).exists()){
			Main.error = true;
			System.err.println("Missing script file: " + fileName);
			return;
		}
		
		this.fileName = fileName;
	}
	
	/**
	 * Link this script file to those files it directly includes.
	 */
	public void linkDirect(){
		// Load the text for this file
		char[] cArray = new char[(int)new File(fileName).length()];
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
		
		for(String name : directIncludes)
			adjenct.add(Main.scripts.get(name));
	}

	/**
	 * Builds the full list of files included by this script.
	 */
	public HashSet<NSSNode> linkFullyAndGetIncludes(NSSNode caller) {
		if(state != STATES.UNSTARTED)
			if(state == STATES.DONE)
				return includes;
			else
				return null;
		
		// Mark the node as work-in-progress, so it won't be handled again
		state = STATES.WORKING;
		// Initialize the includes list for this script with the direct includes
		includes = new HashSet<NSSNode>(adjenct);
		// See if we came to this node from another. If so, mark it for use during the recursion
		/*if(caller != null)
			parent = caller;*/
		
		HashSet<NSSNode> temp;
		for(NSSNode adj : adjenct){
			temp = linkFullyAndGetIncludes(adj);
			if(temp != null)
				includes.addAll(temp);
		}
			
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

}
