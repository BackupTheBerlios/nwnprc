/*
 * ByteConvert.java
 *
 * Created on February 23, 2003, 6:06 PM
 */

package CharacterCreator.io;


// Referenced classes of package CharacterCreator.io:
//            ArrayUtil, Charconvert

public final class Byteconvert
{

    public Byteconvert()
    {
    }

    public static String convertString(byte buffer[], int offset, int length)
    {
        int max = length;
        for(int i = 0; i < length; i++)
        {
            if(buffer[offset + i] != 0)
                continue;
            max = i;
            break;
        }

        buffer = ArrayUtil.getSubArray(buffer, offset, max);
        return Charconvert.convert(buffer);
    }

    public static long convertLong(byte buffer[], int offset)
    {
        long value = 0L;
        for(int i = 7; i >= 0; i--)
            value = value << 8 | (long)(buffer[offset + i] & 0xff);

        return value;
    }

    public static int convertInt(byte buffer[], int offset)
    {
        int value = 0;
        for(int i = 3; i >= 0; i--)
            value = value << 8 | buffer[offset + i] & 0xff;

        return value;
    }

    public static short convertShort(byte buffer[], int offset)
    {
        int value = 0;
        for(int i = 1; i >= 0; i--)
            value = value << 8 | buffer[offset + i] & 0xff;

        return (short)value;
    }

    public static byte convertByte(byte buffer[], int offset)
    {
        int value = 0;
        for(int i = 0; i >= 0; i--)
            value = value << 8 | buffer[offset + i] & 0xff;

        return (byte)value;
    }

    public static long convertUnsignedInt(byte buffer[], int offset)
    {
        long value = convertInt(buffer, offset);
        if(value < 0L)
            value += 0x100000000L;
        return value;
    }

    public static int convertUnsignedShort(byte buffer[], int offset)
    {
        int value = convertShort(buffer, offset);
        if(value < 0)
            value += 0x10000;
        return value;
    }

    public static short convertUnsignedByte(byte buffer[], int offset)
    {
        short value = convertByte(buffer, offset);
        if(value < 0)
            value += 256;
        return value;
    }

    public static byte[] convertBack(long value)
    {
        byte buffer[] = new byte[8];
        for(int i = 0; i <= 7; i++)
            buffer[i] = (byte)(int)(value >> 8 * i & 255L);

        return buffer;
    }

    public static byte[] convertBack(int value)
    {
        byte buffer[] = new byte[4];
        for(int i = 0; i <= 3; i++)
            buffer[i] = (byte)(value >> 8 * i & 0xff);

        return buffer;
    }

    public static byte[] convertBack(short value)
    {
        byte buffer[] = new byte[2];
        for(int i = 0; i <= 1; i++)
            buffer[i] = (byte)(value >> 8 * i & 0xff);

        return buffer;
    }

    public static byte[] convertBack(byte value)
    {
        byte buffer[] = {
            value
        };
        return buffer;
    }
}
