//::///////////////////////////////////////////////
//:: Invocation: Devil's Sight
//:: NW_S0_IDvlSight.nss
//:://////////////////////////////////////////////
/*
    Caster gains Darkvision/Ultravision for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "nw_i0_spells"

#include "x2_inc_spellhook" 

void main()
{

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
    object oTarget = GetSpellTargetObject();
    float fDuration = HoursToSeconds(24);  // Note: Might change this to Permanent?

    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    effect eDark = EffectDarkVision();
    effect eLink = EffectLinkEffects(eVis, eDark);
    //eLink = EffectLinkEffects(eLink, eDark);
    //effect eVis2 = EffectVisualEffect(VFX_DUR_ULTRAVISION);
    effect eUltra = EffectUltravision();
    //eLink = EffectLinkEffects(eLink, eVis2);
    eLink = EffectLinkEffects(eLink, eUltra);

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}