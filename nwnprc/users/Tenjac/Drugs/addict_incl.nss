#include "aps_include"
// Addiction Support Functions

// This function is used internally by the "use_drug" script
// oPC - creature to apply addiction to
// Rating - addiction rating of the drug
// sDrugVar - ID tag of the drug (this is not the tag of the drug item)
// nCallTime - time (in hours) when the function was called
void Addiction(object oPC, int Rating, string sDrugVar, int nCallTime);

// Along with GetNextAddiction loops through current addictions on oPC
object GetFirstAddiction(object oPC);

// Along with GetFirstAddiction loops through current addictions on oPC
object GetNextAddiction(object oPC);

// Removes Addiction from drug specified by oDrugObj
void RemoveAddiction(object oPC, object oDrugObj);

// Removes Addiction and completely clears all effects from drug
//  specified by oDrugObj.
//  This function also resets LastUsed time, so that no overdose will
//      occur even if the drug is taken again immediately.
void RemoveAllDrugEffects(object oPC, object oDrugObj);

// Returns TRUE is oPC is addicted to oDrugObj
int GetIsAddicted(object oDrugObj, object oPC=OBJECT_SELF);

// Returns the name of the drug
string GetDrugName(object oDrugObj);

// Returns Fortitude save DC to avoid addiction
int GetDrugDC(object oDrugObj);

// Returns the drug's addiction rating
int GetDrugRating(object oDrugObj);

// Set these variables as required:
//************************************************************************************
const int DRUG_PERSISTENCE = FALSE;     //  Set to TRUE to have drug effects be stored
                                        //    persistently.

const int BIOWARE_DB = TRUE;           //FALSE means we're using nwnx

const string DB_NAME = "DRUG_VARS";     // Database name for persistent storage.
                                        //If BIOWARE_DB = false, this will be the name of the database for APS/NWNX.
                                        //You will need to create this database, but it is identical to PWDATA

const int ALIGNMENT_ADJUST = TRUE;     // If TRUE, alignment will be shifted
                                        //  towards CHAOTIC with each drug use,
                                        //  to a minimum of 25.
const int PERSIST_LAST_USED=FALSE;       //if false, last used will be reset when the player leaves and comes back
                                        //Do not leave this as true unless you have a persistent time script in place

const float DRUG_EFFECT_DELAY=60.0;      //This is the delay between effects.
//**************************************************************************************

string GetDrugDBName()
{
    //SendMessageToPC(GetFirstPC(),"DB Name: "+GetModuleName()+DB_NAME);
    if (BIOWARE_DB)
        return GetModuleName()+DB_NAME;
    else
        return DB_NAME;
}

string GetPlayerID(object oPC)
{
    return "";  // If the database works properly, then it shouldn't be neccessary
                //      to use a player ID. Just specifying oPC should be enough.
    string sName = GetName(oPC);
    int pos;
    while((pos = FindSubString(sName," ")) != -1)
        sName = GetStringLeft(sName,pos)+GetStringRight(sName,GetStringLength(sName)-pos-1);
    //SendMessageToPC(GetFirstPC(),"Player ID: "+sName);
    return sName;
}

void SetDrugInt(object oPC, string VName, int val)
{
    SetLocalInt(oPC,VName,val);
    if(DRUG_PERSISTENCE)
       {
       if (BIOWARE_DB)
        SetCampaignInt(GetDrugDBName(),GetPlayerID(oPC)+VName,val,oPC);
       else
        SetPersistentInt(oPC,VName,val,0,GetDrugDBName());
       }
}

void DeleteDrugInt(object oPC, string VName)
{
    DeleteLocalInt(oPC,VName);
    if(DRUG_PERSISTENCE)
       {
       if (BIOWARE_DB)
       {
        SetCampaignInt(GetDrugDBName(),GetPlayerID(oPC)+VName,0,oPC);
        }
       else    {
        SetPersistentInt(oPC,GetTag(oPC)+VName,0,0,GetDrugDBName());
        }
       }
}

