// Written by Stratovarius
// Applies the cast domain feats to the hide

#include "prc_inc_domain"

void main()
{

	object oPC = OBJECT_SELF;
    	object oSkin = GetPCSkin(oPC);
    	
    	FloatingTextStringOnCreature("PRC Domain Skin is running", oPC, FALSE);
    
    	// The prereq variables use 0 as true and 1 as false, becuase they are used in class prereqs
    	// It uses allspell because there are some feats that allow a wizard or other arcane caster to take domains.
    	if (!GetHasFeat(FEAT_CHECK_DOMAIN_SLOTS))
    	{
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CHECK_DOMAIN_SLOTS),oSkin);
    	    FloatingTextStringOnCreature("The PC does not have Check Domain Slots, adding", oPC, FALSE);
    	}
    	if (GetLocalInt(oPC, "PRC_AllSpell1") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_ONE))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_ONE),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell2") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_TWO))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_TWO),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell3") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_THREE))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_THREE),oSkin);   
    	if (GetLocalInt(oPC, "PRC_AllSpell4") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_FOUR))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_FOUR),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell5") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_FIVE))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_FIVE),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell6") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_SIX))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_SIX),oSkin);  
    	if (GetLocalInt(oPC, "PRC_AllSpell7") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_SEVEN))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_SEVEN),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell8") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_EIGHT))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_EIGHT),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell9") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_NINE))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_NINE),oSkin);      	    
}