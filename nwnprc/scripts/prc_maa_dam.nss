#include "prc_spell_const"
#include "prc_feat_const"
#include "prc_alterations"
#include "prc_alterations"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iDamageType = (!GetIsObjectValid(oWeap)) ? DAMAGE_TYPE_BLUDGEONING : GetItemDamageType(oWeap);
    
    RemoveEffectsFromSpell(oPC, GetSpellId());
    
    int iBonus = GetHasFeat(FEAT_LEGENDARY_PROWESS, oPC) ? 3 : 1;
    
    effect eDam = EffectDamageIncrease(iBonus, iDamageType);
    effect eAtk = EffectAttackIncrease(iBonus);
    effect eLink = EffectLinkEffects(eDam, eAtk);
    eLink = ExtraordinaryEffect(eLink);
    
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
