//:://////////////////////////////////////////////
//:: FileName: "ss_ep_spellrefle"
/*   Purpose: Epic Spell Reflection - Grants immunity to all spells level 9 and
        lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_epicspells"
#include "x2_inc_spellhook"
//#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, EP_SP_R_DC, EP_SP_R_S, EP_SP_R_XP))
    {
        object oTarget = GetSpellTargetObject();
        object oSkin;
        effect eVis = EffectVisualEffect(VFX_FNF_PWSTUN);
        effect eImp = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
        effect eDur = EffectVisualEffect(VFX_DUR_SPELLTURNING);
        itemproperty ipImm = ItemPropertyImmunityToSpellLevel(9);
        EnsurePCHasSkin(oTarget);
        oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eDur), oTarget);
        IPSafeAddItemProperty(oSkin, ipImm);
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
