//::///////////////////////////////////////////////
//:: Evards Black Tentacles: Heartbeat
//:: NW_S0_EvardsC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
This spell conjures a field of rubbery black tentacles, each 10 feet long.
These waving members seem to spring forth from the earth, floor, or whatever
surface is underfoot—including water. They grasp and entwine around creatures
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
#include "prc_inc_spells"
#include "prc_alterations"
#include "inc_grapple"
#include "inv_inc_invfunc"

void main()
{
    
 ActionDoCommand(SetAllAoEInts(INVOKE_AOE_EARTHEN_GRASP_GRAPPLE,OBJECT_SELF, GetSpellSaveDC()));


    int nCasterLevel = GetInvokerLevel(GetAreaOfEffectCreator(), CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());
    object oTarget = GetFirstInPersistentObject();
    int StrMod = 2 + nCasterLevel / 3;
        
    while(GetIsObjectValid(oTarget))
    {
        if((spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator())
              && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE
              && !GetLocalInt(OBJECT_SELF, "AlreadyGrappling")
              && !GetLocalInt(oTarget, "SourceOfGrapple"))
            || GetLocalObject(OBJECT_SELF, "CurrentlyGrappling") == oTarget)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(),
                INVOKE_EARTHEN_GRASP));
            
            //now do grappling and stuff
            int nGrappleSucessful = FALSE;
            //this spell doesnt need to make a touch attack
            //as defined in the spell
            int nAttackerGrappleMod = nCasterLevel + StrMod;
            int nDefenderGrappleMod = GetGrappleMod(oTarget);
            nGrappleSucessful = DoGrappleCheck(OBJECT_INVALID, oTarget,
                nAttackerGrappleMod, nDefenderGrappleMod,
                GetStringByStrRef(6341), GetName(oTarget));
            if(nGrappleSucessful)
            {
                //if already being grappled, apply damage
                if(GetLocalObject(OBJECT_SELF, "CurrentlyGrappling") == oTarget)
                {
                    //apply the damage
                    int nDamage = d6();
                    nDamage += StrMod;
                    effect eDam = PRCEffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
                //now being grappled
                AssignCommand(oTarget, ClearAllActions());
                effect eHold = EffectCutsceneImmobilize();
                effect eEntangle = EffectVisualEffect(VFX_DUR_SPELLTURNING_R);
                effect eLink = EffectLinkEffects(eHold, eEntangle);
                //eLink = EffectKnockdown();
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
                SetLocalInt(OBJECT_SELF, "AlreadyGrappling", TRUE);
                SetLocalObject(OBJECT_SELF, "CurrentlyGrappling", oTarget);
            }
            else
            {
                DeleteLocalInt(OBJECT_SELF, "AlreadyGrappling");
                DeleteLocalObject(OBJECT_SELF, "CurrentlyGrappling");
            }
        }
        oTarget = GetNextInPersistentObject();
    }


}
