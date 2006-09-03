#include "prc_alterations"

// Only the armor's value is affected.  Therefore, using a shield can still cause ASF.
void ReducedASF(object oCreature)
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    object oSkin = GetPCSkin(oCreature);
    int iArmorType = GetBaseAC(oArmor);
    int iASFMod = 10;
    int iBonus = GetLocalInt(oSkin, "HexbladeArmourCasting");
    int iCostTableValue;
    int iArmorASF = 0;
    int iShieldASF = 0;
    itemproperty ip;

    // First thing is to remove old ASF (in case armor is changed.)
    if (iBonus != -1)
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "HexbladeArmourCasting");
  
    // Find out how much ASF to apply based on armor type
        switch (iArmorType)
        {
            case 1:
                iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;
                break;
            case 2:
                iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;
                break;
            case 3:
                iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
                break;
            default:
                break;
        }
    
    // Determine the amount of ASF the armor has already.
    ip = GetFirstItemProperty(oArmor);
    while (GetIsItemPropertyValid(ip))
    {
       if (GetItemPropertyType(ip) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE)
       {
           iCostTableValue = GetItemPropertyCostTableValue(ip);
           if (iCostTableValue < 10)
               iArmorASF += 10 - iCostTableValue; // see iprp_arcspell.2da for reference
       }
       ip = GetNextItemProperty(oArmor);
    }
    
    // Find the proper adjustment to ASF from armor
    iASFMod += iArmorASF; //existing ASF can push this above 10.

    // Should we apply?  
    if (iASFMod >= 10) // if it went over ten, that means no bonus is needed.
    {
        SetLocalInt(oSkin, "HexbladeArmourCasting", -1); // -1 represents "nothing's there"
        return; // the armor and/or small shieldalready has good enough ASF, we shouldn't add more.
    }
    
    // Apply the ASF to the skin.
    ip = ItemPropertyArcaneSpellFailure(iASFMod); 

    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
    SetLocalInt(oSkin, "HexbladeArmourCasting", iASFMod);
}  

void main()
{
    object oPC = OBJECT_SELF;

    // Hexblade can cast in light armour.
    ReducedASF(oPC);
}
