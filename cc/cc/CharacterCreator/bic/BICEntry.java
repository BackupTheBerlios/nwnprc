/*
 * BICEntry.java
 *
 * Created on March 11, 2003, 1:10 PM
 */

package CharacterCreator.bic;

/**
 *
 * @author  James
 */
public class BICEntry {
    
    /** Creates a new instance of BICEntry */
    public BICEntry(int ent, int off, int num) {
        entitycode = ent;
        offset = off;
        numelements = num;
    }
    
    public int getcode() {
        return entitycode;
    }
    
    public int getoffset() {
        return offset;
    }
    
    public int getnum() {
        return numelements;
    }
    
    private int entitycode;
    private int offset;
    private int numelements;
}
