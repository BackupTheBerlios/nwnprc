//::///////////////////////////////////////////////
//:: OnHeartbeat eventscript
//:: prc_onheartbeat
//:://////////////////////////////////////////////

#include "inc_eventhook"
#include "inc_ecl"
#include "inc_2dacache"
#include "inc_metalocation"

void main()
{
    // Item creation code
    ExecuteScript("hd_o0_heartbeat",OBJECT_SELF);

    // Race Pack Code
    ExecuteScript("race_hb", GetModule() );

    /* Loop over all players, executing various things */
    // Cache switch values to variables. This is one of the places where optimization
    // counts, so also reserve the space for variables used in the loop outside it
    // so as not to waste time reserving them every iteration.
    int bPWTime             = GetPRCSwitch(PRC_PW_TIME),
        bPWPCAutoexport     = GetPRCSwitch(PRC_PW_PC_AUTOEXPORT),
        bPWHPTracking       = GetPRCSwitch(PRC_PW_HP_TRACKING),
        bPWLocationTracking = GetPRCSwitch(PRC_PW_LOCATION_TRACKING),
        bPWMappinTracking   = GetPRCSwitch(PRC_PW_MAPPIN_TRACKING),
        bBiowareDBCache     = GetPRCSwitch(PRC_USE_BIOWARE_DATABASE);
    int bHasPoly;
    effect eTest;
    int nMapPinCount, i;
    // Run some autoexport stuff first. This determines if it needs to loop over players at all
    if(bPWPCAutoexport)
    {
        if(GetLocalInt(GetModule(), "AutoexportCount") == bPWPCAutoexport)
            DeleteLocalInt(GetModule(), "AutoexportCount");
        else
        {
            SetLocalInt(GetModule(), "AutoexportCount", GetLocalInt(GetModule(), "AutoexportCount") + 1);
            bPWPCAutoexport = FALSE;
        }
    }
    
    //decide if to cache bioware 2da yet
    if(bBiowareDBCache)
    {
        if(GetLocalInt(GetModule(), "Bioware2dacacheCount") == bBiowareDBCache)
            DeleteLocalInt(GetModule(), "Bioware2dacacheCount");
        else
        {
            SetLocalInt(GetModule(), "Bioware2dacacheCount", GetLocalInt(GetModule(), "Bioware2dacacheCount") + 1);
            bBiowareDBCache = FALSE;
        }
        if(bBiowareDBCache)
        {
            object o2daCache = GetObjectByTag("Bioware2DACache");
            StoreCampaignObject("PRC2da", "CacheChest", o2daCache);
        }
    }

    // Start looping
    object oPC = GetFirstPC(); // Init the PC object
    while(GetIsObjectValid(oPC))
    {
        // Eventhook
        ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONHEARTBEAT);
        // ECL
        ApplyECLToXP(oPC);
        
        // Check if the character has lost a level since last HB
        if(GetHitDice(oPC) != GetLocalInt(oPC, "PRC_HitDiceTracking"))
        {
            if(GetHitDice(oPC) < GetLocalInt(oPC, "PRC_HitDiceTracking"))
                DelayCommand(0.0f, ExecuteScript("prc_onleveldown", oPC));

            SetLocalInt(oPC, "PRC_HitDiceTracking", GetHitDice(oPC));
        }

        // Persistent World time tracking
        if(bPWTime)
        {
            //store it on all PCs separately
            SetPersistantLocalInt(oPC, "persist_Time_Year", GetCalendarYear());
            SetPersistantLocalInt(oPC, "persist_Time_Month", GetCalendarMonth());
            SetPersistantLocalInt(oPC, "persist_Time_Day", GetCalendarDay());
            SetPersistantLocalInt(oPC, "persist_Time_Hour", GetTimeHour());
            SetPersistantLocalInt(oPC, "persist_Time_Minute", GetTimeMinute());
            SetPersistantLocalInt(oPC, "persist_Time_Second", GetTimeSecond());
        }
        // Automatic character export every 6n seconds
        if(bPWPCAutoexport)
        {
            bHasPoly = FALSE;
            eTest = GetFirstEffect(oPC);
            while(!bHasPoly && GetIsEffectValid(eTest))
            {
                if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
                    bHasPoly = TRUE;
                else
                    eTest = GetNextEffect(oPC);
            }
            if(!bHasPoly)
                ExportSingleCharacter(oPC);
        }
        // Persistant hit point tracking
        if(bPWHPTracking)
        {
            SetPersistantLocalInt(oPC, "persist_HP", GetCurrentHitPoints(oPC));
        }
        // Persistant location tracking
        if(bPWLocationTracking)
        {
            SetPersistantLocalLocation(oPC, "persist_loc", GetLocation(oPC));
        }
        // Persistant map pin tracking
        if(bPWMappinTracking)
        {
            nMapPinCount = GetNumberOfMapPins(oPC);
            for(i = 1; i <= nMapPinCount; i++)
            {
                struct metalocation mLoc = CreateMetalocationFromMapPin(oPC, i);
                SetPersistantLocalMetalocation(oPC, "MapPin_" + IntToString(i), mLoc);
            }
            SetPersistantLocalInt(oPC, "MapPinCount", nMapPinCount);
        }

        // Get the next PC for the loop
        oPC = GetNextPC();
    }
}
