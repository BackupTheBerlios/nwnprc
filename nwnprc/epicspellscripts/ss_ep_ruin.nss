//:://////////////////////////////////////////////
//:: FileName: "ss_ep_ruin"
/*   Purpose: Ruin, as with "Greater Ruin" except only 20d6 instead of 35d6.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_I0_SPELLS"
#include "inc_epicspells"
#include "prc_alterations"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, RUIN_DC, RUIN_S, RUIN_XP))
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
        float fDelay = fDist/(3.0 * log(fDist) + 2.0);
        int nSpellDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetChangesToSaveDC() +
            GetDCSchoolFocusAdjustment(OBJECT_SELF, RUIN_S);
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        int nDam = d6(20);
        if (MySavingThrow(SAVING_THROW_FORT,oTarget,nSpellDC,SAVING_THROW_TYPE_SPELL,OBJECT_SELF) != 0 )
        {
            nDam /=2;
        }
        effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_TWENTY);
        ApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(487), oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED), oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_BONE_MEDIUM), oTarget);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
}
