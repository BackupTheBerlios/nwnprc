package wmg;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.lang.*;
import java.lang.Runtime;
import java.util.*;
import java.lang.Math;
import wmg.Vertex;
import wmg.Face;
import wmg.SetFile;
import wmg.Terrain;
import wmg.NWNModel;
import wmg.RGB;


public class rwg {

	//public static void main(String[] args) throws Throwable{
	public main() throws Throwable{
		boolean bUseWater = true;
		Terrain terrain = new Terrain(64, 64, 4, 0.5);
		//initial rim setup
		terrain.heightmap.applyLowRim(0.25);
		//Terrain terrain = new Terrain(16, 16, 4, 0.6);
		//smooth it
		double[][] filter = {{0,0,0,1,1,1,0,0,0},
							 {0,0,1,1,1,1,1,0,0},
							 {0,1,1,2,3,2,1,1,0},
							 {1,1,2,3,3,3,2,1,1},
							 {1,1,3,3,3,3,3,1,1},
							 {1,1,2,3,3,3,2,1,1},
							 {0,1,1,2,3,2,1,1,0},
							 {0,0,1,1,1,1,1,0,0},
							 {0,0,0,1,1,1,0,0,0}};

		double[][] filterb= {{0,0,0,1,1,1,0,0,0},
							 {0,0,1,1,1,1,1,0,0},
							 {0,1,1,1,1,1,1,1,0},
							 {1,1,1,1,1,1,1,1,1},
							 {1,1,1,1,1,1,1,1,1},
							 {1,1,1,1,1,1,1,1,1},
							 {0,1,1,1,1,1,1,1,0},
							 {0,0,1,1,1,1,1,0,0},
							 {0,0,0,1,1,1,0,0,0}};
		terrain.heightmap.applyPlateau(0.0, 0.5, 0.20);
		terrain.heightmap.applyPlateau(0.1, 0.5, 0.20);
		terrain.heightmap.smooth(filter, 1.0,  0.0);
		//terrain.heightmap.applyPlateau(0.1, 0.5, 0.20);
		//terrain.heightmap.applyPlateau(0.0, 0.2, 0.00);
		//terrain.heightmap.smooth(filterb, 0.3, 0.0, 3);

		//apply the rim to the sea, do this last of the main terrain changes
		terrain.heightmap.applyLowRim(0.25);

		//output heightmap
		terrain.heightmap.writeToDisk("Terrain");

		//now colour the terrains
		//addTerrainLayer(int newID, double minHeight, double maxHeight, RGB colourmin,
		//	RGB colourmax, int parentID, double fractalScale, double amount, double distribScale){
		RGB colourmin, colourmax;
		//grass
		colourmin = new RGB(30, 80, 40);
		colourmax = new RGB(80,150,100);
		terrain.addTerrainLayer(1, 0.12, 0.5, 0.0, 0.04, colourmin, colourmax, 0, 0.8, 1.0, 0.2, 0.0);
		//forest
		colourmin = new RGB(10, 80, 10);
		colourmax = new RGB(30,150, 50);
		terrain.addTerrainLayer(4, 0.12, 0.5, 0.0, 0.03,  colourmin, colourmax, 1, 0.8, 0.3, 0.8, 0.1);
		//sandy shore
		colourmin = new RGB(180,180, 80);
		colourmax = new RGB(190,190, 90);
		terrain.addTerrainLayer(3, 0.08, 0.12, 0.0, 0.02,  colourmin, colourmax, 0, 0.8, 1.0, 0.0, 0.0);
		//snow
		colourmin = new RGB(225,225,250);
		colourmax = new RGB(250,250,250);
		terrain.addTerrainLayer(2, 0.75, 1.0, 0.0, 0.9,  colourmin, colourmax, 0, 0.8, 1.0, 0.0, 0.0);
		//underwater
		colourmin = new RGB(0,0,30);
		colourmax = new RGB(40,40,120);
		terrain.addTerrainLayer(5, 0.0, 0.08, 0.0, 1.0,  colourmin, colourmax, 0, 0.8, 1.0, 0.0, 0.0);

/*
		//plane of fire:
		colourmin = new RGB(100, 40, 40);
		colourmax = new RGB(120, 50, 60);
		terrain.addTerrainLayer(1, 0.0, 0.1, 0.0, 1.0, colourmin, colourmax, 0, 0.8, 1.0, 0.0, 0.0);
		colourmin = new RGB(120, 40, 40);
		colourmax = new RGB(160, 50, 60);
		terrain.addTerrainLayer(2, 0.0, 0.6, 0.0, 1.0, colourmin, colourmax, 1, 0.9, 0.3, 0.8, 0.0);
		colourmin = new RGB(130, 20, 20);
		colourmax = new RGB(150, 70, 20);
		terrain.addTerrainLayer(3, 0.4, 1.0, 0.0, 1.0, colourmin, colourmax, 1, 0.5, 0.3, 0.3, 0.0);
		colourmin = new RGB( 50, 20, 20);
		colourmax = new RGB( 80, 40, 40);
		terrain.addTerrainLayer(4, 0.8, 1.0, 0.0, 1.0, colourmin, colourmax, 3, 0.8, 1.0, 0.0, 0.0);
		bUseWater = false;
*/
		//output colourmap
		terrain.writeToDisk("Terrain_col");


		NWNModel model = new NWNModel(terrain, "Terrain", 8, 8, bUseWater, false);
		SetFile setFile = new SetFile();
		for(int i=0 ; i < model.tileNameList.length;i++){
			setFile.addSetInformation(model.tileNameList[i]);
		}

		//write set file
		setFile.writeToDisk();

		//tell user we've finished
		System.out.println("Done");
	}
}