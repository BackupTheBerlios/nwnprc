//::///////////////////////////////////////////////
//:: Name      Animalistic Power
//:: FileName  sp_animal_pwr.nss
//:://////////////////////////////////////////////
/**@file Animalistic Power
Transmutation
Level: Cleric 2, druid 2, duskblade 2, ranger 2,
       sorcerer/wizard 2
Components: V,S,M
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 minute/level
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You imbue the subject with an aspect of the natural
world. The subject gains a +2 enhancement bonus
to Strength, Dexterity, and Constitution.

Material Component: A bit of animal fur, feathers,
                    or skin.
**/

////////////////////////////////////////////////////
// Author:  Tenjac
// Date:    14.9.2006
////////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = (60.0f * nCasterLvl);
	
	//Build effect
	effect eBuff = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 2), EffectAbilityIncrease(ABILITY_DEXTERITY, 2));
	       eBuff = EffectLinkEffects(eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION, 2));
	       eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_SANCTUARY));
	       
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur);
	
	SPSetSchool();
}
	
	
	
	