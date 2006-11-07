//::///////////////////////////////////////////////
//:: Obscuring Mist
//:: sp_obscmist.nss
//:://////////////////////////////////////////////
/*
    All people within the AoE get 20% conceal.
*/
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
 ActionDoCommand(SetAllAoEInts(SPELL_OBSCURING_MIST, OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage;
    effect eDam;
    object oTarget;
    effect eVis2 = EffectVisualEffect(VFX_DUR_ENTROPIC_SHIELD);
    effect eLink = EffectLinkEffects(eVis2, EffectConcealment(20));
    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_OBSCURING_MIST));

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
