//::///////////////////////////////////////////////
//:: [Disciple of Mephistopheles Feats]
//:: [prc_elemsavant.nss]
//:://////////////////////////////////////////////
//:: Check to see which Disciple of Mephistopheles feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Attilla.  Modified by Aaon Graywolf
//:: Created On: Jan 8, 2004
//:: Modified by Lockindal Linantal: glove property.
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

// * Applies the Disciple of Mephistopheles's resistances on the object's skin.
// * iLevel = IP_CONST_DAMAGERESIST_*
void DiscMephResist(object oPC, object oSkin, int iResist)
{
    if(GetLocalInt(oSkin, "DiscMephResist") == iResist) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_RESISTANCE,IP_CONST_DAMAGETYPE_FIRE, iResist, 1, "DiscMephResist");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE, iResist), oSkin);
    SetLocalInt(oSkin, "DiscMephResist", iResist);
}

void HellFireGrasp(object oPC, object oGaunt)
{
    if(GetLocalInt(oGaunt, "DiscMephGlove") == 6) return;

    RemoveSpecificProperty(oGaunt, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, -1, "DiscMephGlove");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), oGaunt);
    SetLocalInt(oGaunt, "DiscMephGlove", 6);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oGaunt = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
    int iResist = 0;
    int iFire = 0;

    if(GetHasFeat(FEAT_FIRE_RESISTANCE_10, oPC))
    {
        iResist = 2;
    }

    else if(GetHasFeat(FEAT_FIRE_RESISTANCE_20, oPC))
    {
        iResist = 3;
    }

   if(GetHasFeat(FEAT_HELLFIRE_GRASP, oPC))
    {
        iFire = 2;
    }

    //Apply bonuses accordingly
    if(iResist > 1) DiscMephResist(oPC, oSkin, iResist);
    if(iFire > 1) HellFireGrasp(oPC, oGaunt);
}