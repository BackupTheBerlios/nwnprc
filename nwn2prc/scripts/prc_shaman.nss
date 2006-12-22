// This is the level up file for the Shaman OA base class

#include "prc_alterations"
#include "prc_class_const"


// Function to apply the targets charisma bonus to the PRC skin as a Saving Throw bonus.
void ShamanSpiritFavor(object oPC, object oSkin, int nAmount)
{
    if(GetLocalInt(oSkin, "SaveBonus") == nAmount)
        return;
        
    if(nAmount > 0)
    {
        SetCompositeBonus(oSkin, "SaveBonus", nAmount, ITEM_PROPERTY_SAVING_THROW_BONUS);
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    
    if(GetHasFeat(FEAT_SHAMAN_SPIRITFAVOR, oPC))
    {
        int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        ShamanSpiritFavor(oPC, oSkin, nBonus);
    }   
}