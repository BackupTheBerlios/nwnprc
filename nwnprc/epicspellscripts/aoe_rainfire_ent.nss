//:://////////////////////////////////////////////
//:: FileName: "aoe_rainfire_ent"
/*   Purpose: AoE Rain of Fire spell's OnEnter script.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

//#include "X0_I0_SPELLS"
//#include "prc_alterations"
//#include "inc_dispel"
//#include "x2_I0_SPELLS" <--- blows the compiler the **** up
//#include "x2_inc_spellhook"

#include "nw_i0_spells"
#include "inc_epicspells"
#include "prc_add_spell_dc"


void main()
{

    ActionDoCommand(SetAllAoEInts(4054, OBJECT_SELF, GetSpellSaveDC() ) );

    object oTarget;
    object oCreator = GetAreaOfEffectCreator();
    int nDC = /*GetEpicSpellSaveDC(oCreator) +*/ GetChangesToSaveDC() + GetDCSchoolFocusAdjustment(oCreator, RAINFIR_S);
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    float fDelay;
    oTarget = GetEnteringObject();
    if (oTarget != oCreator &&
        !GetIsDM(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD) );
        if(!MyPRCResistSpell(oCreator, oTarget, 0, fDelay))
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            nDamage = d6(1);
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE, oCreator, fDelay))
            {
                DelayCommand(fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
    }
}