/* 
   ----------------
   prc_inc_psionics
   ----------------
   
   20/10/04 by Stratovarius
   
   Calculates Power Resistance for Psionics and performs the checks.
*/

#include "prc_feat_const"
#include "prc_class_const"

// Constants that dictate ResistPower results
const int POWER_RESIST_FAIL = 0;
const int POWER_RESIST_PASS = 1;
const int POWER_RESIST_GLOBE = 2;
const int POWER_RESIST_MANTLE = 3;

//
//	This function is a wrapper should someone wish to rewrite the Bioware
//	version. This is where it should be done.
//
int
PRCResistPower(object oCaster, object oTarget)
{
	return ResistSpell(oCaster, oTarget);
}

//
//	This function is a wrapper should someone wish to rewrite the Bioware
//	version. This is where it should be done.
//
int 
PRCGetPowerResistance(object oTarget, object oCaster)
{
        int iPowerRes = GetSpellResistance(oTarget);

        //racial pack SR
        int iRacialPowerRes = 0;
        if(GetHasFeat(FEAT_SPELL27, oTarget))
            iRacialPowerRes += 27+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL25, oTarget))
            iRacialPowerRes += 25+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL18, oTarget))
            iRacialPowerRes += 18+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL15, oTarget))
            iRacialPowerRes += 15+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL14, oTarget))
            iRacialPowerRes += 14+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL13, oTarget))
            iRacialPowerRes += 13+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL11, oTarget))
            iRacialPowerRes += 11+GetHitDice(oTarget);
        else if(GetHasFeat(FEAT_SPELL5, oTarget))
            iRacialPowerRes += 5+GetHitDice(oTarget);
        if(iRacialPowerRes > iPowerRes)
            iPowerRes = iRacialPowerRes;
        
        // Foe Hunter SR stacks with normal SR 
        // when a Power is cast by their hated enemy
        // When Inlcude fixes are done, change GetRacialType to MyPRCGetRacialType
        if(GetHasFeat(FEAT_HATED_ENEMY_SR, oTarget) && GetLocalInt(oTarget, "HatedFoe") == GetRacialType(oCaster) )
        {
             iPowerRes += 15 + GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oTarget);
        }
	
	return iPowerRes;
}

//
//	If a Power is resisted, display the effect
//
void
PRCShowPowerResist(object oCaster, object oTarget, int nResist, float fDelay = 0.0)
{
	// If either caster/target is a PC send them a message
	if (GetIsPC(oCaster))
	{
		string message = nResist == POWER_RESIST_FAIL ?
			"Target is AFFECTED by the Power" : "Target RESISTED the Power";
		//SendMessageToPC(oCaster, message);
	}
	if (GetIsPC(oTarget))
	{
		string message = nResist == POWER_RESIST_FAIL ?
			"You are AFFECTED by the Power" : "You RESISTED the Power";
		//SendMessageToPC(oTarget, message);
	}
	
	if (nResist != POWER_RESIST_FAIL) {
		// Default to a standard resistance
		int eve = VFX_IMP_MAGIC_RESISTANCE_USE;

		// Check for other resistances
		if (nResist == POWER_RESIST_GLOBE)
			eve = VFX_IMP_GLOBE_USE;
		else if (nResist == POWER_RESIST_MANTLE)
			eve = VFX_IMP_SPELL_MANTLE_USE;

		// Render the effect
		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,
			EffectVisualEffect(eve), oTarget));
	}
}

//
//	This function overrides the BioWare MyResistSpell.
//	TODO: Change name to PRCMyResistPower.
//
int
PRCMyResistPower(object oCaster, object oTarget, int nEffCasterLvl=0, float fDelay = 0.0)
{
	int nResist;

	// Check immunities and mantles, otherwise ignore the result completely
	nResist = PRCResistPower(oCaster, oTarget);
	if (nResist <= POWER_RESIST_PASS) {
		nResist = POWER_RESIST_FAIL;

		// A tie favors the caster.
		if ((nEffCasterLvl + d20(1)) < PRCGetPowerResistance(oTarget, oCaster))
			nResist = POWER_RESIST_PASS;
	}
    

	PRCShowPowerResist(oCaster, oTarget, nResist, fDelay);

    return nResist;
}
