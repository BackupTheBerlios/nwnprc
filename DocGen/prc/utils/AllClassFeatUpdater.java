package prc.utils;

import static prc.autodoc.Main.spinner;
import static prc.autodoc.Main.verbose;
import java.util.*;
import java.io.*;

import prc.autodoc.Data_2da;
import prc.autodoc.TwoDAReadException;

public class AllClassFeatUpdater {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		if(args.length == 0) readMe();
		String cfabcPath = null;
		List<String> paths = new ArrayList<String>();
		
		// parse args
		for(String param : args){//[--help] | pathtoupdate2da targetpath+
			// Parameter parseage
			if(param.startsWith("-")){
				if(param.equals("--help")) readMe();
				else{
					for(char c : param.substring(1).toCharArray()){
						switch(c){
						default:
							System.out.println("Unknown parameter: " + c + "!");
							readMe();
						}
					}
				}
			}
			else{
				// It's a pathname
				if(cfabcPath == null)
					cfabcPath = param;
				else
					paths.add(param);
			}
		}
		
		if(cfabcPath == null){
			System.err.println("You did not specify the location of cls_feat_allBaseClasses.2da\n");
			readMe();
		}
		if(paths.size() == 0){
			System.err.println("You did not specify targets!\n");
			readMe();
		}
		spinner.disable();
		Data_2da source = Data_2da.load2da(cfabcPath);
		//System.out.print(source);
		//System.exit(0);
		// Crop
		int i = source.getEntryCount();
		boolean passedEnd = false, passedBegin = false;
		while(--i >= 0){
			//###cls_feat_allBaseClasses_BEGIN###
			//###cls_feat_allBaseClasses_END###
			if(!passedEnd){
				if(source.getEntry("FeatLabel", i).equals("###cls_feat_allBaseClasses_END###")){
					passedEnd = true;
					continue;
				}
				else
					source.removeRow(i);
			}
			else if(!passedBegin){
				if(source.getEntry("FeatLabel", i).equals("###cls_feat_allBaseClasses_BEGIN###"))
					passedBegin = true;
			}
			else{
				source.removeRow(i);
			}
		}
		
		//System.out.print(source);
		//System.exit(0);
		
		for(String path : paths){
			File dir = new File(path);
			if(!dir.isDirectory()){
				System.err.println("Parameter \"" + path + "\" does not refer to a directory!");
				continue;
			}
			
			File[] cls_feat2da = dir.listFiles(new FileFilter(){
				public boolean accept(File file){
					return file.getName().toLowerCase().startsWith("cls_feat_") &&
						   file.getName().toLowerCase().endsWith(".2da");
					}
				});
			
			Arrays.sort(cls_feat2da);
			
			for(File file : cls_feat2da){
				try{
					//System.out.println(file.getParent());
					update2da(source, Data_2da.load2da(file.getCanonicalPath()), file.getParentFile().getCanonicalPath());
				}catch(Exception e){
					e.printStackTrace();
				} //*/
			}
		}
	}
	
	private static void update2da(Data_2da source, Data_2da target, String path) throws IOException{
		// Find the beginning of replaceable area
		int beginRow = -1, i = 0;
		while(beginRow == -1 && i < target.getEntryCount()){
			if(target.getEntry("FeatLabel", i).equals("###cls_feat_allBaseClasses_BEGIN###"))
				beginRow = i;
			i++;
		}
		
		if(beginRow != -1){
			// Strip the lines to be replaced
			while(beginRow < target.getEntryCount()){
				if(target.getEntry("FeatLabel", beginRow).equals("###cls_feat_allBaseClasses_END###")){
					target.removeRow(beginRow);
					break;
				}else
					target.removeRow(beginRow);
			}
			
			for(i = 0; i < source.getEntryCount(); i++){
				target.insertRow(beginRow + i, source.getRow(i));
			}
			
			//System.out.println(target);
			target.save2da(path, true, true);
		}
	}
	
	private static void readMe(){
		System.out.println("Usage:\n"+
                           "  [--help] | pathtoupdate2da targetpath+\n"+
                           "\n" +
                           "pathtoupdate2da  path of the cls_feat_allBaseClasses.2da\n"+
                           "targetpath       the path of the directory containing the cls_feat_*.2das to update\n"+
                           "\n"+
                           "\n"+
                           "  --help  prints this text\n"
                );
		System.exit(0);
	}

}
