//::///////////////////////////////////////////////
//:: Evards Black Tentacles: On Enter
//:: NW_S0_EvardsA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
This spell conjures a field of rubbery black tentacles, each 10 feet long.
These waving members seem to spring forth from the earth, floor, or whatever
surface is underfoot including water. They grasp and entwine around creatures
that enter the area, holding them fast and crushing them with great strength.
Every creature within the area of the spell must make a grapple check, opposed
by the grapple check of the tentacles. Treat the tentacles attacking a particular
target as a Large creature with a base attack bonus equal to your caster level
and a Strength score of 19. Thus, its grapple check modifier is equal to your
caster level +8. The tentacles are immune to all types of damage.
Once the tentacles grapple an opponent, they may make a grapple check each round
on your turn to deal 1d6+4 points of bludgeoning damage. The tentacles continue
to crush the opponent until the spell ends or the opponent escapes.
Any creature that enters the area of the spell is immediately attacked by the
tentacles. Even creatures who aren’t grappling with the tentacles may move
through the area at only half normal speed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book
//:: Primogenitor: Implemented 3.5ed rules

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_inc_spells"
#include "prc_alterations"
#include "inc_grapple"
#include "inv_inc_invfunc"

void DecrementTentacleCount(object oTarget, string sVar)
{
    SetLocalInt(oTarget, sVar, GetLocalInt(oTarget, sVar) - 1);
}

void main()
{
ActionDoCommand(SetAllAoEInts(INVOKE_CHILLING_TENTACLES,OBJECT_SELF, GetSpellSaveDC()));

    object oTarget = GetEnteringObject();
    int nCasterLevel = GetInvokerLevel(GetAreaOfEffectCreator(), CLASS_TYPE_WARLOCK);
    
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectConcealment(50), oTarget);
    
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator())
        && oTarget != GetAreaOfEffectCreator()
        && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(),
            INVOKE_NIGHTMARES_MADE_REAL));
        
        //save
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oTarget, GetAreaOfEffectCreator(), INVOKE_NIGHTMARES_MADE_REAL), SAVING_THROW_TYPE_SPELL))
		{
            effect eEntangle = EffectLinkEffects(EffectEntangle(), EffectVisualEffect(VFX_DUR_ENTANGLE));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEntangle, oTarget, RoundsToSeconds(nCasterLevel));
        }
    }
    
    if(oTarget != GetAreaOfEffectCreator())
    {
        itemproperty iHide = ItemPropertyBonusFeat(31); //HIPS
        object oSkin = GetPCSkin(GetAreaOfEffectCreator());
        IPSafeAddItemProperty(oSkin, iHide, RoundsToSeconds(nCasterLevel), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
    }

}
