//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTideA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create an aura that steals energy from your
    enemies. Your enemies suffer a -2 circumstance
    penalty on saves, attack rolls, and damage rolls,
    once entering the aura. On casting, you gain a
    +2 circumstance bonus to your saves, attack rolls,
    and damage rolls.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs 06/06/03

//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"
#include "prc_add_spell_dc"

//::///////////////////////////////////////////////
//:: PRCCreateBadTideEffectsLink
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates the linked bad effects for Battletide.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

effect PRCCreateBadTideEffectsLink()
{
    //Declare major variables
    effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link the effects
    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eDur);

    return eLink;
}

//::///////////////////////////////////////////////
//:: PRCCreateGoodTideEffectsLink
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates the linked good effects for Battletide.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

effect PRCCreateGoodTideEffectsLink()
{
    //Declare major variables
    effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    //Link the effects
    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eDur);

    return eLink;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
ActionDoCommand(SetAllAoEInts(SPELL_BATTLETIDE,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    effect eLink = PRCCreateBadTideEffectsLink();
    effect eLink2 = PRCCreateGoodTideEffectsLink();
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eFind;
    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();
    float fDelay;
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());


    //Check faction of spell targets.
    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
        //Make a SR check
        if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        {
            //Make a Fort Save
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,GetAreaOfEffectCreator())), SAVING_THROW_TYPE_NEGATIVE))
            {
               fDelay = GetRandomDelay(0.75, 1.75);
               //Apply the VFX impact and linked effects
               DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE));
            }
        }
    }
    else if(oTarget == oCreator)
    {
        //Apply the VFX impact and linked effects
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget,0.0f,FALSE);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
