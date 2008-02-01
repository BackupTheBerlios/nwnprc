/* Resiliance racial ability for Elans
   Piggybacks on the Psionic system as a "fake manifestation" similar to Diamond Dragons 
   To simulate damage prevention adds Temp HP for 1 round.*/

#include "psi_inc_psifunc"
#include "prc_sp_func"


void main()
{

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
         EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(1,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              1 //base cost is 1 PP
                              );
                              
    effect eHP = EffectTemporaryHitpoints((1 + manif.nTimesAugOptUsed_1) * 2);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oManifester, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, 6.0,TRUE,-1,0);
}