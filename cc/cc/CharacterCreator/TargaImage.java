/*
 * TargaImage.java
 *
 * Created on February 23, 2003, 6:23 PM
 */


package CharacterCreator;

import java.awt.*;
import java.awt.image.DirectColorModel;
import java.awt.image.MemoryImageSource;
import java.io.*;

public class TargaImage {
    private static final int    NO_TRANSPARENCY = 255;
    private static final int    FULL_TRANSPARENCY = 0;
    
    private short               idLength;
    private short               colorMapType;
    private short               imageType;
    private int                 cMapStart;
    private int                 cMapLength;
    private short               cMapDepth;
    private int                 xOffset;
    private int                 yOffset;
    private int                 width;
    private int                 height;
    private short               pixelDepth;
    private short               imageDescriptor;
    private DirectColorModel    cm;
    public int[]                pixels;
    
    /* -------------------------------------------------- [constructor] */
    public TargaImage(File srcFile) throws IOException {
		InputStream is = new FileInputStream(srcFile);
		try {
			open(is);
		}
		catch (IOException e) {
			is.close();
			throw e;
		}
    }

	public TargaImage(byte[] buffer) throws IOException {
		InputStream is = new ByteArrayInputStream(buffer);
		try {
			open(is);
		}
		catch (IOException e) {
			is.close();
			throw e;
		}
	}
    
    /* ----------------------------------------------------------- open */
    private void open(InputStream srcFile) throws IOException {
        int                 red = 0;
        int                 green = 0;
        int                 blue = 0;
        int                 srcLine = 0;
        int                 alpha = FULL_TRANSPARENCY;
        
        /* --- open the file streams --- */
        BufferedInputStream bis = new BufferedInputStream(srcFile, 8192);
        DataInputStream dis = new DataInputStream(bis);
        
        /* --- read targa header info --- */
        idLength = (short) dis.read();
        colorMapType = (short) dis.read();
        imageType = (short) dis.read();
        //Color Map Specification
        cMapStart = (int) flipEndian(dis.readShort()); //Color Map Origin
        cMapLength = (int) flipEndian(dis.readShort()); //Color Map Length
        cMapDepth = (short) dis.read();  //Color Map Entry Depth (16,24,32)
        //Image Specification
        xOffset = (int) flipEndian(dis.readShort());
        yOffset = (int) flipEndian(dis.readShort());
        width = (int) flipEndian(dis.readShort());
        height = (int) flipEndian(dis.readShort());
        pixelDepth = (short) dis.read();//Number of bits in stored pixel index
        if (pixelDepth == 24) {
            cm = new DirectColorModel(24, 0xFF0000, 0xFF00, 0xFF);
        } else if (pixelDepth == 32) {
            cm = new DirectColorModel(
            32, 0xFF0000, 0xFF00, 0xFF, 0xFF000000);
        } else {
			bis.close();
			dis.close();
			throw new IOException("Unhandled Color Depth: " + pixelDepth);
		}

        imageDescriptor = (short) dis.read(); //Should be 0
        
        /* --- skip over image id info (if present) --- */
        if (idLength > 0) {
            bis.skip(idLength);
        }
        // System.out.println("ImageType: "+imageType);
        //Color Map Starts Here
        //The following is for types 1 & 2
        if(imageType == 1 || imageType == 2) {
            /* --- allocate the image buffer --- */
            pixels = new int[width * height];
            
            /* --- read the pixel data --- */
            for (int i = (height - 1); i >= 0; i--) {
                srcLine = i * width;
                for (int j = 0; j < width; j++) {
                    blue = bis.read() & 0xFF;
                    green = bis.read() & 0xFF;
                    red = bis.read() & 0xFF;
                    if (pixelDepth == 32) {
                        alpha = bis.read() & 0xFF;
                        pixels[srcLine + j] =
                        alpha << 24 | red << 16 | green << 8 | blue;
                        
                    } else {
                        pixels[srcLine + j] = red << 16 | green << 8 | blue;
                    }
                }
            }
        }
        //This is for ImageType 9 or 10
		else if(imageType == 9 || imageType == 10) {
            /* --- allocate the image buffer --- */
            pixels = new int[(width) * (height)];
            int numpix = pixels.length;
            boolean moredata = true;
            int pix;
            int header = 0;
            int result = 0;
            int j, k;
            for(k = numpix; k > 0;k--)
            {
                header = bis.read();
                //System.out.println("Header "+ header + "Pixel num "+numpix);
                result = header & 0x80;
                //System.out.println("Header result"+result);
                if(result == 0x80) {
                    //System.out.println("Header starts with 1.");
                    result = header & 0x7F;
                    blue = bis.read() & 0xFF;
                    green = bis.read() & 0xFF;
                    red = bis.read() & 0xFF;
                    if (pixelDepth == 32) {
                        
                        alpha = bis.read() & 0xFF;
                        pix = alpha << 24 | red << 16 | green << 8 | blue;
                    } else {
                        pix = red << 16 | green << 8 | blue;
                    }
                    for(j = 0; j < result+1; j++) {
                        //System.out.println("Pixel "+numpix+" : "+pix);
                        numpix--;
                        k--;
                        pixels[numpix] = pix;
                    }
                    k++;
                }
                if(result == 0) {
                    //System.out.println("Header starts with 0.");
                    result = header;
                    for(j = 0; j < result+1; j++) {
                        blue = bis.read() & 0xFF;
                        green = bis.read() & 0xFF;
                        red = bis.read() & 0xFF;
                        if (pixelDepth == 32) {
                            alpha = bis.read() & 0xFF;
                            pix = alpha << 24 | red << 16 | green << 8 | blue;
                        } else {
                            pix = red << 16 | green << 8 | blue;
                        }
                        //System.out.println("Pixel "+numpix+" : "+pix);
                        numpix--;
                        k--;
                        pixels[numpix] = pix;
                    }
                    k++;
                }
            }
            flipHoriz();
        }
		else {
			bis.close();
			dis.close();
			throw new IOException("Unhandled Image Type: " + imageType);
		}
        /* --- close the input file --- */
        bis.close();
        dis.close();
    }
    
