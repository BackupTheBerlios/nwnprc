package prc.autodoc;

import java.io.*;

/**
 * A convenience class for printing errors to both log and System.err
 */
public class ErrorPrinter{
	private PrintWriter writer;
	
	public ErrorPrinter(){
		try{
			writer = new PrintWriter(new FileOutputStream("errorlog", false), true);
		}catch(Exception e){
			System.err.println("Error while creating error logger. Yes, it's ironic. Now debug");
			System.exit(1);
		}
	}
	
	public void print(String toPrint) { writer.print(toPrint); System.err.print(toPrint); }
	public void println(String toPrint) { writer.println(toPrint); System.err.println(toPrint); }
}