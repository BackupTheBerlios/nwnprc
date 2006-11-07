//::///////////////////////////////////////////////
//:: Renewal Domain Power
//:: prc_domain_renew.nss
//::///////////////////////////////////////////////
/*
    Heals 1d8 + Charisma hit points
    Free Action
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_inc_domain"

void main()
{
    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(DOMAIN_RENEWAL, OBJECT_SELF)) return;
    
	object oPC = OBJECT_SELF;
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
        effect eHeal = EffectHeal(d8() + GetAbilityModifier(ABILITY_CHARISMA, oPC));
        effect eLink = EffectLinkEffects(eVis, eHeal);
	
   	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oPC);
}

