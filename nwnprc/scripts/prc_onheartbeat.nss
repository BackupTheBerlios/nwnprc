//::///////////////////////////////////////////////
//:: OnHeartbeat eventscript
//:: prc_onheartbeat
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_leadersh"

void main()
{
    if(DEBUG) SetLocalObject(GetModule(), "PRC_Debug_FirstPC", GetFirstPC());

    // Item creation code
    ExecuteScript("hd_o0_heartbeat",OBJECT_SELF);


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
    int nMapPinCount, i;
    int bHasPoly;
    effect eTest;

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
    if(bBiowareDBCache > 0)
    {
        if(GetLocalInt(GetModule(), "Bioware2dacacheCount") >= bBiowareDBCache)
            DeleteLocalInt(GetModule(), "Bioware2dacacheCount");
        else
        {
            SetLocalInt(GetModule(), "Bioware2dacacheCount", GetLocalInt(GetModule(), "Bioware2dacacheCount") + 1);
            bBiowareDBCache = FALSE;
        }
        if(bBiowareDBCache)
        {
            //due to biowares piss-poor database coding, you have to destroy the old database before storing
            //the object
            //If you dont, the dataabse will bloat infinitely because when overriting an existing
            //database entry really marks the old entry as "deleted" ( but doesnt actually remove it)
            //and creates a new entry instead.

            if(DEBUG) DoDebug                 ("Storing Bioware2DACache");
            else      WriteTimestampedLogEntry("Storing Bioware2DACache");
            string sDBName = GetBiowareDBName();
            DestroyCampaignDatabase(sDBName);
            object o2daCache = GetObjectByTag("Bioware2DACache");
            // Rebuild the DB
            StoreCampaignObject(sDBName, "CacheChest", o2daCache);
            SetCampaignString(sDBName, "version", PRC_VERSION);
            SetCampaignString(sDBName, "PRC_2DA_Cache_Fingerprint", GetLocalString(GetModule(), "PRC_2DA_Cache_Fingerprint"));
            if(DEBUG) DoDebug                 ("Finished storing Bioware2DACache");
            else      WriteTimestampedLogEntry("Finished storing Bioware2DACache");
        }
    }

    // Start looping
    object oPC = GetFirstPC(); // Init the PC object
    while(GetIsObjectValid(oPC))
    {
        // no running stuff for DMs
        if(!GetIsDM(oPC))
        {
            // Persistent World time tracking
            if(bPWTime)
            {
                //store it on all PCs separately
                SetPersistantLocalTime(oPC, "persist_Time", GetTimeAndDate());
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
                SetPersistantLocalInt(oPC, "persist_HP", GetCurrentHitPoints(oPC));
            // Persistant location tracking
            if(bPWLocationTracking)
                SetPersistantLocalMetalocation(oPC, "persist_loc", LocationToMetalocation(GetLocation(oPC)));
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
            //run the individual HB event script
            ExecuteScript("prc_onhb_indiv", oPC);
        }
        // Get the next PC for the loop
        oPC = GetNextPC();
    }
}
