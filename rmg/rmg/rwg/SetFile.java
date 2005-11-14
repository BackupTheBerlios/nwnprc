package rmg.rwg;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.lang.*;
import java.lang.Runtime;
import java.util.*;
import java.lang.Math;

public class SetFile {
	private String setText = "";
	private int setCount = 0;


	// CONSTRUCTOR

	public SetFile(){
	}

	// PUBLIC

	public void writeToDisk(){
		try
		{
			//make a new file
			File outputFile = new File("worldmap.set");
			outputFile.delete();
			outputFile.createNewFile();
			String outputText = "";
			outputText += getSetHeader();
			outputText += "[TILES]\r\n";
			outputText += "Count="+setCount+"\r\n";
			outputText += "\r\n";
			outputText += setText;
			outputText += getSetFooter();
			// Creater the writer and print
			FileWriter writer = new FileWriter(outputFile, false);
			writer.write(outputText);
			// Clean up
			writer.flush();
			writer.close();
		} catch(IOException e){
		}
	}

	public void addSetInformation(String tileName){
		String setInfo = "";
		setInfo += "[TILE"+setCount+"]\r\n";
		setInfo += "Model="+tileName+"\r\n";
		setInfo += "WalkMesh=msb01\r\n";
		setInfo += "TopLeft=Grass\r\n";
		setInfo += "TopLeftHeight=0\r\n";
		setInfo += "TopRight=Grass\r\n";
		setInfo += "TopRightHeight=0\r\n";
		setInfo += "BottomLeft=Grass\r\n";
		setInfo += "BottomLeftHeight=0\r\n";
		setInfo += "BottomRight=Grass\r\n";
		setInfo += "BottomRightHeight=0\r\n";
		setInfo += "Top=\r\n";
		setInfo += "Right=\r\n";
		setInfo += "Bottom=\r\n";
		setInfo += "Left=\r\n";
		setInfo += "MainLight1=1\r\n";
		setInfo += "MainLight2=1\r\n";
		setInfo += "SourceLight1=1\r\n";
		setInfo += "SourceLight2=1\r\n";
		setInfo += "AnimLoop1=1\r\n";
		setInfo += "AnimLoop2=1\r\n";
		setInfo += "AnimLoop3=1\r\n";
		setInfo += "Doors=0\r\n";
		setInfo += "Sounds=0\r\n";
		setInfo += "PathNode=A\r\n";
		setInfo += "Orientation=0\r\n";
		setInfo += "ImageMap2D=MI_temp01\r\n";
		//setInfo += "ImageMap2D=m"+tileName+"\r\n";
		setInfo += "\r\n";
		setText += setInfo;
		setCount++;
	}

	// PRIVATE

	private String getSetHeader(){
		//set header
		String setHeader = "";
		setHeader += "[GENERAL]\r\n";
		setHeader += "Name=worldmap\r\n";
		setHeader += "Type=SET\r\n";
		setHeader += "Version=V1.0\r\n";
		setHeader += "Interior=0\r\n";
		setHeader += "HasHeightTransition=0\r\n";
		setHeader += "EnvMap=ttr01__ref01\r\n";
		setHeader += "Transition=5\r\n";
		setHeader += "SelectorHeight=10.0\r\n";
		setHeader += "DisplayName=-1\r\n";
		setHeader += "UnlocalizedName=Worldmap\r\n";
		setHeader += "Border=Grass\r\n";
		setHeader += "Default=Grass\r\n";
		setHeader += "Floor=Grass\r\n";
		setHeader += "\r\n";
		setHeader += "[GRASS]\r\n";
		setHeader += "Grass=0\r\n";
		setHeader += "Density=5.000\r\n";
		setHeader += "Height=1.000\r\n";
		setHeader += "AmbientRed=0.800\r\n";
		setHeader += "AmbientGreen=0.600\r\n";
		setHeader += "AmbientBlue=0.300\r\n";
		setHeader += "DiffuseRed=0.800\r\n";
		setHeader += "DiffuseGreen=0.600\r\n";
		setHeader += "DiffuseBlue=0.300\r\n";
		setHeader += "\r\n";
		setHeader += "[TERRAIN TYPES]\r\n";
		setHeader += "Count=1\r\n";
		setHeader += "\r\n";
		setHeader += "[TERRAIN0]\r\n";
		setHeader += "Name=Grass\r\n";
		setHeader += "StrRef=63635\r\n";
		setHeader += "\r\n";
		setHeader += "[CROSSER TYPES]\r\n";
		setHeader += "Count=0\r\n";
		setHeader += "\r\n";
		setHeader += "[PRIMARY RULES]\r\n";
		setHeader += "Count=0\r\n";
		setHeader += "\r\n";
		setHeader += "[SECONDARY RULES]\r\n";
		setHeader += "Count=0\r\n";
		setHeader += "\r\n";
		return setHeader;
	}


	private String getSetFooter(){
		String setFooter = "";
		setFooter += "[GROUPS]\r\n";
		setFooter += "Count=0\r\n";
		return setFooter;
	}
}