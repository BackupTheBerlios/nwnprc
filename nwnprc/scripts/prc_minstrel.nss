#include "inc_item_props"
#include "prc_feat_const"

// Only the armor's value is affected.  Therefore, using a shield can still cause ASF.
void ReducedASF(object oCreature)
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    object oSkin = GetPCSkin(oCreature);
    int iArmorType = GetBaseAC(oArmor);
    int iASFMod;
    int iBonus = GetLocalInt(oSkin, "MinstrelSFBonus");
    int iCostTableValue;
    int iArmorASF = 0;
    int iShieldASF = 0;
    itemproperty ip;

    // First thing is to remove old ASF (in case armor is changed.)
    if (iBonus != -1)
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "MinstrelSFBonus");
  
    // Find out how much ASF to apply based on armor type
    if (GetHasFeat(FEAT_MINSTREL_LIGHT_ARMOR_CASTING, oCreature))
    {
        switch (iArmorType)
        {
            case 0:
                iASFMod = 10; //nothing will be applied if it stays like this.
                break;
            case 1:
                iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;
                break;
            case 2:
                iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;
                break;
            case 3:
                iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
                break;
            case 4:
                if (GetHasFeat(FEAT_MINSTREL_MEDIUM_ARMOR_CASTING, oCreature))
                    iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
                break;
            case 5:
                if (GetHasFeat(FEAT_MINSTREL_MEDIUM_ARMOR_CASTING, oCreature))
                    iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT;
                break;
            default:
                break;
        }
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

    // Determine whether the shield bonus should be applied and the amount of ASF it has already.
    if (GetBaseItemType(oShield) == BASE_ITEM_SMALLSHIELD && GetHasFeat(FEAT_MINSTREL_SMALL_SHIELD_CASTING))
    {
        ip = GetFirstItemProperty(oShield);
        while (GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyType(ip) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE)
            {
                iCostTableValue = GetItemPropertyCostTableValue(ip);
                if (iCostTableValue < 10)
                    iShieldASF += 10 - iCostTableValue; // see iprp_arcspell.2da for reference
            }
            ip = GetNextItemProperty(oShield);
        }
        
        // Find the proper adjustment to ASF from the shield
        iASFMod += iShieldASF - 1; // existing ASF can push this above 10, but the presence of the
                                   // shield drives it down by one level.
    }        
    
    // Should we apply?  
    if (iASFMod >= 10) // if it went over ten, that means no bonus is needed.
    {
        SetLocalInt(oSkin, "MinstrelSFBonus", -1); // -1 represents "nothing's there"
        return; // the armor and/or small shieldalready has good enough ASF, we shouldn't add more.
    }
    
    // Apply the ASF to the skin.
    ip = ItemPropertyArcaneSpellFailure(iASFMod); 

    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
    SetLocalInt(oSkin, "MinstrelSFBonus", iASFMod);
}  

void main()
{
    object oPC = OBJECT_SELF;

    // Minstrel of the Edge can wear light (and later, medium) armor and cast spells.
    ReducedASF(oPC);
}
