#include "prc_alterations"
#include "inc_time"
#include "prc_inc_domain"
#include "prc_inc_clsfunc"
#include "inc_utility"
#include "inc_leto_prc"
#include "x2_inc_switches"
#include "prc_inc_teleport"


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

    //FloatingTextStringOnCreature("PRC on enter was called", oPC, FALSE);

    // Since OnEnter event fires for the PC when loading a saved game (no idea why,
    // since it makes saving and reloading change the state of the module),
    // make sure that the event gets run only once
    if(GetLocalInt(oPC, "PRC_ModuleOnEnterDone"))
        return;
    // Use a local integer to mark the event as done for the PC, so that it gets
    // cleared when the character is saved.
    else
        SetLocalInt(oPC, "PRC_ModuleOnEnterDone", TRUE);
        
    //if server is loading, boot player
    if(GetLocalInt(GetModule(), PRC_PW_LOGON_DELAY+"_TIMER"))
    {
        BootPC(oPC);
        return;
    }

    //do this first so other things dont interfere with it
    if(GetPRCSwitch(PRC_USE_LETOSCRIPT) && !GetIsDM(oPC))
        LetoPCEnter(oPC);
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE) && !GetIsDM(oPC)
        && ExecuteScriptAndReturnInt("prc_ccc_enter", OBJECT_SELF))
        return;

    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);

    // Gives people the proper spells from their bonus domains
    // This should run before EvalPRCFeats, because it sets a variable
    CheckBonusDomains(oPC);
    // Set the uses per day for domains
    BonusDomainRest(oPC);

    SetLocalInt(oPC,"ONENTER",1);
    // Make sure we reapply any bonuses before the player notices they are gone.
    DelayCommand(0.1, EvalPRCFeats(oPC));
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the entering player already meets.
    ExecuteScript("prc_prereq", oPC);
    ExecuteScript("prc_psi_ppoints", oPC);
    DelayCommand(0.15, DeleteLocalInt(oPC,"ONENTER"));
    
    //remove effects from hides, can stack otherwise
    effect eTest=GetFirstEffect(oPC);

    while (GetIsEffectValid(eTest))
    {
        if(GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL
            && (GetEffectType(eTest) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
                || GetEffectType(eTest) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE
                //add other types here
                )
            && !GetIsObjectValid(GetEffectCreator(eTest))
            )
            RemoveEffect(oPC, eTest);
        eTest=GetNextEffect(oPC);
   }

    //Anti Forum Troll Code
    //Thats right, the PRC now has grudges.
    string sPlayerName = GetStringLowerCase(GetPCPlayerName(oPC));
    if(sPlayerName == "archfiend")
    {
        BlackScreen(oPC);//cant see or do anything
    }


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
        struct time tTime = GetPersistantLocalTime(oPC, "persist_Time");
            //first pc logging on
        if(GetIsObjectValid(GetFirstPC()) 
            && !GetIsObjectValid(GetNextPC()))
        {
            SetTimeAndDate(tTime);
        }
        RecalculateTime();              
    }
    if(GetPRCSwitch(PRC_PW_LOCATION_TRACKING))
    {
        struct metalocation lLoc = GetPersistantLocalMetalocation(oPC, "persist_loc");
        DelayCommand(1.0, AssignCommand(oPC, JumpToLocation(MetalocationToLocation(lLoc))));
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
            sSpellList = GetStringRight(sSpellList, GetStringLength(sSpellList)-1);
        }
    }
    //check for persistant golems
    if(persistant_array_exists(oPC, "GolemList"))
    {
        MultisummonPreSummon(oPC, TRUE);
        int i;
        for(i=1;i<persistant_array_get_size(oPC, "GolemList");i++)
        {
            string sResRef = persistant_array_get_string(oPC, "GolemList",i);
            effect eSummon = SupernaturalEffect(EffectSummonCreature(sResRef));
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSummon, oPC);
        }
    }

    // Create map pins from marked teleport locations if the PC has requested that such be done.
    if(GetLocalInt(oPC, PRC_TELEPORT_CREATE_MAP_PINS))
        DelayCommand(10.0f, TeleportLocationsToMapPins(oPC));

    if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD)
        && !GetXP(oPC))
    {
        int nRealRace = GetRacialType(oPC);
        int nRacialHD = StringToInt(Get2DACache("ECL", "RaceHD", nRealRace));
        int nRacialClass = StringToInt(Get2DACache("ECL", "RaceClass", nRealRace));
        if(nRacialHD)
        {
            if(!GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD_NO_FREE_XP))
            {
                int nNewXP = nRacialHD*(nRacialHD+1)*500; //+1 for the original class level
                SetXP(oPC, nNewXP);
                if(GetPRCSwitch(PRC_XP_USE_SIMPLE_LA))
                    DelayCommand(1.0, SetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT, nNewXP));
            }
            if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD_NO_SELECTION))
            {
                int i;
                for(i=0;i<nRacialHD;i++)
                {
                    LevelUpHenchman(oPC, nRacialClass, TRUE);
                }
            }
        }
    }

    // Insert various debug things here
    if(DEBUG)
    {
        // Duplicate ItemPropertyBonusFeat monitor
        SpawnNewThread("PRC_Duplicate_IPBFeat_Mon", "prc_debug_hfeatm", 30.0f, oPC);
    }

    if(GetHasFeat(FEAT_SPELLFIRE_WIELDER, oPC) && GetThreadState("PRC_Spellfire", oPC) == THREAD_STATE_DEAD)
        SpawnNewThread("PRC_Spellfire", "prc_spellfire_hb", 6.0f, oPC);

    //if the player logged off while being registered as a cohort    
    if(GetPersistentLocalInt(oPC, "RegisteringAsCohort"))
        AssignCommand(GetModule(), CheckHB(oPC));

    // Execute scripts hooked to this event for the player triggering it
    //How can this work? The PC isnt a valid object before this. - Primogenitor
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONCLIENTENTER);
}
