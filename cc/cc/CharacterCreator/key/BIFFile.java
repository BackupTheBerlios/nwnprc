/*
 * BIFFile.java
 *
 * Created on February 23, 2003, 6:15 PM
 */

package CharacterCreator.key;

import CharacterCreator.io.Byteconvert;

public class BIFFile
{

    public BIFFile(int index, byte buffer[], int offset)
    {
        this.index = index;
        filelength = Byteconvert.convertInt(buffer, offset);
        stringoffset = Byteconvert.convertInt(buffer, offset + 4);
        stringlength = Byteconvert.convertShort(buffer, offset + 8);
        filename = new String(buffer, stringoffset, stringlength - 1);
        if(filename.startsWith("\\"))
            filename = filename.substring(1);
    }

    public int getindex()
    {
        return index;
    }

    public String getBIFname()
    {
        return filename;
    }

    public int getBIFlength()
    {
        return filelength;
    }

    private int index;
    private int filelength;
    private int stringoffset;
    private short stringlength;
    private String filename;
}
