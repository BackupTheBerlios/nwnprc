//::///////////////////////////////////////////////
//:: Epic Spell: Godsmite
//:: Author: Boneshank (Don Armstrong)

//#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "inc_epicspells"
//#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, GODSMIT_DC, GODSMIT_S, GODSMIT_XP))
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nSpellPower = GetTotalCastingLevel(OBJECT_SELF);

        int nDam, nDamGoodEvil, nDamLawChaos, nCount;
        location lTarget;

        int nSpellDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetDCSchoolFocusAdjustment(OBJECT_SELF, GODSMIT_S) + GetChangesToSaveDC(oTarget,OBJECT_SELF);

        // if this option has been enabled, the caster will take backlash damage
        if (BACKLASH_DAMAGE == TRUE)
        {
            effect eCast = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
            int nDamage = d4(nSpellPower);
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
            DelayCommand(3.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, OBJECT_SELF));
            DelayCommand(3.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF));
        }

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Roll damage
        if (GetAlignmentGoodEvil(OBJECT_SELF) != GetAlignmentGoodEvil(oTarget))
        { nDamGoodEvil = d8(nSpellPower); }
        else if (GetAlignmentGoodEvil(OBJECT_SELF) != GetAlignmentGoodEvil(oTarget) &&
            (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_NEUTRAL ||
            GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL))
        { nDamGoodEvil = d6(nSpellPower); }
        else
        { nDamGoodEvil = d4(nSpellPower); }
        if (GetAlignmentLawChaos(OBJECT_SELF) != GetAlignmentLawChaos(oTarget))
        { nDamLawChaos = d8(nSpellPower); }
        else if (GetAlignmentLawChaos(OBJECT_SELF) != GetAlignmentLawChaos(oTarget) &&
            (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_NEUTRAL ||
            GetAlignmentLawChaos(oTarget) == ALIGNMENT_NEUTRAL))
        { nDamLawChaos = d6(nSpellPower); }
        else
        { nDamLawChaos = d6(nSpellPower); }
        nDam = nDamGoodEvil + nDamLawChaos;

        //Set damage effect

        if (MySavingThrow(SAVING_THROW_FORT,oTarget,nSpellDC,SAVING_THROW_TYPE_SPELL,OBJECT_SELF) != 0 )
        {
            nDam /=2;
        }

        effect eDam = EffectDamage(nDam, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_PLUS_TWENTY);
        lTarget = GetRandomLocation(GetArea(oTarget), oTarget, 4.0);
        DelayCommand(0.4, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(GetArea(oTarget), oTarget, 3.5);
        DelayCommand(0.8, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(GetArea(oTarget), oTarget, 3.0);
        DelayCommand(1.2, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(GetArea(oTarget), oTarget, 2.5);
        DelayCommand(1.6, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(GetArea(oTarget), oTarget, 2.0);
        DelayCommand(2.0, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(GetArea(oTarget), oTarget, 1.5);
        DelayCommand(2.4, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(GetArea(oTarget), oTarget, 1.0);
        DelayCommand(2.7, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        lTarget = GetRandomLocation(GetArea(oTarget), oTarget, 0.5);
        DelayCommand(3.0, ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lTarget));
        ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND), oTarget, 0.75);
        DelayCommand(0.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND), oTarget, 1.0));
        DelayCommand(1.75, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST), oTarget, 0.75));
        DelayCommand(2.5, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND), oTarget, 1.0));
        DelayCommand(3.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_DIVINE), oTarget));
        DelayCommand(3.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM), oTarget));
        DelayCommand(3.1, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
