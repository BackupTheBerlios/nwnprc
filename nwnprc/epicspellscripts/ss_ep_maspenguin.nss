//:://////////////////////////////////////////////
//:: FileName: "ss_ep_maspenguin"
/*   Purpose: Mass Penguin - turns all creatures in the target area into
        penguins!
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
//#include "prc_alterations"
#include "pnp_shft_poly"


void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, MASSPEN_DC, MASSPEN_S, MASSPEN_XP))
    {
        float fDelay;
        int nDuration = 20;

        effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        effect eDuration = EffectVisualEffect(VFX_DUR_PIXIEDUST);
        effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
        effect ePolymorph = EffectPolymorph(POLYMORPH_TYPE_PENGUIN, TRUE);
        effect eLink = EffectLinkEffects(eDuration, ePolymorph);
        location lTarget = GetSpellTargetLocation();
        int nDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetDCSchoolFocusAdjustment(OBJECT_SELF, MASSPEN_S);
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
                if(!MyPRCResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF), fDelay))
                {
                    if(GetCreatureSize(oTarget) == CREATURE_SIZE_TINY ||
                        GetCreatureSize(oTarget) == CREATURE_SIZE_SMALL ||
                        GetCreatureSize(oTarget) == CREATURE_SIZE_MEDIUM)
                    {

                        // Targets all get a Fortitude saving throw
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC + GetChangesToSaveDC(oTarget,OBJECT_SELF),
                            SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                        {
							//this command will make shore that polymorph plays nice with the shifter
							ShifterCheck(oTarget);

                            // Apply effects to the currently selected target.
                            DelayCommand(fDelay, SPApplyEffectToObject
                                (DURATION_TYPE_TEMPORARY, eLink, oTarget,
                                HoursToSeconds(nDuration), TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
                            DelayCommand(fDelay, SPApplyEffectToObject
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
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
