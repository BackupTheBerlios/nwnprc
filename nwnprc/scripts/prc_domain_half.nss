//::///////////////////////////////////////////////
//:: Halfling Domain Power
//:: prc_domain_half.nss
//::///////////////////////////////////////////////
/*
    Grants Charisma to Jump, Move Silently, and Hide for 10 Minutes
    Free Action to activate. 
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_inc_domain"

void main()
{
    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(DOMAIN_HALFLING, OBJECT_SELF)) return;
    
	object oTarget = OBJECT_SELF;
	int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
	effect eJump = EffectSkillIncrease(SKILL_JUMP, nBonus);
	effect eHide = EffectSkillIncrease(SKILL_HIDE, nBonus);
	effect eMS = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus);
	
        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eJump, eDur);
        eLink = EffectLinkEffects(eLink, eHide);
        eLink = EffectLinkEffects(eLink, eMS);
	
   	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 60.0);
}

