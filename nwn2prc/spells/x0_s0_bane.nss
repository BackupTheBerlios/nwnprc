//::///////////////////////////////////////////////
//:: Bane
//:: X0_S0_Bane.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All enemies within 30ft of the caster gain a
    -1 attack penalty and a -1 save penalty vs fear
    effects
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 24, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "X0_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    effect eAttack = EffectAttackDecrease(1);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDuration = CasterLvl;
    int nCasterLvl = CasterLvl + SPGetPenetr();
    
    
    int nMetaMagic = GetMetaMagicFeat();
    float fDelay;
    //Metamagic duration check
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    location lLoc = GetSpellTargetLocation();
    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lLoc);

    //Get the first target in the radius around the caster
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget,SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
             //Fire spell cast at event for target
             SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 449, FALSE));
             if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLvl) )
             {

                int nSpellDC = (PRCGetSaveDC(oTarget,OBJECT_SELF)) ;
                /*Will Save*/
                int nWillResult = WillSave(oTarget, nSpellDC, SAVING_THROW_TYPE_MIND_SPELLS);
                // * Bane is a mind affecting spell BUT its affects are not classified
                // * as mind affecting. To make this work I have to only apply
                // * the effects on the case of a failure, unlike most other spells.
                if (nWillResult == 0)
                {

                    fDelay = GetRandomDelay(0.4, 1.1);
                    //Apply VFX impact and bonus effects
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl));
                }
                else
                // * target will immune
                if (nWillResult == 2)
                {
                    SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
                }

            }
        }
        //Get the next target in the specified area around the caster
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
    }
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}


