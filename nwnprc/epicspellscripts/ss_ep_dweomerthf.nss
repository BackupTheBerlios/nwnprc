//:://////////////////////////////////////////////
//:: FileName: "ss_ep_dweomerthf"
/*   Purpose: Dweomer Thief - the target loses a spell from the highest level,
        which subsequently turns into a scroll in the caster's inventory.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
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
    if (GetCanCastSpell(OBJECT_SELF, DWEO_TH_DC, DWEO_TH_S, DWEO_TH_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nTargetSpell;
        int nSpellDC = GetEpicSpellSaveDC(OBJECT_SELF) + 5 + GetChangesToSaveDC() +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, DWEO_TH_S);
        effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);
        effect eVis2 = EffectVisualEffect(VFX_IMP_DOOM);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
            oTarget != OBJECT_SELF)
        {
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget, 0))
            {
                 if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC,
                    SAVING_THROW_TYPE_NONE))
                 {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eVis, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                        eVis2, oTarget);
                    nTargetSpell = GetBestAvailableSpell(oTarget);
                    if (nTargetSpell != 99999)
                    {
                        int nSpellIP = StringToInt(Get2DAString
                            ("des_crft_spells", // Name of the 2DA file.
                            "IPRP_SpellIndex",  // The column.
                            nTargetSpell));     // The row.
                        object oScroll = CreateItemOnObject("it_dweomerthief",
                            OBJECT_SELF);
                        AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyCastSpell(nSpellIP,
                                IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE),
                                oScroll);
                        DecrementRemainingSpellUses(oTarget, nTargetSpell);
                    }
                 }
            }
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

