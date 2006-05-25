// restore_addict
//  Note: This script is only needed if drug persistence is required
//  Run this script when a PC enters the server (i.e. place in OnClientEnter event)
//   It will read the PC's addictions from the database and add them to the PC
//  Note that this script WILL NOT restore the actual drug effects, only the addiction.
//  The script also resets LastUsed time to the time the PC logged on to the server.

#include "addict_incl"

void RestoreAddictions(object oPC);
string GetFirstToken(string sString);
string GetNextToken(string sString);

void main()
{
    object oPC = GetEnteringObject();
    SendMessageToPC(oPC,"test");
    DelayCommand(12.0, RestoreAddictions(oPC));
}

void RestoreAddictions(object oPC)
{
     string sAddictions;
   //  SendMessageToPC(oPC,"Test2");
    // Don't run this script until the PC is placed in a valid Area
    if(!GetIsObjectValid(GetArea(oPC)))
    {
        DelayCommand(1.0,RestoreAddictions(oPC));
        return;
    }
    if (BIOWARE_DB)
        sAddictions = GetCampaignString(GetDrugDBName(),GetPlayerID(oPC)+"Addictions",oPC);
    else
        sAddictions = GetPersistentString(oPC,"Addictions",GetDrugDBName());
   // SendMessageToPC(oPC,sAddictions);
    //SendMessageToPC(GetFirstPC(),"Player: "+GetName(oPC)+" Restoring Addictions: "+sAddictions);
    // Loop through all the drugs this PC is addicted to and set the addiction variables
    string sDrugVar = GetFirstToken(sAddictions);
    while(sDrugVar != "")
    {
        //SendMessageToPC(GetFirstPC(),"sDrugVar: "+sDrugVar);
        // For each drug oPC is addicted to , find drug object or create one if it doesn't exist
        object oDrugObject = GetLocalObject(GetModule(),"DRUGOBJ_"+sDrugVar);
        if(!GetIsObjectValid(oDrugObject))
        {
            string sTag;
            if (BIOWARE_DB)
            {
                sTag = GetCampaignString(GetDrugDBName(),sDrugVar);
            }
            else
            {
                sTag=GetPersistentString(GetModule(),sDrugVar,GetDrugDBName());
            }
            int marker = FindSubString(sTag,"#");
            //SendMessageToPC(GetFirstPC(),"sTag: "+sTag+" Marker: "+IntToString(marker));
            string sDrugName = GetSubString(sTag,0,marker);
            int AddictRating = StringToInt(GetSubString(sTag,6+marker,1)); // Addiction rating
            int ODTime = StringToInt(GetSubString(sTag,8+marker,2)); // Overdose period
            int nDC;
            switch(AddictRating) {       // Addiction DC
                case 1: nDC = 4; break;
                case 2: nDC = 6; break;
                case 3: nDC = 10; break;
                case 4: nDC = 14; break;
                case 5: nDC = 25; break;
                case 6: nDC = 36; break;
            }
            //SendMessageToPC(GetFirstPC(),"PC Area: "+GetName(GetAreaFromLocation(GetLocation(oPC))));
            oDrugObject = CreateObject(OBJECT_TYPE_PLACEABLE,"plc_invisobj",GetLocation(oPC));
            SetLocalString(oDrugObject,"DrugTag",sDrugVar);
            SetLocalString(oDrugObject,"DrugName",sDrugName);
            SetLocalInt(oDrugObject,"DrugDC",nDC);
            SetLocalObject(GetModule(),"DRUGOBJ_"+sDrugVar,oDrugObject);
            int nDrugCnt = GetLocalInt(GetModule(),"DRUG_COUNT")+1;
            SetLocalObject(GetModule(),"DRUGOBJ"+IntToString(nDrugCnt),oDrugObject);
            SetLocalInt(GetModule(),"DRUG_COUNT",nDrugCnt);
        }
        FloatingTextStringOnCreature("** Addicted **",oPC,FALSE);
        SendMessageToPC(oPC,"You are addicted to "+GetDrugName(oDrugObject));
        SetLocalInt(oPC,"Addicted"+sDrugVar,TRUE);
        if (BIOWARE_DB)
            SetLocalInt(oPC,"Saves"+sDrugVar,GetCampaignInt(GetDrugDBName(),GetPlayerID(oPC)+"Saves"+sDrugVar,oPC));
        else
            SetLocalInt(oPC,"Saves"+sDrugVar,GetPersistentInt(oPC,GetTag(oPC)+"Saves"+sDrugVar,GetDrugDBName()));
        int CurTime = GetCalendarYear()*12*28*24 + GetCalendarMonth()*28*24+GetCalendarDay()*24+GetTimeHour();
        int iLastUsed_JW;
        if (!PERSIST_LAST_USED)
        {
            iLastUsed_JW=CurTime;
        }
        else
        {
            if(BIOWARE_DB)
            {
                iLastUsed_JW=GetCampaignInt(GetDrugDBName(),GetPlayerID(oPC)+"LastUsed"+sDrugVar,oPC);
            }
            else
            {
                iLastUsed_JW=GetPersistentInt(oPC,"LastUsed"+sDrugVar,GetDrugDBName());
            }
        }
        SetLocalInt(oPC,"LastUsed"+sDrugVar,iLastUsed_JW);

        int iTestDelay=(CurTime-iLastUsed_JW);
        //if (iTestDelay=0)
        //    iTestDelay=24;
        SendMessageToPC(oPC,"You used " +  GetDrugName(oDrugObject) + " " + IntToString(iTestDelay) + " hours ago.");
        if((CurTime-iLastUsed_JW) >= 24)
            AssignCommand(oDrugObject,Addiction(oPC,GetDrugRating(oDrugObject),sDrugVar,CurTime));
        else
            DelayCommand(HoursToSeconds(iTestDelay)+6.0,
                AssignCommand(oDrugObject,Addiction(oPC,GetDrugRating(oDrugObject),sDrugVar,CurTime)));

        sDrugVar = GetNextToken(sAddictions);
    }
}

int StrPos;
int StrLen;
string GetFirstToken(string sString)
{
    string ch;
    string sToken;
    StrPos = 1;
    StrLen = GetStringLength(sString);

    ch = GetSubString(sString,1,1);
    while((ch != "_") && (StrPos-1 < StrLen))
    {
        sToken = sToken + ch;
        ch = GetSubString(sString,++StrPos,1);
    }
    return sToken;
}

string GetNextToken(string sString)
{
    string ch, sToken;

    StrPos++;
    ch = GetSubString(sString,++StrPos,1);
    while((ch != "_") && (StrPos-1 < StrLen))
    {
        sToken = sToken + ch;
        ch = GetSubString(sString,++StrPos,1);
    }
    return sToken;
}
