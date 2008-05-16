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
    
    int nDie1 = StringToInt(Get2DAString("classes", "HitDie", nClass1));
    int nDie2 = StringToInt(Get2DAString("classes", "HitDie", nClass2));
    int nDie3 = StringToInt(Get2DAString("classes", "HitDie", nClass3));
    
    int nCon;
        
    //d12 = d12 + CON 10, d10 = d10 + CON 12
    if(nDie1 == 12 || nDie2 == 12 || nDie3 == 12)
    {
            nCon = 10;
    }
    
    else if (nDie1 == 10 || nDie2 == 10 || nDie3 == 10)
    {
            nCon = 12;
    }
    
    else if (nDie1 == 8 || nDie2 == 8 || nDie3 == 8)
    {
            nCon = 14;
    }
    
    else if (nDie1 == 6 || nDie2 == 6 || nDie3 == 6)
    {
            nCon = 16;
    }
    
    else if (nDie1 == 4 || nDie2 == 4 || nDie3 == 4)
    {
            nCon = 18;
    }
    
    else
    {
            SendMessageToPC(oPC, "Script prc_ud_hitdice using invalid dice: d" + nDie1 + ", d" + nDie2 + ", d" + nDie3);
    }
    
    //Make current CON = target nCon
    int nCurrentCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION);
    
    if(nCurrentCon > nCon)
    {
            
}