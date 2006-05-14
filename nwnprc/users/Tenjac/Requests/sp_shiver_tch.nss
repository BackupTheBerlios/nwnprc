//::///////////////////////////////////////////////
//:: Name      Shivering Touch
//:: FileName  sp_shiver_tch.nss
//:://////////////////////////////////////////////
/**@file Shivering Touch
Necromancy [cold]
Level: Cleric 3, Sorceror/Wizard 3
Components: V, S
Casting Time: 1 Standard Action
Range: Touch
Target: Creature Touched
Duration: 1 round/level
Saving Throw: None
Spell Resistance: Yes

On a succesful melee attack, you instantly suck the 
heat from the target's body, rendering it numb. The 
target takes 3d6 points of Dexterity damage.
Creatures with the cold subtype are immune to the 
effects of Shivering Touch.

Author:    Tenjac
Created:   5/14/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "spinc_common"

void main()
{
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDuration = RoundsToSeconds(nCasterLvl);
	int nDam = d6(3);
	int nTouch = PRCDoMeleeTouchAttack(oTarget);
		
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_SHIVERING_TOUCH, oPC);
	
	if(nTouch > 0)
	{
		//Check Spell Resistance
		if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			effect eDrain = EffectAbilityDecrease(ABILITY_DEXTERITY, nDam);
			effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
			
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, fDur);
		}
	}
	SPSetSchool();
}
