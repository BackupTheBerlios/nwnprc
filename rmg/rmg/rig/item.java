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
	public int partBelt = 1;
	public int partLBicep = 1;
	public int partLFArm = 1;
	public int partLFoot = 1;
	public int partLHand = 1;
	public int partLShin = 1;
	public int partLShould = 1;
	public int partLThigh = 1;
	public int partNeck = 1;
	public int partPelvis = 1;
	public int partRBicep = 1;
	public int partRFArm = 1;
	public int partRFoot = 1;
	public int partRHand = 1;
	public int partRShin = 1;
	public int partRShould = 1;
	public int partRThigh = 1;
	public int partTorso = 1;
	public int partRobe = 0;
	public int colorLeather1 = 1;
	public int colorLeather2 = 1;
	public int colorCloth1 = 1;
	public int colorCloth2 = 1;
	public int colorMetal1 = 1;
	public int colorMetal2 = 1;
	private itemproperty[] propertiesList = new itemproperty[0];
	public int paletteID;
	public String comment = "Generated by Primogenitors Random Item Generator";

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
		//String text = "";
		StringBuilder text = new StringBuilder(1000);
		text.append("<gff name=\""+resRef+".uti\" type=\"UTI \" version=\"V3.2\" >\n");
		text.append("    <struct id=\"-1\" >\n");
		text.append("        <element name=\"TemplateResRef\" type=\"11\" value=\""+resRef+"\" />\n");
		text.append("        <element name=\"BaseItem\" type=\"5\" value=\""+baseItem+"\" />\n");
		if(name.matches("[ a-zA-Z-']+")){
		text.append("        <element name=\"LocalizedName\" type=\"12\" value=\"-1\" >\n");
		text.append("            <localString languageId=\"0\" value=\""+name+"\" />\n");
		text.append("        </element>\n");
		} else {
		text.append("        <element name=\"LocalizedName\" type=\"12\" value=\""+name+"\" />\n");
		}
		if(description.matches("[ a-zA-Z-']+")){
		text.append("        <element name=\"Description\" type=\"12\" value=\"-1\" >\n");
		text.append("            <localString languageId=\"0\" value=\""+description+"\" />\n");
		text.append("        </element>\n");
		} else {
		text.append("        <element name=\"Description\" type=\"12\" value=\""+descriptionIdentified+"\" />\n");
		}
		if(descriptionIdentified.matches("[ a-zA-Z-']+")){
		text.append("        <element name=\"DescIdentified\" type=\"12\" value=\"-1\" >\n");
		text.append("            <localString languageId=\"0\" value=\""+descriptionIdentified+"\" />\n");
		text.append("        </element>\n");
		} else {
		text.append("        <element name=\"DescIdentified\" type=\"12\" value=\""+descriptionIdentified+"\" />\n");
		}
		text.append("        <element name=\"Tag\" type=\"10\" value=\""+tag+"\" />\n");
		text.append("        <element name=\"Charges\" type=\"0\" value=\""+charges+"\" />\n");
		text.append("        <element name=\"Cost\" type=\"4\" value=\""+cost+"\" />\n");
		text.append("        <element name=\"Stolen\" type=\"0\" value=\""+stolen+"\" />\n");
		text.append("        <element name=\"StackSize\" type=\"2\" value=\""+stackSize+"\" />\n");
		text.append("        <element name=\"Plot\" type=\"0\" value=\""+plot+"\" />\n");
		text.append("        <element name=\"AddCost\" type=\"4\" value=\""+addCost+"\" />\n");
		text.append("        <element name=\"Identified\" type=\"0\" value=\""+identified+"\" />\n");
		text.append("        <element name=\"Cursed\" type=\"0\" value=\""+cursed+"\" />\n");
		if(rig.baseitem2da.getBiowareEntryAsInt("ModelType", baseItem) == 0){
			//simple icon
		text.append("        <element name=\"ModelPart1\" type=\"0\" value=\""+part1+"\" />\n");
		} else if(rig.baseitem2da.getBiowareEntryAsInt("ModelType", baseItem) == 1){
			//color icon
		text.append("        <element name=\"ModelPart1\" type=\"0\" value=\""+part1+"\" />\n");
        text.append("        <element name=\"Leather1Color\" type=\"0\" value=\""+colorLeather1+"\" />\n");
        text.append("        <element name=\"Leather2Color\" type=\"0\" value=\""+colorLeather2+"\" />\n");
        text.append("        <element name=\"Cloth1Color\" type=\"0\" value=\""+colorCloth1+"\" />\n");
        text.append("        <element name=\"Cloth2Color\" type=\"0\" value=\""+colorCloth2+"\" />\n");
        text.append("        <element name=\"Metal1Color\" type=\"0\" value=\""+colorMetal1+"\" />\n");
        text.append("        <element name=\"Metal2Color\" type=\"0\" value=\""+colorMetal2+"\" />\n");
		} else if(rig.baseitem2da.getBiowareEntryAsInt("ModelType", baseItem) == 2){
			//multiple parts
			//uses 11 instead of part1,2,3 because it has to have a tens for the model
			//and a units for the color
		text.append("        <element name=\"ModelPart1\" type=\"0\" value=\""+11+"\" />\n");
		text.append("        <element name=\"ModelPart2\" type=\"0\" value=\""+11+"\" />\n");
		text.append("        <element name=\"ModelPart3\" type=\"0\" value=\""+11+"\" />\n");
		} else if(rig.baseitem2da.getBiowareEntryAsInt("ModelType", baseItem) == 3){
			//armor
		text.append("        <element name=\"ArmorPart_Belt\" type=\"0\" value=\""+partBelt+"\" />\n");
		text.append("        <element name=\"ArmorPart_LBicep\" type=\"0\" value=\""+partLBicep+"\" />\n");
		text.append("        <element name=\"ArmorPart_LFArm\" type=\"0\" value=\""+partLFArm+"\" />\n");
		text.append("        <element name=\"ArmorPart_LFoot\" type=\"0\" value=\""+partLFoot+"\" />\n");
		text.append("        <element name=\"ArmorPart_LHand\" type=\"0\" value=\""+partLHand+"\" />\n");
		text.append("        <element name=\"ArmorPart_LShin\" type=\"0\" value=\""+partLShin+"\" />\n");
		text.append("        <element name=\"ArmorPart_LShoul\" type=\"0\" value=\""+partLShould+"\" />\n");
		text.append("        <element name=\"ArmorPart_LThigh\" type=\"0\" value=\""+partLThigh+"\" />\n");
		text.append("        <element name=\"ArmorPart_Neck\" type=\"0\" value=\""+partNeck+"\" />\n");
		text.append("        <element name=\"ArmorPart_Pelvis\" type=\"0\" value=\""+partPelvis+"\" />\n");
		text.append("        <element name=\"ArmorPart_RBicep\" type=\"0\" value=\""+partRBicep+"\" />\n");
		text.append("        <element name=\"ArmorPart_RFArm\" type=\"0\" value=\""+partRFArm+"\" />\n");
		text.append("        <element name=\"ArmorPart_RFoot\" type=\"0\" value=\""+partRFoot+"\" />\n");
		text.append("        <element name=\"ArmorPart_RHand\" type=\"0\" value=\""+partRHand+"\" />\n");
		text.append("        <element name=\"ArmorPart_RShin\" type=\"0\" value=\""+partRShin+"\" />\n");
		text.append("        <element name=\"ArmorPart_RShoul\" type=\"0\" value=\""+partRShould+"\" />\n");
		text.append("        <element name=\"ArmorPart_RThigh\" type=\"0\" value=\""+partRThigh+"\" />\n");
		text.append("        <element name=\"ArmorPart_Torso\" type=\"0\" value=\""+partTorso+"\" />\n");
		text.append("        <element name=\"ArmorPart_Robe\" type=\"0\" value=\""+partRobe+"\" />\n");
        text.append("        <element name=\"Leather1Color\" type=\"0\" value=\""+colorLeather1+"\" />\n");
        text.append("        <element name=\"Leather2Color\" type=\"0\" value=\""+colorLeather2+"\" />\n");
        text.append("        <element name=\"Cloth1Color\" type=\"0\" value=\""+colorCloth1+"\" />\n");
        text.append("        <element name=\"Cloth2Color\" type=\"0\" value=\""+colorCloth2+"\" />\n");
        text.append("        <element name=\"Metal1Color\" type=\"0\" value=\""+colorMetal1+"\" />\n");
        text.append("        <element name=\"Metal2Color\" type=\"0\" value=\""+colorMetal2+"\" />\n");
		}
		text.append("        <element name=\"PropertiesList\" type=\"15\" />\n");
		for(int i = 0 ; i < propertiesList.length ; i++){
			text.append(propertiesList[i].toXML());
		}
		text.append("        <element name=\"PaletteID\" type=\"0\" value=\""+paletteID+"\" />\n");
		text.append("        <element name=\"Comment\" type=\"10\" value=\""+comment+"\" />\n");
		text.append("    </struct>\n");
		text.append("</gff>\n");
		return text.toString();
	}
}