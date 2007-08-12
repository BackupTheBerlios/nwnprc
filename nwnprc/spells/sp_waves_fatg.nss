//::///////////////////////////////////////////////
//:: Name      Waves of Fatigue
//:: FileName  sp_waves_fatg.nss
//:://////////////////////////////////////////////
/**@file Waves of Fatigue
Necromancy
Level: 	Sor/Wiz 5
Components: 	V, S
Casting Time: 	1 standard action
Range: 	30 ft.
Area: 	Cone-shaped burst
Duration: 	Instantaneous
Saving Throw: 	No
Spell Resistance: 	Yes

Waves of negative energy render all living creatures
in the spell’s area fatigued. This spell has no effect 
on a creature that is already fatigued. 

**/
//::////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date  : 29.9.06
//::////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetSpellTargetLocation();
	object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 9.14f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	int nCasterLevel = PRCGetCasterLevel(oPC);
	int nPenetr = nCasterLevel + SPGetPenetr();
	
	while(GetIsObjectValid(oTarget))
	{
		if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nPenetr))
		{
			effect eSpeed = EffectMovementSpeedDecrease(25);
			effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, 2), EffectAbilityDecrease(ABILITY_DEXTERITY, 2));
			       eLink = EffectLinkEffects(eLink, eSpeed);
			
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(8));
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
		}
		oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 9.14f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	SPSetSchool();
}
	
	
			


