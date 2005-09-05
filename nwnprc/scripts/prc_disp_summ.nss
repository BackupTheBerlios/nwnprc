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
#include "inc_utility"
#include "prc_class_const"
#include "inc_epicspells"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables

    int iRoll = d3(1);
    object oStone;
    int nDuration = 15;
    float fDelay = 3.0;
    effect eSummon = EffectSummonCreature("erinyes",VFX_FNF_SUMMON_GATE, fDelay);
    effect eSummon2 = EffectSummonCreature("erinyes", VFX_NONE, fDelay, 0);

    //if(GetLevelByClass(CLASS_TYPE_DISPATER,OBJECT_SELF) >= 9)
        //SetPRCSwitch(PRC_MULTISUMMON, 3);

    if(iRoll == 3)
    {
        MultisummonPreSummon(OBJECT_SELF, TRUE);
        //SetMaxHenchmen(GetMaxHenchmen() + 3);
        oStone = CreateObject(OBJECT_TYPE_ITEM, "summoningstone", PRCGetSpellTargetLocation());
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepLeftLocation(oStone), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepRightLocation(oStone), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepRightLocation(oStone), TurnsToSeconds(nDuration));
        //DelayCommand((fDelay * 5), SetMaxHenchmen(GetMaxHenchmen() - 3));
        DestroyObject(oStone);
    }
    else if(iRoll == 2)
    {
        MultisummonPreSummon(OBJECT_SELF, TRUE);
//        SetMaxHenchmen(GetMaxHenchmen() + 2);
        oStone = CreateObject(OBJECT_TYPE_ITEM, "summoningstone", PRCGetSpellTargetLocation());
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepLeftLocation(oStone), TurnsToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepRightLocation(oStone), TurnsToSeconds(nDuration));
        //DelayCommand((fDelay * 5), SetMaxHenchmen(GetMaxHenchmen() - 2));
        DestroyObject(oStone);
    }
    else if(iRoll == 1)
    {
        MultisummonPreSummon(OBJECT_SELF);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), TurnsToSeconds(nDuration));
    }

    /*Apply the VFX impact and summon effect
    MultisummonPreSummon(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), TurnsToSeconds(nDuration));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), TurnsToSeconds(nDuration));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), TurnsToSeconds(nDuration));
    */

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
