//::///////////////////////////////////////////////
//:: Greater Ruin
//:: X2_S2_Ruin
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The caster deals 35d6 damage to a single target
   fort save for half damage
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 18, 2002
//:://////////////////////////////////////////////

/*
    Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_I0_SPELLS"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, GR_RUIN_DC, GR_RUIN_S, GR_RUIN_XP))
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();


        float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
        float fDelay = fDist/(3.0 * log(fDist) + 2.0);

        int nSpellDC = GetEpicSpellSaveDC(OBJECT_SELF) + GetDCSchoolFocusAdjustment(OBJECT_SELF, GR_RUIN_S);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Roll damage
        int nDam = d6(35);
        //Set damage effect

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
