#include "inc_item_props"
#include "prc_feat_const"

void ReducedASF(object oCreature)
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    object oSkin = GetPCSkin(oCreature);
    int iArmorType = GetBaseAC(oArmor);
    int iASFMod = 99; // "bad" dummy value, will cause the code to quit if the wrong kind of armor is on.
    int iBonus = GetLocalInt(oSkin, "MinstrelSFBonus");
    itemproperty ipASF;

    // First thing is to remove old ASF (in case armor is changed.)
    if (iBonus != 99)
        RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "MinstrelSFBonus");
  
    // Find out how much ASF to apply based on armor type
    if (GetHasFeat(FEAT_MINSTREL_LIGHT_ARMOR_CASTING, oCreature))
    {
        switch (iArmorType)
        {
            case 1:
                iASFMod = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT; // same as iASFMod = 0;
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
    
    SetLocalInt(oSkin, "MinstrelSFBonus", iASFMod); // set to 99 if no bonus applied
    
    if (iASFMod == 99) return; // no need to proceed if we're wearing too much armor.

    // Apply the ASF to the skin.
    ipASF = ItemPropertyArcaneSpellFailure(iASFMod); 

    AddItemProperty(DURATION_TYPE_PERMANENT, ipASF, oSkin);
}  

void main()
{
    object oPC = OBJECT_SELF;

    // Minstrel of the Edge can wear light (and later, medium) armor and cast spells.
    ReducedASF(oPC);
}
