//:://////////////////////////////////////////////
//:: FileName: "ss_ep_maspenguin"
/*   Purpose: Mass Penguin - turns all creatures in the target area into
        penguins!
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "prc_alterations"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, MASSPEN_DC, MASSPEN_S, MASSPEN_XP))
    {
        float fDelay;
        int nDuration = 20;
        int nDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetChangesToSaveDC() +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, MASSPEN_S);
        effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        effect eDuration = EffectVisualEffect(VFX_DUR_PIXIEDUST);
        effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
        effect ePolymorph = EffectPolymorph(POLYMORPH_TYPE_PENGUIN, TRUE);
        effect eLink = EffectLinkEffects(eDuration, ePolymorph);
        location lTarget = GetSpellTargetLocation();

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDuration,
            lTarget, 10.0);
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
            RADIUS_SIZE_LARGE, lTarget);
        // Cycle through the targets within the spell shape
        //      until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
            if (oTarget != OBJECT_SELF)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                    GetSpellId()));
                fDelay = GetRandomDelay(1.5, 2.5);
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget, 0, fDelay))
                {
                    if(GetCreatureSize(oTarget) == CREATURE_SIZE_TINY ||
                        GetCreatureSize(oTarget) == CREATURE_SIZE_SMALL ||
                        GetCreatureSize(oTarget) == CREATURE_SIZE_MEDIUM)
                    {
                        // Targets all get a Fortitude saving throw
                        if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC,
                            SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                        {
                            // Apply effects to the currently selected target.
                            DelayCommand(fDelay, ApplyEffectToObject
                                (DURATION_TYPE_TEMPORARY, eLink, oTarget,
                                HoursToSeconds(nDuration)));
                            DelayCommand(fDelay, ApplyEffectToObject
                                (DURATION_TYPE_INSTANT, eVis, oTarget));
                        }
                    }
                 }
            }
           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                RADIUS_SIZE_LARGE, lTarget);
        }
    }
}
