//:://////////////////////////////////////////////
//:: FileName: "ss_ep_impenetrab"
/*   Purpose: Impenetrability - grants 100% protection against piercing
        damage for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "inc_epicspells"
#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, IMPENET_DC, IMPENET_S, IMPENET_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDuration = 24;
        effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
        effect eDur = EffectVisualEffect(VFX_DUR_GLOW_PURPLE);
        effect eProt = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
        effect eLink = EffectLinkEffects(eProt, eDur);
        // if this option has been enabled, the caster will take backlash damage
        if (BACKLASH_DAMAGE == TRUE)
        {
            int nDamage = d6(10);
            effect eDamVis = EffectVisualEffect(VFX_IMP_SONIC);
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
            DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                eDamVis, OBJECT_SELF));
            DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                eDam, OBJECT_SELF));
        }
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(),
                FALSE));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                eLink, oTarget, HoursToSeconds(nDuration));
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
