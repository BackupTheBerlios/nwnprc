package rmg.rwg;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.lang.*;
import java.lang.Runtime;
import java.util.*;
import java.lang.Math;

public class SetFile {
	private StringBuilder setText = new StringBuilder();
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
			outputText += setText.toString();
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
		setText.append("[TILE"+setCount+"]\r\n");
		setText.append("Model="+tileName+"\r\n");
		setText.append("WalkMesh=msb01\r\n");
		setText.append("TopLeft=Grass\r\n");
		setText.append("TopLeftHeight=0\r\n");
		setText.append("TopRight=Grass\r\n");
		setText.append("TopRightHeight=0\r\n");
		setText.append("BottomLeft=Grass\r\n");
		setText.append("BottomLeftHeight=0\r\n");
		setText.append("BottomRight=Grass\r\n");
		setText.append("BottomRightHeight=0\r\n");
		setText.append("Top=\r\n");
		setText.append("Right=\r\n");
		setText.append("Bottom=\r\n");
		setText.append("Left=\r\n");
		setText.append("MainLight1=1\r\n");
		setText.append("MainLight2=1\r\n");
		setText.append("SourceLight1=1\r\n");
		setText.append("SourceLight2=1\r\n");
		setText.append("AnimLoop1=1\r\n");
		setText.append("AnimLoop2=1\r\n");
		setText.append("AnimLoop3=1\r\n");
		setText.append("Doors=0\r\n");
		setText.append("Sounds=0\r\n");
		setText.append("PathNode=A\r\n");
		setText.append("Orientation=0\r\n");
		//sFile.append("ImageMap2D=MI_temp01\r\n)";
		setText.append("ImageMap2D=m"+tileName+"\r\n)";
		setText.append("\r\n";
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