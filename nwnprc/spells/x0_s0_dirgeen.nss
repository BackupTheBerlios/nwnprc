//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.

    **EDITED Nov 18/02 - Keith Warner**
    Only enemies should take the dirge damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"
#include "x2_inc_spellhook"

//::///////////////////////////////////////////////
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies the ability score damage of the dirge effect.

    March 2003
    Because ability score penalties do not stack, I need
    to store the ability score damage done
    and increment each round.
    To that effect I am going to update the description and
    remove the dirge effects if the player leaves the area of effect.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void PRCDoDirgeEffect(object oTarget,int nPenetr)
{    //Declare major variables
//    int nMetaMagic = PRCGetMetaMagicFeat();

   // SpawnScriptDebugger();

    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), PRCGetSpellId()));
        //Spell resistance check
        if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        {

            //Make a Fortitude Save to avoid the effects of the movement hit.
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,GetAreaOfEffectCreator()), SAVING_THROW_ALL, GetAreaOfEffectCreator()))
            {
                int nGetLastPenalty = GetLocalInt(oTarget, "X0_L_LASTPENALTY");
                // * increase penalty by 2
                nGetLastPenalty = nGetLastPenalty + 2;

                //effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nGetLastPenalty);
                //effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nGetLastPenalty);
                //change from sonic effect to bard song...
                effect eVis =    EffectVisualEffect(VFX_FNF_SOUND_BURST);
                //effect eLink = EffectLinkEffects(eDex, eStr);

                //Apply damage and visuals
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nGetLastPenalty, DURATION_TYPE_PERMANENT, TRUE);
                ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, nGetLastPenalty, DURATION_TYPE_PERMANENT, TRUE);
                SetLocalInt(oTarget, "X0_L_LASTPENALTY", nGetLastPenalty);
            }

        }
    }
}

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

ActionDoCommand(SetAllAoEInts(SPELL_DIRGE,OBJECT_SELF, GetSpellSaveDC()));

   int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());



    PRCDoDirgeEffect(GetEnteringObject(),nPenetr);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}



