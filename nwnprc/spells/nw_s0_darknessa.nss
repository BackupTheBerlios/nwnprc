//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "prc_alterations"
#include "prc_class_const"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
 ActionDoCommand(SetAllAoEInts(SPELL_DARKNESS ,OBJECT_SELF, GetSpellSaveDC()));

    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect eDark = EffectDarkness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);

    effect eLink2 =  EffectLinkEffects(eInvis, eDur);

    effect ePnP = EffectLinkEffects(eDur, EffectBlindness());

    object oTarget = GetEnteringObject();
    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOWLORD,oTarget);

    if (iShadow)
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectUltravision(), oTarget,0.0f,FALSE);
    if (iShadow>1)
      SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectConcealment(20), oTarget,0.0f,FALSE);


    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    

    // * July 2003: If has darkness then do not put it on it again
    // Primogenitor: Yes, what about overlapping darkness effects by different casters?
    if (GetHasEffect(EFFECT_TYPE_DARKNESS, oTarget) == TRUE)
    {
        return;
    }

    if(GetIsObjectValid(oTarget) && oTarget != GetAreaOfEffectCreator())
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        }
        
        if (iShadow)
          SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget,0.0f,FALSE);
        else  
        {
            if(GetPRCSwitch(PRC_PNP_DARKNESS))
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePnP, oTarget,0.0f,FALSE);
            else
                //Fire cast spell at event for the specified target
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);
        }  
    }
    else if (oTarget == GetAreaOfEffectCreator())
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        //Fire cast spell at event for the specified target
        if(GetPRCSwitch(PRC_PNP_DARKNESS))
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePnP, oTarget,0.0f,FALSE);
        else
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget,0.0f,FALSE);
    }

   

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}



