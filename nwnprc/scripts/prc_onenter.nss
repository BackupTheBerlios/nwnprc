#include "inc_item_props"
#include "prc_inc_function"
#include "prc_inc_clsfunc"
#include "inc_eventhook"
#include "prc_inc_switch"
#include "inc_leto_prc"
#include "inc_time"    
#include "inc_metalocation"
#include "x2_inc_switches"


void main()
{
    //The composite properties system gets confused when an exported
    //character re-enters.  Local Variables are lost and most properties
    //get re-added, sometimes resulting in larger than normal bonuses.
    //The only real solution is to wipe the skin on entry.  This will
    //mess up the lich, but only until I hook it into the EvalPRC event -
    //hopefully in the next update
    //  -Aaon Graywolf
    object oPC = GetEnteringObject();
    
    //do this first so other things dont interfere with it
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE)
        && ExecuteScriptAndReturnInt("prc_ccc_enter", OBJECT_SELF))
        return;  
    
    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);

    SetLocalInt(oPC,"ONENTER",1);
    // Make sure we reapply any bonuses before the player notices they are gone.
    DelayCommand(0.1, EvalPRCFeats(oPC));
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the entering player already meets.
    ExecuteScript("prc_prereq", oPC);
    ExecuteScript("prc_psi_ppoints", oPC);
    if (GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW))
    {
        //Destroy imbued arrows.
        AADestroyAllImbuedArrows(oPC);
    }
    DelayCommand(0.15, DeleteLocalInt(oPC,"ONENTER"));
    
    //Anti Forum Troll Code
    //Thats right, the PRC now has grudges.
    string sPlayerName = GetStringLowerCase(GetPCPlayerName(oPC));
    if(sPlayerName == "archfiend")
    {
        BlackScreen(oPC);//cant see or do anything
    }
    
    if(GetPRCSwitch(PRC_USE_LETOSCRIPT) && !GetIsDM(oPC))
        LetoPCEnter(oPC);
    if(GetPRCSwitch(PRC_LETOSCRIPT_FIX_ABILITIES) && !GetIsDM(oPC))
        PRCLetoEnter(oPC);     
    //PW tracking starts here
    if(GetPRCSwitch(PRC_PW_HP_TRACKING))
    {
        int nHP = GetPersistantLocalInt(oPC, "persist_HP");                   
        if(nHP != 0)  // 0 is not stored yet i.e. first logon
        {
            int nDamage=GetCurrentHitPoints(oPC)-nHP;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDamage), oPC);
        }
        
    }     
    if(GetPRCSwitch(PRC_PW_TIME))
    {
        int nYear   = GetPersistantLocalInt(oPC, "persist_Time_Year");
        int nMonth  = GetPersistantLocalInt(oPC, "persist_Time_Month");
        int nDay    = GetPersistantLocalInt(oPC, "persist_Time_Day");
        int nHour   = GetPersistantLocalInt(oPC, "persist_Time_Hour");
        int nMinute = GetPersistantLocalInt(oPC, "persist_Time_Minute");
        int nSecond = GetPersistantLocalInt(oPC, "persist_Time_Second");
        if(GetPRCSwitch(PRC_PLAYER_TIME))
        {
            nYear   -= GetCalendarYear();
            nMonth  -= GetCalendarMonth();
            nDay    -= GetCalendarDay();
            nHour   -= GetTimeHour();
            nMinute -= GetTimeMinute();
            nSecond -= GetTimeSecond();
            nSecond = nSecond+((nMinute*60)+FloatToInt(HoursToSeconds(nHour))+(nDay*24*60)+(nMonth*28*24*60)+(nYear*12*28*24*60));
            AdvanceTimeForPlayer(oPC, IntToFloat(nSecond));
        }
        else if(GetIsObjectValid(GetFirstPC()) && !GetIsObjectValid(GetNextPC()))
        {
            //first pc logging on
            SetCalendar(nYear, nMonth, nDay);
            SetTime(nHour, nMinute, nSecond, 0);//dont care about milliseconds
        }
    }
    if(GetPRCSwitch(PRC_PW_LOCATION_TRACKING))
    {
        location lLoc = GetPersistantLocalLocation(oPC, "persist_loc"); 
        DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lLoc)));
    }
    if(GetPRCSwitch(PRC_PW_MAPPIN_TRACKING)
        && !GetLocalInt(oPC, "PRC_PW_MAPPIN_TRACKING_Done"))
    {
        //this local is set so that this is only done once per server session
        SetLocalInt(oPC, "PRC_PW_MAPPIN_TRACKING_Done", TRUE);
        int nCount = GetPersistantLocalInt(oPC, "MapPinCount");
        int i;
        for(i=1; i<=nCount; i++)
        {
            struct metalocation mlocLoc = GetPersistantLocalMetalocation(oPC, "MapPin_"+IntToString(i));
            CreateMapPinFromMetalocation(mlocLoc, oPC);
        }
    }
    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING))
    {
        int bDead = GetPersistantLocalInt(oPC, "persist_dead");                     
        if(bDead == 1)
        {
            int nDamage=9999;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDamage), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        }
            
    }    
    if(GetPRCSwitch(PRC_PW_SPELL_TRACKING))
    {
        string sSpellList = GetPersistantLocalString(oPC, "persist_spells"); 
        string sTest;
        string sChar;
        while(GetStringLength(sSpellList))
        {
            sChar = GetStringLeft(sSpellList,1);
            if(sChar == "|")
            {
                int nSpell = StringToInt(sTest);
                DecrementRemainingSpellUses(oPC, nSpell);
                sTest == "";
            }
            else
                sTest += sChar;
            sSpellList = GetStringRight(sSpellList, GetStringLength(sSpellList)+1);
        }
    }
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTENTER);
    

}
