package wmg;

public class RGB {
	public int r = 0;
	public int g = 0;
	public int b = 0;

	// CONSTRUCTOR

	public RGB(int red, int green, int blue){
		r = red;
		g = green;
		b = blue;
		checkValues();
	}

	// PUBLIC

	public void scale(double scalefactor){

		r = (int)((double)r*scalefactor);
		g = (int)((double)g*scalefactor);
		b = (int)((double)b*scalefactor);

		checkValues();
	}

	//this replaces any existing colour information!
	public void scale(double scalefactor, RGB min, RGB max){

		double gap = (double)(max.r-min.r);
		double rd =(scalefactor*gap)+(double)min.r;
		gap = (double)(max.g-min.g);
		double gd =(scalefactor*gap)+(double)min.g;
		gap = (double)(max.b-min.b);
		double bd =(scalefactor*gap)+(double)min.b;

		r = (int)rd;
		g = (int)gd;
		b = (int)bd;
		checkValues();
	}

	public int rgbToComposite(){
		checkValues();
		return (0 << 24) | (r << 16) | (g << 8) | b;
	}

	public String toString(){
		return r+", "+g+", "+b;
	}

	// Private

	private void checkValues(){
		if(r>255)
			r=255;
		if(g>255)
			g=255;
		if(b>255)
			b=255;
		if(r<0)
			r=0;
		if(g<0)
			g=0;
		if(b<0)
			b=0;
	}
}