    public int[] flipHoriz(int pixel[]) {
        int[] newpixels;
        newpixels = new int[pixel.length];
        int i,j,k,srcLine;
        for (i = (height - 2); i >= 0; i--) {
            srcLine = i * width;
                for (j = 0; j < width; j++) {
                        newpixels[srcLine + j] = pixel[srcLine + width - j];
                }            
        }
        return newpixels;
    }
    
    public void flipHoriz() {
        int[] newpixels;
        newpixels = new int[pixels.length];
        int i,j,k,srcLine;
        for (i = 0; i < height-2; i++) {
            srcLine = i * width;
                for (j = 0; j < width; j++) {
                        newpixels[srcLine + j] = pixels[srcLine + width - j];
                }            
        }
        pixels = newpixels;
    }    
    
    /* ------------------------------------------------------- getImage */
    public Image getImage() {
        /* --- set up an image from memory and return it --- */
        return Toolkit.getDefaultToolkit().createImage(
        new MemoryImageSource(width, height, cm, pixels, 0, width));
    }
    
    /* --------------------------------------------------- getThumbnail */
    public Image getThumbnail(int maxSize, boolean smooth) {
        Dimension   thumbnailSize = new Dimension(0, 0);
        int         pixel = 0;
        int         srcX = 0;
        int         srcY = 0;
        double      multiplier = 0.0;
        int         smoothArea;
        
        if (((width == maxSize) && (height == maxSize)) ||
        ((width < maxSize) && (height < maxSize))) {
            smooth = false;
        }
        
        if (width >= height) {
            thumbnailSize.width = maxSize;
            thumbnailSize.height =
            (int) (Math.round(((float) height / (float) width)
            * (float) maxSize));
        } else {
            thumbnailSize.height = maxSize;
            thumbnailSize.width =
            (int) (Math.round(((float) width / (float) height)
            * (float) maxSize));
        }
        
        multiplier = (double) width / (double) thumbnailSize.width;
        
        int[] thumbnailData =
        new int[thumbnailSize.width * thumbnailSize.height];
        
        for (int i = 0; i < thumbnailSize.height; i++) {
            srcY = (int) (i * multiplier);
            for (int j = 0; j < thumbnailSize.width; j++) {
                srcX = (int) (j * multiplier);
                /* Smoothing algorithm (nearest neighbor - t pattern) */
                if (smooth) {
                    int red = 0;
                    int green = 0;
                    int blue = 0;
                    int[] kernel = new int[5];
                    
                    /* Don't smooth as much if image is already square */
                    if (width == height) {
                        smoothArea = 1;
                    } else {
                        smoothArea = 2;
                    }
                    
                    kernel[2] = pixels[(srcY * width) + srcX];
                    
                    if ((srcY - smoothArea) < 0) {
                        kernel[0] = kernel[2];
                    } else {
                        kernel[0] = pixels[((srcY - smoothArea) * width)
                        + srcX];
                    }
                    if ((srcX - smoothArea) < 0) {
                        kernel[1] = kernel[2];
                    } else {
                        kernel[1] = pixels[(srcY * width)
                        + srcX - smoothArea];
                    }
                    
                    if ((srcX + smoothArea) > (width - 1)) {
                        kernel[3] = kernel[2];
                    } else {
                        kernel[3] = pixels[(srcY * width)
                        + srcX + smoothArea];
                    }
                    
                    if ((srcY + smoothArea) > (height - 1)) {
                        kernel[4] = kernel[2];
                    } else {
                        kernel[4] = pixels[((srcY + smoothArea) * width)
                        + srcX];
                    }
                    
                    for (int k = 0; k < kernel.length; k++) {
                        red += ((kernel[k] & 0x00FF0000) >>> 16);
                        green += ((kernel[k] & 0x0000FF00) >>> 8);
                        blue += (kernel[k] & 0x000000FF);
                    }
                    
                    red /= kernel.length;
                    green /= kernel.length;
                    blue /= kernel.length;
                    pixel = 0xFF000000 | red << 16 | green << 8 | blue;
                } else {
                    pixel = pixels[(srcY * width) + srcX];
                }
                thumbnailData[(i * thumbnailSize.width) + j] = pixel;
            }
        }
        DirectColorModel tcm =
        new DirectColorModel(24, 0xFF0000, 0xFF00, 0xFF);
        
        // --- set up an image from memory and return it ---
        return Toolkit.getDefaultToolkit().createImage(
        new MemoryImageSource(
        thumbnailSize.width, thumbnailSize.height, tcm,
        thumbnailData, 0, thumbnailSize.width));
    }
    
    /* -------------------------------------------------------- getSize */
    public Dimension getSize() {
        return new Dimension(width, height);
    }
    
    /* ----------------------------------------------------- flipEndian */
    private short flipEndian(short signedShort) {
        int input = signedShort & 0xFFFF;
        return (short) (input << 8 | (input & 0xFF00) >>> 8);
    }
    public void setWidth(int newwidth) {
        width = newwidth;
    }
    
    public void setHeight(int newheight) {
        height = newheight;
    }
}
