/*
 * ArrayUtil.java
 *
 * Created on February 23, 2003, 6:06 PM
 */

package CharacterCreator.io;


public final class ArrayUtil {
    
    public ArrayUtil() {
    }
    
    public static final byte[] getSubArray(byte buffer[], int offset, int length) {
        byte r[] = new byte[length];
        System.arraycopy(buffer, offset, r, 0, length);
        return r;
    }
    
    public static final byte[] mergeArrays(byte a1[], byte a2[]) {
        byte r[] = new byte[a1.length + a2.length];
        System.arraycopy(a1, 0, r, 0, a1.length);
        System.arraycopy(a2, 0, r, a1.length, a2.length);
        return r;
    }
    
    public static final byte[] resizeArray(byte src[], int new_size) {
        byte tmp[] = new byte[new_size];
        System.arraycopy(src, 0, tmp, 0, src.length >= new_size ? new_size : src.length);
        return tmp;
    }
    /**
     * Reallocates an array with a new size, and copies the contents
     * of the old array to the new array.
     * @param oldArray  the old array, to be reallocated.
     * @param newSize   the new array size.
     * @return          A new array with the same contents.
     */
    public static Object resizeMainArray(Object oldArray, int newSize) {
        int oldSize = java.lang.reflect.Array.getLength(oldArray);
        Class elementType = oldArray.getClass().getComponentType();
        Object newArray = java.lang.reflect.Array.newInstance(
        elementType,newSize);
        int preserveLength = Math.min(oldSize,newSize);
        if (preserveLength > 0)
            System.arraycopy(oldArray,0,newArray,0,preserveLength);
        return newArray; }
}
