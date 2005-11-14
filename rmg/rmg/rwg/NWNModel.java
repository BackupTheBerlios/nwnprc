package rmg.rwg;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.lang.*;
import java.lang.Runtime;
import java.util.*;
import java.lang.Math;
import rmg.rwg.Vertex;
import rmg.rwg.Face;
import rmg.rwg.Terrain;

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

	//constructors
	//default to 4 x 4 tiles with water
	/*public NWNModel(Terrain terrain, String filename, int xTiles, int yTiles) throws Exception{
		this(terrain, filename, xTiles, yTiles, true);
	}
	public NWNModel(Terrain terrain, String filename) throws Exception{
		this(terrain, filename, 4, 4, true);
	}*/

	public NWNModel(Terrain terrain, String filename, int xTiles, int yTiles, boolean inAddWater, boolean noGraphics){
		addWater = inAddWater;
		//this is the number of vertexs on each tile on each edge
		int tileXSize = (terrain.xSize/terrain.textureScale/xTiles);
		int tileYSize = (terrain.ySize/terrain.textureScale/yTiles);
		double scaleFactor = 10.0/((double)tileXSize);
		double texScaleFactor = 1.0/((double)tileXSize);
		double zscale = 10.0;//*scaleFactor;
		waterlevel = 0.1*zscale;
		tileNameList = new String[xTiles*yTiles];
//System.out.println("tileXSize="+tileXSize);
//System.out.println("scaleFactor="+scaleFactor);
		//scale the terrain to a suitable height
		//terrain.heightmap.scaleHeightmap(0.0, 30.0);

		for(int x = terrain.textureScale; x < (terrain.heightmap.height.length-terrain.textureScale); x++){
			for(int y = terrain.textureScale; y < (terrain.heightmap.height[0].length-terrain.textureScale); y++){
				int averageCount = 0;
				double averageTotal = 0.0;

				if(x % (tileXSize*terrain.textureScale) == 0)
				{
//					averageCount += 2;
//					averageTotal += terrain.heightmap.height[x][y+terrain.textureScale];
//					averageTotal += terrain.heightmap.height[x][y-terrain.textureScale];
					averageCount += 2;
					averageTotal += terrain.heightmap.height[x+terrain.textureScale][y];
					averageTotal += terrain.heightmap.height[x-terrain.textureScale][y];

//					double spotheight = terrain.heightmap.height[x][y];
//					terrain.heightmap.height[x][y+terrain.textureScale] = spotheight;
//					terrain.heightmap.height[x][y-terrain.textureScale] = spotheight;
//					terrain.heightmap.height[x+terrain.textureScale][y] = spotheight;
//					terrain.heightmap.height[x-terrain.textureScale][y] = spotheight;
//System.out.println(spotheight+" @ x,y="+x+","+y);
				}

				if(y % (tileYSize*terrain.textureScale) == 0)
				{
//					averageCount += 2;
//					averageTotal += terrain.heightmap.height[x+terrain.textureScale][y];
//					averageTotal += terrain.heightmap.height[x-terrain.textureScale][y];
					averageCount += 2;
					averageTotal += terrain.heightmap.height[x][y+terrain.textureScale];
					averageTotal += terrain.heightmap.height[x][y-terrain.textureScale];
//System.out.println(terrain.heightmap.height[x][y]+" @ x,y="+x+","+y);
				}

				if(averageCount>0)
					terrain.heightmap.height[x][y] = averageTotal/(double)averageCount;
			}
		}

		for(int xTileCount = 0; xTileCount < xTiles; xTileCount++){
			for(int yTileCount = 0; yTileCount < yTiles; yTileCount++){

				//create a temporary heightmap
				double[][] tempheightmap = new double[tileXSize+1][tileYSize+1];
				int xOffset = (xTileCount*(tileXSize)*terrain.textureScale);//-xTileCount;
				int yOffset = (yTileCount*(tileYSize)*terrain.textureScale);//-yTileCount;
				for(int x = 0; x < tempheightmap.length ; x++){
					for(int y = 0; y < tempheightmap[0].length; y++){
						int originalX = ((x)*terrain.textureScale)+xOffset;
						int originalY = ((y)*terrain.textureScale)+yOffset;
						if((originalX >=terrain.heightmap.height.length) || (originalY >=terrain.heightmap.height[0].length))
							tempheightmap[x][y] = 0.0;
						else
							tempheightmap[x][y] = terrain.heightmap.height[originalX][originalY];
//if(xTileCount == 0 && yTileCount == 0)
//System.out.println("x="+x);
//if(y==0)
//System.out.println("originalX="+originalX);

						//if(yTileCount == 0 && xTileCount == 0 && x == (tempheightmap.length-1))
						//	System.out.println("1 tempheightmap["+x+"]["+y+"]=terrain.heightmap.height["+originalX+"]["+originalY+"]="+terrain.heightmap.height[originalX][originalY]);
						//if(yTileCount == 0 && xTileCount == 1 && x == 0)
						//	System.out.println("2 tempheightmap["+x+"]["+y+"]=terrain.heightmap.height["+originalX+"]["+originalY+"]="+terrain.heightmap.height[originalX][originalY]);
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
				for(int x = 0; x < tempheightmap.length ; x++){
					for(int y = 0; y < tempheightmap[0].length; y++){
						vertexIDMap[x][y] = ID;
						double xpos = roundNumber(((double)x*scaleFactor)-5.0);
						double ypos = roundNumber(((double)y*scaleFactor)-5.0);
						double zpos = roundNumber(tempheightmap[x][y]*zscale);
						//xpos = (xpos*1.002)-0.001;
						//ypos = (ypos*1.002)-0.001;
						Vertex vertex = new Vertex(xpos, ypos, zpos);
						//final x row
						//if(xTileCount == 0 && x == tempheightmap.length-1)
						//	System.out.println("tempheightmap["+x+"]["+y+"]="+tempheightmap[x][y]+" zpos="+zpos);
						//if(xTileCount == 1 && x == 0)
						//	System.out.println("tempheightmap["+x+"]["+y+"]="+tempheightmap[x][y]+" zpos="+zpos);
						vertexlist[ID] = vertex;

						//xpos = (double)x/((double)(tempheightmap.length+1));
						xpos = ((double)x*texScaleFactor);
						//ypos = 1.0-((double)y/((double)(tempheightmap[0].length+1)));
						ypos = 1.0-((double)y*texScaleFactor);
						//xpos = (xpos*1.02)-0.01;
						//ypos = (ypos*1.02)-0.01;
						//xpos = (xpos*(1.0-mapOverlap-mapOverlap))+mapOverlap;
						//ypos = (ypos*(1.0-mapOverlap-mapOverlap))+mapOverlap;
						xpos = (xpos*(0.5))+0.25;
						ypos = (ypos*(0.5))+0.25;
						xpos = roundNumber(xpos);
						ypos = roundNumber(ypos);
						zpos = 0.0;
						Vertex texvertex = new Vertex(xpos, ypos, zpos);
//if(yTileCount == 0 && xTileCount == 0)
//System.out.println(x+", "+y+" = "+xpos+", "+ypos);
						texturevertexlist[ID] = texvertex;

						ID++;
					}
				}
				//make faces (not the funny kind)
				facelist = new Face[(tileXSize)*(tileYSize)*2];
				ID = 0;
				for(int x = 0; x < (tileXSize) ; x++){
					for(int y = 0; y < (tileYSize); y++){
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

					int imageX = (tileXSize*terrain.textureScale);
					int imageY = (tileYSize*terrain.textureScale);
					//add buffers to overlap texture
					int imageXmapOverlap = (int)((double)imageX*(0.0+mapOverlap+mapOverlap));
					int imageYmapOverlap = (int)((double)imageY*(0.0+mapOverlap+mapOverlap));

					int xTexOffset = (xTileCount*(tileXSize)*terrain.textureScale);
					int yTexOffset = (yTileCount*(tileYSize)*terrain.textureScale);
					int xTexOffsetOverlap = xTexOffset-(imageXmapOverlap/2);
					int yTexOffsetOverlap = yTexOffset-(imageYmapOverlap/2);
					image = new BufferedImage(imageX+imageXmapOverlap, imageY+imageYmapOverlap, BufferedImage.TYPE_INT_RGB);
					for(int x = 0; x < (imageX+imageXmapOverlap) ; x++){
						for(int y = 0; y < (imageY+imageXmapOverlap); y++){
							int originalX = x+xTexOffsetOverlap;
							int originalY = y+yTexOffsetOverlap;

							if(originalX >= terrain.terrainmap.length)
								originalX -= terrain.terrainmap.length;
							else if(originalX < 0)
								originalX += terrain.terrainmap.length;

							if(originalY >= terrain.terrainmap.length)
								originalY -= terrain.terrainmap[0].length;
							else if(originalY < 0)
								originalY += terrain.terrainmap[0].length;

							//yes this is backwards, but it works
							int colour = terrain.terrainmap[originalX][originalY].rgbToComposite();
							//do a greyscale height mapping for test purposes
							//colour = (int)(255.0*terrain.heightmap.height[originalX][originalY]);
							//colour = (0 << 24) | (colour << 16) | (colour << 8) | colour;
							//set the pixels
							image.setRGB(x, y, colour);
	//if(y==0 && x==0)
	//System.out.println("x,y = "+originalX+","+originalY);
						}
					}
						ImageIO.write(image, "bmp", imagefile);
					//converted to tga files by batch post-processing

					//and a mini-map
						imagefile = new File("m"+modelname+".bmp");
						imagefile.delete();
						imagefile.createNewFile();
					image = new BufferedImage(16, 16, BufferedImage.TYPE_INT_RGB);
					for(int x = 0; x < 16 ; x++){
						for(int y = 0; y < 16; y++){
							//yes this is backwards, but it works
							int colour = terrain.terrainmap[(x*(imageX/16))+xTexOffset][(y*(imageY/16))+yTexOffset].rgbToComposite();
							//do a greyscale mapping for test purposes
							//colour = (int)(255.0*terrain.heightmap.height[x+xTexOffset][y+yTexOffset]);
							//colour = (0 << 24) | (colour << 16) | (colour << 8) | colour;
							//set the pixels
							image.setRGB(x, y, colour);
	//if(y==0 && x==0)
	//System.out.println("x+xTexOffset="+(x+xTexOffset));
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
		String sFile = "";
		//header stuff
		sFile += "newmodel "+modelname+"\n";
		sFile += "setsupermodel "+modelname+" NULL"+"\n";
		sFile += "classification tile"+"\n";
		sFile += "setanimationscale 1"+"\n";
		sFile += "beginmodelgeom "+modelname+"\n";
		//dummy node
		sFile += "node dummy "+modelname+"\n";
		sFile += "  parent NULL"+"\n";
		sFile += "endnode"+"\n";
		//geometry
		//one node
		sFile += "node trimesh "+modelname+"mesh"+"\n";
		sFile += "  parent "+modelname+"\n";
		sFile += "  ambient 1 1 1"+"\n";
		sFile += "  diffuse 1 1 1"+"\n";
		sFile += "  specular 0 0 0"+"\n";
		sFile += "  shininess 1"+"\n";
		sFile += "  shadow 0\n";
  		sFile += "  bitmap "+modelname+"\n";
  		//vertex list
  		sFile += "  verts "+vertexlist.length+"\n";
  		for(int i = 0; i < vertexlist.length; i++){
			Vertex vertex = vertexlist[i];
  			sFile += "    "+vertex.x+" "+vertex.y+" "+vertex.z+"\n";
		}
  		//texture face list
  		sFile += "  tverts "+texturevertexlist.length+"\n";
  		for(int i = 0; i < texturevertexlist.length; i++){
			Vertex vertex = texturevertexlist[i];
  			sFile += "    "+vertex.x+" "+vertex.y+" "+vertex.z+"\n";
		}
  		//face list
  		sFile += "  faces "+facelist.length+"\n";
  		for(int i = 0; i < facelist.length; i++){
			Face face = facelist[i];
  			sFile += "    "+face.vertIDA+" "+face.vertIDB+" "+face.vertIDC+" "+face.shadingGroup+" "+face.textvertIDA+" "+face.textvertIDB+" "+face.textvertIDC+" "+face.walkmesh+"\n";
		}
    	sFile += "  position 0 0 0"+"\n";
  		sFile += "  orientation 0 0 0 0"+"\n";
  		sFile += "endnode"+"\n";
  		//water node
  		if(addWater == true)
  		{
			sFile += "node trimesh water\n";
			sFile += "  parent "+modelname+"\n";
			sFile += "  ambient 1 1 1\n";
			sFile += "  diffuse 1 1 1\n";
			sFile += "  specular 0 0 0\n";
			sFile += "  shininess 1\n";
			sFile += "  shadow 0\n";
			sFile += "  transparencyhint 1\n";
			sFile += "  bitmap TTR01_water01\n";
			sFile += "  verts 4\n";
			sFile += "    -5 5 "+waterlevel+"\n";
			sFile += "    -5 -5 "+waterlevel+"\n";
			sFile += "    5 5 "+waterlevel+"\n";
			sFile += "    5 -5 "+waterlevel+"\n";
			sFile += "  tverts 4\n";
			sFile += "    12.0001001 -0.200011998 0\n";
			sFile += "    12.0001001 -2.00003004 0\n";
			sFile += "    13.8001003 -0.200011998 0\n";
			sFile += "    13.8001003 -2.00003004 0\n";
			sFile += "  faces 2\n";
			sFile += "    0 1 2 1 0 1 2 1\n";
			sFile += "    3 2 1 1 3 2 1 1\n";
			sFile += "  position 0 0 0\n";
			sFile += "  orientation 0 0 0 0\n";
			sFile += "  alpha 1\n";
			sFile += "  scale 1\n";
			sFile += "  setfillumcolor 0 0 0\n";
			sFile += "endnode\n";
		}
		//lighting
		sFile += "node light "+modelname+"ml1"+"\n";
		sFile += "  parent "+modelname+"\n";
		sFile += "  ambientonly 0"+"\n";
		sFile += "  shadow 0"+"\n";
		sFile += "  isdynamic 0"+"\n";
		sFile += "  affectdynamic 1"+"\n";
		sFile += "  lightpriority 5"+"\n";
		sFile += "  fadingLight 1"+"\n";
		sFile += "  flareradius 0"+"\n";
		sFile += "  position 0 0 15"+"\n";
		sFile += "  orientation 0 0 0 0"+"\n";
		sFile += "  radius 14"+"\n";
		sFile += "  color 0 0 0"+"\n";
		sFile += "endnode"+"\n";
		//aabb node
		sFile += "node aabb "+modelname+"mesh"+"\n";
		sFile += "  parent "+modelname+"\n";
		sFile += "  position 0 0 0"+"\n";
		sFile += "  orientation 0 0 0 0"+"\n";
		//vertex list
		sFile += "  verts "+vertexlist.length+"\n";
		for(int i = 0; i < vertexlist.length; i++){
			Vertex vertex = vertexlist[i];
			sFile += "    "+vertex.x+" "+vertex.y+" "+vertex.z+"\n";
		}
		//face list
		sFile += "  faces "+facelist.length+"\n";
		for(int i = 0; i < facelist.length; i++){
			Face face = facelist[i];
			sFile += "    "+face.vertIDA+" "+face.vertIDB+" "+face.vertIDC+" 0 0 0 0 "+face.walkmesh+"\n";
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
		sFile += "  aabb "+nwnaabb.returnString;
		sFile += "endnode"+"\n";
		//finish it
		sFile += "endmodelgeom "+modelname+"\n";
		sFile += "donemodel "+modelname+"\n";
		try{
			writeToFile(sFile);
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
		sFile = "";
		//header stuff
		sFile += "beginwalkmeshgeom "+modelname+"\n";
		//one node
		sFile += "node aabb "+modelname+"mesh"+"\n";
		sFile += "  parent "+modelname+"\n";
		sFile += "  position 0 0 0"+"\n";
		sFile += "  orientation 0 0 0 0"+"\n";
		//vertex list
		sFile += "  verts "+vertexlist.length+"\n";
		for(int i = 0; i < vertexlist.length; i++){
			Vertex vertex = vertexlist[i];
			sFile += "    "+vertex.x+" "+vertex.y+" "+vertex.z+"\n";
		}
		//face list
		sFile += "  faces "+facelist.length+"\n";
		for(int i = 0; i < facelist.length; i++){
			Face face = facelist[i];
			sFile += "    "+face.vertIDA+" "+face.vertIDB+" "+face.vertIDC+" 0 0 0 0 "+face.walkmesh+"\n";
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
		sFile += "  aabb "+nwnaabb.returnString;
		sFile += "endnode"+"\n";
		sFile += "endwalkmeshgeom "+modelname+"\n";
		try{
			writeToFile(sFile);
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
		String sFile = "";
		sFile += "<gff name=\""+filename+".gic\" type=\"GIC \" version=\"V3.2\" >\n";
		sFile += "    <struct id=\"-1\" >\n";
		sFile += "        <element name=\"Creature List\" type=\"15\" />\n";
		sFile += "        <element name=\"Door List\" type=\"15\" />\n";
		sFile += "        <element name=\"Encounter List\" type=\"15\" />\n";
		sFile += "        <element name=\"List\" type=\"15\" />\n";
		sFile += "        <element name=\"SoundList\" type=\"15\" />\n";
		sFile += "        <element name=\"StoreList\" type=\"15\" />\n";
		sFile += "        <element name=\"TriggerList\" type=\"15\" />\n";
		sFile += "        <element name=\"WaypointList\" type=\"15\" />\n";
		sFile += "        <element name=\"Placeable List\" type=\"15\" />\n";
		sFile += "    </struct>\n";
		sFile += "</gff>\n";
		writeToFile(sFile);
		//git area contents
		try{
			file = new File(filename+".git.xml");
			file.delete();
			file.createNewFile();
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		sFile = "";
		sFile += "<gff name=\""+filename+".git\" type=\"GIT \" version=\"V3.2\" >\n";
		sFile += "    <struct id=\"-1\" >\n";
		sFile += "        <element name=\"AreaProperties\" type=\"14\" >\n";
		sFile += "            <struct id=\"100\" >\n";
		sFile += "                <element name=\"AmbientSndDay\" type=\"5\" value=\"31\" />\n";
		sFile += "                <element name=\"AmbientSndNight\" type=\"5\" value=\"31\" />\n";
		sFile += "                <element name=\"AmbientSndDayVol\" type=\"5\" value=\"32\" />\n";
		sFile += "                <element name=\"AmbientSndNitVol\" type=\"5\" value=\"32\" />\n";
		sFile += "                <element name=\"EnvAudio\" type=\"5\" value=\"0\" />\n";
		sFile += "                <element name=\"MusicBattle\" type=\"5\" value=\"34\" />\n";
		sFile += "                <element name=\"MusicDay\" type=\"5\" value=\"20\" />\n";
		sFile += "                <element name=\"MusicNight\" type=\"5\" value=\"20\" />\n";
		sFile += "                <element name=\"MusicDelay\" type=\"5\" value=\"90000\" />\n";
		sFile += "            </struct>\n";
		sFile += "        </element>\n";
		sFile += "        <element name=\"Creature List\" type=\"15\" />\n";
		sFile += "        <element name=\"Door List\" type=\"15\" />\n";
		sFile += "        <element name=\"Encounter List\" type=\"15\" />\n";
		sFile += "        <element name=\"List\" type=\"15\" />\n";
		sFile += "        <element name=\"SoundList\" type=\"15\" />\n";
		sFile += "        <element name=\"StoreList\" type=\"15\" />\n";
		sFile += "        <element name=\"TriggerList\" type=\"15\" />\n";
		sFile += "        <element name=\"WaypointList\" type=\"15\" />\n";
		sFile += "        <element name=\"Placeable List\" type=\"15\" />\n";
		sFile += "    </struct>\n";
		sFile += "</gff>\n";
		try{
			writeToFile(sFile);
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
		sFile = "";
		sFile += "<gff name=\""+filename+".are\" type=\"ARE \" version=\"V3.2\" >\n";
		sFile += "    <struct id=\"-1\" >\n";
		sFile += "        <element name=\"ID\" type=\"5\" value=\"-1\" />\n";
		sFile += "        <element name=\"Creator_ID\" type=\"5\" value=\"-1\" />\n";
		sFile += "        <element name=\"Version\" type=\"4\" value=\"8\" />\n";
		sFile += "        <element name=\"Tag\" type=\"10\" value=\""+filename+"\" />\n";
		sFile += "        <element name=\"Name\" type=\"12\" value=\"-1\" >\n";
		sFile += "            <localString languageId=\"0\" value=\""+filename+"\" />\n";
		sFile += "        </element>\n";
		sFile += "        <element name=\"ResRef\" type=\"11\" value=\""+filename+"\" />\n";
		sFile += "        <element name=\"Comments\" type=\"10\" value=\"\" />\n";
		sFile += "        <element name=\"Expansion_List\" type=\"15\" />\n";
		sFile += "        <element name=\"Flags\" type=\"4\" value=\"4\" />\n";
		sFile += "        <element name=\"ModSpotCheck\" type=\"5\" value=\"0\" />\n";
		sFile += "        <element name=\"ModListenCheck\" type=\"5\" value=\"0\" />\n";
		sFile += "        <element name=\"MoonAmbientColor\" type=\"4\" value=\"0\" />\n";
		sFile += "        <element name=\"MoonDiffuseColor\" type=\"4\" value=\"2631720\" />\n";
		sFile += "        <element name=\"MoonFogAmount\" type=\"0\" value=\"3\" />\n";
		sFile += "        <element name=\"MoonFogColor\" type=\"4\" value=\"0\" />\n";
		sFile += "        <element name=\"MoonShadows\" type=\"0\" value=\"0\" />\n";
		sFile += "        <element name=\"SunAmbientColor\" type=\"4\" value=\"3947580\" />\n";
		sFile += "        <element name=\"SunDiffuseColor\" type=\"4\" value=\"7895160\" />\n";
		sFile += "        <element name=\"SunFogAmount\" type=\"0\" value=\"3\" />\n";
		sFile += "        <element name=\"SunFogColor\" type=\"4\" value=\"3947580\" />\n";
		sFile += "        <element name=\"SunShadows\" type=\"0\" value=\"0\" />\n";
		sFile += "        <element name=\"IsNight\" type=\"0\" value=\"0\" />\n";
		sFile += "        <element name=\"LightingScheme\" type=\"0\" value=\"10\" />\n";
		sFile += "        <element name=\"ShadowOpacity\" type=\"0\" value=\"30\" />\n";
		sFile += "        <element name=\"FogClipDist\" type=\"8\" value=\"45.0\" />\n";
		sFile += "        <element name=\"SkyBox\" type=\"0\" value=\"2\" />\n";
		sFile += "        <element name=\"DayNightCycle\" type=\"0\" value=\"1\" />\n";
		sFile += "        <element name=\"ChanceRain\" type=\"5\" value=\"100\" />\n";
		sFile += "        <element name=\"ChanceSnow\" type=\"5\" value=\"0\" />\n";
		sFile += "        <element name=\"ChanceLightning\" type=\"5\" value=\"50\" />\n";
		sFile += "        <element name=\"WindPower\" type=\"5\" value=\"2\" />\n";
		sFile += "        <element name=\"LoadScreenID\" type=\"2\" value=\"0\" />\n";
		sFile += "        <element name=\"PlayerVsPlayer\" type=\"0\" value=\"3\" />\n";
		sFile += "        <element name=\"NoRest\" type=\"0\" value=\"0\" />\n";
		sFile += "        <element name=\"Width\" type=\"5\" value=\""+xTiles+"\" />\n";
		sFile += "        <element name=\"Height\" type=\"5\" value=\""+yTiles+"\" />\n";
		sFile += "        <element name=\"OnEnter\" type=\"11\" value=\"\" />\n";
		sFile += "        <element name=\"OnExit\" type=\"11\" value=\"\" />\n";
		sFile += "        <element name=\"OnHeartbeat\" type=\"11\" value=\"\" />\n";
		sFile += "        <element name=\"OnUserDefined\" type=\"11\" value=\"\" />\n";
		sFile += "        <element name=\"Tileset\" type=\"11\" value=\"worldmap\" />\n";
		sFile += "        <element name=\"Tile_List\" type=\"15\" >\n";
//loop over tiles
		for(int y = 0; y < yTiles; y++){
			for(int x = 0; x < xTiles; x++){
				int tileID = (x*xTiles)+y;
				sFile += "            <struct id=\"1\" >\n";
				sFile += "                <element name=\"Tile_ID\" type=\"5\" value=\""+tileID+"\" />\n";
				sFile += "                <element name=\"Tile_Orientation\" type=\"5\" value=\"0\" />\n";
				sFile += "                <element name=\"Tile_Height\" type=\"5\" value=\"0\" />\n";
				sFile += "                <element name=\"Tile_MainLight1\" type=\"0\" value=\"0\" />\n";
				sFile += "                <element name=\"Tile_MainLight2\" type=\"0\" value=\"0\" />\n";
				sFile += "                <element name=\"Tile_SrcLight1\" type=\"0\" value=\"2\" />\n";
				sFile += "                <element name=\"Tile_SrcLight2\" type=\"0\" value=\"2\" />\n";
				sFile += "                <element name=\"Tile_AnimLoop1\" type=\"0\" value=\"1\" />\n";
				sFile += "                <element name=\"Tile_AnimLoop2\" type=\"0\" value=\"1\" />\n";
				sFile += "                <element name=\"Tile_AnimLoop3\" type=\"0\" value=\"1\" />\n";
				sFile += "            </struct>\n";
			}
		}
//end loop
		sFile += "        </element>\n";
		sFile += "    </struct>\n";
		sFile += "</gff>\n";
		try{
		writeToFile(sFile);
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