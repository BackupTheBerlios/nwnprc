//:://////////////////////////////////////////////
//:: FileName: "ss_ep_singsunder"
/*   Purpose: Singular Sunder - spell target's an enemy's equipment, and
        irrevocably destroys a single item, on a failed will save.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
//#include "prc_alterations"

object GetSunderTarget(object oTarget);

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SINGSUN_DC, SINGSUN_S, SINGSUN_XP))
    {
        object oTarget = GetSpellTargetObject();
        int nDC = /*GetEpicSpellSaveDC(OBJECT_SELF) + */ GetChangesToSaveDC() +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, SINGSUN_S);
        effect eImp = EffectVisualEffect(VFX_IMP_BREACH);
        effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
        object oItem = GetSunderTarget(oTarget);
        // Does the target have an equipped item to sunder?
        if (oItem != OBJECT_INVALID)
        {
            // SR check.
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget, 0))
            {
                // Will save.
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
                {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DestroyObject(oItem, 1.0);
                }
            }
        }
        else
            SendMessageToPC(OBJECT_SELF,
                "That creature has nothing equipped to sunder!");
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

object GetSunderTarget(object oTarget)
{
    object oItem = OBJECT_INVALID;
    object oTemp;
    // Search for item hierarchy, lowest to highest priority, and non-plot.
    oTemp = GetItemInSlot(12, oTarget); // Bullets
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(13, oTarget); // Bolts
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(11, oTarget); // Arrows
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(7, oTarget); // Left ring
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(8, oTarget); // Right ring
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(0, oTarget); // Helmet
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(10, oTarget); // Belt
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(2, oTarget); // Boots
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(6, oTarget); // Cloak
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(9, oTarget); // Neck
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(3, oTarget); // Arms (gauntlets)
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(5, oTarget); // Left (off) hand
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(1, oTarget); // Armor
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    oTemp = GetItemInSlot(4, oTarget); // Right (main) hand
    if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
    return oItem;
}

