
#include "prc_class_const"
#include "inc_item_props"
#include "prc_feat_const"

// Bonus on certain CHA based skills
void Dark_Charisma(object oPC ,object oSkin, int nLevel)
{
    int nBonus = 0;
    switch(nLevel)
    { 
         case 3: nBonus = 1;
         case 5: nBonus = 2;
         case 7: nBonus = 3;
         case 11: nBonus = 4;
         case 13: nBonus = 5;
         case 17: nBonus = 6;
         case 21: nBonus = 7;
         case 25: nBonus = 8;
         case 29: nBonus = 9;
    }
    
    if(GetLocalInt(oSkin, "Dark_Charm_AE") == nBonus) return;

    SetCompositeBonus(oSkin, "Dark_Charm_AE", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
    SetCompositeBonus(oSkin, "Dark_Charm_PF", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
    SetCompositeBonus(oSkin, "Dark_Charm_PS", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "Dark_Charm_BL", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
}

void main()
{
    // Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, OBJECT_SELF) + GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, OBJECT_SELF);
       
    Dark_Charisma(oPC, oSkin, nLevel);
}