#include "nw_i0_spells"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"
#include "prc_inc_unarmed"
#include "inc_item_props"

void BrawlerDodge(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);
    int iLevel = 0;
    
    if(GetHasFeat(FEAT_BRAWLER_DODGE_1, oCreature))
       iLevel = 1;
    if(GetHasFeat(FEAT_BRAWLER_DODGE_2, oCreature))
       iLevel = 2;
    if(GetHasFeat(FEAT_BRAWLER_DODGE_3, oCreature))
       iLevel = 3;
    if(GetHasFeat(FEAT_BRAWLER_DODGE_4, oCreature))
       iLevel = 4;
    if(GetHasFeat(FEAT_BRAWLER_DODGE_5, oCreature))
       iLevel = 5;

    if(GetLocalInt(oSkin, "BrawlerDodge") == iLevel) return;
    else SetCompositeBonus(oSkin, "BrawlerDodge", iLevel, ITEM_PROPERTY_AC_BONUS);
}

void BrawlerWeaponFinesse(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_WEAPFINESSE, -1, 1, "BrawlerFinesse");
    
    if (GetHasFeat(FEAT_WEAPON_FINESSE_UNARMED, oCreature) &&
        GetBaseAC(oArmor) <= 3 &&
        !GetIsObjectValid(oRighthand) &&
        !GetIsObjectValid(oLefthand) &&
        !GetLocalInt(oSkin, "BrawlerFinesse"))
    {
        DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPFINESSE), oSkin));
        SetLocalInt(oSkin, "BrawlerFinesse", TRUE);
    }
}

void RemoveExtraAttacks(object oCreature)
{
    if (GetHasSpellEffect(SPELL_BRAWLER_EXTRA_ATT))
    {
        RemoveSpellEffects(SPELL_BRAWLER_EXTRA_ATT, oCreature, oCreature);
        if (GetLocalInt(oCreature, "BrawlerAttacks"))
        {
            FloatingTextStringOnCreature("*Extra unarmed attacks disabled*", oCreature, FALSE);
            DeleteLocalInt(oCreature, "BrawlerAttacks");
        }
    }
}

void main ()
{
    object oPC = OBJECT_SELF;

    //Evaluate The Unarmed Strike Feats
    UnarmedFeats(oPC);

    //Evaluate Fists
    UnarmedFists(oPC);

    //Evaluate Weapon Finesse (Unarmed)
    BrawlerWeaponFinesse(oPC);

    //Evaluate Dodge
    BrawlerDodge(oPC);

    //Extra Attacks OFF if equipping of weapons or shield is done
    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) ||
        GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)))
            RemoveExtraAttacks(oPC);
}
