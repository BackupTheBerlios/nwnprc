//::///////////////////////////////////////////////
//:: Epic Ward
//:: X2_S2_EpicWard.
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the caster invulnerable to damage
    (equals damage reduction 50/+20)
    Lasts 1 round per level
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Aug 12, 2003
//:://////////////////////////////////////////////
/*
    Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/

#include "nw_i0_spells"
#include "inc_epicspells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, EP_WARD_DC, EP_WARD_S, EP_WARD_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDuration = GetTotalCastingLevel(OBJECT_SELF);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        int nLimit = 50*nDuration;
        effect eDur = EffectVisualEffect(495);
        effect eProt = EffectDamageReduction(50, DAMAGE_POWER_PLUS_TWENTY, nLimit);
        effect eLink = EffectLinkEffects(eDur, eProt);
        eLink = EffectLinkEffects(eLink, eDur);

        // * Brent, Nov 24, making extraodinary so cannot be dispelled
        eLink = ExtraordinaryEffect(eLink);

        RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());
        //Apply the armor bonuses and the VFX impact
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }
}
