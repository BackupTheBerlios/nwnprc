//::///////////////////////////////////////////////
//:: Name      Twilight Luck
//:: FileName  sp_twlght_lck.nss
//:://////////////////////////////////////////////
/**@file Twilight Luck 
Abjuration [Good] 
Level: Sanctified 1 
Components: V
Casting Time: 1 standard action 
Range: Touch
Target: One non-evil creature touched 
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: Yes (harmless)

By means of this spell, the caster can impart the 
luck of the fey to one non-evil being. The target 
gains a +1 luck bonus on all saving throws for the 
duration of the spell.

Author:    Tenjac
Created:   8/29/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nAlign = GetAlignmentGoodEvil(oTarget);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLvl);
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	if(nAlign != ALIGNMENT_EVIL)
	{
		effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL);
		
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur);
	}
	
	//Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
	AdjustAlignment(oPC, ALIGNMENT_GOOD, 10);
	
	SPGoodShift(oPC);
	
	SPSetSchool();
}
	