#include "prc_feat_const"
#include "prc_class_const"

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
PRCGetSpellResistance(object oTarget, object oCaster)
{
        int iSpellRes = GetSpellResistance(oTarget);
        
        // Foe Hunter SR stacks with normal SR 
        // when a spell is cast by their hated enemy
        // When Inlcude fixes are done, change GetRacialType to MyPRCGetRacialType
        if(GetHasFeat(FEAT_HATED_ENEMY_SR, oTarget) && GetLocalInt(oTarget, "HatedFoe") == GetRacialType(oCaster) )
        {
             iSpellRes += 15 + GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oTarget);
        }
	
	return iSpellRes;
}

//
//	If a spell is resisted, display the effect
//
void
PRCShowSpellResist(object oCaster, object oTarget, int nResist, float fDelay = 0.0)
{
	// If either caster/target is a PC send them a message
	if (GetIsPC(oCaster))
	{
		string message = nResist == SPELL_RESIST_FAIL ?
			"Target is AFFECTED by the spell" : "Target RESISTED the spell";
		SendMessageToPC(oCaster, "Target RESISTED spell");
	}
	if (GetIsPC(oTarget))
	{
		string message = nResist == SPELL_RESIST_FAIL ?
			"You are AFFECTED by the spell" : "You RESISTED the spell";
		SendMessageToPC(oTarget, message);
	}
	
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

	// Check if the archmage shape mastery applies to this target
	if (CheckMasteryOfShapes(oCaster, oTarget))
		nResist = SPELL_RESIST_MANTLE;
	else {
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
					nEffCasterLvl = PRCGetCasterLevel(oCaster) + SPGetPenetr();
					SetLocalInt(oCaster, CASTER_LEVEL_TAG, nEffCasterLvl);
					DelayCommand(CACHE_TIMEOUT_CAST,
						DeleteLocalInt(oCaster, CASTER_LEVEL_TAG));
				}
			}
			
			// Pernicious Magic
                        // +4 caster level vs SR Weave user (not Evoc & Trans spells)
                        int iWeav;
                        if (GetHasFeat(FEAT_PERNICIOUSMAGIC,oCaster))
                        {
                                if (!GetHasFeat(FEAT_SHADOWWEAVE,oTarget))
                                {
                                        int nSchool = GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
                                        if ( nSchool != SPELL_SCHOOL_EVOCATION && nSchool != SPELL_SCHOOL_TRANSMUTATION )
                                        iWeav=4;
                                }

                        }


			// A tie favors the caster.
			if ((nEffCasterLvl + d20(1)+iWeav) < PRCGetSpellResistance(oTarget, oCaster))
				nResist = SPELL_RESIST_PASS;
		}
    }

	PRCShowSpellResist(oCaster, oTarget, nResist, fDelay);

    return nResist;
}
