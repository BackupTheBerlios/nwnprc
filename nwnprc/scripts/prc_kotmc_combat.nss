//::///////////////////////////////////////////////
//:: Knight of the Middle Circle - Combat Sense
//:: prc_kotmc_combat.nss
//:://////////////////////////////////////////////
//:: Applies a temporary AC and Attack bonus vs
//:: monsters of the targets racial type
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 16, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_class_const"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oTarget = GetSpellTargetObject();
    int nRace = GetRacialType(oTarget);
    int nClass = GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, oPC);
    int nDur = nClass + 3;
    int nAC;
    int nAttack;

    if (nClass >= 1)
    {
    nAC = 2;
    nAttack = 2;
    }
    if (nClass >= 5)
    {
    nAC = 4;
    nAttack = 4;
    }
    if (nClass >= 10)
    {
    nAC = 6;
    nAttack = 6;
    }
    if (nClass >= 15)
    {
    nAC = 8;
    nAttack = 8;
    }
    if (nClass >= 20)
    {
    nAC = 10;
    nAttack = 10;
    }
    if (nClass >= 25)
    {
    nAC = 12;
    nAttack = 12;
    }
    if (nClass >= 30)
    {
    nAC = 14;
    nAttack = 14;
    }


    itemproperty iAttack = ItemPropertyAttackBonusVsRace(nRace, nAttack);
    AddItemProperty(DURATION_TYPE_TEMPORARY, iAttack, oWeapon, RoundsToSeconds(nDur));
    itemproperty iAC = ItemPropertyACBonusVsRace(nRace, nAC);
    AddItemProperty(DURATION_TYPE_TEMPORARY, iAC, oSkin, RoundsToSeconds(nDur));
}
