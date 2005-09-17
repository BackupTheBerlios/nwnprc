package prc.autodoc;

import java.io.*;

/**
 * A convenience class for printing errors to both log and System.err
 */
public class ErrorPrinter{
	private PrintWriter writer;
	
	/**
	 * Creates a new ErrorPrinter.
	 * Attempts to open a log file by name of "errorlog" for writing. If this
	 * fails, aborts the program.
	 */
	public ErrorPrinter(){
		try{
			writer = new PrintWriter(new FileOutputStream("errorlog", false), true);
		}catch(Exception e){
			System.err.println("Error while creating error logger. Yes, it's ironic. Now debug");
			System.exit(1);
		}
	}
	
	
	/**
	 * Prints the given string to both stderr and errorlog.
	 * 
	 * @param toPrint string to write
	 */
	public void print(String toPrint) { writer.print(toPrint); System.err.print(toPrint); }
	
	/**
	 * Prints the given string to both stderr and errorlog. In addition, adds
	 * a line terminator to the end of the string.
	 * 
	 * @param toPrint string to write
	 */
	public void println(String toPrint) { writer.println(toPrint); System.err.println(toPrint); }
}