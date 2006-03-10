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
    if(GetXP(oCohort) >= (GetHitDice(oCohort)*(GetHitDice(oCohort)-1)*500))
    {
        //standard
        if(GetResRef(oCohort) != "")
        {
            LevelUpHenchman(oCohort, CLASS_TYPE_INVALID, TRUE);    
        }
        else
        {
            //custom
            //resummon it but dont decrease XP as much
            int nCohortID = GetLocalInt(oCohort, "CohortID");
            object oNewCohort = AddCohortToPlayer(nCohortID, oPC);
            
            //copy its equipment & inventory
            object oTest = GetFirstItemInInventory(oCohort);
            while(GetIsObjectValid(oTest))
            {
                if(!GetLocalInt(oTest, "CohortCopied"))
                    object oNewTest = CopyItem(oTest, oNewCohort, TRUE);
                SetLocalInt(oTest, "CohortCopied", TRUE);
                DestroyObject(oTest);
                oTest = GetNextItemInInventory(oCohort);
            }
            int nSlot;
            for(nSlot = 0;nSlot<14;nSlot++)
            {
                oTest = GetItemInSlot(nSlot, oCohort);  
                object oTest2 = CopyItem(oTest, oNewCohort, TRUE);
                AssignCommand(oNewCohort, ActionEquipItem(oTest2, nSlot));
                DestroyObject(oTest);
            }
            //destroy old cohort
            SetIsDestroyable(TRUE, FALSE, FALSE);
            DestroyObject(OBJECT_SELF);
        }
    }
}   