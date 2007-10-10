#include "prc_spell_const"
#include "prc_feat_const"
#include "prc_alterations"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int iDamageType = (!GetIsObjectValid(oRight)) ? DAMAGE_TYPE_BASE_WEAPON : GetItemDamageType(oRight);
    int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    int nBonus = (nInt > 5) ? nInt + 10 : nInt;     //more efficient int conversion

    RemoveEffectsFromSpell(oPC, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(nBonus, iDamageType), oPC);
}