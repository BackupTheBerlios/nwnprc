#include "nw_i0_spells"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"
#include "prc_inc_unarmed"
#include "inc_item_props"
#include "prc_ipfeat_const"

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

void BrawlerDamageReduction(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);
    
    if (GetHasFeat(FEAT_BRAWLER_DAMAGE_REDUCTION_3, oCreature) && !GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_3))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DR_3),oSkin);
    if (GetHasFeat(FEAT_BRAWLER_DAMAGE_REDUCTION_6, oCreature) && !GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_6))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DR_6),oSkin);
    if (GetHasFeat(FEAT_BRAWLER_DAMAGE_REDUCTION_9, oCreature) && !GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_9))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_DR_9),oSkin);
}      
       

void main ()
{
    object oPC = OBJECT_SELF;

    //Evaluate The Unarmed Strike Feats
    UnarmedFeats(oPC);

    //Evaluate Fists
    UnarmedFists(oPC);

    //Evaluate Dodge
    BrawlerDodge(oPC);
    
    //Evaluate DR
    BrawlerDamageReduction(oPC);

    //Extra Attacks OFF if equipping of weapons or shield is done
    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) ||
        GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)) ||
        GetLevelByClass(CLASS_TYPE_MONK, oPC))  // in case the brawler takes the monk class, this will handle it onlevelup
            RemoveExtraAttacks(oPC);
}
