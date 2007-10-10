#include "prc_craft_inc"

void main()
{
    object oPC = OBJECT_SELF;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nBonus = 0;
    int nCapIncrease = 0;
    int nLevel = (GetLevelByClass(CLASS_TYPE_COC, oPC));
    if(StringToInt(GetStringLeft(GetTag(oArmour), 3)) & 16)
    {   //mithral armour :P
        nCapIncrease += 2;
    }
    if(nLevel >= 3)
    {   //increases by 1 every 3 levels of champion of corellon
        nCapIncrease += nLevel / 3;
    }
    if(nCapIncrease)
    {
        int nMaxDexBonus;
        SetIdentified(oArmour, FALSE);
        switch(GetGoldPieceValue(oArmour))
        {
            case    1: nMaxDexBonus = -1; break; // None - assumes you can't make robes mithral
            case    5: nMaxDexBonus = 8; break; // Padded
            case   10: nMaxDexBonus = 6; break; // Leather
            case   15: nMaxDexBonus = 4; break; // Studded Leather / Hide
            case  100: nMaxDexBonus = 4; break; // Chain Shirt / Scale Mail
            case  150: nMaxDexBonus = 2; break; // Chainmail / Breastplate
            case  200: nMaxDexBonus = 1; break; // Splint Mail / Banded Mail
            case  600: nMaxDexBonus = 1; break; // Half-Plate
            case 1500: nMaxDexBonus = 1; break; // Full Plate
        }
        SetIdentified(oArmour, TRUE);
        if(nMaxDexBonus == -1)
            nBonus = 0;     //can't increase max dex bonus on 0 base AC armour since it's unlimited
        int nDexBonus = (GetAbilityScore(oPC, ABILITY_DEXTERITY) - 10) / 2;
        if(nDexBonus > nMaxDexBonus)
        {
            nBonus = min(nDexBonus - nMaxDexBonus, nCapIncrease);
        }
    }
    SetCompositeBonus(GetPCSkin(oPC), "PRC_CRAFT_MITHRAL", nBonus, ITEM_PROPERTY_AC_BONUS);
}