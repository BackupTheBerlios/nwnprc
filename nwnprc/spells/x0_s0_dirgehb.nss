//::///////////////////////////////////////////////
//:: Dirge: Heartbeat
//:: x0_s0_dirgeHB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
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

    object oTarget;
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
     PRCDoDirgeEffect(oTarget,nPenetr);
        //Get next target.
    oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}


