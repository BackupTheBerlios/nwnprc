package prc.makedep;

import java.util.*;
import java.io.*;


/**
 * Calculates nwscript dependencies.
 * 
 * Usage:   makedep [-aio?] nssfile+
 * Options:
 * -a                Append to outputfile. This option must be defined before -o
 * -n                Ignore include file if not found
 * -iPATH[,PATH...]  Include contents of directories
 * -oFILE            Use FILE as outputfile, stdout assumed
 * -?, --help        This text
 * 
 * 
 * @author Ornedan
 */
public class Main {

	static Map<String, NSSNode> scripts = new LinkedHashMap<String, NSSNode>();
	
	protected static boolean append = false,
	                         ignoreMissing = false,
	                         error = false;
	static PrintStream oStrm = System.out; 
	
	/**
	 * Main method. Entrypoint to the program
	 * 
	 * @param args The arguments. See readMe() for accepted ones
	 */
	public static void main(String[] args){
		//Map<String, NSSNode> debugMap = scripts;
		// Parse arguments
		int i = 0;
		String arg;
		while(i < args.length){
			arg = args[i];
			if(arg.equals("-a"))
				append = true;
			else if(arg.equals("-n"))
				ignoreMissing = true;
			else if(arg.startsWith("-i"))
				getFiles(arg.substring(2));
			else if(arg.startsWith("-o"))
				setOutput(arg.substring(2));
			else if(arg.equals("-?") || arg.equals("--help"))
				readMe();
			else
				break;
			i++;
		}
		
		// Add the remaining params to source list
		String temp;
		for(; i < args.length; i++){
			//scripts.add(new NSSNode(args[i]));
			//files.add(args[i]);
			temp = NSSNode.getScriptName(args[i]);
			if(!scripts.containsKey(temp))
				scripts.put(temp, new NSSNode(args[i]));
			else{
				System.err.println("Duplicate script file: " + temp);
				error = true;
			}
		}
		
		// Terminate if errored
		if(error) System.exit(1);
		
		// TODO: Load the files concurrently. I suspect it will give a slight performance boost
		//NSSNode[] debugArr = debugMap.values().toArray(new NSSNode[0]);
		for(NSSNode script: scripts.values())
			script.linkDirect();
		
		// Check for errors again
		if(error) System.exit(1);
		
		
		// Start a depth-first-search to find all the include trees
		for(NSSNode node : scripts.values()){
			node.linkFullyAndGetIncludes(null);
			node.printSelf(oStrm, append);
		}
	}
	
	/**
	 * Prints usage and terminates.
	 */
	private static void readMe(){
		System.out.println("Usage:   makedep [-aio?] nssfile+\n" +
				           "Options:\n" +
				           "-a                Append to outputfile. This option must be defined before -o\n"+
				           "-n                Ignore include file if not found\n"+
				           "-iPATH[,PATH...]  Include contents of directories\n"+
				           "-oFILE            Use FILE as outputfile, stdout assumed\n"+
				           "-?, --help        This text");
		System.exit(0);
	}
	
	/**
	 * Looks in the directories specified by the given list for .nss
	 * files and adds them to the sources list.
	 * 
	 * @param pathList comma-separated list of directories to look in
	 */
	private static void getFiles(String pathList){
		String[] paths = pathList.split(",");
		File[] files;
		String temp;
		for(String path : paths){
			files = new File(path).listFiles(new FileFilter(){
				public boolean accept(File file){
					return file.getName().endsWith(".nss");
				}
			});
			for(File file: files){
				temp = NSSNode.getScriptName(file.getName());
				if(!scripts.containsKey(temp))
					scripts.put(temp, new NSSNode(file.getPath()));
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
			oStrm = new PrintStream(new FileOutputStream(outFileName, append), true);
		}catch(FileNotFoundException e){
			System.err.println("Missing output file " + outFileName + "\nTerminating!");
			System.exit(1);
		}
	}
}
