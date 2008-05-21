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
        object oSkin = GetPCSkin(oPC);
        int nClass1 = GetClassByPosition(1, oPC);
        int nClass2 = GetClassByPosition(2, oPC);
        int nClass3 = GetClassByPosition(3, oPC);       
        
        int nDie1 = StringToInt(Get2DAString("classes", "HitDie", nClass1));
        int nDie2 = StringToInt(Get2DAString("classes", "HitDie", nClass2));
        int nDie3 = StringToInt(Get2DAString("classes", "HitDie", nClass3));
        
        int nConBonus;
        int nFortPenalty = 0;
        
        //Remove any items with a CON Bonus
        object oEquipped = GetItemLastEquipped();
        
        itemproperty ipTest = GetFirstItemProperty(oEquipped)
        
        while(GetIsItemPropertyValid(ipTest))
        {
                if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_ABILITY_BONUS ||
                GetItemPropertyType(ipTest) == ITEM_PROPERTY_DECREASED_ABILITY_SCORE)
                {
                        //CON?
                        if(GetItemPropertySubType(ipTest) == ABILITY_CONSTITUTION)
                        {
                                AssignCommand(oPC, ClearAllActions());
                                AssignCommand(oPC, ActionUnequipItem(oItem));
                                SendMessageToPC(oPC, "You cannot equip this item because you have no Constitution score.");
                                break;
                        }
                }
                ipTest = GetNextItemProperty(oEquipped);
        }
        
        //d12 = d12 + 0 CON bonus, d10 + 2, etc
        if(nDie1 == 12 || nDie2 == 12 || nDie3 == 12)
        {
                nConBonus = 0;
        }
        
        else if (nDie1 == 10 || nDie2 == 10 || nDie3 == 10)
        {
                nConBonus = 2;
                nFortPenalty = 1;
        }
        
        else if (nDie1 == 8 || nDie2 == 8 || nDie3 == 8)
        {
                nConBonus = 4;
                nFortPenalty = 2;
        }
        
        else if (nDie1 == 6 || nDie2 == 6 || nDie3 == 6)
        {
                nConBonus = 6;
                nFortPenalty = 3;
        }
        
        else if (nDie1 == 4 || nDie2 == 4 || nDie3 == 4)
        {
                nConBonus = 8;
                nFortPenalty = 4;
        }
        
        else
        {
                SendMessageToPC(oPC, "Script prc_ud_hitdice using invalid dice: d" + nDie1 + ", d" + nDie2 + ", d" + nDie3);
                return;
        }
        
        //Make the CON bonus what it should be
        SetCompositeBonus(oSkin, "PRCUndeadHD", nConBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
        
        //Fort Penalty
        if(nFortPenalty > 0) SetCompositeBonus(oSkin, "PRCUndeadFSPen", nFortPenalty, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC, IP_CONST_SAVEBASETYPE_FORTITUDE);
}