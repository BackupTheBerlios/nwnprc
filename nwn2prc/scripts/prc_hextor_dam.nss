//::///////////////////////////////////////////////
//:: Fist of Hextor Damage/Attack
//:: prc_hextor.nss
//:://////////////////////////////////////////////
//:: Applies Fist of Hextor Bonuses by using
//:: ActionCastSpellOnSelf
//:://////////////////////////////////////////////


#include "prc_feat_const"
#include "prc_alterations"

int BrutalStrikeAttack(object oPC)
{
    int iAtk = 0;

    if (GetHasFeat(FEAT_BSTRIKE_A12, oPC))
    {
        iAtk = 12;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A11, oPC))
    {
        iAtk = 11;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A10, oPC))
    {
        iAtk = 10;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A9, oPC))
    {
        iAtk = 9;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A8, oPC))
    {
        iAtk = 8;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A7, oPC))
    {
        iAtk = 7;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A6, oPC))
    {
        iAtk = 6;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A5, oPC))
    {
        iAtk = 5;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A4, oPC))
    {
        iAtk = 4;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A3, oPC))
    {
        iAtk = 3;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A2, oPC))
    {
        iAtk = 2;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
    {
        iAtk = 1;
    }

    return iAtk;
}

int BrutalStrikeDamage(object oPC)
{
    int iDam = 0;

    if (GetHasFeat(FEAT_BSTRIKE_D12, oPC))
    {
        iDam = DAMAGE_BONUS_12;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D11, oPC))
    {
        iDam = DAMAGE_BONUS_11;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D10, oPC))
    {
        iDam = DAMAGE_BONUS_10;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D9, oPC))
    {
        iDam = DAMAGE_BONUS_9;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D8, oPC))
    {
        iDam = DAMAGE_BONUS_8;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D7, oPC))
    {
        iDam = DAMAGE_BONUS_7;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D6, oPC))
    {
        iDam = DAMAGE_BONUS_6;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D5, oPC))
    {
        iDam = DAMAGE_BONUS_5;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D4, oPC))
    {
        iDam = DAMAGE_BONUS_4;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D3, oPC))
    {
        iDam = DAMAGE_BONUS_3;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D2, oPC))
    {
        iDam = DAMAGE_BONUS_2;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D1, oPC))
    {
        iDam = DAMAGE_BONUS_1;
    }

    return iDam;
}

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int iAttack = BrutalStrikeAttack(oPC);
    int iDamage = BrutalStrikeDamage(oPC);
    int iDamageType = (!GetIsObjectValid(oWeap)) ? DAMAGE_TYPE_BLUDGEONING : GetItemDamageType(oWeap);

    effect eDam = EffectDamageIncrease(iDamage, iDamageType);
    effect eAtk = EffectAttackIncrease(iAttack);
    effect eLink = EffectLinkEffects(eDam, eAtk);
    eLink = ExtraordinaryEffect(eLink);

    RemoveEffectsFromSpell(oPC, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
