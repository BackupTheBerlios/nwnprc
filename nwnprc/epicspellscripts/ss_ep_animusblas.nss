//:://////////////////////////////////////////////
//:: FileName: "ss_ep_animusblas"
/*   Purpose: Animus Blast
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "prc_alterations"

void DoAnimationBit(location lTarget, object oCaster);

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, ANBLAST_DC, ANBLAST_S, ANBLAST_XP))
    {
        float fDelay;
        int nDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetChangesToSaveDC() +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, ANBLAST_S);
        int nDam;
        effect eExplode = EffectVisualEffect(VFX_IMP_PULSE_COLD);
        effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
        effect eDam, eLink;
        location lTarget = GetSpellTargetLocation();

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        DelayCommand(0.3,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
        DelayCommand(0.6,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
        DelayCommand(0.9,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
        DelayCommand(1.2,
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
            RADIUS_SIZE_HUGE, lTarget);
        while (GetIsObjectValid(oTarget))
        {
            if (oTarget != OBJECT_SELF && !GetIsDM(oTarget) &&
                !GetFactionEqual(oTarget) && spellsIsTarget(oTarget,
                SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                    GetSpellId()));
                fDelay = GetRandomDelay();
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget, 0, fDelay))
                {
                    nDam = d6(10);
                    // Reflex save for half damage.
                    if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC,
                        SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                        nDam /= 2;
                    eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
                    eLink = EffectLinkEffects(eDam, eVis);
                    eLink = EffectLinkEffects(eExplode, eLink);
                    DelayCommand(fDelay, ApplyEffectToObject
                        (DURATION_TYPE_INSTANT, eLink, oTarget));
                    // Do the animation bit if the target dies from blast.
                    if (!MatchNonliving(GetRacialType(oTarget)))
                    {
                        SetLocalInt(oTarget, "nAnBlasCheckMe", TRUE);
                    }
                }
            }
           oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                RADIUS_SIZE_HUGE, lTarget);
        }
        DelayCommand(3.0, DoAnimationBit(lTarget, OBJECT_SELF));
    }
}

void DoAnimationBit(location lTarget, object oCaster)
{
    int nX = 0;
    int nM = GetMaxHenchmen();
    int nH = nM;
    string sSkel = "NW_S_SKELWARR";
    object oSkel;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
        RADIUS_SIZE_HUGE, lTarget);
    while (GetIsObjectValid(oTarget))
    {
        if (nX < 12)
        {
            if (GetIsDead(oTarget) &&
                GetLocalInt(oTarget, "nAnBlasCheckMe") == TRUE)
            {
                nH++;
                SetMaxHenchmen(nH);
                oSkel = CreateObject(OBJECT_TYPE_CREATURE, sSkel,
                    GetLocation(oTarget));
                AddHenchman(oCaster, oSkel);
                SetAssociateListenPatterns(oSkel);
                DetermineCombatRound(oSkel);
                nX++;
            }
        }
        DeleteLocalInt(oTarget, "nAnBlasCheckMe");
        oTarget = GetNextObjectInShape(SHAPE_SPHERE,
            RADIUS_SIZE_HUGE, lTarget);
    }
    SetMaxHenchmen(nM);
}
