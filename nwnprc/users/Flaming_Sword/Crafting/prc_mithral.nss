#include "prc_craft_inc"

void main()
{
    object oPC = OBJECT_SELF;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int nBonus = 0;
    if(StringToInt(GetStringLeft(GetTag(oArmour), 3) & 16))
    {   //mithral armour :P
        int nMaxDexBonus;
        SetIdentified(oArmour, FALSE);
        switch(GetGoldPieceValue(oArmour))
        {
            //case    1: nAC = 0; break; // None - assumes you can't make robes mithral
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
        int nDexBonus = (GetAbilityScore(oPC, ABILITY_DEXTERITY) - 10) / 2;
        if(nDexBonus > nMaxDexBonus)
        {
            nBonus = min(nDexBonus - nMaxDexBonus, 2);
        }
    }
    SetCompositeBonus(GetPCSkin(oPC), "PRC_CRAFT_MITHRAL", nBonus, ITEM_PROPERTY_AC_BONUS);
}