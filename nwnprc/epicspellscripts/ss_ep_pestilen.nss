//::///////////////////////////////////////////////
//:: Epic Spell: Pestilence
//:: Author: Boneshank (Don Armstrong)

//#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
//#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, PESTIL_DC, PESTIL_S, PESTIL_XP))
    {
        //Declare major variables
        int nDamage;

        float fDelay;
        effect eExplode = EffectVisualEffect(VFX_FNF_HORRID_WILTING);
        effect eDuration = EffectVisualEffect(VFX_DUR_AURA_DISEASE);
        effect eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
        effect eDisease = EffectDisease(DISEASE_SLIMY_DOOM);
        location lTarget = GetLocation(OBJECT_SELF);
        int nDC = GetEpicSpellSaveDC(OBJECT_SELF)  + GetDCSchoolFocusAdjustment(OBJECT_SELF, PESTIL_S);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDuration, lTarget, 10.0);
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
            if (oTarget != OBJECT_SELF)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HORRID_WILTING));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetRandomDelay(1.5, 2.5);
                if(!MyPRCResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF), fDelay))
                {
                    if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                    {
    
                        // Targets all get a Fortitude saving throw
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC+ GetChangesToSaveDC(oTarget,OBJECT_SELF), SAVING_THROW_TYPE_DISEASE, OBJECT_SELF, fDelay))
                        {
                            // Apply effects to the currently selected target.
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDisease, oTarget));
                            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }
                    }
                 }
            }
           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
