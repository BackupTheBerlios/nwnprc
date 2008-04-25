//::///////////////////////////////////////////////
//:: Name      Celestial blood
//:: FileName  sp_celest_bld.nss
//:://////////////////////////////////////////////
/**@file Celestial Blood 
Abjuration [Good] 
Level: Apostle of peace 6, Clr 6, Pleasure 6
Components: V, S, M 
Casting Time: 1 round 
Range: Touch
Target: Non-evil creature touched 
Duration: 1 minute/level 
Saving Throw: None
Spell Resistance: Yes (harmless)

You channel holy power to grant the subject some of 
the protection enjoyed by celestial creatures. The 
subject gains resistance 10 to acid, cold, and 
electricity, a +4 bonus on saving throws against 
poison, and damage reduction 10/evil.

Material Component: A vial of holy water, with 
which you anoint the subject's head.

Author:    Tenjac
Created:   6/16/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLevel = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLevel);
	
	if(GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL)
	{
		
		effect eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_ACID, 10, 0), EffectDamageResistance(DAMAGE_TYPE_COLD, 10, 0));
		eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 10, 0));
		eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_POISON));
		
		//Can't do DR 10/evil
		eLink = EffectLinkEffects(eLink, EffectDamageReduction(10, DAMAGE_POWER_PLUS_TWO));
		
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur);
	}
	SPGoodShift(oPC);
	PRCSetSchool();
}