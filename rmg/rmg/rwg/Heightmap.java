package rmg.rwg;

import java.awt.image.*;
import javax.imageio.*;
import java.io.*;
import java.lang.*;
import java.util.*;
import java.lang.Math;
import java.awt.*;

public class Heightmap {

	private double height[][] = new double [1][1];
	private BufferedImage image;
  	private Random rng = new Random();
	private boolean clamp = false;

	//constructor
	public Heightmap(int xSize, int ySize, double fractalDecay){
		height = new double [xSize][ySize];
		generateFractalBase(fractalDecay);
	}
	public Heightmap(int xSize, int ySize){
		this(xSize, ySize, 0.6);
	}


	public void generateFractalBase(double fractalDecay){

		double tempheightmap[][] = new double [2][2];
		tempheightmap[0][0] = 0;//rng.nextInt(zMax-zMin)+zMin;
		tempheightmap[1][0] = tempheightmap[0][0];
		tempheightmap[0][1] = tempheightmap[0][0];
		tempheightmap[1][1] = tempheightmap[0][0];
		double initialrandomrange = 255.0;
		double randomrange = initialrandomrange;

		int itteration = 0;
		while(tempheightmap.length < height.length
			&& tempheightmap[0].length < height[0].length)
		{
			randomrange = initialrandomrange;
			double randomscale = Math.pow(fractalDecay, (double)itteration);
			randomrange = (randomrange*randomscale);
			tempheightmap = diamondSquare(tempheightmap, randomrange);
			itteration++;
		}

		for(int x = 0; x < height.length; x++){
			for(int y = 0; y < height[0].length; y++){
				height[x][y] = tempheightmap[x][y];
			}
		}
	}

	public void applyLowRim(double rimSize){
		int rimWidthX = (int)(rimSize*(double)height.length);
		int rimWidthY = (int)(rimSize*(double)height[0].length);
		for(int x = 0; x < height.length; x++){
			for(int y = 0; y < height[0].length; y++){
				double scale = 1.0;

				if(x<rimWidthX){
					double newscale = (double)x/(double)rimWidthX;
					if(newscale < scale)
						scale = newscale;
				}

				if(y<rimWidthY){
					double newscale = (double)y/(double)rimWidthY;
					if(newscale < scale)
						scale = newscale;
				}

				if(x>(rimWidthX-height.length)){
					double newscale = ((double)height.length-(double)x)/(double)rimWidthX;
					if(newscale < scale)
						scale = newscale;
				}

				if(y>(rimWidthY-height[0].length)){
					double newscale = ((double)height[0].length-(double)y)/(double)rimWidthY;
					if(newscale < scale)
						scale = newscale;
				}
				//rather than a straight edge, use a curved one
				scale = Math.sin(scale*Math.PI*0.25);

				height[x][y] = height[x][y]*scale;
			}
		}
		scaleHeightmap(1.0, 0.0);
	}

	public void smooth(double[][] filter, double maxheight, double minheight, int runs){
		for(int i = 0; i < runs; i++){
			smooth(filter, maxheight, minheight);
		}
	}

	public void smooth(double[][] filter, double maxheight, double minheight){
		double[][] heightout = new double[height.length][height[0].length];
		for(int x = 0; x < height.length; x++){
			for(int y = 0; y < height[0].length; y++){
				double spotheight = height[x][y];
				heightout[x][y] = height[x][y];
				if((spotheight >= minheight) && (spotheight <= maxheight)){
					double average = 0.0;
					double filtertotal = 0.0;
					for(int xf = 0; xf < filter.length; xf++){
						for(int yf = 0; yf < filter[0].length; yf++){
							int xpos = x+xf-(filter.length/2);
							int ypos = y+yf-(filter[0].length/2);
							if(xpos >= height.length)
								xpos -= height.length;
							if(ypos >= height[0].length)
								ypos -= height[0].length;
							if(xpos < 0)
								xpos += height.length;
							if(ypos < 0 )
								ypos += height[0].length;
							average += height[xpos][ypos]*filter[xf][yf];
							filtertotal += filter[xf][yf];
						}
					}
					average /= filtertotal;
					heightout[x][y] = average;
				}
			}
		}
		height = heightout;
		scaleHeightmap(1.0, 0.0);
	}


