package prc.autodoc;

/**
 * An exception indicating TLK read failed.
 */
public class TLKReadException extends java.lang.RuntimeException{
	private static final long serialVersionUID = 0x0L;
	
	public TLKReadException(String message)                 { super(message); }
	public TLKReadException(String message, Throwable cause){ super(message, cause); }
}