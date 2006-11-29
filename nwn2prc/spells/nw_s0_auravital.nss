//::///////////////////////////////////////////////
//:: Aura of Vitality
//:: NW_S0_AuraVital
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within the AOE gain +4 Str, Con, Dex
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"


#include "prc_alterations"

#include "x2_inc_spellhook"

void main()
{
     SPSetSchool(GetSpellSchool(PRCGetSpellId()));
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
    object oTarget;
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,4);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,4);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,4);

    effect eLink = EffectLinkEffects(eStr, eDex);
    eLink = EffectLinkEffects(eLink, eCon);

    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AURA_OF_VITALITY);
    eLink = EffectLinkEffects(eLink, eVis);
    // effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nSpellID = PRCGetSpellId();
    
    float fDelay;

    int nMetaMagic = PRCGetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration *= 2; //Duration is +100%
    }
    
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Signal the spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
            //Apply effects and VFX to target
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE, nSpellID,CasterLvl));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    SPSetSchool();
}
