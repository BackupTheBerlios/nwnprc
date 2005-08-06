package prc.utils;

public class Radials{
	public static void main(String[] args){
		if(args.length == 0)
			readMe();
		
		int feat             = Integer.parseInt(args[0]),
		    radialrangestart = Integer.parseInt(args[1]);

		System.out.println("Five consecutive radialfeat FeatIDs for feat " + feat + " starting from " + radialrangestart + ":");
		
		for(int i = 0; i < 5; i++){
			System.out.println((radialrangestart + i) + " & " + feat + ": " + ((radialrangestart + i) * 0x10000 + feat));
		}
	}
	
	private static void readMe(){
		System.out.println("Usage: java Radials featid subradnum");
		System.exit(0);
	}
}