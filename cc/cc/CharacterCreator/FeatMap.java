package CharacterCreator;

import java.io.IOException;
import java.util.ArrayList;

public class FeatMap {

	public static void InitializeStatics(TLKFactory tlkFactory, ResourceFactory resFactory) {
		Feat.InitializeStatics(tlkFactory, resFactory);

		try {
			// Parse the 2da
			String[][] feats = resFactory.getResourceAs2DA("feat", false);

			// We might as well keep a side list of feats
			// that are available to all classes
			ArrayList alNonClassFeats = new ArrayList();

			// Create the parse structure
			featmap = new Feat[feats.length];
			for (int ii=0; ii<feats.length; ++ii) {
				Feat feat = Feat.ParseFeat(ii, feats[ii]);
				featmap[ii] = feat;

				if (feat != null && feat.AllClassesCanUse)
					alNonClassFeats.add(feat);
			}

			nonClassFeats = (Feat[])alNonClassFeats.toArray(new Feat[1]);
		}
		catch (IOException ioe) {
			featmap = null;
		}
	}

	public static Feat[] GetFeatMap() {
		return featmap;
	}

	public static Feat[] GetNonClassFeats() {
		return nonClassFeats;
	}

	private static Feat[] featmap = null;
	private static Feat[] nonClassFeats = null;
}
