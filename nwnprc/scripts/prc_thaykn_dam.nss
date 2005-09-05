#include "prc_spell_const"
#include "prc_alterations"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iDamageType = (!GetIsObjectValid(oWeap)) ? DAMAGE_TYPE_BLUDGEONING : GetItemDamageType(oWeap);

    RemoveEffectsFromSpell(oPC, GetSpellId());

    effect eDam = EffectDamageIncrease(DAMAGE_BONUS_2, iDamageType);
    effect eAtk = EffectAttackIncrease(2);
    effect eLink = EffectLinkEffects(eDam, eAtk);
    eLink = ExtraordinaryEffect(eLink);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
