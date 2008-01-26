//::///////////////////////////////////////////////
//:: Dragonfire Adept
//:: inv_drgnfireadpt.nss
//::///////////////////////////////////////////////
/*
    Handles the passive bonuses for Dragonfire Adepts
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 24, 2007
//:://////////////////////////////////////////////


#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	
	int nClass = GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC);
	
	int nScales = 2;
	effect eReduction;
	
	//Scales
	if(nClass > 37)
	    nScales = 9;
	else if(nClass > 32)
	    nScales = 8;
	else if(nClass > 27)
	    nScales = 7;
	else if(nClass > 22)
	    nScales = 6;
	else if(nClass > 17)
	    nScales = 5;
	else if(nClass > 12)
	    nScales = 4;
	else if(nClass > 7)
	    nScales = 3;
	    
	if(nClass > 1)
	   SetCompositeBonus(oSkin, "DFA_AC", nScales, ITEM_PROPERTY_AC_BONUS);
	
	//Reduction
	if(nClass > 35)
	    eReduction = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE);
	else if(nClass > 25)
	    eReduction = EffectDamageReduction(7, DAMAGE_POWER_PLUS_FIVE);
	else if(nClass > 15)
	    eReduction = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
	else if(nClass > 5)
	    eReduction = EffectDamageReduction(2, DAMAGE_POWER_PLUS_ONE);
	    
	if(nClass > 5)
	   ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eReduction), oPC);
		    
}