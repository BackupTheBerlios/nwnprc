package prc.utils;

import prc.autodoc.*;

import java.io.*;

//for the spinner
import static prc.Main.*;

public final class SpellbookMaker{
	private SpellbookMaker(){}


	/**
	 * The main method, as usual.
	 *
	 * @param args do I really need to explain this?
	 * @throws Exception this is a simple tool, just let all failures blow up
	 */
	public static void main(String[] args) throws Exception{
		if(args.length == 0 || args[0].equals("--help") || args[0].equals("-?"))
			readMe();
	}

	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "\tjava spellbookmaker precacher2das\n"+
		                   "\n"+
		                   "This application is designed to take some 2DA\n"+
		                   "files in the directory and modify the other 2DA\n"+
		                   "files and tlk file to add the spellbook entries"
		                  );
		System.exit(0);
	}
}