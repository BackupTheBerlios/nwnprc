/*
 * BICElement.java
 *
 * Created on March 11, 2003, 1:10 PM
 */

package CharacterCreator.bic;

/**
 *
 * @author  James
 */
public class BICElement {
    
    /** Creates a new instance of BICElement */
    public BICElement(int types, int index, Object stuff) {
        vartype = types;
        varindex = index;
        data = stuff;
    }
    
    public int gettype() {
        return vartype;
    }
    
    public int getindex() {
        return varindex;
    }
    
    public Object getdata() {
        return data;
    }
    
    private int vartype;
    private int varindex;
    private Object data;
    
}
