//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an area of effect that will cover the
    creature with a stone shell holding them in
    place.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: August  2003
//:: Updated   : October 2003
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"




#include "prc_add_spell_dc"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
ActionDoCommand(SetAllAoEInts(SPELL_STONEHOLD,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nRounds;
    effect eHold = EffectParalyze();
    effect eDur = EffectVisualEffect(476  );
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eLink = EffectLinkEffects(eDur,eHold);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());
    


    //Get the first object in the persistant area
    oTarget = GetEnteringObject();
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONEHOLD));
        //Make a SR check
            if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
            {
                int nDC = PRCGetSaveDC(oTarget,GetAreaOfEffectCreator());
                //Make a Fort Save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (nDC), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                   nRounds = PRCMaximizeOrEmpower(6, 1, nMetaMagic);
                   fDelay = GetRandomDelay(0.45, 1.85);
                   //Apply the VFX impact and linked effects
                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nRounds),FALSE));
                }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
