//::///////////////////////////////////////////////
//:: Darkness: On Exit
//:: NW_S0_DarknessB.nss
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
#include "prc_alterations"
#include "prc_feat_const"
#include "x2_inc_spellhook"
#include "spinc_common"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
 ActionDoCommand(SetAllAoEInts(SPELL_DARKNESS ,OBJECT_SELF, GetSpellSaveDC()));

    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();
DoDebug(GetName(oTarget)+" is leaving "+GetName(oCreator)+"'s darkness effect");

    int bValid = FALSE;
    effect eAOE;
    //Search through the valid effects on the target.
    eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        int nType = GetEffectType(eAOE);
        int nID = GetEffectSpellId(eAOE);
        if( (nID== SPELL_DARKNESS 
                || nID == SPELLABILITY_AS_DARKNESS  
                || nID == SPELL_SHADOW_CONJURATION_DARKNESS 
                || nID == 688 //bioware SLA darkness 
                || nID == SHADOWLORD_DARKNESS 
                || nID == SPELL_RACE_DARKNESS
                || nID == SPELL_DEEPER_DARKNESS)
            && (GetEffectCreator(eAOE) == oCreator)
            && nType != EFFECT_TYPE_AREA_OF_EFFECT
                )
        {
DoDebug(GetName(oTarget)+" has an effect from "+GetName(oCreator)+"'s darkness effect");
            RemoveEffect(oTarget, eAOE);
        }

        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
