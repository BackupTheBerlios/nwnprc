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
        if(GetPRCSwitch(PRC_USE_DATABASE))
        {
            PRC_SQL_Store("Time_Year",  IntToString(GetCalendarYear()));
            PRC_SQL_Store("Time_Month", IntToString(GetCalendarMonth()));
            PRC_SQL_Store("Time_Day",   IntToString(GetCalendarDay()));
            PRC_SQL_Store("Time_Hour",  IntToString(GetTimeHour()));
            PRC_SQL_Store("Time_Minute",IntToString(GetTimeMinute()));
            PRC_SQL_Store("Time_Second",IntToString(GetTimeSecond()));
        }
        else
        {
            SetCampaignInt(GetName(GetModule()), "Time_Year", GetCalendarYear());
            SetCampaignInt(GetName(GetModule()), "Time_Month", GetCalendarMonth());
            SetCampaignInt(GetName(GetModule()), "Time_Day", GetCalendarDay());
            SetCampaignInt(GetName(GetModule()), "Time_Hour", GetTimeHour());
            SetCampaignInt(GetName(GetModule()), "Time_Minute", GetTimeMinute());
            SetCampaignInt(GetName(GetModule()), "Time_Second", GetTimeSecond());
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
            if(GetPRCSwitch(PRC_USE_DATABASE))
                PRC_SQL_Store(GetPCPlayerName(oPC)+GetName(oPC)+"_HP",  IntToString(GetCurrentHitPoints()));
            else
                SetCampaignInt(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_HP",  GetCurrentHitPoints());                    
            oPC = GetNextPC();
        }
    }
    if(GetPRCSwitch(PRC_PW_LOCATION_TRACKING))
    {
        object oPC = GetFirstPC();
        while(GetIsObjectValid(oPC))
        {
            location lLoc = GetLocation(oPC);
            vector vPos = GetPositionFromLocation(lLoc);
            object oArea = GetAreaFromLocation(lLoc);
            float fFacing = GetFacingFromLocation(lLoc);
            if(GetPRCSwitch(PRC_USE_DATABASE))
            {
                PRC_SQL_Store(GetPCPlayerName(oPC)+GetName(oPC)+"_LocX",  FloatToString(vPos.x));
                PRC_SQL_Store(GetPCPlayerName(oPC)+GetName(oPC)+"_LocY",  FloatToString(vPos.y));
                PRC_SQL_Store(GetPCPlayerName(oPC)+GetName(oPC)+"_LocY",  FloatToString(vPos.z));
                PRC_SQL_Store(GetPCPlayerName(oPC)+GetName(oPC)+"_LocF",  FloatToString(fFacing));
                PRC_SQL_Store(GetPCPlayerName(oPC)+GetName(oPC)+"_LocT",  GetTag(oArea));
                PRC_SQL_Store(GetPCPlayerName(oPC)+GetName(oPC)+"_LocR",  GetResRef(oArea));
            }                
            else
            {
                SetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocX",  FloatToString(vPos.x));
                SetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocY",  FloatToString(vPos.y));
                SetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocY",  FloatToString(vPos.z));
                SetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocF",  FloatToString(fFacing));
                SetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocT",  GetTag(oArea));
                SetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocR",  GetResRef(oArea));
            }    
            oPC = GetNextPC();
        }
    }
}
