//::///////////////////////////////////////////////
//:: [Knight of the Chalice Feats]
//:: [prc_knghtch.nss]
//:://////////////////////////////////////////////
//:: Check to see which Knight of the Chalice feats
//:: a creature has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_ipfeat_const"

void ApplyDemonslaying(object oPC, int iDivBonus, int iAttBonus)
{
    if (!iDivBonus) return;

    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_OUTSIDER, -1, 1, "DSlayBonusDiv", -1, DURATION_TYPE_TEMPORARY);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_DIVINE, iDivBonus), oWeap, 9999.0);
    SetLocalInt(oWeap, "DSlayBonusDiv", iDivBonus);

    effect eAttBonus = VersusRacialTypeEffect(EffectAttackIncrease(iAttBonus, ATTACK_BONUS_ONHAND), RACIAL_TYPE_OUTSIDER);
    eAttBonus = SupernaturalEffect(eAttBonus);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttBonus, oPC);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    
    //Determine which knight of the chalice feats the character has
    int iDivBonus = GetHasFeat(DEMONSLAYING_1, oPC) ? IP_CONST_DAMAGEBONUS_1d6 : 0;
        iDivBonus = GetHasFeat(DEMONSLAYING_2, oPC) ? IP_CONST_DAMAGEBONUS_2d6 : iDivBonus;
        iDivBonus = GetHasFeat(DEMONSLAYING_3, oPC) ? IP_CONST_DAMAGEBONUS_3D6 : iDivBonus;
        iDivBonus = GetHasFeat(DEMONSLAYING_4, oPC) ? IP_CONST_DAMAGEBONUS_4D6 : iDivBonus;

    int iAttBonus = GetHasFeat(DEMONSLAYING_1, oPC) ? 1 : 0;
        iAttBonus = GetHasFeat(DEMONSLAYING_2, oPC) ? 2 : iAttBonus;
        iAttBonus = GetHasFeat(DEMONSLAYING_3, oPC) ? 3 : iAttBonus;
        iAttBonus = GetHasFeat(DEMONSLAYING_4, oPC) ? 4 : iAttBonus;

    // For some odd reason, this refused to work using if (GetLocalInt(oPC, "ONEQUIP") == 1)
    object oWeap = GetPCItemLastUnequipped();
    if (GetLocalInt(oWeap, "DSlayBonusDiv"))
        RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_OUTSIDER, -1, 1, "DSlayBonusDiv", -1, DURATION_TYPE_TEMPORARY);

    ApplyDemonslaying(oPC, iDivBonus, iAttBonus);
}
