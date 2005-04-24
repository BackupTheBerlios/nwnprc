//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "prc_feat_const"

void main()
{
    //Yep thats it
    SummonAnimalCompanion();
    
    //Exalted Companion
    if (GetHasFeat(FEAT_EXALTED_COMPANION))
    {
    	object oComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
    	int nHD = GetHitDice(oComp);
    	int nResist;
    	effect eDR;
    	if (nHD >= 12)
    	{
    		eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE);
    		nResist = 20;
    	}
    	else if (12 > nHD && nHD >= 8)
    	{
    		eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_TWO);
    		nResist = 20;
    	}
    	else if (8 > nHD && nHD >= 4)
    	{
    		eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
    		nResist = 20;
    	}
    	else if (4 > nHD)
    	{
    		nResist = 5;
    	}
    	
    	effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResist);
    	effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist);
    	effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist);
    	effect eVis = EffectUltravision();
    	effect eLink = EffectLinkEffects(eDR, eAcid);
    	eLink = EffectLinkEffects(eLink, eCold);
    	eLink = EffectLinkEffects(eLink, eElec);
    	eLink = EffectLinkEffects(eLink, eVis);
    	eLink = SupernaturalEffect(eLink);
    	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oComp);
    }
}
