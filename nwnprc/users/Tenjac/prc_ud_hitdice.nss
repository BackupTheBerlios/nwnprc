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
//:: Modified:    5/16/08
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int nClass1 = GetClassByPosition(1, oPC);
    int nClass2 = GetClassByPosition(2, oPC);
    int nClass3 = GetClassByPosition(3, oPC);       
    
    int nDie1 = StringToInt(Get2DAString("classes", "HitDie", nClass1));
    int nDie2 = StringToInt(Get2DAString("classes", "HitDie", nClass2));
    int nDie3 = StringToInt(Get2DAString("classes", "HitDie", nClass3));
    
    int nCon;
    int nFortPenalty = 0;
        
    //d12 = d12 + CON 10, d10 = d10 + CON 12
    if(nDie1 == 12 || nDie2 == 12 || nDie3 == 12)
    {
            nCon = 10;
    }
    
    else if (nDie1 == 10 || nDie2 == 10 || nDie3 == 10)
    {
            nCon = 12;
            nFortPenalty = 1;
    }
    
    else if (nDie1 == 8 || nDie2 == 8 || nDie3 == 8)
    {
            nCon = 14;
            nFortPenalty = 2;
    }
    
    else if (nDie1 == 6 || nDie2 == 6 || nDie3 == 6)
    {
            nCon = 16;
            nFortPenalty = 3;
    }
    
    else if (nDie1 == 4 || nDie2 == 4 || nDie3 == 4)
    {
            nCon = 18;
            nFortPenalty = 4;
    }
    
    else
    {
            SendMessageToPC(oPC, "Script prc_ud_hitdice using invalid dice: d" + nDie1 + ", d" + nDie2 + ", d" + nDie3);
    }
    
    //Make current CON = target nCon
    int nCurrentCon = GetAbilityScore(oPC, ABILITY_CONSTITUTION);
    
    if(nCurrentCon != nCon)
    {
            effect eAdjust;
            
            if(nCurrentCon > nCon) eAdjust = EffectAbilityDecrease(ABILITY_CONSTITUTION, (nCurrentCon - nCon));            
            
            else if(nCon > nCurrentCon) eAdjust = EffectAbilityIncrease(ABILITY_CONSTITUTION, (nCon - nCurrentCon));
            
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAdjust, oPC);
    }
    
    //Fort Penalty
    if(nFortPenalty > 0) SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSavingThrowDecrease(SAVING_THROW_FORT, nFortPenalty));
}