//:://////////////////////////////////////////////
//:: FileName: "aoe_rainfire_ent"
/*   Purpose: AoE Rain of Fire spell's OnEnter script.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

//#include "prc_alterations"
//#include "prc_alterations"
//#include "inc_dispel"
//#include "x2_I0_SPELLS" <--- blows the compiler the **** up
//#include "x2_inc_spellhook"

#include "prc_alterations"
#include "prc_alterations"
#include "inc_epicspells"
#include "prc_add_spell_dc"


void main()
{


    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    int nDC = GetEpicSpellSaveDC(oCaster, oTarget, SPELL_EPIC_RAINFIR);
    ActionDoCommand(SetAllAoEInts(4054, OBJECT_SELF, PRCGetSaveDC(oTarget, oCaster) ) );
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    float fDelay;
    
    if (oTarget != oCaster &&
        !GetIsDM(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD) );
        if(!MyPRCResistSpell(oCaster, oTarget, GetTotalCastingLevel(oCaster)+SPGetPenetr(oCaster), fDelay))
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            nDamage = d6(1);
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE, oCaster, fDelay))
            {
                DelayCommand(fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
    }
}
