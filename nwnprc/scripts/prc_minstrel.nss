#include "inc_item_props"
#include "prc_feat_const"

// Only the armor's value is affected.  Therefore, using a shield can still cause ASF.
void ReducedASF(object oCreature)
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    object oSkin = GetPCSkin(oCreature);
    int iArmorType = GetBaseAC(oArmor);
    int iASFMod = 99; // "bad" dummy value, will cause the code to quit if the wrong kind of armor is on.
    int iBonus = GetLocalInt(oSkin, "MinstrelSFBonus");
    int iCostTableValue;
    int iArmorASF = 0;
    itemproperty ip;

    // First thing is to remove old ASF (in case armor is changed.)
    if (iBonus != 99)
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "MinstrelSFBonus");
  
    SetLocalInt(oSkin, "MinstrelSFBonus", 99); // set to 99 until the bonus is applied.
  
    // Find out how much ASF to apply based on armor type
    if (GetHasFeat(FEAT_MINSTREL_LIGHT_ARMOR_CASTING, oCreature))
    {
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
    
    // Why 99?  Because 0 is IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT!  99 isn't taken.
    if (iASFMod == 99) return; // no need to proceed if we're wearing too much armor.

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

    // Find the proper adjustment to ASF.
    iASFMod += iArmorASF;
    
    if (iASFMod >= 10) return; // the armor already has good enough ASF, we shouldn't add more.
    
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
