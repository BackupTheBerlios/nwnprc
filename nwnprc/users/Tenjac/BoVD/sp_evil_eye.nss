//::///////////////////////////////////////////////
//:: Name      Evil Eye
//:: FileName  sp_evil_eye.nss
//:://////////////////////////////////////////////
/**@file Evil Eye 
Enchantment [Evil]
Level: Mortal Hunter 2, Sor/Wiz 3 
Components: S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One creature
Duration: Instantaneous (see text) 
Saving Throw: Will negates 
Spell Resistance: Yes
 
The caster focuses malevolent wishes through her 
gaze and curses someone with bad luck. The subject
takes a -4 luck penalty on all attack rolls, 
saves, and checks. The spell ends at the next 
sunrise, when dismissed, when a remove curse is 
cast on the subject, or when the caster takes at 
least 1 point of damage from the subject.

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
	int nPenalty = 4;
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	//Check Spell Resistance
	if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//Will save
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
			eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
			eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));
			
			//Handle removal
			
		}
	}
	
	SPEvilShift(oPC);
	SPSetSchool();
}
	