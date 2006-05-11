//::///////////////////////////////////////////////
//:: Name      Unnerving Gaze
//:: FileName  sp_unnerv_gaze.nss
//:://////////////////////////////////////////////
/**@file Unnerving Gaze 
Illusion (Phantasm) 
Level: Demonologist 1, Mortal Hunter 1, Sor/Wiz 0 
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One humanoid creature 
Duration: 1 round/level
Saving Throw: Will negates 
Spell Resistance: Yes

The caster makes his face resemble one of the 
opponent's departed loved ones or bitter enemies.
The subject takes a -1 morale penalty on attack 
rolls for the duration of the spell. 

Author:    Tenjac
Created:   5/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// Set the spellschool
	SPSetSchool(SPELL_SCHOOL_ILLUSION); 
		
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}	
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_UNNERVING_GAZE, oPC);
	
	effect ePenalty = EffectAttackDecrease(1, ATTACK_BONUS_MISC);
	
	//Spell Resistance
	if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//Saving Throw
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenalty, oTarget, fDur);
		}
	}
	
	SPSetSchool();
}
	