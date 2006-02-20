//::///////////////////////////////////////////////
//:: Strength Domain Power
//:: prc_domain_str.nss
//::///////////////////////////////////////////////
/*
    Grants Char level to Strength for 1 round
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    	object oPC = OBJECT_SELF;
    	object oTarget = PRCGetSpellTargetObject();
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eCha = EffectAbilityIncrease(ABILITY_STRENGTH, GetHitDice(oPC));
        effect eLink = EffectLinkEffects(eCha, eDur);
	
   	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
}

