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
#include "prc_class_const"
#include "nw_i0_spells"
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

    if(GetLevelByClass(CLASS_TYPE_DISPATER,OBJECT_SELF) >= 9)
    	SetPRCSwitch(PRC_MUTLISUMMON, 3);
	
	if(iRoll == 3)
	{
		MultisummonPreSummon(OBJECT_SELF);
		SetMaxHenchmen(GetMaxHenchmen() + 3);
		oStone = CreateObject(OBJECT_TYPE_ITEM, "summoningstone", GetSpellTargetLocation());
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepLeftLocation(oStone), TurnsToSeconds(nDuration));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepRightLocation(oStone), TurnsToSeconds(nDuration));
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepRightLocation(oStone), TurnsToSeconds(nDuration));
		DelayCommand((fDelay * 5), SetMaxHenchmen(GetMaxHenchmen() - 3));
		DestroyObject(oStone);
	}
	else if(iRoll == 2)
		{
			MultisummonPreSummon(OBJECT_SELF);
			SetMaxHenchmen(GetMaxHenchmen() + 2);
			oStone = CreateObject(OBJECT_TYPE_ITEM, "summoningstone", GetSpellTargetLocation());
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepLeftLocation(oStone), TurnsToSeconds(nDuration));
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon2, GetStepRightLocation(oStone), TurnsToSeconds(nDuration));
			DelayCommand((fDelay * 5), SetMaxHenchmen(GetMaxHenchmen() - 2));
			DestroyObject(oStone);
		}
		else if(iRoll == 1)
			{
				MultisummonPreSummon(OBJECT_SELF);
				ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
			}
    
    /*Apply the VFX impact and summon effect
    MultisummonPreSummon(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));
    */

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
