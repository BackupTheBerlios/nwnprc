import prc.autodoc.Data_2da;

import java.io.*;
import java.util.*;

public final class CodeGen{
	private CodeGen(){}
	
	private static class Script implements Cloneable{
		public String text,
		              name;
		
		public Script(String text, String name){
			this.text = text;
			this.name = name;
		}
		
		public Object clone(){
			return new Script(text, name);
		}
	}
	
	
	private static String prefix,
	                      template;
	private static Data_2da[] data;
	
	public static void main(String[] args) throws Exception{
		if(args.length == 0 || args[0].equals("--help") || args[0].equals("-?"))
			readMe();
	
		prefix = args[0];
		template = readTemplate(args[1]);
		
		data = new Data_2da[args.length - 2];
		for(int i = 0; i < data.length; i++)
			data[i] = new Data_2da(args[i + 2]);
		
		doCreation(new Script(template, prefix), 0);
	}
	
	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "\tjava CodeGen namePrefix templatePath 2daPaths...\n"+
		                   "\n"+
		                   "namePrefix\tprefix that all the resulting filenames will share\n"+
		                   "templatePath\tlocation of the template to use. May be absolute or relative\n"+
		                   "2daPaths\tone or more 2da files to use fill the template with\n"+
		                   "\n\n"+
		                   "Places to replace in the template are marked with ~~~Identifier~~~. This will\n"+
		                   "be replaced by entries from the given 2da called Identifier.2da. This is\n"+
		                   "case-sensitive.\n"+
		                   "\n"+
		                   "The 2da files must contain two columns labeled Suffix and Value.\n"+
		                   "\n"+
		                   "One script file will be generated for each possible combination of values from\n"+
		                   "the 2das. They will automatically have file type identifier of .nss"
		                  );
		
		System.exit(0);
	}
	
	
	private static String readTemplate(String filePath) throws Exception{
		Scanner reader = new Scanner(new File(filePath));
		StringBuffer temp = new StringBuffer();
		
		while(reader.hasNextLine()) temp.append(reader.nextLine() + "\n");
		
		return temp.toString();
	}
	
	
	private static void doCreation(Script script, int depth) throws Exception{
		if(depth == data.length){
			printScript(script);
			return;
		}
		Script copy;
		
		for(int i = 0; i < data[depth].getEntryCount(); i++){
			copy = (Script)script.clone();
			copy.text = script.text.replaceAll("~~~" + data[depth].getName() + "~~~",
			                                   data[depth].getEntry("Value", i));
			copy.name += data[depth].getEntry("Suffix", i);
			
			doCreation(copy, depth + 1);
		}
	}
	
	
	private static void printScript(Script toPrint) throws Exception{
		File target = new File(toPrint.name + ".nss");
		// Clean up old version if necessary
		if(target.exists()){
			System.out.println("Deleting previous version of " + toPrint.name + ".nss");
			target.delete();
		}
		target.createNewFile();
		
		// Creater the writer and print
		FileWriter writer = new FileWriter(target, false);
		writer.write(toPrint.text);
		// Clean up
		writer.flush();
		writer.close();
	}
}