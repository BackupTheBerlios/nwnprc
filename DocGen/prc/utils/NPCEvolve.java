package prc.utils;

import prc.autodoc.*;

import java.io.*;
import java.math.*;
//import java.util.*;
//import java.util.regex.*;

//for the spinner
import static prc.Main.*;

public final class NPCEvolve{
	private NPCEvolve(){}

	/**
	 * The main method, as usual.
	 *
	 * @param args do I really need to explain this?
	 * @throws Exception this is a simple tool, just let all failures blow up
	 */
	public static void main(String[] args) throws Exception{
		if(args.length < 2 || args[0].equals("--help") || args[0].equals("-?"))
			readMe();

		String logFilePath = args[0];
		String packageFilePath = args[1];

		//get the file
		File logFile =  new File(logFilePath);
		//parse it

	//this is the layout of the data string
    //## (id) class0pack1 class0pack2 ... class10pack9 class10pack10
	}

	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "\tjava npcevol logfile packages\n"+
		                   "\n"+
		                   "This application is designed to take a logfile \n"+
		                   "and parse it to extract relevant data.\n"+
		                   "Then it will take some package 2da files\n"+
		                   "and mutate them appropriately"
		                  );

		System.exit(0);
	}
}