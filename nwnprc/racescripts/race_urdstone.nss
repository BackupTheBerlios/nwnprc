/*
    Urdinnir Stoneskin
*/

#include "spinc_common"
#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    effect eStone;
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink;
    object oTarget = GetSpellTargetObject();
    int CasterLvl = 4;
    int nAmount = CasterLvl * 10;
    int nDuration = CasterLvl;

    //Define the damage reduction effect
    eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nAmount);
    //Link the effects
    eLink = EffectLinkEffects(eStone, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    RemoveEffectsFromSpell(oTarget, SPELL_STONESKIN);

    //Apply the linked effects.
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);
}
