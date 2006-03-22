// This script will use the heal skill to try to cure drug addiction.
// The drug addiction rating determines the DC to cure the addiction.
#include "x2_inc_switches"
#include "addict_incl"
void main()
{
    // Only run this script for OnActivateItem event
    // Note: The statement below may not work for non HoTU version (not sure).
    //      In that case remove the if-statement below and get rid of the
    //      '#include "x2_inc_switches"' above
    if(GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ACTIVATE)
        return;

    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
        return;
    object oDrug = GetFirstAddiction(oTarget);
    while(GetIsObjectValid(oDrug))
    {
        int nRoll = d20();
        int nSkill = GetSkillRank(SKILL_HEAL,oPC);
        string DrugName = GetDrugName(oDrug);
        int nDC = 5 + GetDrugDC(oDrug);
        int bSuccess = (nRoll+nSkill) >= nDC;
        string sMsg = "Trying to cure "+DrugName+" addiction : ";
        if(bSuccess)
            sMsg += "*success* : (";
        else
            sMsg += "*failure* : (";
        sMsg += IntToString(nRoll)+" + "+IntToString(nSkill)+" = "+IntToString(nRoll+nSkill)
            +" vs. DC: "+IntToString(nDC)+")";
        SendMessageToPC(oPC,sMsg);
//        SendMessageToPC(oPC,"Trying to cure "+DrugName+" addiction: "+IntToString(nRoll)+" + "
//            +IntToString(nSkill)+" = "+IntToString(nRoll+nSkill)+" vs. DC "+IntToString(nDC));
        if((nRoll+nSkill) >= nDC)
        {
            //SendMessageToPC(oPC,"Cured "+DrugName+" addiction");
            FloatingTextStringOnCreature(DrugName+" addiction cured",oTarget);
            RemoveAddiction(oTarget,oDrug);
        }
       //else
            //SendMessageToPC(oPC,"Cure "+DrugName+" addiction failure");
        oDrug = GetNextAddiction(oTarget);
    }
}
