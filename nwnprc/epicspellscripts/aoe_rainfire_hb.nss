//:://////////////////////////////////////////////
//:: FileName: "aoe_rainfire_hb"
/*   Purpose: AoE Rain of Fire's Heartbeat script.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "x2_I0_SPELLS"
#include "prc_alterations"

void main()
{

ActionDoCommand(SetAllAoEInts(4054,OBJECT_SELF, GetSpellSaveDC()));

    int nDamage;
    effect eDam;
    object oTarget;
    object oCreator = GetAreaOfEffectCreator();
    int nDC = GetEpicSpellSaveDC(oCreator) + GetChangesToSaveDC() +
        GetDCSchoolFocusAdjustment(oCreator, RAINFIR_S);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    float fDelay;

    oTarget = GetFirstInPersistentObject
        (OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    while(GetIsObjectValid(oTarget))
    {
        if (oTarget != oCreator &&
        !GetIsDM(oTarget))
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            if(!MyPRCResistSpell(oCreator, oTarget, 0, fDelay))
            {
                SignalEvent(oTarget,
                    EventSpellCastAt(oCreator, SPELL_INCENDIARY_CLOUD));
                nDamage = d6(1);
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC,
                SAVING_THROW_TYPE_FIRE, oCreator, fDelay))
                {
                    DelayCommand(fDelay,
                        SPApplyEffectToObject
                            (DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay,
                        SPApplyEffectToObject
                            (DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        oTarget = GetNextInPersistentObject
            (OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
