package CharacterCreator;

import java.io.IOException;
import java.util.ArrayList;

public class SkillMap {

	public static void InitializeStatics(TLKFactory tlkFactory, ResourceFactory resFactory) {
		Skill.InitializeStatics(tlkFactory, resFactory);

		try {
			// Parse the 2da
			String[][] skills = resFactory.getResourceAs2DA("skills", false);

			// Create the parse structure
			skillmap = new Skill[skills.length];
			for (int ii=0; ii<skills.length; ++ii)
				skillmap[ii] = Skill.ParseSkill(ii, skills[ii]);
		}
		catch (IOException ioe) {
			skillmap = null;
			System.out.println("Failed to Load Skillmap.2da");
			ioe.printStackTrace();
		}
	}

	public static Skill[] GetSkillMap() {
		return skillmap;
	}

	private static Skill[] skillmap = null;
}
