/*
 * Filereader.java
 *
 * Created on February 23, 2003, 6:06 PM
 */

package CharacterCreator.io;

import java.io.*;
import javax.swing.JOptionPane;

// Referenced classes of package CharacterCreator.io:
//            Byteconvert, Charconvert

public final class Filereader
{

    public Filereader()
    {
    }

    public static byte[] readBytes(InputStream is, int length)
        throws IOException
    {
        byte buffer[] = new byte[length];
        int newread;
        for(int bytesread = 0; bytesread < length; bytesread += newread)
        {
            newread = is.read(buffer, bytesread, length - bytesread);
            if(newread == -1)
            {
                JOptionPane.showMessageDialog(null, "Unable to read " + length + " bytes", "Error", 0);
                throw new IOException();
            }
        }

        return buffer;
    }

    public static byte[] readFully(InputStream is)
        throws IOException
    {
        byte[] buffer = new byte[0xFFFFFFFF];
        int newread;
        boolean EOF = false;
        int i = 0;
        byte tmpbyte;
        byte[] btary;
        while(!EOF) {
            tmpbyte = (byte)is.read();
            if(tmpbyte == -1) {
                EOF = true;
            } else {
                btary = Byteconvert.convertBack(tmpbyte);
                buffer[i] = btary[0];
                i++;
            }
        }

          //  newread = is.read(buffer, bytesread, length - bytesread);
          //  if(newread == -1)
          //  {
          //      JOptionPane.showMessageDialog(null, "Unable to read " + length + " bytes", "Error", 0);
          //      throw new IOException();
          //  }


        return buffer;
    }    
    
    public static String readString(InputStream is, int length)
        throws IOException
    {
        byte buffer[] = readBytes(is, length);
        return Byteconvert.convertString(buffer, 0, length);
    }

    public static byte readByte(InputStream is)
        throws IOException
    {
        return Byteconvert.convertByte(readBytes(is, 1), 0);
    }

    public static short readShort(InputStream is)
        throws IOException
    {
        return Byteconvert.convertShort(readBytes(is, 2), 0);
    }

    public static int readInt(InputStream is)
        throws IOException
    {
        return Byteconvert.convertInt(readBytes(is, 4), 0);
    }

    public static long readLong(InputStream is)
        throws IOException
    {
        return Byteconvert.convertLong(readBytes(is, 8), 0);
    }

    public static int readUnsignedByte(InputStream is)
        throws IOException
    {
        int value = Byteconvert.convertByte(readBytes(is, 1), 0);
        if(value < 0)
            value += 256;
        return value;
    }

    public static int readUnsignedShort(InputStream is)
        throws IOException
    {
        int value = Byteconvert.convertShort(readBytes(is, 2), 0);
        if(value < 0)
            value += 0x10000;
        return value;
    }

    public static long readUnsignedInt(InputStream is)
        throws IOException
    {
        long value = Byteconvert.convertInt(readBytes(is, 4), 0);
        if(value < 0L)
            value += 0x100000000L;
        return value;
    }

    public static String readString(RandomAccessFile ranfile, int length)
        throws IOException
    {
        byte buffer[] = new byte[length];
        ranfile.readFully(buffer);
        return Charconvert.convert(buffer);
    }

    public static int readInt(RandomAccessFile ranfile)
        throws IOException
    {
        ranfile.readFully(buffer4);
        return Byteconvert.convertInt(buffer4, 0);
    }

    public static long readUnsignedInt(RandomAccessFile ranfile)
        throws IOException
    {
        ranfile.readFully(buffer4);
        long value = Byteconvert.convertInt(buffer4, 0);
        if(value < 0L)
            value += 0x100000000L;
        return value;
    }

    public static short readShort(RandomAccessFile ranfile)
        throws IOException
    {
        ranfile.readFully(buffer2);
        return Byteconvert.convertShort(buffer2, 0);
    }

    private static byte buffer4[] = new byte[4];
    private static byte buffer2[] = new byte[2];

}
