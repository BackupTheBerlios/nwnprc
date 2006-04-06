package prc.utils;

import prc.autodoc.*;

import java.io.*;
import java.math.*;
//import java.util.*;
//import java.util.regex.*;

//for the spinner
import static prc.Main.*;

public final class ItempropMaker{
	private ItempropMaker(){}


	private static Data_2da itempropdef2da;
	private static Data_2da costtable2da;
	private static Data_2da paramtable2da;


	public static void main(String[] args) throws Exception{
		//load the 2das
		itempropdef2da = Data_2da.load2da("2das\\itempropdef.2da",     true);
		costtable2da   = Data_2da.load2da("2das\\iprp_costtable.2da",  true);
		paramtable2da  = Data_2da.load2da("2das\\iprp_paramtable.2da", true);
		//loop over each row
		for(int itempropdef2darow = 85;
			itempropdef2darow < itempropdef2da.getEntryCount();
			itempropdef2darow ++) {
			if(itempropdef2da.getBiowareEntryAsInt("Name", itempropdef2darow) != 0){
				int type	 = itempropdef2darow;
				int subtype;
				int cost;
				int param1;
				if(itempropdef2da.getBiowareEntry("SubTypeResRef", type) == "")
					subtype = 0;
				else
					subtype = 1;
				if(itempropdef2da.getBiowareEntry("CostTableResRef", type) == "")
					cost = 0;
				else
					cost = 1;
				if(itempropdef2da.getBiowareEntry("Param1ResRef", type) == "")
					param1 = 0;
				else
					param1 = 1;
				//loop over each subtype
				if(subtype){
					Data_2da subtype2da = Data_2da.load2da("2das\\"+itempropdef2da.getBiowareEntry("SubTypeResRef", type)"+.2da", true);
					for(int subtypeID = 0; subtypeID < subtype2da.getEntryCount(); subtypeID ++) {
						//loop over the param1s, if applicable
						if(subtype2da.getBiowareEntry("Param1ResRef", subtypeID) == ""){
							param1 = 1;
						}else{
							if(itempropdef2da.getBiowareEntry("Param1ResRef", type) == "")
								param1 = 0;
							else
								param1 = 1;
						}
					}
				}else{
					//no subtype
					if(param1){
					}else{
						//no param1
					}
				}
			}
		}

	}
}