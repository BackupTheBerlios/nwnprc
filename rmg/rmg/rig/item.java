package rmg.rig;

import rmg.rig.*;


public class item {
	public String resRef;
	public int baseItem;
	public String name;
	public String description = -1;
	public String descriptionIdentified = -1;
	public String tag;
	public int charges = 50;
	public int cost;
	public int stolen = 0;
	public int stackSize = 1;
	public int plot = 0;
	public int addCost = 0;
	public int identified = 0;
	public int cursed =0;
	public int part1;
	public int part2;
	public int part3;
	public int colorLeather1;
	public int colorLeather2;
	public int colorCloth1;
	public int colorCloth2;
	public int colorMetal1;
	public int colorMetal2;
	private itemproperty[] propertiesList;
	public int paletteID;
	public String comment;

	//constructor
	public item(){
	}

	public addItemproperty(itemproperty iprop){
		propertiesListNew = new itemproperty[propertiesList.lenght+1];
		for(int i = 0 ; i < propertiesList.length ; i++){
				propertiesListNew[i] = propertiesList[i];
		}
		propertiesListNew[propertiesListNew.length] = iprop;
	}

	public String toXML(){
		String text = "";
		text += "<gff name=\"master0.uti\" type=\"UTI \" version=\"V3.2\" >\n";
		text += "    <struct id=\"-1\" >\n";
		text += "        <element name=\"TemplateResRef\" type=\"11\" value=\""+resRef+"\" />\n";
		text += "        <element name=\"BaseItem\" type=\"5\" value=\""+baseItem+"\" />\n";
		text += "        <element name=\"LocalizedName\" type=\"12\" value=\""+name+"\" />\n";
		text += "        <element name=\"Description\" type=\"12\" value=\""+description+"\" />\n";
		text += "        <element name=\"DescIdentified\" type=\"12\" value=\""+descriptionIdentified+"\" />\n";
		text += "        <element name=\"Tag\" type=\"10\" value=\""+tag+"\" />\n";
		text += "        <element name=\"Charges\" type=\"0\" value=\""+charges+"\" />\n";
		text += "        <element name=\"Cost\" type=\"4\" value=\""+cost+"\" />\n";
		text += "        <element name=\"Stolen\" type=\"0\" value=\""+stolen+"\" />\n";
		text += "        <element name=\"StackSize\" type=\"2\" value=\""+stackSize+"\" />\n";
		text += "        <element name=\"Plot\" type=\"0\" value=\""+plot+"\" />\n";
		text += "        <element name=\"AddCost\" type=\"4\" value=\""+addCost+"\" />\n";
		text += "        <element name=\"Identified\" type=\"0\" value=\""+identified+"\" />\n";
		text += "        <element name=\"Cursed\" type=\"0\" value=\""+cursed+"\" />\n";
		text += "        <element name=\"ModelPart1\" type=\"0\" value=\""+part1+"\" />\n";
		text += "        <element name=\"ModelPart2\" type=\"0\" value=\""+part2+"\" />\n";
		text += "        <element name=\"ModelPart3\" type=\"0\" value=\""+part3+"\" />\n";
        text += "        <element name=\"Leather1Color\" type=\"0\" value=\""+colorLeather1+"\" />\n";
        text += "        <element name=\"Leather2Color\" type=\"0\" value=\""+colorLeather2+"\" />\n";
        text += "        <element name=\"Cloth1Color\" type=\"0\" value=\""+colorCloth1+"\" />\n";
        text += "        <element name=\"Cloth2Color\" type=\"0\" value=\""+colorCloth2+"\" />\n";
        text += "        <element name=\"Metal1Color\" type=\"0\" value=\""+colorMetal1+"\" />\n";
        text += "        <element name=\"Metal2Color\" type=\"0\" value=\""+colorMetal2+"\" />\n";
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