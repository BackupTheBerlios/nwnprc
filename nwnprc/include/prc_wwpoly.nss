//::///////////////////////////////////////////////
//:: Polymorph script for Lycanthropes
//:: prc_wwpoly
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 11, 2004
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"

// polymorph.2da

const int POLYMORPH_TYPE_WOLF_0                    = 133;
const int POLYMORPH_TYPE_WOLF_1                    = 134;
const int POLYMORPH_TYPE_WOLF_2                    = 135;
const int POLYMORPH_TYPE_WEREWOLF_0                = 136;
const int POLYMORPH_TYPE_WEREWOLF_1                = 137;
const int POLYMORPH_TYPE_WEREWOLF_2                = 138;

const int POLYMORPH_TYPE_WOLF_0s                   = 139;
const int POLYMORPH_TYPE_WOLF_1s                   = 140;
const int POLYMORPH_TYPE_WOLF_2s                   = 141;
const int POLYMORPH_TYPE_WEREWOLF_0s               = 142;
const int POLYMORPH_TYPE_WEREWOLF_1s               = 143;
const int POLYMORPH_TYPE_WEREWOLF_2s               = 144;

const int POLYMORPH_TYPE_WOLF_0l                   = 145;
const int POLYMORPH_TYPE_WOLF_1l                   = 146;
const int POLYMORPH_TYPE_WOLF_2l                   = 147;
const int POLYMORPH_TYPE_WEREWOLF_0l               = 148;
const int POLYMORPH_TYPE_WEREWOLF_1l               = 149;
const int POLYMORPH_TYPE_WEREWOLF_2l               = 150;

// Used to polymorph characters to lycanthrope shapes
// Merges Weapons, Armors, Items if told to by 2da.
// - object oPC: Player to Polymorph
// - int nPoly: POLYMORPH_TYPE_* Constant
void LycanthropePoly(object oPC, int nPoly);

void LycanthropePoly(object oPC, int nPoly)
{
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    effect ePoly;

    ePoly = EffectPolymorph(nPoly);
    ePoly = SupernaturalEffect(ePoly);

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    if (GetIsObjectValid(oShield))
    {
        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC);

    object oWeaponNewRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeaponNewLeft = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeaponNewBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

    if (bWeapon)
    {
        IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNewLeft, TRUE);
        IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNewRight, TRUE);
        IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNewBite, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }

}


