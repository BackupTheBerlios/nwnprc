#include "inc_item_props"
#include "prc_feat_const"

void MinstrelIgnoreSpellFailure(object oPC, object oSkin, int iLevel, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, GetLocalInt(oSkin, sFlag), 1, sFlag);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyArcaneSpellFailure(iLevel), oSkin);
    SetLocalInt(oSkin, sFlag, iLevel);
}

void main()
{
    object oPC = OBJECT_SELF;

    int bSpells = GetHasFeat(FEAT_MOE_REDUCED_ASF_10, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT : 0;
        bSpells = GetHasFeat(FEAT_MOE_REDUCED_ASF_20, oPC)  ? IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT : bSpells;

    object oSkin = GetPCSkin(oPC);

    if(bSpells > 0)  MinstrelIgnoreSpellFailure(oPC, oSkin, bSpells, "MinstrelSFBonusNormal");
}
