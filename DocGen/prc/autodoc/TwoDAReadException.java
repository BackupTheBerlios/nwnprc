package prc.autodoc;

/**
 * An exception indicating TLK read failed.
 */
public class TwoDAReadException extends java.lang.RuntimeException{
	private static final long serialVersionUID = 0x1L;
	
	public TwoDAReadException(String message)                 { super(message); }
	public TwoDAReadException(String message, Throwable cause){ super(message, cause); }
}