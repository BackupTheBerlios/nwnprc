#include "inc_item_props"
#include "prc_inc_function"
#include "prc_inc_clsfunc"
#include "inc_eventhook"
#include "prc_inc_switch"
#include "inc_leto_prc"


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
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE))
        ExecuteScript("prc_ccc_enter", OBJECT_SELF);         
    if(GetPRCSwitch(PRC_PW_HP_TRACKING))
    {
        int nHP;
        if(GetPRCSwitch(PRC_USE_DATABASE))
            nHP = StringToInt(PRC_SQL_Retrieve(GetPCPlayerName(oPC)+GetName(oPC)+"_HP"));
        else
            nHP = GetCampaignInt(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_HP");                    
        if(nHP != 0)  // 0 is not stored yet i.e. first logon
        {
            int nDamage=GetCurrentHitPoints(oPC)-nHP;
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nHP), oPC);
        }
        
    }     
    if(GetPRCSwitch(PRC_PW_LOCATION_TRACKING))
    {
        float fLocX;
        float fLocY;
        float fLocZ;
        float fLocFacing;
        string sLocTag;
        string sLocResRef;
        if(GetPRCSwitch(PRC_USE_DATABASE))
        {
            fLocX = StringToFloat(PRC_SQL_Retrieve(GetPCPlayerName(oPC)+GetName(oPC)+"_LocX"));
            fLocY = StringToFloat(PRC_SQL_Retrieve(GetPCPlayerName(oPC)+GetName(oPC)+"_LocY"));
            fLocZ = StringToFloat(PRC_SQL_Retrieve(GetPCPlayerName(oPC)+GetName(oPC)+"_LocY"));
            fLocFacing = StringToFloat(PRC_SQL_Retrieve(GetPCPlayerName(oPC)+GetName(oPC)+"_LocF"));
            sLocTag = PRC_SQL_Retrieve(GetPCPlayerName(oPC)+GetName(oPC)+"_LocT");
            sLocResRef = PRC_SQL_Retrieve(GetPCPlayerName(oPC)+GetName(oPC)+"_LocR");
        }                
        else
        {
            fLocX = StringToFloat(GetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocX"));
            fLocY = StringToFloat(GetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocY"));
            fLocZ = StringToFloat(GetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocY"));
            fLocFacing = StringToFloat(GetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocF"));
            sLocTag = GetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocT");
            sLocResRef = GetCampaignString(GetName(GetModule()), GetPCPlayerName(oPC)+GetName(oPC)+"_LocR");
        }    
        vector vPos = Vector(fLocX, fLocY, fLocZ);
        int i;
        object oArea = GetObjectByTag(sLocTag, i);
        while(GetIsObjectValid(oArea))
        {
            if(GetResRef(oArea) == sLocResRef)
                break;//end while loop
            i++;
            oArea = GetObjectByTag(sLocTag, i);
        }
        location lLoc = Location(oArea, vPos, fLocFacing);
        DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lLoc)));
    }
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTENTER);
    

}
