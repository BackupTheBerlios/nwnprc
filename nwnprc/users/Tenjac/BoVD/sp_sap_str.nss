//::///////////////////////////////////////////////
//:: Name      Sap Strength
//:: FileName  sp_sap_str.nss
//:://////////////////////////////////////////////
/**@file Sap Strength
Enchantment [Evil] 
Level: Clr 2, Sor/Wiz 2 
Components: V, S, M 
Casting Time: 1 action 
Range: Touch
Target: One living creature 
Duration: Instantaneous
Saving Throw: Fortitude negates 
Spell Resistance: Yes

The caster drains the personal well­being from the 
subject, who becomes exhausted. After 1 hour of 
complete rest, characters become fatigued rather 
than exhausted. A fatigued character becomes 
exhausted again if she does something else that 
would normally cause fatigue. After 8 hours of 
complete rest, fatigued characters are no longer
fatigued.

Material Component: A long needle and a tiny glass
bottle.

Author:    Tenjac
Created:   6/4/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void SapLoop(object oTarget);

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLevel = PRCGetCasterLevel(oPC);
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	
	SPRaiseSpellCastAt(oTarget,TRUE, SPELL_SAP_STRENGTH, oPC);
	
	// Gotta be a living critter
	int nType = MyPRCGetRacialType(oTarget);
	
	if ((nType != RACIAL_TYPE_CONSTRUCT) &&
	(nType == RACIAL_TYPE_UNDEAD) &&
	(nType == RACIAL_TYPE_ELEMENTAL))
	
	{
		//SR
		if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Save
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				//Exhausted - moves at 1/2 speed, -6 to STR/DEX
				effect eLink = EffectMovementSpeedDecrease(50);
				       eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_STRENGTH, 6));
				       eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, 6));
				       
				SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
				
				SapLoop(oTarget);				
			}
		}
	}
	
	SPEvilShift(oPC);
}
					
	
void SapLoop(object oTarget)
{
	if(GetLocalInt(oTarget, "PRC_HasRested1Hour"))
	{
		
	
	
	
