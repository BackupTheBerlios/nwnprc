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

void ZealousHeart(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "BFZHeart") == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYSPELL_FEAR), oSkin);
    SetLocalInt(oSkin, "BFZHeart", TRUE);
}


void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    ZealousHeart(oPC, oSkin);
}