	public void applyPlateau(double minHeight, double maxHeight, double outHeight){
		double outProp = (outHeight-minHeight)/(maxHeight-minHeight);
//System.out.println("outProp="+outProp);
		for(int x = 0; x < height.length; x++){
			for(int y = 0; y < height[0].length; y++){
				double spotHeight = height[x][y];
				if(spotHeight < maxHeight && spotHeight > minHeight){
					double proportion = (spotHeight-minHeight)/(maxHeight-minHeight);
					/*double outproportion = Math.sin(proportion*Math.PI*0.5)*outProp;//0.5
					if(proportion > 0.5);//0.5
						outproportion = 1.0-((outproportion/outProp)*(1.0-outProp));


					spotHeight = minHeight+((maxHeight-minHeight)*outproportion);*/
					spotHeight = outHeight;
//System.out.println("in: "+height[x][y]+" out: "+spotHeight);
					height[x][y] = spotHeight;
				}
			}
		}
		scaleHeightmap(1.0, 0.0);
	}

	//write the terrain as a bitmap to disk
	public void writeToDisk(String filename){
		try{
			//make sure its up to date
			refreshImageFromHeightmap();
			File file = new File(filename+".jpg");
			//file.delete();
			ImageIO.write(image, "jpg", file);
		} catch(IOException e){
		} catch(IllegalArgumentException e){
		}
		System.out.println("heightmap written to disk");
	}


	public void scaleHeightmap(double max, double min){

		if(min>max){
			double temp = max;
			max = min;
			min = max;
		}

		double tempmax = 0.0;
		double tempmin = 99999.9;

		for(int x = 0; x < height.length; x++){
			for(int y = 0; y < height[0].length; y++){
				double value = height[x][y];
				if(value>tempmax)
					tempmax = value;
				if(value<tempmin)
					tempmin = value;
			}
		}

		for(int x = 0; x < height.length; x++){
			for(int y = 0; y < height[0].length; y++){
				double value = height[x][y];
				double proportion = (height[x][y]-tempmin)/(tempmax-tempmin);
				value = (proportion*(max-min))+min;
				height[x][y] = value;
			}
		}
	}

	public double getHeightmap(int row, int column){
		if(row < 0)
			return 0.0;
		else if(column < 0)
			return 0.0;
		else if(row >= height.length)
			return 0.0;
		else if(column >= height[0].length)
			return 0.0;
		return height[row][column];
	}
	public void setHeightmap(int row, int column, double value){
		if(row < 0)
			return;
		else if(column < 0)
			return;
		else if(row >= height.length)
			return;
		else if(column >= height[0].length)
			return;
		height[row][column] = value;
	}
	public int getHeightmapRows(){
		return height.length;
	}
	public int getHeightmapColumns(){
		return height[0].length;
	}

	// PRIVATE FUNCTIONS



	private void DEBUGoutputHeightmap(){
		DEBUGoutputHeightmap(height);
	}


	private void DEBUGoutputHeightmap(double[][] outputheightmap){
		System.out.println("DEBUG:");
		for(int x = 0; x < outputheightmap.length; x++){
			for(int y = 0; y < outputheightmap[0].length; y++){
				String stringvalue = ""+outputheightmap[x][y];
				System.out.print(stringvalue+"\t");
			}
			System.out.print("\n");
		}
	}

	private void DEBUGoutputHeightmap(int[][] outputheightmap){
		System.out.println("DEBUG:");
		for(int x = 0; x < outputheightmap.length; x++){
			for(int y = 0; y < outputheightmap[0].length; y++){
				String stringvalue = ""+outputheightmap[x][y];
				System.out.print(stringvalue+"\t");
			}
			System.out.print("\n");
		}
	}

