//::///////////////////////////////////////////////
//:: Sleep
//:: NW_S0_Sleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Goes through the area and sleeps the lowest 4+d4
    HD of creatures first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 7 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"
#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void DoSleepCheck(object oTarget, int nSleepCheck, object oCaster)
{
    if(nSleepCheck != GetLocalInt(oTarget, "nSleepCheck"))
        return;
        
    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (nDC), SAVING_THROW_TYPE_MIND_SPELLS))
    {
        DelayCommand(HoursToSeconds(24), DoSleepCheck(oTarget, nSleepCheck, oCaster));
    }
    else
    {
        DeleteLocalInt(oTarget, "PainfulSleep");
        RemoveSpellEffects(INVOKE_PAINFUL_SLUMBER_OF_AGES, oCaster, oTarget);
        RemoveEventScript(oTarget, EVENT_ONHEARTBEAT, "inv_painsleep", FALSE, FALSE);
    }
}

void main()
{
    if (!PreInvocationCastCode()) return;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eSleep =  EffectSleep();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);

    effect eLink = EffectLinkEffects(eSleep, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

     // * Moved the linking for the ZZZZs into the later code
     // * so that they won't appear if creature immune

    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());

    int nPenetr = CasterLvl + SPGetPenetr();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);
    
    //Get the first target in the spell area
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_PAINFUL_SLUMBER_OF_AGES));
    //Make SR check
    if (!MyPRCResistSpell(OBJECT_SELF, oTarget, nPenetr))
    {
        int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
        //Make Will save
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (nDC), SAVING_THROW_TYPE_MIND_SPELLS))
        {
            if (GetIsImmune(oTarget, IMMUNITY_TYPE_SLEEP) == FALSE)
            {
                effect eLink2 = EffectLinkEffects(eLink, eVis);
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget, 0.0,TRUE,-1,CasterLvl);
                SetLocalInt(oTarget, "PainfulSleep", CasterLvl);
                ExecuteScript("inv_painsleep", oTarget);
                //set up the 24 hour saving throws
                int nSleepCheck = GetLocalInt(oTarget, "nSleepCheck");
                if(nSleepCheck > 30) nSleepCheck = 1;
                SetLocalInt(oTarget, "nSleepCheck", nSleepCheck);
                DelayCommand(HoursToSeconds(24), DoSleepCheck(oTarget, nSleepCheck, OBJECT_SELF));
            }
            else
            // * even though I am immune apply just the sleep effect for the immunity message
            {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oTarget, 6.0,TRUE,-1,CasterLvl);
            }
        }
    }
    
}
