#include "nw_i0_spells"

void main ()
{
    object oPC = GetSpellTargetObject();
    
    int iPen = GetLocalInt(oPC, "UnarmedAttackPenalty");
    
    effect ePen = EffectAttackDecrease(iPen);
    ePen = SupernaturalEffect(ePen);

    RemoveEffectsFromSpell(oPC, GetSpellId());
    
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePen, oPC);
}