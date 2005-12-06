package rmg.rig;

import rmg.rig.*;


public class item {
	public String resRef;
	public int baseItem;
	public String name;
	public String description = "-1";
	public String descriptionIdentified = "-1";
	public String tag;
	public int charges = 50;
	public int cost = 1;
	public int stolen = 0;
	public int stackSize = 1;
	public int plot = 0;
	public int addCost = 0;
	public int identified = 0;
	public int cursed =0;
	public int part1 = 1;
	public int part2 = 1;
	public int part3 = 1;
	public int colorLeather1 = 1;
	public int colorLeather2 = 1;
	public int colorCloth1 = 1;
	public int colorCloth2 = 1;
	public int colorMetal1 = 1;
	public int colorMetal2 = 1;
	private itemproperty[] propertiesList = new itemproperty[0];
	public int paletteID;
	public String comment;

	//constructor
	public item(){
	}

	public void addItemproperty(itemproperty iprop){
		itemproperty[] propertiesListNew = new itemproperty[propertiesList.length+1];
		for(int i = 0 ; i < propertiesList.length ; i++){
				propertiesListNew[i] = propertiesList[i];
		}
		propertiesListNew[propertiesList.length] = iprop;
		propertiesList = propertiesListNew;
	}

	public String toXML(){
		String text = "";
		text += "<gff name=\""+resRef+".uti\" type=\"UTI \" version=\"V3.2\" >\n";
		text += "    <struct id=\"-1\" >\n";
		text += "        <element name=\"TemplateResRef\" type=\"11\" value=\""+resRef+"\" />\n";
		text += "        <element name=\"BaseItem\" type=\"5\" value=\""+baseItem+"\" />\n";
		if(!name.matches("[0-9]")){
		text += "        <element name=\"LocalizedName\" type=\"12\" value=\"-1\" >\n";
		text += "            <localString languageId=\"0\" value=\""+name+"\" />\n";
		text += "        </element>\n";
		} else {
		text += "        <element name=\"LocalizedName\" type=\"12\" value=\""+name+"\" />\n";
		}
		if(!description.matches("[0-9]")){
		text += "        <element name=\"Description\" type=\"12\" value=\"-1\" >\n";
		text += "            <localString languageId=\"0\" value=\""+description+"\" />\n";
		text += "        </element>\n";
		} else {
		text += "        <element name=\"Description\" type=\"12\" value=\""+descriptionIdentified+"\" />\n";
		}
		if(!descriptionIdentified.matches("[0-9]")){
		text += "        <element name=\"DescIdentified\" type=\"12\" value=\"-1\" >\n";
		text += "            <localString languageId=\"0\" value=\""+descriptionIdentified+"\" />\n";
		text += "        </element>\n";
		} else {
		text += "        <element name=\"DescIdentified\" type=\"12\" value=\""+descriptionIdentified+"\" />\n";
		}
		text += "        <element name=\"Tag\" type=\"10\" value=\""+tag+"\" />\n";
		text += "        <element name=\"Charges\" type=\"0\" value=\""+charges+"\" />\n";
		text += "        <element name=\"Cost\" type=\"4\" value=\""+cost+"\" />\n";
		text += "        <element name=\"Stolen\" type=\"0\" value=\""+stolen+"\" />\n";
		text += "        <element name=\"StackSize\" type=\"2\" value=\""+stackSize+"\" />\n";
		text += "        <element name=\"Plot\" type=\"0\" value=\""+plot+"\" />\n";
		text += "        <element name=\"AddCost\" type=\"4\" value=\""+addCost+"\" />\n";
		text += "        <element name=\"Identified\" type=\"0\" value=\""+identified+"\" />\n";
		text += "        <element name=\"Cursed\" type=\"0\" value=\""+cursed+"\" />\n";
		if(rig.baseitem2da.getBiowareEntry("ModelType", baseItem) == "0"){
			//simple icon
		text += "        <element name=\"ModelPart1\" type=\"0\" value=\""+part1+"\" />\n";
		} else if(rig.baseitem2da.getBiowareEntry("ModelType", baseItem) == "1"){
			//color icon
		text += "        <element name=\"ModelPart1\" type=\"0\" value=\""+part1+"\" />\n";
        text += "        <element name=\"Leather1Color\" type=\"0\" value=\""+colorLeather1+"\" />\n";
        text += "        <element name=\"Leather2Color\" type=\"0\" value=\""+colorLeather2+"\" />\n";
        text += "        <element name=\"Cloth1Color\" type=\"0\" value=\""+colorCloth1+"\" />\n";
        text += "        <element name=\"Cloth2Color\" type=\"0\" value=\""+colorCloth2+"\" />\n";
        text += "        <element name=\"Metal1Color\" type=\"0\" value=\""+colorMetal1+"\" />\n";
        text += "        <element name=\"Metal2Color\" type=\"0\" value=\""+colorMetal2+"\" />\n";
		} else if(rig.baseitem2da.getBiowareEntry("ModelType", baseItem) == "2"){
			//multiple parts
			//uses 11 instead of part1,2,3 because it has to have a tens for the model
			//and a units for the color
		text += "        <element name=\"ModelPart1\" type=\"0\" value=\""+11+"\" />\n";
		text += "        <element name=\"ModelPart2\" type=\"0\" value=\""+11+"\" />\n";
		text += "        <element name=\"ModelPart3\" type=\"0\" value=\""+11+"\" />\n";
		} else if(rig.baseitem2da.getBiowareEntry("ModelType", baseItem) == "3"){
			//armor
		}
		text += "        <element name=\"PropertiesList\" type=\"15\" />\n";
		for(int i = 0 ; i < propertiesList.length ; i++){
			text += propertiesList[i].toXML();
		}
		text += "        <element name=\"PaletteID\" type=\"0\" value=\""+paletteID+"\" />\n";
		text += "        <element name=\"Comment\" type=\"10\" value=\""+comment+"\" />\n";
		text += "    </struct>\n";
		text += "</gff>\n";
		return text;
	}
}