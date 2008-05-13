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

#include "prc_alterations"


void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nClass1 = GetClassByPosition(1, oPC);
    int nClass2 = GetClassByPosition(2, oPC);
    int nClass3 = GetClassByPosition(3, oPC);
    
    //d12 = d12 + CON 10, d10 = d10 + CON 12
    
    
}