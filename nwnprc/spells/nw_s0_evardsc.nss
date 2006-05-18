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
#include "spinc_common"


#include "prc_alterations"
#include "x2_inc_spellhook"
#include "inc_grapple"


void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
 ActionDoCommand(SetAllAoEInts(SPELL_EVARDS_BLACK_TENTACLES,OBJECT_SELF, GetSpellSaveDC()));


    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator())
            && GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(),
                SPELL_EVARDS_BLACK_TENTACLES));
            //now do grappling and stuff
            int nGrappleSucessful = FALSE;
            //this spell doesnt need to make a touch attack
            //as defined in the spell
            int nAttackerGrappleMod = nCasterLevel+4+4;
            nGrappleSucessful = DoGrappleCheck(OBJECT_INVALID, oTarget, 
                nAttackerGrappleMod, 0, 
                GetStringByStrRef(6341), "");
            if(nGrappleSucessful)
            {
                //if already being grappled, apply damage
                if(GetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF)))
                {
                    //apply the damage
                    int nDamage = d6();
                    if(nMetaMagic == METAMAGIC_MAXIMIZE)
                        nDamage = 6;
                    if(nMetaMagic == METAMAGIC_EMPOWER)
                        nDamage += d6()/2;
                    nDamage += 4;
                    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
                //now being grappled
                AssignCommand(oTarget, ClearAllActions());
                effect eHold = EffectEntangle();
                effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
                effect eLink = EffectLinkEffects(eHold, eEntangle);
                //eLink = EffectKnockdown();
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
                SetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF),
                    GetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF))+1);
                DelayCommand(6.1,
                    SetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF),
                        GetLocalInt(oTarget, "GrappledBy_"+ObjectToString(OBJECT_SELF))-1));
            }
        }
        oTarget = GetNextInPersistentObject();
    }
    
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
