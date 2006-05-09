//::///////////////////////////////////////////////
//:: Name      Wave of Grief
//:: FileName  sp_wave_grief.nss
//:://////////////////////////////////////////////
/**@file Wave of Grief
Enchantment [Evil, Mind-Affecting] 
Level: Brd 2, Clr 2
Components: S, M 
Casting Time: 1 action 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: Cone
Duration: 1 round/level 
Saving Throw: Will negates 
Spell Resistance: Yes
 
All within the cone when the spell is cast are 
overcome with sorrow and grief. They take a -3 morale
penalty on all attack rolls, saving throws, ability 
checks, and skill checks. 

Material Component: Three tears. 

Author:    Tenjac
Created:   5/9/2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 7.62.0f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	location lLoc = GetSpellTargetLocation();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	effect eVis = EffectVisualEffect(VFX_DUR_GLOW_BLUE);
	effect eLink = EffectAttackDecrease(3, ATTACK_BONUS_MISC);					       eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 3, SAVING_THROW_TYPE_ALL);
	       eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL, 3);
	       eLink = EffectLinkEffects(eLink, eVis);
	       //Can't do ability without modifying the ability score itself; skipping
	
	
	while(GetIsObjectValid(oTarget))
	{		
		if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Save
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 7.62.0f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	SPEvilShift(oPC);
	SPSetSchool();
}
	
	