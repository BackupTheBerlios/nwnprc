//::///////////////////////////////////////////////
//:: True Seeing
//:: NW_S0_TrueSee.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The creature can seen all invisible, sanctuared,
    or hidden opponents.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: [date]
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"

#include "x2_inc_spellhook"
#include "inc_utility"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSight = EffectTrueSeeing();
    if(GetPRCSwitch(PRC_PNP_TRUESEEING))
    {
        eSight = EffectSeeInvisible();
        int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
        if(nSpot == 0)
            nSpot = 15;
        effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
        effect eUltra = EffectUltravision();
        eSight = EffectLinkEffects(eSight, eSpot);
        eSight = EffectLinkEffects(eSight, eUltra);
    }
    effect eLink = EffectLinkEffects(eVis, eSight);
    eLink = EffectLinkEffects(eLink, eDur);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TRUE_SEEING, FALSE));
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Enter Metamagic conditions
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

