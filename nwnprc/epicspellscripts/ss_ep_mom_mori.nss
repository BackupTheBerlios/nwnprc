//::///////////////////////////////////////////////
//:: Epic Spell: Momento Mori
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
    if (GetCanCastSpell(OBJECT_SELF, MORI_DC, MORI_S, MORI_XP))
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nDamage;
        int nSpellDC = GetEpicSpellSaveDC(OBJECT_SELF) + 10 + GetChangesToSaveDC() +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, MORI_S);
        effect eDam;
        effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
        effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
            GetHitDice(oTarget) < 50 && oTarget != OBJECT_SELF)
        {
            //Make SR check
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget, 0))
               {
                 //Make Fortitude save
                 if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nSpellDC, SAVING_THROW_TYPE_DEATH))
                 {
                    //Apply the death effect and VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                 }
                 else
                 {
                    //Roll damage
                    nDamage = d6(3) + 20;
                    //Set damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    //Apply damage effect and VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
            }
        }
        else SendMessageToPC(OBJECT_SELF, "Spell failure - the target was not valid.");
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
