//::///////////////////////////////////////////////
//:: Epic Spell: Twinfiend
//:: Author: Boneshank (Don Armstrong)

//#include "x2_inc_toollib"
#include "nw_i0_spells"
#include "inc_epicspells"
#include "x2_inc_spellhook"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, TWINF_DC, TWINF_S, TWINF_XP))
    {
        //Declare major variables
        float fDuration = RoundsToSeconds(20);
        object oFiend, oFiend2;
        // effect eSummon;
        effect eVis = EffectVisualEffect(460);
        effect eVis2 = EffectVisualEffect(VFX_IMP_UNSUMMON);
        if(GetPRCSwitch(PRC_MUTLISUMMON))
        {
            effect eSummon = EffectSummonCreature("twinfiend_demon", 460);
            MultisummonPreSummon();
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, 
                GetSpellTargetLocation(), fDuration);
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, 
                GetSpellTargetLocation(), fDuration);
        }
        else
        {
            DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation()));
            oFiend = CreateObject(OBJECT_TYPE_CREATURE, "twinfiend_demon", GetSpellTargetLocation());
            oFiend2 = CreateObject(OBJECT_TYPE_CREATURE, "twinfiend_demon", GetStepLeftLocation(oFiend));
            SetMaxHenchmen(GetMaxHenchmen() + 2);
            AddHenchman(OBJECT_SELF, oFiend);
            AddHenchman(OBJECT_SELF, oFiend2);
            SetMaxHenchmen(GetMaxHenchmen() - 2);
            AssignCommand(oFiend, DetermineCombatRound());
            AssignCommand(oFiend2, DetermineCombatRound());
            DelayCommand(fDuration, DestroyObject(oFiend));
            DelayCommand(fDuration, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oFiend)));
            DelayCommand(fDuration, DestroyObject(oFiend2));
            DelayCommand(fDuration, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(oFiend2)));
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


