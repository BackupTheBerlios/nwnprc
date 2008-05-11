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
tentacles. Even creatures who aren�t grappling with the tentacles may move
through the area at only half normal speed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book
//:: Primogenitor: Implemented 3.5ed rules

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
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
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator(), nCasterLevel);
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator())
        && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(),
            INVOKE_CHILLING_TENTACLES));
        //Apply reduced movement effect and VFX_Impact
        //firstly, make them half-speed
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectMovementSpeedDecrease(50), oTarget);
        
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        {
            //apply cold damage
            effect eColdDamage = EffectDamage(d6(2), DAMAGE_TYPE_COLD);
            eColdDamage = EffectLinkEffects(eColdDamage, EffectVisualEffect(VFX_IMP_FROST_S));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eColdDamage, oTarget);
        }
            
        //now do grappling and stuff
        //cant already be grappled so no need to check that
        int nGrappleSucessful = FALSE;
        //this spell doesnt need to make a touch attack
        //as defined in the spell
        int nAttackerGrappleMod = nCasterLevel+4+4;
        nGrappleSucessful = DoGrappleCheck(OBJECT_INVALID, oTarget,
            nAttackerGrappleMod, 0,
            "Chilling Tentacles", "");
        if(nGrappleSucessful)
        {
            //now being grappled
            AssignCommand(oTarget, ClearAllActions());
            effect eHold = EffectCutsceneImmobilize();
            effect eEntangle = EffectVisualEffect(VFX_DUR_SPELLTURNING_R);
            effect eLink = EffectLinkEffects(eHold, eEntangle);
            //eLink = EffectKnockdown();
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
            SetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF),
                GetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF))+1);
            DelayCommand(6.1, DecrementTentacleCount(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF)));
        }
    }

}