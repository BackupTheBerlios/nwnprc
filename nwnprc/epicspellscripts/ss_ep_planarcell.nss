//:://////////////////////////////////////////////
//:: FileName: "ss_ep_planarcell"
/*   Purpose: Planar Cell - You must cast this spell on the ground somewhere to
        assign a "Cell" location. Then you can cast it on creatures to teleport
        them to the cell, even across the planes.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "inc_epicspells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "prc_alterations"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, PLANCEL_DC, PLANCEL_S, PLANCEL_XP))
    {
        object oTarget = GetSpellTargetObject();
        location lTarget = GetSpellTargetLocation();
        location lCell;
        int nDC = GetEpicSpellSaveDC(OBJECT_SELF) +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, PLANCEL_S);
        effect eVis1 = EffectVisualEffect(VFX_FNF_IMPLOSION);
        effect eVis2 = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
        // If there is a cell location, and the target is a valid creature.
        if (GetLocalInt(OBJECT_SELF, "nHasPlanarCell") == TRUE &&
            oTarget != OBJECT_INVALID &&
            oTarget != OBJECT_SELF &&
            !GetIsDM(oTarget))
        {
            lCell = GetLocalLocation(OBJECT_SELF, "lPlanarCell");
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget, 0))
            {
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
                {
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis1, lTarget);
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget);
                    DelayCommand(1.0,
                        AssignCommand(oTarget, JumpToLocation(lCell)));
                    DelayCommand(1.0,
                        AssignCommand(oTarget, ActionDoCommand(ClearAllActions(TRUE))));
                    DelayCommand(1.0,
                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis1, lCell));
                    DelayCommand(1.0,
                        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lCell));
                }
            }
        }
        // If no cell location known, or the target is not a creature,
        //      assign the target location as the cell.
        if (GetLocalInt(OBJECT_SELF, "nHasPlanarCell") != TRUE &&
            oTarget == OBJECT_INVALID)
        {
            SetLocalInt(OBJECT_SELF, "nHasPlanarCell", TRUE);
            SetLocalLocation(OBJECT_SELF, "lPlanarCell", lTarget);
            SendMessageToPC(OBJECT_SELF, "The planar cell is prepared.");
            SendMessageToPC(OBJECT_SELF,
                "You can now teleport creatures to the cell's location.");
        }
        // If the target is yourself, delete the planar cell's location.
        if (GetLocalInt(OBJECT_SELF, "nHasPlanarCell") == TRUE &&
            oTarget == OBJECT_SELF)
        {
            SetLocalInt(OBJECT_SELF, "nHasPlanarCell", FALSE);
            DeleteLocalLocation(OBJECT_SELF, "lPlanarCell");
            SendMessageToPC(OBJECT_SELF,
                "The planar cell's location is lost.");
            SendMessageToPC(OBJECT_SELF,
                "You must prepare a new cell to teleport creatures to.");
        }
    }
}
