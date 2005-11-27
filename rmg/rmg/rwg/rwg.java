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
	//public static Data_2da terrainheight2da   = Data_2da.load2da("terrain_height.2da");
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
		double water;
		int vertexsX;
		int vertexsY;
		int tilesX;
		int tilesY;
		int pixelPerVertex;
		double roughness;
		String label;
		String terrainlist;
		Data_2da terrainlist2da;
		Terrain terrain;
		RGB colourmin, colourmax;
		double minHeight;
		double maxHeight;
		double minSlope;
		double maxSlope;
		double fractalScale;
		double amount;
		double distribScale;
		double heightOffset;
		int texturerow;
		for(int row = 0; row < terrain2da.getEntryCount(); row++){
			water = new Double(terrain2da.getEntry("WaterLevel", row));
			vertexsX  = terrain2da.getBiowareEntryAsInt("VertexsX", row);
			vertexsY  = terrain2da.getBiowareEntryAsInt("VertexsY", row);
			tilesX  = terrain2da.getBiowareEntryAsInt("TileX", row);
			tilesY  = terrain2da.getBiowareEntryAsInt("TileY", row);
			pixelPerVertex  = terrain2da.getBiowareEntryAsInt("PixelPerVertex", row);
			roughness  = new Double(terrain2da.getEntry("WaterLevel", row));
			label = terrain2da.getEntry("Label", row);
			terrainlist = terrain2da.getEntry("TerrainList", row);
			terrainlist2da = Data_2da.load2da(terrainlist+".2da");

			//vertexs in the 2da is the vertexs per tile
			//we want overall vertex counts
			vertexsX *= tilesX;
			vertexsY *= tilesY;

			terrain = new Terrain(vertexsX, vertexsX, pixelPerVertex, roughness);
			//apply the rim to the sea, do this last of the main terrain changes
			//moved up here in the name of "realism"
			terrain.heightmap.applyLowRim(0.5);
			terrain.heightmap.applyPlateau(water, water+0.2, water+0.1);
			terrain.heightmap.smooth(filterb, 1.0,  0.0);

			//now colour the terrains
			for(int terrainrow = 0; terrainrow < terrainlist2da.getEntryCount(); terrainrow++){
				texturerow = terrainlist2da.getBiowareEntryAsInt("Reference", terrainrow);
				colourmin = new RGB(terraintexture2da.getBiowareEntryAsInt("colourminR", texturerow),terraintexture2da.getBiowareEntryAsInt("colourminG", texturerow),terraintexture2da.getBiowareEntryAsInt("colourminB", texturerow));
				colourmax = new RGB(terraintexture2da.getBiowareEntryAsInt("colourmaxR", texturerow),terraintexture2da.getBiowareEntryAsInt("colourmaxG", texturerow),terraintexture2da.getBiowareEntryAsInt("colourmaxB", texturerow));
				minHeight = new Double(terraintexture2da.getEntry("minHeight", texturerow));
				maxHeight = new Double(terraintexture2da.getEntry("maxHeight", texturerow));
				minSlope = new Double(terraintexture2da.getEntry("minSlope", texturerow));
				maxSlope = new Double(terraintexture2da.getEntry("maxSlope", texturerow));
				fractalScale = new Double(terraintexture2da.getEntry("fractalScale", texturerow));
				amount = new Double(terraintexture2da.getEntry("amount", texturerow));
				distribScale = new Double(terraintexture2da.getEntry("distribScale", texturerow));
				heightOffset = new Double(terraintexture2da.getEntry("heightOffset", texturerow));
				terrain.addTerrainLayer(terrainrow, minHeight, maxHeight, minSlope, maxSlope, colourmin, colourmax, terraintexture2da.getBiowareEntryAsInt("parentID", texturerow), fractalScale, amount, distribScale, heightOffset);
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