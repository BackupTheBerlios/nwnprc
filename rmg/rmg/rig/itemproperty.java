package rmg.rig;

import rmg.rig.*;

public class itemproperty {
	public int changeAppear = 100;
	public int costTable    =   0;
	public int costValue    =   0;
	public int param1       =   0;
	public int param1Value  =   0;
	public int propertyName =   0;
	public int subType      =   0;

	//constructor(s)
	public itemproperty(int inType, int inSubType, int inCost, int inParam1){
		propertyName = inType;
		subType = inSubType;
		costValue = inCost;
		param1Value = inParam1;
		param1 = rig.itempropdef2da.getBiowareEntryAsInt("Param1ResRef", propertyName);
		costTable = rig.itempropdef2da.getBiowareEntryAsInt("CostTableResRef", propertyName);
	}

	public itemproperty(int id){
	}

	//public functions

	public String toXML(){
		String text = "";
        text+="    <struct id=\"0\" >\n";
        text+="        <element name=\"PropertyName\" type=\"2\" value=\""+propertyName+"\" />\n";
        text+="        <element name=\"Subtype\" type=\"2\" value=\""+subType+"\" />\n";
        text+="        <element name=\"CostTable\" type=\"0\" value=\""+costTable+"\" />\n";
        text+="        <element name=\"CostValue\" type=\"2\" value=\""+costValue+"\" />\n";
        text+="        <element name=\"Param1\" type=\"0\" value=\""+param1+"\" />\n";
        text+="        <element name=\"Param1Value\" type=\"0\" value=\""+param1Value+"\" />\n";
        text+="        <element name=\"ChanceAppear\" type=\"0\" value=\""+changeAppear+"\" />\n";
        text+="    </struct>\n";
		return text;
	}
}