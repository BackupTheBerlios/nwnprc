package rmg.rwg;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.lang.*;
import java.lang.Runtime;
import java.util.*;
import java.lang.Math;
import rmg.rwg.*;

public class NWNModel {

	private Vertex vertexlist[];
	private Vertex texturevertexlist[];
	private int vertexIDMap[][];
	private Face facelist[];
	private String modelname = "terrain";
	private File file;
	private BufferedImage image;
	private double waterlevel = 0.1;
	private boolean addWater = true;
	public String[] tileNameList;
	private int tileNameListID = 0;
	private double mapOverlap = 0.5;
	public int tilesUsedCount = 0;

	//constructors
	//default to 4 x 4 tiles with water
	/*public NWNModel(Terrain terrain, String filename, int xTiles, int yTiles) throws Exception{
		this(terrain, filename, xTiles, yTiles, true);
	}
	public NWNModel(Terrain terrain, String filename) throws Exception{
		this(terrain, filename, 4, 4, true);
	}*/

	public NWNModel(){
	}

	public void makeModel(Terrain terrain, String filename, int xTiles, int yTiles, double water, boolean noGraphics){
		//sanity checks
		if(filename == "")			filename = "terrain";
		if(xTiles < 1)				xTiles = 1;
		if(yTiles < 1)				yTiles = 1;
		if(xTiles > 32)				xTiles = 32;
		if(yTiles > 32)				yTiles = 32;
		if(water < 0.0)				water = 0.0;
		if(water > 1.0)				water = 0.0;

		if(water == 0.0)
			addWater = false;
		else
			waterlevel = water;


		//this is the number of vertexs on each tile on each edge
		int tileXSize = (terrain.xSize/terrain.textureScale/xTiles);
		int tileYSize = (terrain.ySize/terrain.textureScale/yTiles);
		double scaleFactor = 10.0/((double)tileXSize);
		double texScaleFactor = 1.0/((double)tileXSize);
		double zscale = 10.0;
		waterlevel = waterlevel*zscale;
		tileNameList = new String[xTiles*yTiles];

		int averageCount = 0;
		double averageTotal = 0.0;
		int x;
		int y;
		for(x = terrain.textureScale; x < (terrain.heightmap.getHeightmapRows()-terrain.textureScale); x++){
			for(y = terrain.textureScale; y < (terrain.heightmap.getHeightmapColumns()-terrain.textureScale); y++){
				averageCount = 0;
				averageTotal = 0.0;

				if(x % (tileXSize*terrain.textureScale) == 0)
				{
					averageCount += 2;
					averageTotal += terrain.heightmap.getHeightmap(x+terrain.textureScale,y);
					averageTotal += terrain.heightmap.getHeightmap(x-terrain.textureScale,y);

				}

				if(y % (tileYSize*terrain.textureScale) == 0)
				{
					averageCount += 2;
					averageTotal += terrain.heightmap.getHeightmap(x,y+terrain.textureScale);
					averageTotal += terrain.heightmap.getHeightmap(x,y-terrain.textureScale);
				}

				if(averageCount>0)
					terrain.heightmap.setHeightmap(x, y, averageTotal/(double)averageCount);
			}
		}

		tileNameListID = 0;

		double[][] tempheightmap;
		int originalX;
		int originalY;
		double xpos;
		double ypos;
		double zpos;
		Vertex vertex;
		Vertex texvertex;
		int colour;
		int imageX;
		int imageY;
		int imageXmapOverlap;
		int imageYmapOverlap;
		int xTexOffset;
		int yTexOffset;
		int xTexOffsetOverlap;
		int yTexOffsetOverlap;
		for(int xTileCount = 0; xTileCount < xTiles; xTileCount++){
			for(int yTileCount = 0; yTileCount < yTiles; yTileCount++){

				//create a temporary heightmap
				tempheightmap = new double[tileXSize+1][tileYSize+1];
				int xOffset = (xTileCount*(tileXSize)*terrain.textureScale);//-xTileCount;
				int yOffset = (yTileCount*(tileYSize)*terrain.textureScale);//-yTileCount;
				for(x = 0; x < tempheightmap.length ; x++){
					for(y = 0; y < tempheightmap[0].length; y++){
						originalX = ((x)*terrain.textureScale)+xOffset;
						originalY = ((y)*terrain.textureScale)+yOffset;
						if((originalX >=terrain.heightmap.getHeightmapRows()) || (originalY >=terrain.heightmap.getHeightmapColumns()))
							tempheightmap[x][y] = 0.0;
						else
							tempheightmap[x][y] = terrain.heightmap.getHeightmap(originalX, originalY);
					}
				}

				//store the string input in the modelname
				//this way around matches col/row in the area file
				modelname = filename+"_"+yTileCount+"_"+xTileCount;
				//create the file
				//make vertexs & texture vertexs
				vertexlist = new Vertex[tempheightmap.length*tempheightmap[0].length];
				texturevertexlist = new Vertex[tempheightmap.length*tempheightmap[0].length];
				vertexIDMap = new int[tempheightmap.length][tempheightmap[0].length];
				int ID = 0;
				for(x = 0; x < tempheightmap.length ; x++){
					for(y = 0; y < tempheightmap[0].length; y++){
						vertexIDMap[x][y] = ID;
						xpos = roundNumber(((double)x*scaleFactor)-5.0);
						ypos = roundNumber(((double)y*scaleFactor)-5.0);
						zpos = roundNumber(tempheightmap[x][y]*zscale);
						vertex = new Vertex(xpos, ypos, zpos);
						vertexlist[ID] = vertex;

						xpos = ((double)x*texScaleFactor);
						ypos = 1.0-((double)y*texScaleFactor);
						xpos = (xpos*(0.5))+0.25;
						ypos = (ypos*(0.5))+0.25;
						xpos = roundNumber(xpos);
						ypos = roundNumber(ypos);
						zpos = 0.0;
						texvertex = new Vertex(xpos, ypos, zpos);
						texturevertexlist[ID] = texvertex;

						ID++;
					}
				}
				//make faces (not the funny kind)
				facelist = new Face[(tileXSize)*(tileYSize)*2];
				ID = 0;
				for(x = 0; x < (tileXSize) ; x++){
					for(y = 0; y < (tileYSize); y++){
						Face face = new Face();
						face.vertIDA = vertexIDMap[x][y];
						face.vertIDB = vertexIDMap[x+1][y];
						face.vertIDC = vertexIDMap[x][y+1];
						face.textvertIDA = vertexIDMap[x][y];
						face.textvertIDB = vertexIDMap[x+1][y];
						face.textvertIDC = vertexIDMap[x][y+1];
						face.ID = ID;
						facelist[ID] = face;

						ID++;

						face = new Face();
						face.vertIDB = vertexIDMap[x+1][y+1];
						face.vertIDA = vertexIDMap[x+1][y];
						face.vertIDC = vertexIDMap[x][y+1];
						face.textvertIDB = vertexIDMap[x+1][y+1];
						face.textvertIDA = vertexIDMap[x+1][y];
						face.textvertIDC = vertexIDMap[x][y+1];
						face.ID = ID;

						facelist[ID] = face;

						ID++;
					}
				}
				//writ it to disk
				outputToFile();

				//now do the texture
				if(noGraphics == false){

					//create the file
					try{
						File imagefile = new File(modelname+".bmp");
						imagefile.delete();
						imagefile.createNewFile();

					imageX = (tileXSize*terrain.textureScale);
					imageY = (tileYSize*terrain.textureScale);
					//add buffers to overlap texture
					imageXmapOverlap = (int)((double)imageX*(0.0+mapOverlap+mapOverlap));
					imageYmapOverlap = (int)((double)imageY*(0.0+mapOverlap+mapOverlap));

					xTexOffset = (xTileCount*(tileXSize)*terrain.textureScale);
					yTexOffset = (yTileCount*(tileYSize)*terrain.textureScale);
					xTexOffsetOverlap = xTexOffset-(imageXmapOverlap/2);
					yTexOffsetOverlap = yTexOffset-(imageYmapOverlap/2);
					image = new BufferedImage(imageX+imageXmapOverlap, imageY+imageYmapOverlap, BufferedImage.TYPE_INT_RGB);
					for(x = 0; x < (imageX+imageXmapOverlap) ; x++){
						for(y = 0; y < (imageY+imageXmapOverlap); y++){
							originalX = x+xTexOffsetOverlap;
							originalY = y+yTexOffsetOverlap;

							if(originalX >= terrain.terrainmap.length)
								originalX -= terrain.terrainmap.length;
							else if(originalX < 0)
								originalX += terrain.terrainmap.length;

							if(originalY >= terrain.terrainmap.length)
								originalY -= terrain.terrainmap[0].length;
							else if(originalY < 0)
								originalY += terrain.terrainmap[0].length;

							//yes this is backwards, but it works
							colour = terrain.terrainmap[originalX][originalY].rgbToComposite();
							//do a greyscale height mapping for test purposes
							//colour = (int)(255.0*terrain.heightmap.height[originalX][originalY]);
							//colour = (0 << 24) | (colour << 16) | (colour << 8) | colour;
							//set the pixels
							image.setRGB(x, y, colour);
						}
					}
					ImageIO.write(image, "bmp", imagefile);
					//converted to tga files by batch post-processing

					//and a mini-map
					imagefile = new File("m"+modelname+".bmp");
					imagefile.delete();
					imagefile.createNewFile();
					image = new BufferedImage(16, 16, BufferedImage.TYPE_INT_RGB);
					for(x = 0; x < 16 ; x++){
						for(y = 0; y < 16; y++){
							//yes this is backwards, but it works
							colour = terrain.terrainmap[(x*(imageX/16))+xTexOffset][(y*(imageY/16))+yTexOffset].rgbToComposite();
							//do a greyscale mapping for test purposes
							//colour = (int)(255.0*terrain.heightmap.height[x+xTexOffset][y+yTexOffset]);
							//colour = (0 << 24) | (colour << 16) | (colour << 8) | colour;
							//set the pixels
							image.setRGB(x, y, colour);
						}
					}
						ImageIO.write(image, "bmp", imagefile);
					} catch(IOException e){
					} catch(IllegalArgumentException e){
					}
					//converted to tga files by batch post-processing
				}

        		//store it on the array to be put in .set file later
        		tileNameList[tileNameListID]= modelname;
        		tileNameListID++;
			}
		}
		//output erf
		outputToERFFile(xTiles, yTiles, filename);
	}

