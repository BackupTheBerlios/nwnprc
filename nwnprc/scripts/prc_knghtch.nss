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

// * Applies the damage bonuses for Daemonslaying
// * Uses multiple damage types, since constance do not exist for
// * 3d6 and 4d6 (which are used by daemonslaying at higher levels)
// * so stack different damage types in increments of 2d6
void KnightDaemonslayingDamage(object oPC, object oWeap, int iDamageBonus, int iDamageType, string sFlag)
{
    if(GetLocalInt(oWeap, sFlag) != iDamageBonus){
    	
        RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_OUTSIDER, GetLocalInt(oWeap, sFlag), 1, sFlag, iDamageType,DURATION_TYPE_TEMPORARY);
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, iDamageType, iDamageBonus), oWeap,9999.0);
        SetLocalInt(oWeap, sFlag, iDamageBonus);
    }
}

void KnightDaemonslayingAttack(object oPC, object oWeap, int iAttackBonus)
{
    if(GetLocalInt(oWeap, "DSlayingAttackBonus") != iAttackBonus)
        SetCompositeBonusT(oWeap, "DSlayingAttackBonus", iAttackBonus, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP, IP_CONST_RACIALTYPE_OUTSIDER);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(GetLocalInt(oPC,"ONEQUIP") == 1) return;

    //Determine which knight of the chalice feats the character has
    int iDivBonus = GetHasFeat(DEMONSLAYING_1, oPC) ? IP_CONST_DAMAGEBONUS_1d6 : 0;
        iDivBonus = GetHasFeat(DEMONSLAYING_2, oPC) ? IP_CONST_DAMAGEBONUS_2d6 : iDivBonus;
        iDivBonus = GetHasFeat(DEMONSLAYING_3, oPC) ? IP_CONST_DAMAGEBONUS_3D6 : iDivBonus;
        iDivBonus = GetHasFeat(DEMONSLAYING_4, oPC) ? IP_CONST_DAMAGEBONUS_4D6 : iDivBonus;

    int iAttBonus = GetHasFeat(DEMONSLAYING_1, oPC) ? 1 : 0;
        iAttBonus = GetHasFeat(DEMONSLAYING_2, oPC) ? 2 : iAttBonus;
        iAttBonus = GetHasFeat(DEMONSLAYING_3, oPC) ? 3 : iAttBonus;
        iAttBonus = GetHasFeat(DEMONSLAYING_4, oPC) ? 4 : iAttBonus;

    int iAtkb = GetAtkBonus(oWeap);
    int iHolyAv = GetItemHolyAvengerBonus(oWeap); // Hey, Knights of the Chalice want to use Holy Avengers too!
    if (iAtkb>iHolyAv)
        iAttBonus += iAtkb;
    else
        iAttBonus += iHolyAv;

    if(iDivBonus > 0)
        KnightDaemonslayingDamage(oPC, oWeap, iDivBonus, IP_CONST_DAMAGETYPE_DIVINE, "DSlayBonusDiv");
    if(iAttBonus > 0)
        KnightDaemonslayingAttack(oPC, oWeap, iAttBonus);
}
