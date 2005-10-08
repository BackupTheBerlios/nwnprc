//::///////////////////////////////////////////////
//:: Name   Undead Hit Dice
//:: FileName   prc_bn_hitdice
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*   Gives +12 to CON on oSkin to simulate the d12
     change of undead creatures

*/
//:://////////////////////////////////////////////
//:: Created By:  Tenjac
//:: Created On:  11/26/04
//:://////////////////////////////////////////////
#include "inc_item_props"
void main()
{
object oPC = OBJECT_SELF;
object oSkin = GetPCSkin(oPC);
int nBonus = 12;

SetCompositeBonus(oSkin, "HD", nBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
}