	private void outputToFile(){
		try{
		file = new File(modelname+".mdl");
		file.delete();
		file.createNewFile();
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		StringBuilder sFile = new StringBuilder();
		//header stuff
		sFile.append("newmodel "+modelname+"\n");
		sFile.append("setsupermodel "+modelname+" NULL"+"\n");
		sFile.append("classification tile"+"\n");
		sFile.append("setanimationscale 1"+"\n");
		sFile.append("beginmodelgeom "+modelname+"\n");
		//dummy node
		sFile.append("node dummy "+modelname+"\n");
		sFile.append("  parent NULL"+"\n");
		sFile.append("endnode"+"\n");
		//geometry
		//one node
		sFile.append("node trimesh "+modelname+"mesh"+"\n");
		sFile.append("  parent "+modelname+"\n");
		sFile.append("  ambient 1 1 1"+"\n");
		sFile.append("  diffuse 1 1 1"+"\n");
		sFile.append("  specular 0 0 0"+"\n");
		sFile.append("  shininess 1"+"\n");
		sFile.append("  shadow 0\n");
  		sFile.append("  bitmap "+modelname+"\n");
  		//vertex list
  		sFile.append("  verts "+vertexlist.length+"\n");
  		for(int i = 0; i < vertexlist.length; i++){
			Vertex vertex = vertexlist[i];
  			sFile.append("    "+vertex.x+" "+vertex.y+" "+vertex.z+"\n");
		}
  		//texture face list
  		sFile.append("  tverts "+texturevertexlist.length+"\n");
  		for(int i = 0; i < texturevertexlist.length; i++){
			Vertex vertex = texturevertexlist[i];
  			sFile.append("    "+vertex.x+" "+vertex.y+" "+vertex.z+"\n");
		}
  		//face list
  		sFile.append("  faces "+facelist.length+"\n");
  		for(int i = 0; i < facelist.length; i++){
			Face face = facelist[i];
  			sFile.append("    "+face.vertIDA+" "+face.vertIDB+" "+face.vertIDC+" "+face.shadingGroup+" "+face.textvertIDA+" "+face.textvertIDB+" "+face.textvertIDC+" "+face.walkmesh+"\n");
		}
    	sFile.append("  position 0 0 0"+"\n");
  		sFile.append("  orientation 0 0 0 0"+"\n");
  		sFile.append("endnode"+"\n");
  		//water node
  		if(addWater == true)
  		{
			sFile.append("node trimesh water\n");
			sFile.append("  parent "+modelname+"\n");
			sFile.append("  ambient 1 1 1\n");
			sFile.append("  diffuse 1 1 1\n");
			sFile.append("  specular 0 0 0\n");
			sFile.append("  shininess 1\n");
			sFile.append("  shadow 0\n");
			sFile.append("  transparencyhint 1\n");
			sFile.append("  bitmap TTR01_water01\n");
			sFile.append("  verts 4\n");
			sFile.append("    -5 5 "+waterlevel+"\n");
			sFile.append("    -5 -5 "+waterlevel+"\n");
			sFile.append("    5 5 "+waterlevel+"\n");
			sFile.append("    5 -5 "+waterlevel+"\n");
			sFile.append("  tverts 4\n");
			sFile.append("    12.0001001 -0.200011998 0\n");
			sFile.append("    12.0001001 -2.00003004 0\n");
			sFile.append("    13.8001003 -0.200011998 0\n");
			sFile.append("    13.8001003 -2.00003004 0\n");
			sFile.append("  faces 2\n");
			sFile.append("    0 1 2 1 0 1 2 1\n");
			sFile.append("    3 2 1 1 3 2 1 1\n");
			sFile.append("  position 0 0 0\n");
			sFile.append("  orientation 0 0 0 0\n");
			sFile.append("  alpha 1\n");
			sFile.append("  scale 1\n");
			sFile.append("  setfillumcolor 0 0 0\n");
			sFile.append("endnode\n");
		}
		//lighting
		sFile.append("node light "+modelname+"ml1"+"\n");
		sFile.append("  parent "+modelname+"\n");
		sFile.append("  ambientonly 0"+"\n");
		sFile.append("  shadow 0"+"\n");
		sFile.append("  isdynamic 0"+"\n");
		sFile.append("  affectdynamic 1"+"\n");
		sFile.append("  lightpriority 5"+"\n");
		sFile.append("  fadingLight 1"+"\n");
		sFile.append("  flareradius 0"+"\n");
		sFile.append("  position 0 0 15"+"\n");
		sFile.append("  orientation 0 0 0 0"+"\n");
		sFile.append("  radius 14"+"\n");
		sFile.append("  color 0 0 0"+"\n");
		sFile.append("endnode"+"\n");
		//aabb node
		sFile.append("node aabb "+modelname+"mesh"+"\n");
		sFile.append("  parent "+modelname+"\n");
		sFile.append("  position 0 0 0"+"\n");
		sFile.append("  orientation 0 0 0 0"+"\n");
		//vertex list
		sFile.append("  verts "+vertexlist.length+"\n");
		for(int i = 0; i < vertexlist.length; i++){
			Vertex vertex = vertexlist[i];
			sFile.append("    "+vertex.x+" "+vertex.y+" "+vertex.z+"\n");
		}
		//face list
		sFile.append("  faces "+facelist.length+"\n");
		for(int i = 0; i < facelist.length; i++){
			Face face = facelist[i];
			sFile.append("    "+face.vertIDA+" "+face.vertIDB+" "+face.vertIDC+" 0 0 0 0 "+face.walkmesh+"\n");
		}
		//aabb tree
		//http://nwn.bioware.com/forums/search_results.html?keywords=aabb&start=1043478000&end=1135666799&author=&dev=&sort=date&search_for=all&where=message&forum=48&type=n&limit=100
		//double minHeight = 0.0;
		//double maxHeight = 0.0;
		//int minX = 0;
		//int maxX = vertexIDMap.length-1;
		//int minY = 0;
		//int maxY = vertexIDMap[0].length-1;
		NWNAABB nwnaabb = new NWNAABB(facelist, vertexlist, true);
		sFile.append("  aabb "+nwnaabb.returnString);
		sFile.append("endnode"+"\n");
		//finish it
		sFile.append("endmodelgeom "+modelname+"\n");
		sFile.append("donemodel "+modelname+"\n");
		try{
			writeToFile(sFile.toString());
		//} catch(IOException e){
		} catch(IllegalArgumentException e){
		}

		//wok stuff
		try{
			file = new File(modelname+".wok");
			file.delete();
			file.createNewFile();
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		sFile = new StringBuilder();
		//header stuff
		sFile.append("beginwalkmeshgeom "+modelname+"\n");
		//one node
		sFile.append("node aabb "+modelname+"mesh"+"\n");
		sFile.append("  parent "+modelname+"\n");
		sFile.append("  position 0 0 0"+"\n");
		sFile.append("  orientation 0 0 0 0"+"\n");
		//vertex list
		sFile.append("  verts "+vertexlist.length+"\n");
		for(int i = 0; i < vertexlist.length; i++){
			Vertex vertex = vertexlist[i];
			sFile.append("    "+vertex.x+" "+vertex.y+" "+vertex.z+"\n");
		}
		//face list
		sFile.append("  faces "+facelist.length+"\n");
		for(int i = 0; i < facelist.length; i++){
			Face face = facelist[i];
			sFile.append("    "+face.vertIDA+" "+face.vertIDB+" "+face.vertIDC+" 0 0 0 0 "+face.walkmesh+"\n");
		}
		//aabb tree
		//http://nwn.bioware.com/forums/search_results.html?keywords=aabb&start=1043478000&end=1135666799&author=&dev=&sort=date&search_for=all&where=message&forum=48&type=n&limit=100
		//double minHeight = 0.0;
		//double maxHeight = 0.0;
		//int minX = 0;
		//int maxX = vertexIDMap.length-1;
		//int minY = 0;
		//int maxY = vertexIDMap[0].length-1;
		//NWNAABB nwnaabb = new NWNAABB(facelist, vertexlist, true);
		sFile.append("  aabb "+nwnaabb.returnString);
		sFile.append("endnode"+"\n");
		sFile.append("endwalkmeshgeom "+modelname+"\n");
		try{
			writeToFile(sFile.toString());
		//} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
	}

	private void outputToERFFile(int xTiles, int yTiles, String filename){

		//output area files for erf
		//done via xml
		//gic area comments
		try{
			file = new File(filename+".gic.xml");
			file.delete();
			file.createNewFile();
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		StringBuilder sFile = new StringBuilder();
		sFile.append("<gff name=\""+filename+".gic\" type=\"GIC \" version=\"V3.2\" >\n");
		sFile.append("    <struct id=\"-1\" >\n");
		sFile.append("        <element name=\"Creature List\" type=\"15\" />\n");
		sFile.append("        <element name=\"Door List\" type=\"15\" />\n");
		sFile.append("        <element name=\"Encounter List\" type=\"15\" />\n");
		sFile.append("        <element name=\"List\" type=\"15\" />\n");
		sFile.append("        <element name=\"SoundList\" type=\"15\" />\n");
		sFile.append("        <element name=\"StoreList\" type=\"15\" />\n");
		sFile.append("        <element name=\"TriggerList\" type=\"15\" />\n");
		sFile.append("        <element name=\"WaypointList\" type=\"15\" />\n");
		sFile.append("        <element name=\"Placeable List\" type=\"15\" />\n");
		sFile.append("    </struct>\n");
		sFile.append("</gff>\n");
		writeToFile(sFile.toString());
		//git area contents
		try{
			file = new File(filename+".git.xml");
			file.delete();
			file.createNewFile();
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		sFile = new StringBuilder();
		sFile.append("<gff name=\""+filename+".git\" type=\"GIT \" version=\"V3.2\" >\n");
		sFile.append("    <struct id=\"-1\" >\n");
		sFile.append("        <element name=\"AreaProperties\" type=\"14\" >\n");
		sFile.append("            <struct id=\"100\" >\n");
		sFile.append("                <element name=\"AmbientSndDay\" type=\"5\" value=\"31\" />\n");
		sFile.append("                <element name=\"AmbientSndNight\" type=\"5\" value=\"31\" />\n");
		sFile.append("                <element name=\"AmbientSndDayVol\" type=\"5\" value=\"32\" />\n");
		sFile.append("                <element name=\"AmbientSndNitVol\" type=\"5\" value=\"32\" />\n");
		sFile.append("                <element name=\"EnvAudio\" type=\"5\" value=\"0\" />\n");
		sFile.append("                <element name=\"MusicBattle\" type=\"5\" value=\"34\" />\n");
		sFile.append("                <element name=\"MusicDay\" type=\"5\" value=\"20\" />\n");
		sFile.append("                <element name=\"MusicNight\" type=\"5\" value=\"20\" />\n");
		sFile.append("                <element name=\"MusicDelay\" type=\"5\" value=\"90000\" />\n");
		sFile.append("            </struct>\n");
		sFile.append("        </element>\n");
		sFile.append("        <element name=\"Creature List\" type=\"15\" />\n");
		sFile.append("        <element name=\"Door List\" type=\"15\" />\n");
		sFile.append("        <element name=\"Encounter List\" type=\"15\" />\n");
		sFile.append("        <element name=\"List\" type=\"15\" />\n");
		sFile.append("        <element name=\"SoundList\" type=\"15\" />\n");
		sFile.append("        <element name=\"StoreList\" type=\"15\" />\n");
		sFile.append("        <element name=\"TriggerList\" type=\"15\" />\n");
		sFile.append("        <element name=\"WaypointList\" type=\"15\" />\n");
		sFile.append("        <element name=\"Placeable List\" type=\"15\" />\n");
		sFile.append("    </struct>\n");
		sFile.append("</gff>\n");
		try{
			writeToFile(sFile.toString());
		//} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		//are tiles
		//git area contents
		try{
			file = new File(filename+".are.xml");
			file.delete();
			file.createNewFile();
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		sFile = new StringBuilder();
		sFile.append("<gff name=\""+filename+".are\" type=\"ARE \" version=\"V3.2\" >\n");
		sFile.append("    <struct id=\"-1\" >\n");
		sFile.append("        <element name=\"ID\" type=\"5\" value=\"-1\" />\n");
		sFile.append("        <element name=\"Creator_ID\" type=\"5\" value=\"-1\" />\n");
		sFile.append("        <element name=\"Version\" type=\"4\" value=\"8\" />\n");
		sFile.append("        <element name=\"Tag\" type=\"10\" value=\""+filename+"\" />\n");
		sFile.append("        <element name=\"Name\" type=\"12\" value=\"-1\" >\n");
		sFile.append("            <localString languageId=\"0\" value=\""+filename+"\" />\n");
		sFile.append("        </element>\n");
		sFile.append("        <element name=\"ResRef\" type=\"11\" value=\""+filename+"\" />\n");
		sFile.append("        <element name=\"Comments\" type=\"10\" value=\"\" />\n");
		sFile.append("        <element name=\"Expansion_List\" type=\"15\" />\n");
		sFile.append("        <element name=\"Flags\" type=\"4\" value=\"4\" />\n");
		sFile.append("        <element name=\"ModSpotCheck\" type=\"5\" value=\"0\" />\n");
		sFile.append("        <element name=\"ModListenCheck\" type=\"5\" value=\"0\" />\n");
		sFile.append("        <element name=\"MoonAmbientColor\" type=\"4\" value=\"0\" />\n");
		sFile.append("        <element name=\"MoonDiffuseColor\" type=\"4\" value=\"2631720\" />\n");
		sFile.append("        <element name=\"MoonFogAmount\" type=\"0\" value=\"3\" />\n");
		sFile.append("        <element name=\"MoonFogColor\" type=\"4\" value=\"0\" />\n");
		sFile.append("        <element name=\"MoonShadows\" type=\"0\" value=\"0\" />\n");
		sFile.append("        <element name=\"SunAmbientColor\" type=\"4\" value=\"3947580\" />\n");
		sFile.append("        <element name=\"SunDiffuseColor\" type=\"4\" value=\"7895160\" />\n");
		sFile.append("        <element name=\"SunFogAmount\" type=\"0\" value=\"3\" />\n");
		sFile.append("        <element name=\"SunFogColor\" type=\"4\" value=\"3947580\" />\n");
		sFile.append("        <element name=\"SunShadows\" type=\"0\" value=\"0\" />\n");
		sFile.append("        <element name=\"IsNight\" type=\"0\" value=\"0\" />\n");
		sFile.append("        <element name=\"LightingScheme\" type=\"0\" value=\"10\" />\n");
		sFile.append("        <element name=\"ShadowOpacity\" type=\"0\" value=\"30\" />\n");
		sFile.append("        <element name=\"FogClipDist\" type=\"8\" value=\"45.0\" />\n");
		sFile.append("        <element name=\"SkyBox\" type=\"0\" value=\"2\" />\n");
		sFile.append("        <element name=\"DayNightCycle\" type=\"0\" value=\"1\" />\n");
		sFile.append("        <element name=\"ChanceRain\" type=\"5\" value=\"100\" />\n");
		sFile.append("        <element name=\"ChanceSnow\" type=\"5\" value=\"0\" />\n");
		sFile.append("        <element name=\"ChanceLightning\" type=\"5\" value=\"50\" />\n");
		sFile.append("        <element name=\"WindPower\" type=\"5\" value=\"2\" />\n");
		sFile.append("        <element name=\"LoadScreenID\" type=\"2\" value=\"0\" />\n");
		sFile.append("        <element name=\"PlayerVsPlayer\" type=\"0\" value=\"3\" />\n");
		sFile.append("        <element name=\"NoRest\" type=\"0\" value=\"0\" />\n");
		sFile.append("        <element name=\"Width\" type=\"5\" value=\""+xTiles+"\" />\n");
		sFile.append("        <element name=\"Height\" type=\"5\" value=\""+yTiles+"\" />\n");
		sFile.append("        <element name=\"OnEnter\" type=\"11\" value=\"\" />\n");
		sFile.append("        <element name=\"OnExit\" type=\"11\" value=\"\" />\n");
		sFile.append("        <element name=\"OnHeartbeat\" type=\"11\" value=\"\" />\n");
		sFile.append("        <element name=\"OnUserDefined\" type=\"11\" value=\"\" />\n");
		sFile.append("        <element name=\"Tileset\" type=\"11\" value=\"worldmap\" />\n");
		sFile.append("        <element name=\"Tile_List\" type=\"15\" >\n");
//loop over tiles
		int tileIDOffset = tilesUsedCount;
		for(int y = 0; y < yTiles; y++){
			for(int x = 0; x < xTiles; x++){
				int tileID = (x*xTiles)+y;
				sFile.append("            <struct id=\"1\" >\n");
				sFile.append("                <element name=\"Tile_ID\" type=\"5\" value=\""+(tileID+tileIDOffset)+"\" />\n");
				sFile.append("                <element name=\"Tile_Orientation\" type=\"5\" value=\"0\" />\n");
				sFile.append("                <element name=\"Tile_Height\" type=\"5\" value=\"0\" />\n");
				sFile.append("                <element name=\"Tile_MainLight1\" type=\"0\" value=\"0\" />\n");
				sFile.append("                <element name=\"Tile_MainLight2\" type=\"0\" value=\"0\" />\n");
				sFile.append("                <element name=\"Tile_SrcLight1\" type=\"0\" value=\"2\" />\n");
				sFile.append("                <element name=\"Tile_SrcLight2\" type=\"0\" value=\"2\" />\n");
				sFile.append("                <element name=\"Tile_AnimLoop1\" type=\"0\" value=\"1\" />\n");
				sFile.append("                <element name=\"Tile_AnimLoop2\" type=\"0\" value=\"1\" />\n");
				sFile.append("                <element name=\"Tile_AnimLoop3\" type=\"0\" value=\"1\" />\n");
				sFile.append("            </struct>\n");
				tilesUsedCount++;
			}
		}
//end loop
		sFile.append("        </element>\n");
		sFile.append("    </struct>\n");
		sFile.append("</gff>\n");
		try{
		writeToFile(sFile.toString());
		//} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
	}

	private void writeToFile(String text){
		try{
			// Creater the writer and print
			FileWriter writer = new FileWriter(file, true);
			writer.write(text);
			// Clean up
			writer.flush();
			writer.close();
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
	}

	private double roundNumber(double input){
		return roundNumber(input, 2);
	}

	private double roundNumber(double input, int places){
		double scale = Math.pow(10, (double)places);
		int fixed = (int)(input*scale);
		double output = (double)(fixed/scale);
		return output;
	}
}