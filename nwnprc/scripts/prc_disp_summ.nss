//::///////////////////////////////////////////////
//:: Baalzebul Summon 1
//:: prc_baal_sum1
//:://////////////////////////////////////////////
/*
    Summons an Eryines
*/
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x2_inc_spellhook"
#include "prc_inc_switch"
void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables

    int nDuration = 15;
    float fDelay = 3.0;
    effect eSummon = EffectSummonCreature("erinyes",VFX_FNF_SUMMON_GATE, fDelay);
    
    //Apply the VFX impact and summon effect
    MultisummonPreSummon(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

