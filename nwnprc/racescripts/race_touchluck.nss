/* Glimmerskin Halfling's "Touch of Luck"
   +2 to the saving throw of an ally within 30'*/

#include "prc_sp_func"


void main()
{

    object oHalfling = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oHalfling, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, 6.0,TRUE,-1,0);
        
}