//::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
    Gather Horde - Summons an barbarian of proper level as a henchmen.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_feat_const"
#include "prc_inc_util"

// sets how many of a specific orc can be summoned
int iNumSummon = 2;

int GetCanSummonOrc(object oPC, string sCreatureResRef)
{
     int bCanSummon;
     int iNumOrc = 0;
     
     object oHench1 = GetHenchman(oPC, 1);
     object oHench2 = GetHenchman(oPC, 2);
     object oHench3 = GetHenchman(oPC, 3);
     object oHench4 = GetHenchman(oPC, 4);
     
     if(GetResRef(oHench1) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench2) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench3) ==  sCreatureResRef) iNumOrc += 1;
     if(GetResRef(oHench4) ==  sCreatureResRef) iNumOrc += 1;
     
     if(iNumSummon > iNumOrc) bCanSummon = TRUE;
     else                     bCanSummon = FALSE;

     return bCanSummon;
}

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
    
         if      (iHD > 39)	sSummon = "ow_sum_barb_12";
         else if (iHD > 36)	sSummon = "ow_sum_barb_11";
         else if (iHD > 33)	sSummon = "ow_sum_barb_10";
         else if (iHD > 30)	sSummon = "ow_sum_barb_9";
         else if (iHD > 27)	sSummon = "ow_sum_barb_8";
         else if (iHD > 24)	sSummon = "ow_sum_barb_7";
         else if (iHD > 21)	sSummon = "ow_sum_barb_6";
         else if (iHD > 18)	sSummon = "ow_sum_barb_5";
         else if (iHD > 15)	sSummon = "ow_sum_barb_4";
         else if (iHD > 12)	sSummon = "ow_sum_barb_3";
         else if (iHD > 9)	sSummon = "ow_sum_barb_2";
         else if (iHD > 6)	sSummon = "ow_sum_barb_1";
         
         if( GetCanSummonOrc(oPC, sSummon) )
         {
              oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
              AddHenchman(OBJECT_SELF, oCreature);
              ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
         }
         else
         {
              string sMes = "You cannot gather more than " + IntToString(iNumSummon) + " of this type of orc.";
              SendMessageToPC(oPC, sMes);
              
              if(GetHasFeat(FEAT_GATHER_HORDE_II, oPC) )
                   IncrementRemainingFeatUses(oPC, FEAT_GATHER_HORDE_II);
              else
                   IncrementRemainingFeatUses(oPC, FEAT_GATHER_HORDE_I);  
         }
    }
}