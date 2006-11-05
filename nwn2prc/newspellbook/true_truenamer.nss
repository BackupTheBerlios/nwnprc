/*
   ----------------
   Truenamer Passives
   
   true_truenamer
   ----------------

   4/9/06 by Stratovarius
*/ /** @file

   Gives him the +3 (or greater) Lore bonus at the appropriate levels.
*/

#include "true_inc_trufunc"

/// +3 on Lore /////////
void Truenamer_Lore(object oPC, object oSkin, int nLore)
{

   if(GetLocalInt(oSkin, "TruenamerLore") == nLore) return;

    SetCompositeBonus(oSkin, "TruenamerLore", nLore, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
}

void main()
{
     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_TRUENAMER, oPC);
    int nLore;
    
    if (nClass >= 14) nLore = 12;
    else if (nClass >= 10 && nClass < 14) nLore = 9;
    else if (nClass >= 7 && nClass < 10) nLore = 6;
    else if (nClass >= 2 && nClass < 7) nLore = 3;
    
    Truenamer_Lore(oPC, oSkin, nLore);
}
