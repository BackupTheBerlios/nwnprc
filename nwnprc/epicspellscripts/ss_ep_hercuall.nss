/////////////////////////////////////////////////
// Herculean Alliance
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/06/2004
// Description: This script changes someone's ability scores
/////////////////////////////////////////////////
/*
    Boneshank - copied Herculean Empowerment, and converted to area/ally spell.
*/

#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "inc_epicspells"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, HERCALL_DC, HERCALL_S, HERCALL_XP))
    {
        //Declare major variables
        int nCasterLvl = GetTotalCastingLevel(OBJECT_SELF); // Boneshank - changed.
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0,
            GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            if (GetFactionEqual(oTarget, OBJECT_SELF))
            {
                int nModify = d4() + 5;
                float fDuration = HoursToSeconds(nCasterLvl);
                effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nModify);
                effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,nModify);
                effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,nModify);

                //Signal the spell cast at event
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

                //Link major effects
                effect eLink = EffectLinkEffects(eStr, eDex);
                eLink = EffectLinkEffects(eLink, eCon);
                eLink = EffectLinkEffects(eLink, eDur);

                // * Making extraodinary so cannot be dispelled (optional)
                eLink = ExtraordinaryEffect(eLink);

                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0,
                GetSpellTargetLocation());
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
