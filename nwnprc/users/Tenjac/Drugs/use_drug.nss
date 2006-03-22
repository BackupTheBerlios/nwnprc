#include "addict_incl"

// Implements drug use
// Note that each drug has an associated invisible object to keep track of
// drug effect.
// When a drug is used, the approriate invis object is located or created if
// it doesn't exist yet.

// 5/1/04 Added persistence:
//      Campaign variable "Addictions" stores the drugs each player is addicted to.
//          The variable is a concatinated list of drug Tags separated by "_".
//        Example: Addictions variable value of  "_sannish__devilweed_" would indicate
//          that the player is addicted to sannish and devilweed.
//      When a player leaves and then returns to the server, all his addictions will
//          be restored if "restore_addict" script is run OnClientEnter.
//          Note that the drug effects will NOT be restored, only the addiction.
//          Also, for the purposes of withdrawl and overdose effects, the LastUsed time\
//          will be reset to the time the PC last entered the server

void main()
{
    // Drug tag format is "DRUG_<x>_<OD>_<drug_name>", where
    // <x> is the addiction rating (1 digit) and
    // 1 - Negligible, 2 - Low, 3 - Medium, 4 - High, 5 - Extreme, 6 - Vicious
    // <OD> is the min number of hours between uses to avoid overdose (2 digits)
    // Script <drug_name>_a is run for initial effects (and side effects)
    // Script <drug_name>_b is run for secondary effects (delayed 1min)
    // Script <drug_name>_c is run for an overdose
    object item = GetItemActivated();
    object oPC = GetItemActivator();
    string sTag = GetTag(item);
    int AddictRating = StringToInt(GetSubString(sTag,5,1)); // Addiction rating
    int ODTime = StringToInt(GetSubString(sTag,7,2)); // Overdose period
    int nDC;
    switch(AddictRating) {       // Addiction DC
        case 1: nDC = 4; break;
        case 2: nDC = 6; break;
        case 3: nDC = 10; break;
        case 4: nDC = 14; break;
        case 5: nDC = 25; break;
        case 6: nDC = 36; break;
    }
    sTag = GetStringRight(sTag,GetStringLength(sTag)-10);
    ExecuteScript(sTag+"_a",oPC);
    DelayCommand(DRUG_EFFECT_DELAY,FloatingTextStringOnCreature("** Drug Secondary Effects **",oPC,FALSE));
    DelayCommand(DRUG_EFFECT_DELAY,ExecuteScript(sTag+"_b",oPC));
    int LastUsed;

    LastUsed = GetLocalInt(oPC,"LastUsed"+sTag);
    int CurTime = GetCalendarYear()*12*28*24 + GetCalendarMonth()*28*24+GetCalendarDay()*24+GetTimeHour();
    if((CurTime-LastUsed) < ODTime) // Check for an overdose
    {
        FloatingTextStringOnCreature("** Overdose **",oPC,FALSE);
        SendMessageToPC(oPC,"You overdosed on "+GetName(item));
        ExecuteScript(sTag+"_c",oPC);
    }
    SetLocalInt(oPC,"LastUsed"+sTag,CurTime);

    if(PERSIST_LAST_USED)
        SetDrugInt(oPC,"LastUsed"+sTag,CurTime);
    else
        SetLocalInt(oPC,"LastUsed"+sTag,CurTime);

    //SetLocalString(oPC,"DrugName"+sTag,GetName(item));

    // Try to find the drug object. If it doesn't exist then create it
    object oDrugObject = GetLocalObject(OBJECT_SELF,"DRUGOBJ_"+sTag);
    if(!GetIsObjectValid(oDrugObject))
    {
        oDrugObject = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_invisobj",GetLocation(oPC));
        SetLocalString(oDrugObject,"DrugTag",sTag);
        SetLocalString(oDrugObject,"DrugName",GetName(item));
        SetLocalInt(oDrugObject,"DrugDC",nDC);
        SetLocalObject(OBJECT_SELF,"DRUGOBJ_"+sTag,oDrugObject);
        int nDrugCnt = GetLocalInt(OBJECT_SELF,"DRUG_COUNT")+1;
        SetLocalObject(OBJECT_SELF,"DRUGOBJ"+IntToString(nDrugCnt),oDrugObject);
        SetLocalInt(OBJECT_SELF,"DRUG_COUNT",nDrugCnt);
        if(DRUG_PERSISTENCE)
        {
            if(BIOWARE_DB)
                SetCampaignString(GetDrugDBName(),sTag,GetName(item)+"#"+GetTag(item));
            else
                SetPersistentString(GetModule(),sTag,GetName(item)+"#"+GetTag(item),0,GetDrugDBName());
        }
    }
    if(GetLocalInt(oPC,"Addicted"+sTag))
    {
        // Remove any withdrawl symptoms
        effect eff = GetFirstEffect(oPC);
        while(GetIsEffectValid(eff))
        {
            if(GetEffectCreator(eff) == oDrugObject)
                RemoveEffect(oPC,eff);
            eff = GetNextEffect(oPC);
        }
        DelayCommand(HoursToSeconds(24)+6.0,
            AssignCommand(oDrugObject,Addiction(oPC,AddictRating,sTag,CurTime)));
    }
    else if(!FortitudeSave(oPC,nDC,SAVING_THROW_TYPE_POISON))
    {
        FloatingTextStringOnCreature("** Addicted **",oPC,FALSE);
        SendMessageToPC(oPC,"You have become addicted to "+GetName(item));
        SetDrugInt(oPC,"Addicted"+sTag,TRUE);
        //SetDrugInt(oPC,"Rating"+sTag,AddictRating);
        if(DRUG_PERSISTENCE)
        {
            string sAddictions;
            if(BIOWARE_DB)
            {
                sAddictions = GetCampaignString(GetDrugDBName(),GetPlayerID(oPC)+"Addictions",oPC);
                if(!TestStringAgainstPattern("*_"+sTag+"_*",sAddictions))
                {
                    sAddictions = sAddictions + "_"+sTag+"_";
                    SetCampaignString(GetDrugDBName(),GetPlayerID(oPC)+"Addictions",sAddictions,oPC);
                }
            }
            else
            {
                sAddictions = GetPersistentString(oPC,GetTag(oPC)+"Addictions",GetDrugDBName());
                if(!TestStringAgainstPattern("*_"+sTag+"_*",sAddictions))
                {
                    sAddictions = sAddictions + "_"+sTag+"_";
                    SetPersistentString(oPC,GetTag(oPC)+"Addictions",sAddictions,0,GetDrugDBName());
                }
            }
        }
        DelayCommand(HoursToSeconds(24)+6.0,
            AssignCommand(oDrugObject,Addiction(oPC,AddictRating,sTag,CurTime)));
    }
    if(ALIGNMENT_ADJUST)
    {
        int nShift = (GetLawChaosValue(oPC)-21)/5;
        if(nShift > 0)
            AdjustAlignment(oPC,ALIGNMENT_CHAOTIC,nShift);
    }

}
