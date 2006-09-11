//::///////////////////////////////////////////////
//:: Name      Augment Familiar
//:: FileName  sp_aug_famil.nss
//:://////////////////////////////////////////////
/**@file Augment Familiar
Transmutation
Level: Sor/Wiz 2, Hexblade 1
Components: V,S
Casting Time: 1 action
Range: Personal
Target: Your familiar
Duration: 1 round/level
Saving Throw: Fortitude negates (harmless)
Spell Resistance: Yes (harmless)

This spell grants your familiar a +4 enhancement bonus
to Strength, Dexterity and Constitution, damage 
reduction 5/magic, and a +2 resistance bonus on 
saving throws.

**/

/////////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date:   8.9.2006
/////////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	if(!GetIsObjectValid(oFamiliar))
	{
		FloatingTextStringOnCreature("Your familiar is not present.", oPC, FALSE);
		SPSetSchool();
		return;
	}
		
	effect eBuff = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 4), EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
	       eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
	       eBuff = EffectLinkEffects(eBuff, EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE, 0));
	       eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));
	       
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oFamiliar, fDur);
	
	SPSetSchool();
}