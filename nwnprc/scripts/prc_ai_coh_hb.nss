//Cohort HB script

#include "prc_alterations"
#include "inc_utility"
#include "prc_inc_leadersh"

void main()
{
    object oCohort = OBJECT_SELF;
    object oPC = GetMaster(oCohort);
    if(!GetIsObjectValid(oPC))
    {
        RemoveCohortFromPlayer(oCohort, oPC);
        return;
    }    
        

    //cohort XP gain
    //get the amount the PC has gained
    int XPGained = GetXP(oPC)-GetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT);
    //
    float ECLRatio = IntToFloat(GetECL(oPC))/IntToFloat(GetECL(oCohort));
    int CohortXPGain = FloatToInt(IntToFloat(XPGained)*ECLRatio);
    SetXP(oCohort, GetXP(oCohort)+CohortXPGain);
    //if cohorts ECL is greater than players-2 reduce XP
    while(GetECL(oCohort)>(GetECL(oPC)-2))
    {
        SetXP(oCohort, (GetHitDice(oCohort)*(GetHitDice(oCohort)-1)*500)-1);
    }
    //handle levelup
}   