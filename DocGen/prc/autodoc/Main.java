package prc.autodoc;

import java.io.*;
import java.util.*;

public class Main{

	public static final boolean verbose = true;
	public static final Spinner spinner = new Spinner();
	
	private static final String fileSeparator = System.getProperty("file.separator");
	private static String curLanguage = null;
	
	private static HashMap twoDAStore = new HashMap();
	
	/**
	 * A small data structure class that gives access to both normal and custom
	 * TLK with the same method
	 */
	private static class TLKStore{
		private Data_TLK normal,
		                 custom;
		
		public TLKStore(String normalName, String customName) throws TLKReadException{
			this.normal = new Data_TLK("tlk" + fileSeparator + normalName);
			this.custom = new Data_TLK("tlk" + fileSeparator + customName);
		}
		
		public String getEntry(int num){
			return num < 0x01000000 ? normal.getEntry(num) : custom.getEntry(num);
		}
		
		public String getEntry(String num){
			return Integer.parseInt(num) < 0x01000000 ? normal.getEntry(num) : custom.getEntry(num);
		}
	}
	
	
}