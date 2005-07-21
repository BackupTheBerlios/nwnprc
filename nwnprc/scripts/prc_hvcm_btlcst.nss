// Written by Stratovarius
// Turns Battlecast on and off for the Havoc Mage.

#include "prc_spell_const"
#include "prc_ipfeat_const"
#include "inc_item_props"
#include "nw_i0_spells"

void main()
{

     object oPC = OBJECT_SELF;
     object oSkin = GetPCSkin(oPC);
     string nMes = "";

     if(!GetLocalInt(oPC, "HavocMageBattlecast"))
     {    
	SetLocalInt(oPC, "HavocMageBattlecast", TRUE);
	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_IMP_CC), oSkin);
     	nMes = "*Battlecast Activated*";
     }
     else     
     {
	// Removes effects
	RemoveSpellEffects(SPELL_BATTLECAST, oPC, oPC);
	DeleteLocalInt(oPC, "HavocMageBattlecast");
	nMes = "*Battlecast Deactivated*";
	RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_IMP_CC);
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}