//::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
    Gather Horde - Summons an shaman of proper level as a henchmen.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_inc_util"

void main()
{
    object oPC = OBJECT_SELF;
    int iOrcWarlordLevel = GetLevelByClass(CLASS_TYPE_ORC_WARLORD, oPC);
    int iHD = GetHitDice(oPC);
    
    int iMaxHenchmen = 4;
    if(iOrcWarlordLevel < 3) iMaxHenchmen -= 2;
    
    // Sets proper number of henchmen based on orc warlord level
    SetMaxHenchmen(iMaxHenchmen);
    
    if(GetNumHenchmen(oPC) < iMaxHenchmen)
    {
         string sSummon;
         object oCreature;
    
         effect eSummon = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
         effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    
         if      (iHD > 39)	sSummon = "ow_sum_sham_13";
         else if (iHD > 36)	sSummon = "ow_sum_sham_12";
         else if (iHD > 33)	sSummon = "ow_sum_sham_11";
         else if (iHD > 30)	sSummon = "ow_sum_sham_10";
         else if (iHD > 27)	sSummon = "ow_sum_sham_9";
         else if (iHD > 24)	sSummon = "ow_sum_sham_8";
         else if (iHD > 21)	sSummon = "ow_sum_sham_7";
         else if (iHD > 18)	sSummon = "ow_sum_sham_6";
         else if (iHD > 15)	sSummon = "ow_sum_sham_5";
         else if (iHD > 12)	sSummon = "ow_sum_sham_4";
         else if (iHD > 9)	sSummon = "ow_sum_sham_3";
         else if (iHD > 6)	sSummon = "ow_sum_sham_2";
         else if (iHD > 3)	sSummon = "ow_sum_sham_1";
    
         oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
         AddHenchman(OBJECT_SELF, oCreature);
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    }
}