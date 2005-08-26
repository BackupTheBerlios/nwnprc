package prc.makedep;

import java.util.*;
import java.io.*;


/**
 * Usage:   makedep [-aio?] nssfile+
 * Options:
 *    -a                Append to outputfile
 *    -iPATH[;PATH...]  Include contents of directories
 *    -oFILE            Use FILE as outputfile, stdout assumed
 *    -?, --help        This text
 * 
 * 
 * @author heikki
 */
public class Main {

	static Map<String, NSSNode> scripts = new LinkedHashMap<String, NSSNode>();
	
	protected static boolean append = false,
	                         error = false;
	static PrintStream oStrm = System.out; 
	
	/**
	 * @param args
	 */
	public static void main(String[] args){
		//Set<String> files = new HashSet<String>();
		// Parse arguments
		int i = 0;
		String arg;
		while(i++ < args.length){
			arg = args[i];
			if(arg.equals("-a"))
				append = true;
			else if(arg.startsWith("-i"))
				getFiles(arg.substring(2));
			else if(arg.startsWith("-o"))
				setOutput(arg.substring(2));
			else if(arg.equals("-?") || arg.equals("--help"))
				readMe();
			else
				break;
		}
		
		// Add the remaining params to source list
		String temp;
		for(; i < args.length; i++){
			//scripts.add(new NSSNode(args[i]));
			//files.add(args[i]);
			temp = NSSNode.getScriptName(args[i]);
			if(!scripts.containsKey(temp))
				scripts.put(NSSNode.getScriptName(temp), new NSSNode(temp));
			else{
				System.err.println("Duplicate script file: " + temp);
				error = true;
			}
		}
		
		// Terminate if errored
		if(error) System.exit(1);
		
		// Load the files concurrently. I suspect it will give a slight performance boost
		//Map<String, NSSNode> parsecontainer = Collections.synchronizedMap(new HashMap<String, NSSNode>());
		//Map<String, NSSNode> parseContainer = new HashMap<String, NSSNode>(files.size());
		
		/*
		for(String fileName : files){
			parseContainer.put(NSSNode.getScriptName(fileName), new NSSNode(fileName));
		}*/
		for(NSSNode script: scripts.values())
			script.linkDirect();
		
		// Check for errors again
		if(error) System.exit(1);
		
		
		// Start a depth-first-search to find all the include trees
		for(NSSNode node : scripts.values())
			node.linkFullyAndGetIncludes(null);
	}
	
	/**
	 * Prints usage and terminates.
	 */
	private static void readMe(){
		System.out.println("Usage:   makedep [-aio?] nssfile+\n" +
				           "Options:\n" +
				           "-a                Append to outputfile\n"+
				           "-iPATH[;PATH...]  Include contents of directories\n"+
				           "-oFILE            Use FILE as outputfile, stdout assumed\n"+
				           "-?, --help        This text");
		System.exit(0);
	}
	
	/**
	 * Looks in the directories specified by the given list for .nss
	 * files and adds them to the sources list.
	 * 
	 * @param pathList ;-separated list of directories to look in
	 * @param fileNameSet Set to place the script names into
	 */
	private static void getFiles(String pathList/*, Set<String> fileNameSet*/){
		String[] paths = pathList.split(";");
		String[] files;
		String temp;
		for(String path : paths){
			files = new File(path).list(new FilenameFilter(){
				public boolean accept(File dir, String name){
					return name.endsWith(".nss");
				}
			});
			for(String file: files){
				temp = NSSNode.getScriptName(file);
				if(!scripts.containsKey(temp))
					scripts.put(NSSNode.getScriptName(temp), new NSSNode(temp));
				else{
					System.err.println("Duplicate script file: " + temp);
					error = true;
				}
			}
		}
	}
	
	/**
	 * Sets the output to write the results to to a file specified by the
	 * given filename.
	 * If the file is not found, the program terminates.
	 * 
	 * @param outFileName Name of the file to print results to
	 */
	private static void setOutput(String outFileName){
		try{
			oStrm = new PrintStream(outFileName);
		}catch(FileNotFoundException e){
			System.err.println("Missing output file " + outFileName + "\nTerminating!");
			System.exit(1);
		}
	}
}
