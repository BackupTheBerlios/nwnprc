package rmg;

import prc.autodoc.Spinner;

public class Main {


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

		if(toCall.equals("-rig")){
			//random item generator
			rmg.rig.rig.main(paramsToPass);
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
		                   "  java -jar rmg.jar [--help] | class [parameters]\n"+
		                   "\n"+
		                   "class       name of the class to call. possible values:\n"+
		                   "            -rig Random Item Generator \n"+
		                   "\n"+
						   "parameters  a list of parameters passed to the class called\n"+
						   "\n"+
		                   "--help      prints this info you are reading\n"
		                  );
		System.exit(0);
	}
}
