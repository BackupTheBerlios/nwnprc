// Module Constants
const float CACHE_TIMEOUT_CAST = 2.0;
const string CASTER_LEVEL_TAG = "PRCEffectiveCasterLevel";

// Constants that dictate ResistSpell results
const int SPELL_RESIST_FAIL = 0;
const int SPELL_RESIST_PASS = 1;
const int SPELL_RESIST_GLOBE = 2;
const int SPELL_RESIST_MANTLE = 3;

//
//	This function is a wrapper should someone wish to rewrite the Bioware
//	version. This is where it should be done.
//
int
PRCResistSpell(object oCaster, object oTarget)
{
	return ResistSpell(oCaster, oTarget);
}

//
//	This function is a wrapper should someone wish to rewrite the Bioware
//	version. This is where it should be done.
//
int
PRCGetSpellResistance(object oTarget)
{
	return GetSpellResistance(oTarget);
}

//
//	If a spell is resisted, display the effect
//
void
PRCShowSpellResist(object oTarget, int nResist, float fDelay = 0.0)
{
	if (nResist != SPELL_RESIST_FAIL) {
		// Default to a standard resistance
		int eve = VFX_IMP_MAGIC_RESISTANCE_USE;

		// Check for other resistances
		if (nResist == SPELL_RESIST_GLOBE)
			eve = VFX_IMP_GLOBE_USE;
		else if (nResist == SPELL_RESIST_MANTLE)
			eve = VFX_IMP_SPELL_MANTLE_USE;

		// Render the effect
		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,
			EffectVisualEffect(eve), oTarget));
	}
}

//
//	This function overrides the BioWare MyResistSpell.
//	TODO: Change name to PRCMyResistSpell.
//
int
MyPRCResistSpell(object oCaster, object oTarget, int nEffCasterLvl=0, float fDelay = 0.0)
{
	int nResist;

	// Check immunities and mantles, otherwise ignore the result completely
	nResist = PRCResistSpell(oCaster, oTarget);
	if (nResist <= SPELL_RESIST_PASS) {
		nResist = SPELL_RESIST_FAIL;

		// Because the version of this function was recently changed to
		// optionally allow the caster level, we must calculate it here.
		// The result will be cached for a period of time.
		if (!nEffCasterLvl) {
			nEffCasterLvl = GetLocalInt(oCaster, CASTER_LEVEL_TAG);
			if (!nEffCasterLvl) {
				nEffCasterLvl = GetCasterLevel(oCaster)
					+ GetChangesToCasterLevel(oCaster)
					+ SPGetPenetr();
				SetLocalInt(oCaster, CASTER_LEVEL_TAG, nEffCasterLvl);
				DelayCommand(CACHE_TIMEOUT_CAST,
					DeleteLocalInt(oCaster, CASTER_LEVEL_TAG));
			}
		}

		// A tie favors the caster.
		if ((nEffCasterLvl + d20(1)) < PRCGetSpellResistance(oTarget))
			nResist = SPELL_RESIST_PASS;
	}

	PRCShowSpellResist(oTarget, nResist, fDelay);

    return nResist;
}