void Addiction(object oPC, int Rating, string sDrugVar, int nCallTime)
{
    if(!GetLocalInt(oPC,"Addicted"+sDrugVar))
        return;
    // If this function was called before the last time advance, then do nothing
    //  Note this part is for use with my time advance code. If there's no time
    //  advance code, the statement below won't do anything
    if(nCallTime < GetLocalInt(GetModule(),"TIME_ADVANCE_TIME"))
        return;
    int LastUsed = GetLocalInt(oPC,"LastUsed"+sDrugVar);
    int CurTime = GetCalendarYear()*12*28*24 + GetCalendarMonth()*28*24+GetCalendarDay()*24+GetTimeHour();
    if((CurTime-LastUsed) >= 24)  // Is it 24 hrs of more since last use of the drug?
    {
        int nDC;        // Withdrawl effect save DC
        int nSat;       // Satiation period in days
        effect eff;
        switch(Rating) {
            case 1: // Negligible addiction
                nDC=4;
                nSat=1;
                eff = EffectAbilityDecrease(ABILITY_DEXTERITY,Random(2));
                break;
            case 2:  // Low addiction
                nDC=6;
                nSat=10;
                eff = EffectAbilityDecrease(ABILITY_DEXTERITY,d3());
                break;
            case 3:  // Medium addiction
                nDC=10;
                nSat=5;
                eff = EffectAbilityDecrease(ABILITY_DEXTERITY,d4());
                eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_WISDOM,d4()),eff);
                break;
            case 4:  // High addiction
                nDC=14;
                nSat=2;
                eff = EffectAbilityDecrease(ABILITY_DEXTERITY,d6());
                eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_WISDOM,d6()),eff);
                eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_CONSTITUTION,d2()),eff);
                break;
            case 5:  // Extreme addiction
                nDC=25;
                nSat=1;
                eff = EffectAbilityDecrease(ABILITY_DEXTERITY,d6());
                eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_WISDOM,d6()),eff);
                eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_CONSTITUTION,d6()),eff);
                break;
            case 6:  // Vicious addiction
                nDC=36;
                nSat=1;
                eff = EffectAbilityDecrease(ABILITY_DEXTERITY,d8());
                eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_WISDOM,d8()),eff);
                eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_CONSTITUTION,d6()),eff);
                eff = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH,d6()),eff);
                break;
        }
        if((CurTime-LastUsed) > nSat*24)  // Exceeded satiation period, increase DC by 5
            nDC += 5;
        object oDrugObj = GetLocalObject(GetModule(),"DRUGOBJ_"+sDrugVar);
        string sDrugName = GetLocalString(oDrugObj,"DrugName");
        //string sDrugName = GetLocalString(oPC,"DrugName"+sDrugVar);
        if(!FortitudeSave(oPC,nDC,SAVING_THROW_TYPE_POISON))
        {
            PlayVoiceChat(VOICE_CHAT_PAIN1,oPC);
            SendMessageToPC(oPC,sDrugName+" withdrawal effects");
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eff) ,oPC);
            SetDrugInt(oPC,"Saves"+sDrugVar,0);
            DelayCommand(HoursToSeconds(24)+6.0,Addiction(oPC,Rating,sDrugVar,CurTime));
        }
        else   // Saved against withdrawl symptoms
        {
            int nSaveCnt = GetLocalInt(oPC,"Saves"+sDrugVar)+1;
            SendMessageToPC(oPC,"You resisted "+sDrugName+" addiction effects");
            if(nSaveCnt >= 2)  // If passed 2 saves in a row, then stop being addicted
            {
                SendMessageToPC(oPC,"You have overcome your "+sDrugName+" addiction");
                RemoveAddiction(oPC,oDrugObj);
                //DeleteDrugInt(oPC,"Saves"+sDrugVar);
                //DeleteDrugInt(oPC,"Addicted"+sDrugVar);
                //DeleteDrugInt(oPC,"Rating"+sDrugVar);
            }
            else
            {
                SetDrugInt(oPC,"Saves"+sDrugVar,nSaveCnt);
                DelayCommand(HoursToSeconds(24)+6.0,Addiction(oPC,Rating,sDrugVar,CurTime));
            }
        }
    }
}

object GetFirstAddiction(object oPC)
{
    object oDrugObj;
    if(!GetIsObjectValid(oPC))
        return OBJECT_INVALID;
    int Num = GetLocalInt(GetModule(),"DRUG_COUNT");
    //SendMessageToPC(GetFirstPC(),"DRUG_COUNT: "+IntToString(Num));
    int Cnt = 1;
    while(Cnt <= Num)
    {
        oDrugObj = GetLocalObject(GetModule(),"DRUGOBJ"+IntToString(Cnt));
        string sTag = GetLocalString(oDrugObj,"DrugTag");
        if(GetLocalInt(oPC,"Addicted"+sTag))
            break;
        Cnt++;
    }
    if(Cnt <= Num) // Found an addiction
    {
        SetLocalInt(GetModule(),"DRUG_LOOP_COUNT",Cnt+1);
        return oDrugObj;
    }
    return OBJECT_INVALID;
}

