#include "nw_i0_spells"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"
#include "prc_inc_unarmed"
#include "inc_item_props"
#include "prc_ipfeat_const"

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
    
    //Evaluate DR
    BrawlerDamageReduction(oPC);

    //Extra Attacks OFF if equipping of weapons or shield is done
    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) ||
        GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)) ||
        GetLevelByClass(CLASS_TYPE_MONK, oPC))  // in case the brawler takes the monk class, this will handle it onlevelup
        RemoveExtraAttacks(oPC);
}
