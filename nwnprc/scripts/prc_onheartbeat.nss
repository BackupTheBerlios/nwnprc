//::///////////////////////////////////////////////
//:: OnHeartbeat eventscript
//:: prc_onheartbeat
//:://////////////////////////////////////////////

#include "inc_eventhook"
#include "inc_ecl"
#include "inc_2dacache"

void main()
{
    // Item creation code
    ExecuteScript("hd_o0_heartbeat",OBJECT_SELF);

    // Race Pack Code
    ExecuteScript("race_hb", GetModule() );

    // Execute hooked HB scripts for all players
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONHEARTBEAT);
        ApplyECLToXP(oPC);
        oPC = GetNextPC();
    }
    if(GetPRCSwitch(PRC_PW_TIME))
    {
        //store it on all PCs separately
        object oPC = GetFirstPC();
        while(GetIsObjectValid(oPC))
        {
            SetPersistantLocalInt(oPC, "persist_Time_Year", GetCalendarYear());
            SetPersistantLocalInt(oPC, "persist_Time_Month", GetCalendarMonth());
            SetPersistantLocalInt(oPC, "persist_Time_Day", GetCalendarDay());
            SetPersistantLocalInt(oPC, "persist_Time_Hour", GetTimeHour());
            SetPersistantLocalInt(oPC, "persist_Time_Minute", GetTimeMinute());
            SetPersistantLocalInt(oPC, "persist_Time_Second", GetTimeSecond());
            oPC = GetNextPC();
        }
    }
    if(GetPRCSwitch(PRC_PW_PC_AUTOEXPORT))
    {
        if(GetLocalInt(GetModule(), "AutoexportCount") == GetPRCSwitch(PRC_PW_PC_AUTOEXPORT))
        {
            object oPC = GetFirstPC();
            while(GetIsObjectValid(oPC))
            {
                int nHasPoly;
                effect eTest = GetFirstEffect(oPC);
                while(GetIsEffectValid(eTest) && !nHasPoly)
                {
                    if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
                        nHasPoly = TRUE;
                    eTest = GetNextEffect(oPC);
                }
                if(!nHasPoly)
                    ExportSingleCharacter(oPC);
                oPC = GetNextPC();
            }
            DeleteLocalInt(GetModule(), "AutoexportCount");
        }
        else
            SetLocalInt(GetModule(), "AutoexportCount", GetLocalInt(GetModule(), "AutoexportCount")+1);
    }
    if(GetPRCSwitch(PRC_PW_HP_TRACKING))
    {
        object oPC = GetFirstPC();
        while(GetIsObjectValid(oPC))
        {   
            SetPersistantLocalInt(oPC, "persist_HP", GetCurrentHitPoints(oPC));
            oPC = GetNextPC();
        }
    }
    if(GetPRCSwitch(PRC_PW_LOCATION_TRACKING))
    {
        object oPC = GetFirstPC();
        while(GetIsObjectValid(oPC))
        {
            SetPersistantLocalLocation(oPC, "persist_loc", GetLocation(oPC));
            oPC = GetNextPC();
        }
    }
}
