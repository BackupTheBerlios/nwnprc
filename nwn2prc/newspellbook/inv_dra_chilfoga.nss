//Entry script for Chilling Fog

#include "prc_alterations"
#include "inv_inc_invfunc"

void main()
{
 ActionDoCommand(SetAllAoEInts(INVOKE_AOE_CHILLFOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eSlow = EffectMovementSpeedDecrease(80);
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConceal2 = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eHitReduce = EffectAttackDecrease(2);
    effect eDamReduce = EffectDamageDecrease(2);
    
    int nDamage = d6(2);
    effect eDamage = EffectDamage(nDamage);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
   
    // Link
    effect eLink = EffectLinkEffects(eConceal, eConceal2);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eMiss);
    eLink = EffectLinkEffects(eLink, eHitReduce);
    eLink = EffectLinkEffects(eLink, eDamReduce);
    
    effect eLink2 = EffectLinkEffects(eDamage, eVis);

    //Fire cast spell at event for the target
    SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), INVOKE_CHILLING_FOG));

    // Maximum time possible. If its less, its simply cleaned up when the utterance ends.
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(40));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
}
