//::///////////////////////////////////////////////
//:: Black Flame Zealot
//:: prc_bfz.nss
//:://////////////////////////////////////////////
//:: Check to see which Black Flame Zealot feats a PC
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 6, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

void ZealousHeart(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "BFZHeart") == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYSPELL_FEAR), oSkin);
    SetLocalInt(oSkin, "BFZHeart", TRUE);
}

void SacredFlame(object oPC, object oWeap)
{
    if(GetLocalInt(oWeap, "BFZFlame") == TRUE) return;

SendMessageToPC(oPC, "Add Sacred Flame is run");

    RemoveSpecificProperty(oWeap, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, -1, "BFZFlame");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), oWeap);
    SetLocalInt(oWeap, "BFZFlame", TRUE);
}

void RemoveSacredFlame(object oPC, object oWeap)
{

SendMessageToPC(oPC, "Remove Sacred Flame is run");

    if(GetLocalInt(oWeap, "BFZFlame") == TRUE)
        //RemoveSpecificProperty(oWeap, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, -1, "BFZFlame");
	RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, "BFZFlame", -1, DURATION_TYPE_PERMANENT);
}


void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oUnequip = GetPCItemLastUnequipped();
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    ZealousHeart(oPC, oSkin);

    if(GetHasFeat(FEAT_SACRED_FLAME, oPC))
    {
	if (GetLocalInt(oUnequip, "BFZFlame") == TRUE)
	{
        	if (iEquip == 1)    RemoveSacredFlame(oPC, oUnequip);
	}
        if (iEquip == 2)    SacredFlame(oPC, oWeap);
    }
}
