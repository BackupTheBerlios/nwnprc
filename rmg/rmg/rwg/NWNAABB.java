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
import wmg.Terrain;

public class NWNAABB {
	public String returnString = "";

	public NWNAABB(Face facelist[], Vertex vertexlist[], boolean xBox){
		Vertex minVert = new Vertex( 5.0, 5.0, 5.0);
		Vertex maxVert = new Vertex(-5.0,-5.0,-5.0);
		for(int i = 0; i < facelist.length; i++){
			double temp = 0.0;
			temp = vertexlist[facelist[i].vertIDA].x;
			if(temp > maxVert.x)
				maxVert.x = temp;
			if(temp < minVert.x)
				minVert.x = temp;
			temp = vertexlist[facelist[i].vertIDA].y;
			if(temp > maxVert.y)
				maxVert.y = temp;
			if(temp < minVert.y)
				minVert.y = temp;
			temp = vertexlist[facelist[i].vertIDA].z;
			if(temp > maxVert.z)
				maxVert.z = temp;
			if(temp < minVert.z)
				minVert.z = temp;
			temp = vertexlist[facelist[i].vertIDB].x;
			if(temp > maxVert.x)
				maxVert.x = temp;
			if(temp < minVert.x)
				minVert.x = temp;
			temp = vertexlist[facelist[i].vertIDB].y;
			if(temp > maxVert.y)
				maxVert.y = temp;
			if(temp < minVert.y)
				minVert.y = temp;
			temp = vertexlist[facelist[i].vertIDB].z;
			if(temp > maxVert.z)
				maxVert.z = temp;
			if(temp < minVert.z)
				minVert.z = temp;
			temp = vertexlist[facelist[i].vertIDC].x;
			if(temp > maxVert.x)
				maxVert.x = temp;
			if(temp < minVert.x)
				minVert.x = temp;
			temp = vertexlist[facelist[i].vertIDC].y;
			if(temp > maxVert.y)
				maxVert.y = temp;
			if(temp < minVert.y)
				minVert.y = temp;
			temp = vertexlist[facelist[i].vertIDC].z;
			if(temp > maxVert.z)
				maxVert.z = temp;
			if(temp < minVert.z)
				minVert.z = temp;
		}
		returnString = "       "+minVert.x+" "+minVert.y+" "+minVert.z+" "+maxVert.x+" "+maxVert.y+" "+maxVert.z+" ";
		int faceID = -1;
		if(facelist.length == 1){
			faceID = facelist[0].ID;
			returnString += faceID+"\n";
System.out.print(returnString);
			} else {
			Face facelistA[] = new Face[facelist.length];
			Face facelistB[] = new Face[facelist.length];
			int facelistACount = 0;
			int facelistBCount = 0;
			Vertex endA;
			Vertex endB;
			if(xBox){
				double yAverage = (minVert.y+maxVert.y)/2.0;
				double zAverage = (minVert.z+maxVert.z)/2.0;
				endA = new Vertex(minVert.x, yAverage, zAverage);
				endB = new Vertex(maxVert.x, yAverage, zAverage);
			} else {
				double xAverage = (minVert.x+maxVert.x)/2.0;
				double zAverage = (minVert.z+maxVert.z)/2.0;
				endA = new Vertex(xAverage, minVert.y, zAverage);
				endB = new Vertex(xAverage, maxVert.y, zAverage);
			}
			for(int i = 0; i < facelist.length; i++){
				double distanceToFaceA;
				double distanceToFaceB;
				double averageX = 0.0;
				double averageY = 0.0;
				double averageZ = 0.0;
				averageX += vertexlist[facelist[i].vertIDA].x;
				averageX += vertexlist[facelist[i].vertIDB].x;
				averageX += vertexlist[facelist[i].vertIDC].x;
				averageX = averageX/3.0;
				averageY += vertexlist[facelist[i].vertIDA].y;
				averageY += vertexlist[facelist[i].vertIDB].y;
				averageY += vertexlist[facelist[i].vertIDC].y;
				averageY /= 3.0;
				averageZ += vertexlist[facelist[i].vertIDA].z;
				averageZ += vertexlist[facelist[i].vertIDB].z;
				averageZ += vertexlist[facelist[i].vertIDC].z;
				averageZ /= 3.0;
				Vertex faceAverage = new Vertex(averageX, averageY, averageZ);
				double distanceX;
				double distanceY;
				double distanceZ;
				distanceX = averageX-endA.x;
				distanceY = averageY-endA.y;
				distanceZ = averageZ-endA.z;
				distanceToFaceA = Math.sqrt((distanceX*distanceX)+(distanceY*distanceY)+(distanceZ*distanceZ));
				distanceX = averageX-endB.x;
				distanceY = averageY-endB.y;
				distanceZ = averageZ-endB.z;
				distanceToFaceB = Math.sqrt((distanceX*distanceX)+(distanceY*distanceY)+(distanceZ*distanceZ));
				if(distanceToFaceA < distanceToFaceB){
					facelistA[facelistACount] = facelist[i];
					facelistACount++;
				} else {
					facelistB[facelistBCount] = facelist[i];
					facelistBCount++;
				}
			}
			if(facelistBCount == 0){
				facelistB[facelistBCount] = facelistA[facelistACount-1];
				facelistBCount++;
				facelistACount--;
			} else if(facelistACount == 0){
				facelistA[facelistACount] = facelistB[facelistBCount-1];
				facelistACount++;
				facelistBCount--;
			}
			Face facelistANew[] = new Face[facelistACount];
			for(int i = 0; i < facelistACount; i++){
				facelistANew[i] = facelistA[i];
			}
			Face facelistBNew[] = new Face[facelistBCount];
			for(int i = 0; i < facelistBCount; i++){
				facelistBNew[i] = facelistB[i];
			}
			returnString += faceID+"\n";
System.out.println("facelistACount = "+facelistACount);
System.out.println("facelistBCount = "+facelistBCount);
System.out.print(returnString);
			NWNAABB childNodeA = new NWNAABB(facelistANew, vertexlist, !xBox);
			returnString += childNodeA.returnString;
			NWNAABB childNodeB = new NWNAABB(facelistBNew, vertexlist, !xBox);
			returnString += childNodeB.returnString;
		}
	}
}