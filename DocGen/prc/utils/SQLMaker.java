package prc.utils;

import prc.autodoc.*;

import java.io.*;
//import java.util.*;
//import java.util.regex.*;

//for the spinner
import static prc.Main.*;

public final class SQLMaker{
	private SQLMaker(){}

	private static StringBuilder sql;

	/**
	 * The main method, as usual.
	 *
	 * @param args do I really need to explain this?
	 * @throws Exception this is a simple tool, just let all failures blow up
	 */
	public static void main(String[] args) throws Exception{
		if(args.length == 0 || args[0].equals("--help") || args[0].equals("-?"))
			readMe();

		// Allocate a buffer for constructing the string in - 1Kb
		sql = new StringBuilder(0x3FF);
		//setup the transaction
		sql.append("BEGIN IMMEDIATE;\n");
		//optimize for windows
		sql.append("PRAGMA page_size=4096;\n");
		//create a few tables
    	sql.append("CREATE TABLE prc_cached2da_ireq (rowid varchar(255), "                   +
    	           "file varchar(255), LABEL varchar(255), ReqType varchar(255), "           +
    	           "ReqParam1 varchar(255), ReqParam2 varchar(255));\n"                      +
    	           
    	           "CREATE TABLE prc_cached2da_cls_feat (rowid varchar(255), "               +
    	           "file varchar(255), FeatLabel varchar(255), FeatIndex varchar(255), "     +
    	           "List varchar(255), GrantedOnLevel varchar(255), OnMenu varchar(255));\n" +
    	           
    	           "CREATE TABLE prc_cached2da (name varchar(255), "                         +
    		       "columnid varchar(255), rowid varchar(255), data varchar(255));\n"
    	           );
		printSQL(true); //start a new file


		String dir = args[0];
		File[] files = new File(dir).listFiles();
		for(int i = 0; i < files.length; i++)
			addFileToSQL(files[i]);

		//create some indexs
		sql.append("CREATE UNIQUE INDEX spellsrowindex  ON prc_cached2da_spells (rowid);\n"       +
		           "CREATE UNIQUE INDEX featrowindex    ON prc_cached2da_feat (rowid);\n"         +
		           "CREATE        INDEX clsfeatindex    ON prc_cached2da_cls_feat (FeatIndex);\n" +
		           "CREATE        INDEX clsfileindex    ON prc_cached2da_cls_feat (file);\n"      +
		           "CREATE UNIQUE INDEX appearrowindex  ON prc_cached2da_appearance (rowid);\n"   +
		           "CREATE UNIQUE INDEX portrrowindex   ON prc_cached2da_portrait (rowid);\n"     +
		           "CREATE UNIQUE INDEX soundsrowindex  ON prc_cached2da_soundset (rowid);\n"     +
		           "CREATE UNIQUE INDEX datanameindex   ON prc_data (name);\n"                    +
		           "CREATE        INDEX irewfileindex   ON prc_cached2da_ireq (file);\n"          +
		           "CREATE UNIQUE INDEX refrindex       ON prc_cached2da_item_to_ireq (l_resref);\n"
		           );
		//complete the transaction
		sql.append("COMMIT;\n");

		printSQL(false);

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

	private static void addFileToSQL(File file) throws Exception{
		String filename = file.getAbsolutePath();
		Data_2da data = Data_2da.load2da(filename, true);
		//remove path and extension from filename
		filename = file.getName();
		filename = filename.substring(0, filename.length()-4);
		//tell the user what were doing
		if(verbose) System.out.print("Making SQL from "+filename+" - ");
		//specific files get their own tables
        if(filename.matches("feat")
            || filename.matches("spells")
            || filename.matches("portraits")
            || filename.matches("soundset")
            || filename.matches("appearance")
            || filename.matches("portraits")
            || filename.matches("classes")
            || filename.matches("racialtypes")
            || filename.matches("item_to_ireq")){

			//output the table creation
			addSQLForSingleTable(data, filename);
		}
		//some groups get specific matches
		else if(filename.matches("cls_feat_[^ ]*")){
			addSQLForGroupedTable(data, filename, "cls_feat");
		}
		else if(filename.matches("ireq_[^ ]*")){
			addSQLForGroupedTable(data, filename, "ireq");
		}
		//everything else goes in the same table
		else{
			addSQLForGeneralTable(data, filename);
		}
		//tell user finished that table
		if(verbose) System.out.println("- Done");
	}

	private static void printSQL(boolean newFile) throws Exception{
	//private static void printSQL(boolean newFile){
		File target = new File("out.sql");
		// Clean up old version if necessary
		if(target.exists() && newFile){
			if(verbose) System.out.println("Deleting previous version of " + target.getName());
			target.delete();
		}
		target.createNewFile();

		// Creater the writer and print
		FileWriter writer = new FileWriter(target, true);
		writer.write(sql.toString());
		// Clean up
		writer.flush();
		writer.close();
		// Allocate a new buffer - 64Kb this time, since the strings following the first are likely to be larger
		sql = new StringBuilder(0xFFFF);
		
		// Force garbage collection
		System.gc();
	}

	/*
	 *		Below are the three functions that produce SQL for adding
	 * 		to each of the 3 table types.
	 */


	private static void addSQLForSingleTable(Data_2da data, String filename) throws Exception{

		StringBuilder entry;
		entry = new StringBuilder("CREATE TABLE prc_cached2da_"+filename+" (rowid varchar(255)");
		String[] labels = data.getLabels();
		for(int i = 0 ; i < labels.length ; i++){
			entry.append(", "+labels[i]+" varchar(255) DEFAULT '_'");
		}
		entry.append(");");

		sql.append(entry + "\n");
		//put the data in
		for(int row = 0; row < data.getEntryCount() ; row ++) {
			entry = new StringBuilder("INSERT INTO prc_cached2da_"+filename);
			//entry +=" (rowid";
			//for(int i = 0 ; i < labels.length ; i++){
			//	entry += ", "+labels[i];
			//}
			//entry += ")"
			entry.append(" VALUES ("+row);
			for(int column = 0; column < labels.length ; column ++) {
				entry.append(", ");

				String value = data.getEntry(labels[column], row);

				if(value == "****")
					value = "";
				entry.append("'"+value+"'");

				if(verbose) spinner.spin();
			}
			entry.append(");");
			sql.append(entry + "\n");
			printSQL(false);
		}

		printSQL(false);
	}

	private static void addSQLForGroupedTable(Data_2da data, String filename, String tablename) throws Exception{
		String[] labels = data.getLabels();
		StringBuilder entry;
		for(int row = 0; row < data.getEntryCount() ; row ++) {
			entry = new StringBuilder("INSERT INTO prc_cached2da_"+tablename);
			//entry +="(rowid";
			//for(int i = 0 ; i < labels.length ; i++){
			//	entry += ", "+labels[i];
			//}
			//entry += ", file)";
			entry.append(" VALUES ("+row);
			for(int column = 0; column < labels.length ; column ++) {
				entry.append(", ");

				String value = data.getEntry(labels[column], row);

				if(value == "****")
					value = "";
				entry.append("'"+value+"'");

				if(verbose) spinner.spin();
			}
			entry.append(", '"+filename+"');");
			sql.append(entry + "\n");
			printSQL(false);
		}

		printSQL(false);
	}
	private static void addSQLForGeneralTable(Data_2da data, String filename) throws Exception{
		String[] labels = data.getLabels();
		StringBuilder entry;
		for(int row = 0; row < data.getEntryCount() ; row ++) {
			for(int column = 0; column < labels.length ; column ++) {
				entry = new StringBuilder("INSERT INTO prc_cached2da VALUES ('"+filename+"', '"+labels[column]+"', "+row+", ");

				String value = data.getEntry(labels[column], row);

				if(value == "****")
					value = "";
				entry.append("'"+value+"'");
				entry.append(");");
				sql.append(entry + "\n");

				if(verbose) spinner.spin();
			}
			printSQL(false);
		}

		printSQL(false);
	}
}