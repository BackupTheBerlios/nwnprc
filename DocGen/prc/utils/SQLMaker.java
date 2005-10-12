package prc.utils;

import prc.autodoc.Data_2da;

import java.io.*;
import java.util.*;
import java.util.regex.*;

public final class SQLMaker{
	private SQLMaker(){}

	private static String prefix,
	                      suffix,
	                      template;
	private static String sql;

	/**
	 * The main method, as usual.
	 *
	 * @param args do I really need to explain this?
	 * @throws Exception this is a simple tool, just let all failures blow up
	 */
	public static void main(String[] args) throws Exception{
		if(args.length == 0 || args[0].equals("--help") || args[0].equals("-?"))
			readMe();

		//setup the transaction
		sql += "BEGIN IMMEDIATE;";

		String dir = args[0];
		String[] filenames = new File(dir).list();
		for(int i = 0; i < filenames.length; i++)
			addFileToSQL(dir+"/"+filenames[i]);

		//complete the transaction
		sql += "COMMIT;";

		printSQL();

	}

	private static void readMe(){
		System.out.println("Usage:\n"+
		                   "\tjava 2datosql precacher2das\n"+
		                   "\n"+
		                   "This application is designed to take all the 2DA\n"+
		                   "files in the directory and output a SQL\n"+
		                   "file for them"
		                  );

		System.exit(0);
	}

	private static void addFileToSQL(String filename) {

		Data_2da data = Data_2da.load2da(filename, true);
		//output the table creation
		addSQLForTable(data, filename);
		String[] labels = data.getLabels();
		String entry;
		for(int row = 0; row < data.getEntryCount() ; row ++) {
			entry = "INSERT INTO prc_cached2da_"+filename+" (rowid, ";
			for(int i = 0 ; i < labels.length ; i++){
				entry += ", "+labels[i];
			}
			entry += ") VALUES ("+row;
			for(int column = 0; column < labels.length ; column ++) {
				entry += ", ";

				String value = data.getEntry(labels[column], row);

				if(value == "****")
					value = "";
				entry += value;

				//spinner.spin();
			}
			entry += ");";
			sql += entry+"\n";
		}
	}

	private static void printSQL() throws Exception{
		//Spinner spinner = new Spinner();
		File target = new File("out.sql");
		// Clean up old version if necessary
		if(target.exists()){
			System.out.println("Deleting previous version of " + target.getName());
			target.delete();
		}
		target.createNewFile();

		// Creater the writer and print
		FileWriter writer = new FileWriter(target, false);
		writer.write(sql);
		// Clean up
		writer.flush();
		writer.close();
	}

	private static void addSQLForTable(Data_2da data, String filename){
		String entry;
		entry = "CREATE TABLE prc_cached2da_"+filename+" (rowid varchar(255)";
		String[] labels = data.getLabels();
		for(int i = 0 ; i < labels.length ; i++){
			entry += ", "+labels[i]+" varchar(255) DEFAULT '_'";
		}
		entry += ");";

		sql += entry+"\n";
	}
}