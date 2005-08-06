package prc.utils;


import prc.autodoc.*;

import java.io.*;
import java.util.*;

public class twoDAcomp{
	
	public static void main(String[] args) throws Exception{
		File[] prc2das = new File("." + File.separator + "prc2da" + File.separator).listFiles();
		File[] nor2das = new File("." + File.separator + "2da" + File.separator).listFiles();
		
		
		HashMap<String, File> cont = new HashMap<String, File>();
		
		for(File elem : nor2das) cont.put(elem.getName().toLowerCase(), elem);
		
		for(File file1 : prc2das){
			File file2 = cont.get(file1.getName().toLowerCase());
			if(file2 == null) continue;
			try{
				Data_2da data1 = new Data_2da(file1.getPath());
				Data_2da data2 = new Data_2da(file2.getPath());
				
				Data_2da.doComparison(data1, data2);
			}catch(Exception e){
				System.out.println("Exception");
				System.err.println(e);
			}
		}
		
	}
}