package CharacterCreator;

import java.io.IOException;

public class SpellMap {

	public static void InitializeStatics(TLKFactory tlkFactory, ResourceFactory resFactory) {
		Spell.InitializeStatics(tlkFactory, resFactory);

		try {
			// Parse the 2da
			String[][] spells = resFactory.getResourceAs2DA("spells", false);

			// Create the parse structure
			spellmap = new Spell[spells.length];
			for (int ii=0; ii<spells.length; ++ii)
				spellmap[ii] = Spell.ParseSpell(ii, spells[ii]);
		}
		catch (IOException ioe) {
			spellmap = null;
		}
	}

	public static Spell[] GetSpellMap() {
		return spellmap;
	}

	private static Spell[] spellmap = null;
}
