//::///////////////////////////////////////////////
//:: Epic Spell: Greater Spell Resistance
//:: Author: Boneshank (Don Armstrong)

#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "inc_dispel"
//#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, GR_SP_RE_DC, GR_SP_RE_S, GR_SP_RE_XP))
    {
        object oTarget = GetSpellTargetObject();
        effect eSR = EffectSpellResistanceIncrease(35);
        effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eDur2 = EffectVisualEffect(249);
        effect eLink = EffectLinkEffects(eSR, eDur);
        eLink = EffectLinkEffects(eLink, eDur2);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPELL_RESISTANCE, FALSE));
        //Apply VFX impact and SR bonus effect
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(20));
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
