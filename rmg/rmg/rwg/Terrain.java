package rmg.rwg;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.lang.*;
import java.util.*;
import java.lang.Math;
import java.awt.*;
import rmg.rwg.RGB;
import rmg.rwg.Heightmap;

public class Terrain {

	public int xSize, ySize;
	public int textureScale = 16;

	public Heightmap heightmap;
	public RGB terrainmap[][];
	private int terrainIDmap[][];


	//constructor
	//defaults to 512 by 512 at 0 height
	public Terrain(int inXSize, int inYSize, int inTextureScale, double fractalBase){
		textureScale = inTextureScale;
		xSize = inXSize*textureScale;
		ySize = inYSize*textureScale;

		terrainmap = new RGB [xSize][ySize];
		terrainIDmap = new int [xSize][ySize];
		for(int x = 0; x < xSize; x++){
			for(int y = 0; y < ySize; y++){
				terrainIDmap[x][y] = 0;
			}
		}
		heightmap = new Heightmap(xSize, ySize, fractalBase);
		heightmap.scaleHeightmap(1.0, 0.0);
		//greyish base
		RGB colourmin = new RGB( 50,  50,  50);
		RGB colourmax = new RGB(200, 200, 200);
		addTerrainLayer(0, 0.0, 1.0, 0.0, 1.0, colourmin, colourmax, 0, 0.8, 1.0, 0.0, 0.0);
	}

	public Terrain(int inXSize, int inYSize){
		this(inXSize, inYSize, 4, 0.6);
	}

	public Terrain(int inXSize, int inYSize, int inTextureScale){
		this(inXSize, inYSize, inTextureScale, 0.6);
	}

	public Terrain(){
		this(64,64,4,0.6);
	}

	//PUBLIC

	public void addTerrainLayer(int newID, double minHeight, double maxHeight, double minSlope, double maxSlope, RGB colourmin, RGB colourmax, int parentID, double fractalScale, double amount, double distribScale, double heightOffset){
		if(minHeight < 0.0)
			minHeight = 0.0;
/*		if(coverage < 0.0)
			coverage = 0.0;
		if(coverage > 1.0)
			coverage = 1.0;
*/
		Heightmap terrainfractal = new Heightmap(xSize, ySize, fractalScale);
		terrainfractal.scaleHeightmap(1.0, 0.0);
		Heightmap distribfractal = new Heightmap(xSize, ySize, distribScale);
		distribfractal.scaleHeightmap(1.0, 0.0);
		heightmap.scaleHeightmap(1.0, 0.0);
		Heightmap newheight      = new Heightmap(xSize, ySize);
		int sloperadius = (textureScale/2)+1;
		double[][] nearheight = new double[sloperadius][sloperadius];

		for(int x = 0; x < xSize; x++){
			for(int y = 0; y < ySize; y++){
				double newheightoffset = 0.0;
				double spotheight = heightmap.getHeightmap(x,y);
				int baseterrainID = terrainIDmap[x][y];
				double spotfractal = distribfractal.getHeightmap(x,y);
				//calculate slope
				double nearlow = 1.0;
				double nearhigh = 0.0;
				for(int nx = 0; nx < nearheight.length; nx++){
					for(int ny = 0; ny < nearheight.length; ny++){
						double tempheight;
						int tempx = nx+x-(sloperadius/2);
						int tempy = ny+y-(sloperadius/2);
						if((nx+x-(sloperadius/2)) < 0)
							tempx = nx+x-(sloperadius/2)+heightmap.getHeightmapRows();
						else if((nx+x-(sloperadius/2)) >= heightmap.getHeightmapRows())
							tempx = nx+x-(sloperadius/2)-heightmap.getHeightmapRows();
						if((ny+y-(sloperadius/2)) < 0)
							tempy = ny+y-(sloperadius/2)+heightmap.getHeightmapColumns();
						else if((ny+y-(sloperadius/2)) >= heightmap.getHeightmapColumns())
							tempy = ny+y-(sloperadius/2)-heightmap.getHeightmapColumns();

						tempheight = heightmap.getHeightmap(tempx,tempy);

						if(tempheight>nearhigh)
							nearhigh = tempheight;
						if(tempheight<nearlow)
							nearlow = tempheight;
					}
				}
				double spotslope = nearhigh - nearlow;

				if((spotheight >= minHeight) && (spotheight <= maxHeight) && (baseterrainID == parentID) && (spotfractal<=amount) && (spotslope>=minSlope) && (spotslope<=maxSlope)){
					RGB spotcolour = new RGB(255,255,255);
					spotcolour.r = colourmin.r;
					spotcolour.g = colourmin.g;
					spotcolour.b = colourmin.b;
					spotcolour.scale(terrainfractal.getHeightmap(x,y), colourmin, colourmax);
					//if(x<10 && y< 10) System.out.println(colourmin.toString()+" & "+colourmax.toString()+" ->"+terrainfractal.height[x][y]+"-> "+spotcolour.toString());
					//terrainmap[x][y].r = spotcolour.r;
					//terrainmap[x][y].g = spotcolour.g;
					//terrainmap[x][y].b = spotcolour.b;
					terrainmap[x][y] = spotcolour;
					terrainIDmap[x][y] = newID;
					newheightoffset = heightOffset;
				}
				newheight.setHeightmap(x,y, heightmap.getHeightmap(x,y)+newheightoffset);
			}
		}
		for(int x = 0; x < xSize; x++){
			for(int y = 0; y < ySize; y++){
				heightmap.setHeightmap(x,y, newheight.getHeightmap(x,y));
			}
		}
	}

	//write the terrain as a bitmap to disk
	public void writeToDisk(String filename){
		try{
			//make sure its up to date
			int xsize = terrainmap.length;
			int ysize = terrainmap[0].length;
			BufferedImage image;
			image = new BufferedImage(xsize-1, ysize-1, BufferedImage.TYPE_INT_RGB);
			for(int x = 1; x < xsize; x++){
				for(int y = 1; y < ysize; y++){
					//DEBUGoutputHeightmap(greyscaleheightmap);
					int colour = terrainmap[x][y].rgbToComposite();
					image.setRGB(x-1, y-1, colour);
				}
			}
			File file = new File(filename+".jpg");
			//file.delete();
			ImageIO.write(image, "jpg", file);
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		System.out.println("terrain written to disk");
	}

	// PRIVATE


}