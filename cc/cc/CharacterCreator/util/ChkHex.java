/*
 * ChkHex.java
 *
 * Created on December 9, 2003, 1:00 AM
 */

package CharacterCreator.util;

/**
 *
 * @author  James
 */
public class ChkHex {
    
    /** Creates a new instance of ChkHex */
    public ChkHex() {
    }
    
    public static int ChkHex(String input) {
        return ChkHex(input, 0);
    }

    public static int ChkHex(String input, int def) {
        int descnum;

		if (input == null)
			descnum = def;
		else if(input.startsWith("0x"))
			descnum = Integer.parseInt(input.substring(2), 16);
		else
			descnum = Integer.parseInt(input);

        return descnum;
    }
}
