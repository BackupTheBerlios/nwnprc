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
		param1 = Integer.decode(rig.itempropdef2da.getEntry("Param1ResRef", propertyName));
		costTable = Integer.decode(rig.itempropdef2da.getEntry("CostTableResRef", propertyName));
	}

	public itemproperty(int id){
	}

	//public functions

	public String toXML(){
		String text = "";
		return text;
	}
}