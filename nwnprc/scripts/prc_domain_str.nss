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

#include "prc_inc_domain"

void main()
{
    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(DOMAIN_STRENGTH, OBJECT_SELF)) return;
    
    	object oPC = OBJECT_SELF;
    	object oTarget = PRCGetSpellTargetObject();
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	// Variables effected by MCoK levels
	int nDur = 1;
	int nBoost = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);

	// Mighty Contender class abilities
	if (GetLevelByClass(CLASS_TYPE_CONTENDER, oPC) > 0)
	{
		nBoost += GetLevelByClass(CLASS_TYPE_CONTENDER, oPC);
		nDur = d4() + 1;
	}

        effect eCha = EffectAbilityIncrease(ABILITY_STRENGTH, nBoost);
        effect eLink = EffectLinkEffects(eCha, eDur);
	
   	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));
}

