package prc.autodoc;

/**
 * An absolutely critical part of the Document Creator, not. Prints a spinning line
 * for the user to look at while the program is working.
 */
public final class Spinner{
	private char[] states = new char[]{'|','/','-','\\'};
	private int curState = 0;
	
	public Spinner(){}
	
	public void spin(){
		System.out.print(states[curState = ++curState % states.length] + "\u0008");
	}
}