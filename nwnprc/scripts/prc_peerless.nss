#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"

/// +3 on Craft Weapon /////////
void Expert_Bowyer(object oPC ,object oSkin ,int nBowyer)
{

   if(GetLocalInt(oSkin, "PABowyer") == nBowyer) return;

    SetCompositeBonus(oSkin, "PABowyer", nBowyer, ITEM_PROPERTY_SKILL_BONUS, SKILL_CRAFT_WEAPON);
}


/// Applies the Peerless Archer Sneak Attack to its bow ///
void AddSneakAttack(object oPC ,object oWeapon)
{

    if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
    {
        SendMessageToPC(oPC, "Add Sneak Attack Is Called");
        if (GetHasFeat(FEAT_PA_SNEAK_4D6, oPC))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(FEAT_ROGUE_SA_4D6), oWeapon);
        }
        else if (GetHasFeat(FEAT_PA_SNEAK_3D6, oPC))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_3D6), oWeapon);
        }
        else if (GetHasFeat(FEAT_PA_SNEAK_2D6, oPC))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_2D6), oWeapon);
        }
        else if (GetHasFeat(FEAT_PA_SNEAK_1D6, oPC))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_1D6), oWeapon);
        }
    }

}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int nBowyer = GetHasFeat(FEAT_EXPERT_BOWYER, oPC) ? 3 : 0;

    if (GetLevelByClass(CLASS_TYPE_PEERLESS, oPC) > 1) AddSneakAttack(oPC, oWeapon);
    if (nBowyer>0) Expert_Bowyer(oPC, oSkin, nBowyer);
}