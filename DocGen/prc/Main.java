package prc;

import prc.autodoc.ErrorPrinter;
import prc.autodoc.Spinner;

/**
 * A menu class. Calls operations from classes in subpackages based on parameters
 *
 * @author heikki
 */
public class Main {

	/** A convenience object for printing both to log and System.err */
	public static ErrorPrinter err_pr = new ErrorPrinter();

	/** A boolean determining whether to spam the user with progress information */
	public static boolean verbose = true;

	/** A decorative spinner to look at while the program is loading big files */
	public static Spinner spinner = new Spinner();

	/**
	 * Ooh, a main method!
	 *
	 * @param args arguments, surprisingly enough
	 *
	 * @throws Throwable everything received from the classes called is passed on
	 */
	public static void main(String[] args) throws Throwable{
		if(args.length == 0 || args[0].equals("--help"))
			readMe();

		String toCall = args[0];
		String[] paramsToPass = new String[args.length - 1];
		System.arraycopy(args, 1, paramsToPass, 0, paramsToPass.length);

		if(toCall.equals("manual")){
			prc.autodoc.Main.main(paramsToPass);
		}
		else if(toCall.equals("2da")){
			prc.autodoc.Data_2da.main(paramsToPass);
		}
		else if(toCall.equals("codegen")){
			prc.utils.CodeGen.main(paramsToPass);
		}
		else if(toCall.equals("radials")){
			prc.utils.Radials.main(paramsToPass);
		}
		else if(toCall.equals("dupsubrad")){
			prc.utils.DuplicateSubradials.main(paramsToPass);
		}
		else if(toCall.equals("makedep")){
			prc.makedep.Main.main(paramsToPass);
		}
		else if(toCall.equals("upclsfeat")){
			prc.utils.AllClassFeatUpdater.main(paramsToPass);
		}
		else if(toCall.equals("lsentries")){
			prc.utils.List2daEntries.main(paramsToPass);
		}
		else if(toCall.equals("dupentries")){
			prc.utils.Duplicate2daEntryDetector.main(paramsToPass);
		}
		else if(toCall.equals("2datosql")){
			prc.utils.SQLMaker.main(paramsToPass);
		}
		else if(toCall.equals("spellbookmaker")){
			prc.utils.SpellbookMaker.main(paramsToPass);
		}
		else if(toCall.equals("letoxml")){
			prc.utils.LetoListsGenerator.main(paramsToPass);
		}

		else{
			System.out.println("Unknown class: " + toCall);
			readMe();
		}
	}


	/**
	 * Prints the use instructions for this program and kills execution.
	 */
	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "  java -jar prc.jar [--help] | class [parameters]\n"+
		                   "\n"+
		                   "class       name of the class to call. possible values:\n"+
		                   "             manual     - Generates the manual\n"+
						   "             2da        - Either verifies a single 2da file or compares two\n"+
						   "             codegen    - Autogenerates scripts (or other files)\n"+
						   "             radials    - Generates subradial FeatID values\n"+
						   "             dupsubrad  - Seeks through spells.2da and prints lines\n"+
						   "                          containing duplicate subradial values\n"+
						   "             makedep    - Builds include dependency lists\n" +
						   "             upclsfeat  - Updates base cls_feat_*.2da based on given templates\n" +
						   "             lsentries  - Lists the unique entries in given columns of a\n" +
						   "                          given 2da\n" +
						   "             dupentries - Seeks for duplicate entries in the given columns\n" +
						   "                          of a given 2da\n"+
						   "             2datosql   - Creates a SQL file from 2das\n" +
						   "             letoxml    - Creates Leto XML lists from 2da and TLK\n" +
		                   "\n"+
						   "parameters  a list of parameters passed to the class called\n"+
						   "\n"+
		                   "--help      prints this info you are reading\n"
		                  );
		System.exit(0);
	}
}
