//::///////////////////////////////////////////////
//:: Epic Spell: Enslave
//:: Author: Boneshank (Don Armstrong)

#include "NW_I0_SPELLS"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    if (!X2PreSpellCastCode())
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, ENSLAVE_DC, ENSLAVE_S, ENSLAVE_XP))
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetDCSchoolFocusAdjustment(OBJECT_SELF, ENSLAVE_S) + GetChangesToSaveDC();
        effect eDom = EffectDominated();
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        //Link domination and persistant VFX
        effect eLink = EffectLinkEffects(eMind, eDom);
        eLink = EffectLinkEffects(eLink, eDur);
        effect eLink2 = SupernaturalEffect(eLink);

        effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_MONSTER, FALSE));
        //Make sure the target is a monster
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Make SR Check
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget, 0))
            {
                //Make a Will Save
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply linked effects and VFX Impact
                    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
