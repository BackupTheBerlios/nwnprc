//:://////////////////////////////////////////////
//:: FileName: "ss_ep_allhoplost"
/*   Purpose: All Hope Lost - causes all enemies within the area to make a will
        save or resist the spell to avoid losing all courage and drop their items.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_i0_spells"
//#include "inc_epicspells"
//#include "prc_alterations"


#include "nw_i0_spells"
#include "inc_epicspells"
#include "prc_add_spell_dc"
#include "x2_inc_spellhook"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    if (!X2PreSpellCastCode() )
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, ALLHOPE_DC, ALLHOPE_S, ALLHOPE_XP))
    {
        int nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        int nSaveDC = GetEpicSpellSaveDC(OBJECT_SELF) + 10 + GetDCSchoolFocusAdjustment(OBJECT_SELF, ALLHOPE_S);        
        float fDuration = RoundsToSeconds(20);
        effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
        effect eFear = EffectFrightened();
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
        effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        float fDelay;
        effect eLink = EffectLinkEffects(eFear, eMind);
        eLink = EffectLinkEffects(eLink, eDur);
        object oTarget, oWeap, oOffhand, oNewR, oNewL;
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
            eImpact, GetLocation(OBJECT_SELF));
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
            RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
        while(GetIsObjectValid(oTarget))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,
                OBJECT_SELF) && oTarget != OBJECT_SELF)
            {
                fDelay = GetRandomDelay();
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
                if(!MyPRCResistSpell(OBJECT_SELF, oTarget, 0, fDelay))
                {
 
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC + GetChangesToSaveDC(oTarget,OBJECT_SELF),
                        SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
                    {
                        if (GetIsCreatureDisarmable(oTarget))
                        {
                            oWeap = GetItemInSlot
                                (INVENTORY_SLOT_RIGHTHAND, oTarget);
                            oOffhand = GetItemInSlot
                                (INVENTORY_SLOT_LEFTHAND, oTarget);
                            if (oWeap != OBJECT_INVALID &&
                                GetDroppableFlag(oWeap))
                            {
                                CopyObject(oWeap, GetLocation(oTarget));
                                DelayCommand(2.0, DestroyObject(oWeap));
                            }
                            if (oOffhand != OBJECT_INVALID &&
                                GetDroppableFlag(oOffhand))
                            {
                                CopyObject(oOffhand, GetLocation(oTarget));
                                DelayCommand(2.0, DestroyObject(oOffhand));
                            }
                        }
                        DelayCommand(fDelay, SPApplyEffectToObject
                            (DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
                    }
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
        }
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