object GetNextAddiction(object oPC)
{
    object oDrugObj;
    if(!GetIsObjectValid(oPC))
        return OBJECT_INVALID;
    int Num = GetLocalInt(GetModule(),"DRUG_COUNT");
    int Cnt = GetLocalInt(GetModule(),"DRUG_LOOP_COUNT");
    while(Cnt <= Num)
    {
        oDrugObj = GetLocalObject(GetModule(),"DRUGOBJ"+IntToString(Cnt));
        string sTag = GetLocalString(oDrugObj,"DrugTag");
        if(GetLocalInt(oPC,"Addicted"+sTag))
            break;
        Cnt++;
    }
    if(Cnt <= Num) // Found an addiction
    {
        SetLocalInt(GetModule(),"DRUG_LOOP_COUNT",Cnt+1);
        return oDrugObj;
    }
    return OBJECT_INVALID;
}

// Deletes substring SubStr from MainStr
string DeleteMatchedSubString(string SubStr, string MainStr)
{
    int pos = FindSubString(MainStr,SubStr);
    if(pos == -1) // substring not found
        return MainStr;

    int len1 = GetStringLength(SubStr);
    int len2 = GetStringLength(MainStr);
    return GetSubString(MainStr,0,pos)+GetSubString(MainStr,pos+len1,len2-len1-pos);
}

void RemoveAddiction(object oPC, object oDrugObj)
{
    string sAddictions;
    if(!GetIsObjectValid(oPC) || !GetIsObjectValid(oDrugObj))
        return;
    string sTag = GetLocalString(oDrugObj,"DrugTag");
    DeleteDrugInt(oPC,"Saves"+sTag);
    DeleteDrugInt(oPC,"Addicted"+sTag);
    //DeleteDrugInt(oPC,"Rating"+sTag);
    if(DRUG_PERSISTENCE)
    {   // Update "Addictions" variable
       if (BIOWARE_DB)
       {
        sAddictions = GetCampaignString(GetDrugDBName(),GetPlayerID(oPC)+"Addictions",oPC);
        sAddictions = DeleteMatchedSubString("_"+sTag+"_",sAddictions);
        SetCampaignString(GetDrugDBName(),GetPlayerID(oPC)+"Addictions",sAddictions,oPC);
       }
       else
       {
            sAddictions=GetPersistentString(oPC,GetTag(oPC)+"Addictions",GetDrugDBName());
            sAddictions=DeleteMatchedSubString("_"+sTag+"_",sAddictions);
            SetPersistentString(oPC,GetTag(oPC)+"Addictions",sAddictions,0,GetDrugDBName());


       }
    }
}

void RemoveAllDrugEffects(object oPC, object oDrugObj)
{
    if(!GetIsObjectValid(oPC) || !GetIsObjectValid(oDrugObj))
        return;
    RemoveAddiction(oPC,oDrugObj);
    string sTag = GetLocalString(oDrugObj,"DrugTag");
    DeleteDrugInt(oPC,"LastUsed"+sTag);
    effect eff = GetFirstEffect(oPC);
    while(GetIsEffectValid(eff))
    {
        if(GetEffectCreator(eff) == oDrugObj)
            RemoveEffect(oPC,eff);
        eff = GetNextEffect(oPC);
    }
}

int GetIsAddicted(object oDrugObj, object oPC=OBJECT_SELF)
{
    string sTag = GetLocalString(oDrugObj,"DrugTag");
    if(GetLocalInt(oPC,"Addicted"+sTag))
        return TRUE;
    return FALSE;
}

string GetDrugName(object oDrugObj)
{
    return GetLocalString(oDrugObj,"DrugName");
}

int GetDrugDC(object oDrugObj)
{
    return GetLocalInt(oDrugObj,"DrugDC");
}

int GetDrugRating(object oDrugObj)
{
    int nRating;
    int nDC = GetDrugDC(oDrugObj);
    switch(nDC) {       // Addiction DC
        case 4: nRating = 1; break;
        case 6: nRating = 2; break;
        case 10: nRating = 3; break;
        case 14: nRating = 4; break;
        case 25: nRating = 5; break;
        case 36: nRating = 6; break;
    }
    return nRating;
}


