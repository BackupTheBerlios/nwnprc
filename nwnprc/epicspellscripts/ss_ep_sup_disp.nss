//::///////////////////////////////////////////////
//:: Epic Spell: Superb Dispelling
//:: Author: Boneshank (Don Armstrong)

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SUP_DIS_DC, SUP_DIS_S, SUP_DIS_XP))
    {
        effect   eVis         = EffectVisualEffect(VFX_IMP_BREACH);
        effect   eImpact      = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
        int      nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        object   oTarget      = GetSpellTargetObject();
        location lLocal       = GetSpellTargetLocation();
        // If this option has been enabled, the caster will take the damage
        // as he/she should in accordance with the ELHB.
        if (BACKLASH_DAMAGE == TRUE)
        {
            effect eCast = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
            int nDam = d6(10);
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_NEGATIVE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF);
            }

        // Superb Dispelling's bonus is capped at caster level 40
        if(nCasterLevel >40 )
            nCasterLevel = 40;

        // Targeted Dispelling
        if (GetIsObjectValid(oTarget))
            spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);

        // Area of Effect - Only dispel best effect
        else
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
            while (GetIsObjectValid(oTarget))
            {
                if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
                    spellsDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);
                else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                else
                    spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
            }
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
