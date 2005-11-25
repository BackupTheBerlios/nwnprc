package rmg.rwg;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.lang.*;
import java.lang.Runtime;
import java.util.*;
import java.lang.Math;
import rmg.rwg.*;
import rmg.rwg.Vertex;
import rmg.rwg.Face;
import rmg.rwg.SetFile;
import rmg.rwg.Terrain;
import rmg.rwg.NWNModel;
import rmg.rwg.RGB;
import prc.autodoc.*;


public class rwg {
	public static Data_2da terrain2da         = Data_2da.load2da("terrain.2da");
	public static Data_2da terraintexture2da  = Data_2da.load2da("terrain_texture.2da");
	public static Data_2da terrainheight2da   = Data_2da.load2da("terrain_height.2da");
  	public static Random rng = new Random();

	public static void main(String[] args){
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
		NWNModel model = new NWNModel();
		SetFile setFile = new SetFile();
		for(int row = 0; row < terrain2da.getEntryCount(); row++){
			double water = new Double(terrain2da.getEntry("WaterLevel", row));
			int vertexsX  = terrain2da.getBiowareEntryAsInt("VertexsX", row);
			int vertexsY  = terrain2da.getBiowareEntryAsInt("VertexsY", row);
			int tilesX  = terrain2da.getBiowareEntryAsInt("TileX", row);
			int tilesY  = terrain2da.getBiowareEntryAsInt("TileY", row);
			int pixelPerVertex  = terrain2da.getBiowareEntryAsInt("PixelPerVertex", row);
			double roughness  = new Double(terrain2da.getEntry("WaterLevel", row));
			String label = terrain2da.getEntry("Label", row);
			String terrainlist = terrain2da.getEntry("TerrainList", row);
			Data_2da terrainlist2da         = Data_2da.load2da(terrainlist+".2da");

			Terrain terrain = new Terrain(vertexsX, vertexsY, pixelPerVertex, roughness);
			//smooth it
			terrain.heightmap.applyPlateau(water, water+0.2, water+0.1);
			terrain.heightmap.smooth(filterb, 1.0,  0.0);

			//apply the rim to the sea, do this last of the main terrain changes
			terrain.heightmap.applyLowRim(0.1);


			//now colour the terrains
			RGB colourmin, colourmax;
			for(int terrainrow = 0; terrainrow < terrainlist2da.getEntryCount(); terrainrow++){
				colourmin = new RGB(terrainlist2da.getBiowareEntryAsInt("colourminR", terrainrow),terrainlist2da.getBiowareEntryAsInt("colourminG", terrainrow),terrainlist2da.getBiowareEntryAsInt("colourminB", terrainrow));
				colourmax = new RGB(terrainlist2da.getBiowareEntryAsInt("colourmaxR", terrainrow),terrainlist2da.getBiowareEntryAsInt("colourmaxG", terrainrow),terrainlist2da.getBiowareEntryAsInt("colourmaxB", terrainrow));
				double minHeight = new Double(terrainlist2da.getEntry("minHeight", terrainrow));
				double maxHeight = new Double(terrainlist2da.getEntry("maxHeight", terrainrow));
				double minSlope = new Double(terrainlist2da.getEntry("minSlope", terrainrow));
				double maxSlope = new Double(terrainlist2da.getEntry("maxSlope", terrainrow));
				double fractalScale = new Double(terrainlist2da.getEntry("fractalScale", terrainrow));
				double amount = new Double(terrainlist2da.getEntry("amount", terrainrow));
				double distribScale = new Double(terrainlist2da.getEntry("distribScale", terrainrow));
				double heightOffset = new Double(terrainlist2da.getEntry("heightOffset", terrainrow));
				terrain.addTerrainLayer(terrainrow, minHeight, maxHeight, minSlope, maxSlope, colourmin, colourmax, terrainlist2da.getBiowareEntryAsInt("parentID", terrainrow), fractalScale, amount, distribScale, heightOffset);
	//addTerrainLayer(newID, minHeight, maxHeight, minSlope, maxSlope, colourmin, colourmax, parentID, fractalScale, amount,  distribScale, heightOffset){
	//addTerrainLayer(int  , double ,   double ,   double ,  double ,  RGB ,      RGB ,      int ,     double ,      double , double ,      double ){
			}
			//output heightmap
			terrain.heightmap.writeToDisk(label);
			//output colourmap
			terrain.writeToDisk(label+"_col");
			model.makeModel(terrain, label, tilesX, tilesY, water, false);
			for(int i=0 ; i < model.tileNameList.length;i++){
				setFile.addSetInformation(model.tileNameList[i]);
			}
		}
		//write set file
		setFile.writeToDisk();
		//tell user we've finished
		System.out.println("Done");
	}
}