//:://////////////////////////////////////////////
//:: FileName: "ss_ep_spellrefle"
/*   Purpose: Epic Spell Reflection - Grants immunity to all spells level 9 and
        lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "inc_epicspells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

void main()
{
    if (!X2PreSpellCastCode())
    {
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
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eDur), oTarget);
        IPSafeAddItemProperty(oSkin, ipImm);
    }
}
