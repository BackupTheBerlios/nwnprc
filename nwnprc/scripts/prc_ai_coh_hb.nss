//Cohort HB script

#include "inc_ecl"
#include "inc_utility"
#include "prc_alterations"
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
    int XPGained = GetXP(oPC)-GetLocalInt(OBJECT_SELF, "MastersXP");
    SetLocalInt(OBJECT_SELF, "MastersXP", GetXP(oPC));
    int nPCECL = GetECL(oPC);
    int nCohortECL = GetECL(oCohort);
    int nCohortLag = GetLocalInt(oCohort, "CohortLevelLag");
    float ECLRatio = IntToFloat(nPCECL)/IntToFloat(nCohortECL);
    int nCohortXPGain = FloatToInt(IntToFloat(XPGained)*ECLRatio);
    int nCohortXP = GetXP(oCohort);
    int nCohortNewXP = nCohortXP+nCohortXPGain;
    int nCohortXPCap = ((nPCECL-nCohortLag)*(nPCECL-nCohortLag+1)*500)-1;
    int nCohortXPLevel = nCohortECL*(nCohortECL+1)*500;
DoDebug("XPGained = "+IntToString(XPGained));
DoDebug("nPCECL = "+IntToString(nPCECL));
DoDebug("nCohortECL = "+IntToString(nCohortECL));
DoDebug("nCohortXPGain = "+IntToString(nCohortXPGain));
DoDebug("nCohortXP = "+IntToString(nCohortXP));
DoDebug("nCohortNewXP = "+IntToString(nCohortNewXP));
DoDebug("nCohortXPCap = "+IntToString(nCohortXPCap));
DoDebug("nCohortXPLevel = "+IntToString(nCohortXPLevel));
    //apply the cap
    if(nCohortNewXP > nCohortXPCap)
        nCohortNewXP = nCohortXPCap;
    //give the XP   
    SetXP(oCohort, nCohortNewXP); 
    //handle levelup
    if(nCohortNewXP >= nCohortXPLevel)
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
DoDebug("Test A");
            object oNewCohort = AddCohortToPlayer(nCohortID, oPC);
            
DoDebug("Test B");
            //copy its equipment & inventory
            object oTest = GetFirstItemInInventory(oCohort);
            while(GetIsObjectValid(oTest))
            {
                if(!GetLocalInt(oTest, "CohortCopied"))
                    object oNewTest = CopyItem(oTest, oNewCohort, TRUE);
                SetLocalInt(oTest, "CohortCopied", TRUE);
                DestroyObject(oTest, 0.01);
                oTest = GetNextItemInInventory(oCohort);
            }
DoDebug("Test C");
            int nSlot;
            for(nSlot = 0;nSlot<14;nSlot++)
            {
                oTest = GetItemInSlot(nSlot, OBJECT_SELF);  
                object oTest2 = CopyItem(oTest, oNewCohort, TRUE);
                AssignCommand(oNewCohort, ActionEquipItem(oTest2, nSlot));
                DestroyObject(oTest, 0.01);
            }
DoDebug("Test D");            
            //destroy old cohort
            SetIsDestroyable(TRUE, FALSE, FALSE);
DoDebug("Test E");
            DestroyObject(OBJECT_SELF, 0.1);
DoDebug("Test F");
        }
    }
}   