package prc.autodoc;

/**
 * An exception indicating failure while generating a page.
 */
public class PageGenerationException extends java.lang.RuntimeException{
	private static final long serialVersionUID = 0x2L;
	
	public PageGenerationException(String message)                 { super(message); }
	public PageGenerationException(String message, Throwable cause){ super(message, cause); }
}