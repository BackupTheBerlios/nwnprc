/**
 * A system for calculating nwscript dependencies. Makes some assumptions specific
 * to the PRC setup.
 */
package prc.makedep;

import java.util.*;
import java.io.*;

import static prc.Main.*;


/**
 * Calculates nwscript dependencies.
 * 
 * Usage:   makedep [-aio?] targetlist
 * Options:
 * -a                Append to outputfile. This option must be defined before -o
 * -n                Ignore include file if not found
 * -sPATH[,PATH...]  List of source directories
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
			else if(arg.startsWith("-s"))
				getFiles(arg.substring(2));
			else if(arg.startsWith("-o"))
				setOutput(arg.substring(2));
			else if(arg.equals("-?") || arg.equals("--help"))
				readMe();
			else
				break;
			i++;
		}
		
		/*
		// Add the remaining params to source list
		String temp;
		for(; i < args.length; i++){
			//scripts.add(new NSSNode(args[i]));
			//files.add(args[i]);
			temp = NSSNode.getScriptName(args[i]);
			if(!scripts.containsKey(temp))
				scripts.put(temp, new NSSNode(args[i]));
			else{
				err_pr.println("Duplicate script file: " + temp);
				error = true;
			}
		}
		*/
		// Parse the target file list
		HashMap<String, String> targetList = new LinkedHashMap<String, String>();
		File targetListFile;// = new File(args[i]);
		Scanner scan;
		String targetName;
		for(; i < args.length; i++){
			targetListFile = new File(args[i]);
			// Read the contents
			try {
				scan = new Scanner(targetListFile);
			} catch (FileNotFoundException e) {
				err_pr.println("Could not find file: " + args[i]);
				error = true;
				continue;
			}
			
			while(scan.hasNextLine()){
				targetName = scan.nextLine().toLowerCase();
				// Strip everything after the .ncs from the line
				targetName = targetName.substring(0, targetName.indexOf(".ncs") + 4);
				targetList.put(NSSNode.getScriptName(targetName), targetName);
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
			//node.printSelf(oStrm, append);
		}
		
		// Do the printing
		for(String target : targetList.keySet()){
			scripts.get(target.toLowerCase()).printSelf(oStrm, append, targetList.get(target));
		}
	}
	
	/**
	 * Prints usage and terminates.
	 */
	private static void readMe(){
		System.out.println("Usage:   makedep [-aio?] targetlist+\n" +
				           "Options:\n" +
				           "-a                Append to outputfile. This option must be defined before -o\n"+
				           "-n                Ignore include file if not found\n"+
				           "-sPATH[,PATH...]  List of source directories\n"+
				           "-oFILE            Use FILE as outputfile, stdout assumed\n"+
				           "-?, --help        This text\n"+
				           "\n"+
				           "targetlist is the name of a file containing a list of object files to calculate\n"+
				           "dependencies for. One filename per line."
				           );
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
				temp = NSSNode.getScriptName(file.getName()).toLowerCase();
				if(!scripts.containsKey(temp))
					scripts.put(temp, new NSSNode(file.getPath()));
				else{
					err_pr.println("Duplicate script file: " + temp);
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
			err_pr.println("Missing output file " + outFileName + "\nTerminating!");
			System.exit(1);
		}
	}
}