	private void refreshImageFromHeightmap(){
		int xsize = height.length;
		int ysize = height[0].length;
		int greyscaleheightmap[][] = new int [xsize][ysize];
		//image = new BufferedImage(xsize, ysize, BufferedImage.TYPE_BYTE_GRAY);
		image = new BufferedImage(xsize-1, ysize-1, BufferedImage.TYPE_INT_RGB);
		double maxheight = 0.0;
		double minheight = 99999.0;
		for(int x = 0; x < xsize; x++){
			for(int y = 0; y < ysize; y++){
				double spotheight = height[x][y];
				if(spotheight > maxheight)
					maxheight = spotheight;
				if(spotheight < minheight)
					minheight = spotheight;
			}
		}

		for(int x = 0; x < xsize; x++){
			for(int y = 0; y < ysize; y++){
				double spotheight = height[x][y];
				double proportion = (spotheight-minheight)/(maxheight-minheight);
				spotheight = (proportion * 255.0);
				greyscaleheightmap[x][y]=(int)spotheight;
			}
		}
		for(int x = 1; x < xsize; x++){
			for(int y = 1; y < ysize; y++){
				int spotheight = greyscaleheightmap[x][y];
				//DEBUGoutputHeightmap(greyscaleheightmap);
				int colour = (0 << 24) | (spotheight << 16) | (spotheight << 8) | spotheight;
				image.setRGB(x-1, y-1, colour);
				/* This may be quicker bit speed isnt an issue yet
				private void setRGB(int[] bitmap, int width, int height)
				{
				WritableRaster raster = bi.getRaster();

				int[] pixels = ( (DataBufferInt) raster.getDataBuffer()).getData();
				for (int i = 0; i < width * height; i++) {
				pixels = bitmap;
				}
				}
				*/
			}
		}
	}


	private double clampHeight(double inheight){
		return clampHeight(inheight, 0.0, 255.0);
	}

	private double clampHeight(double inheight, double min, double max){
		if(clamp = false)
			return inheight;
		//inputs wrong way around
		if(max < min){
			double temp = max;
			max = min;
			min = temp;
		}

		if(inheight > max)
			return max;
		if(inheight < min)
			return min;
		return inheight;
	}


	private double[][] diamondSquare(double[][] inputheightmap, double randomrange){
		int x,y;
		double outputheightmap[][] = new double [inputheightmap.length+(inputheightmap.length-1)][inputheightmap[0].length+(inputheightmap[0].length-1)];
		//enlarge the map
		for(x = 0; x < inputheightmap.length ; x++){
			for(y = 0; y < inputheightmap[0].length; y++){
				outputheightmap[x*2][y*2] = inputheightmap[x][y];
			}
		}
		//diamond
		for(x = 1; x < outputheightmap.length; x=x+2){
			for(y = 1; y < outputheightmap[0].length; y=y+2){
				double newheight;
				newheight = (outputheightmap[x-1][y-1]
							+outputheightmap[x+1][y-1]
							+outputheightmap[x-1][y+1]
							+outputheightmap[x+1][y+1])/4;
				newheight += (rng.nextDouble()*(randomrange+1.0))-(randomrange/2.0);
				//newheight = clampHeight(newheight, 0.0, 1.0);
				newheight = clampHeight(newheight);
				outputheightmap[x][y] 	= newheight;
			}
		}
		//square
		for(x = 0; x < outputheightmap.length; x++){
			int ystart = 0;
			if(x%2==0)//if divisible by 2
				ystart = 1;

			for(y = ystart; y < outputheightmap[0].length; y=y+2){
				//System.out.println("calculating square step "+x+" "+y);
				double newheight = 0;
				if(x-1>0)
					newheight += outputheightmap[x-1][y];
				else
					newheight += outputheightmap[x-1+outputheightmap.length-1][y];

				if(y-1>0)
					newheight += outputheightmap[x][y-1];
				else
					newheight += outputheightmap[x][y-1+outputheightmap[0].length-1];

				if(x+1<outputheightmap.length)
					newheight += outputheightmap[x+1][y];
				else
					newheight += outputheightmap[x+1-outputheightmap.length+1][y];

				if(y+1<outputheightmap[0].length)
					newheight += outputheightmap[x][y+1];
				else
					newheight += outputheightmap[x][y+1-outputheightmap[0].length+1];

				newheight /=4;
				newheight += (rng.nextDouble()*(randomrange+1.0))-(randomrange/2.0);
				//newheight = clampHeight(newheight, 0.0, 1.0);
				newheight = clampHeight(newheight);
				outputheightmap[x][y] = newheight;
			}
		}
		return outputheightmap;
	}
}