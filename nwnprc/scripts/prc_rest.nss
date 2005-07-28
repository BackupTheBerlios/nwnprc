//::///////////////////////////////////////////////
//:: OnPlayerRest eventscript
//:: prc_rest
//:://////////////////////////////////////////////
/*
    Hooked NPC's into this via prc_npc_rested - 06.03.2004, Ornedan
*/

#include "inc_item_props"
#include "nw_i0_plot"
#include "prc_inc_function"
#include "prc_ipfeat_const"
#include "inc_epicspells"
#include "prc_inc_clsfunc"
#include "inc_newspellbook"
#include "prc_power_const"
#include "psi_inc_ac_manif"
#include "inc_eventhook"
#include "inc_prc_npc"
#include "inc_time"

void PrcFeats(object oPC)
{
     SetLocalInt(oPC,"ONREST",1);
     DeletePRCLocalIntsT(oPC);
     EvalPRCFeats(oPC);
     DeleteLocalInt(oPC,"ONREST");
     FeatSpecialUsePerDay(oPC);
}

void RestCancelled(object oPC)
{
    DelayCommand(1.0,PrcFeats(oPC));
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERREST_CANCELLED);
}

void RestStarted(object oPC)
{
    if (GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC)){
        SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0);
        SetLocalInt(oPC, "DRUNKEN_MASTER_IS_DRUNK_LIKE_A_DEMON", 0);
    }
    if (GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW))
    {
        //Destroy imbued arrows.
        AADestroyAllImbuedArrows(oPC);
    }
    /* Left here in case the multisummon trick is ever broken. In that case, use this to make Astral Constructs get unsummoned properly
    if(GetHasFeat(whatever feat determines if the PC can manifest Astral Construct here)){
        int i = 1;
        object oCheck = GetHenchman(oPC, i);
        while(oCheck != OBJECT_INVALID){
            if(GetStringLeft(GetTag(oCheck), 14) == "psi_astral_con")
                DoDespawn(oCheck);
            i++;
            oCheck = GetHenchman(oPC, i);
        }
    }
    */
    if(GetPRCSwitch(PRC_PNP_REST_HEALING))
    {
        SetLocalInt(oPC, "PnP_Rest_InitialHP", GetCurrentHitPoints(oPC));
    }
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERREST_STARTED);
}

void RestFinished(object oPC)
{
    //Restore Power Points for Psionics
    ExecuteScript("prc_psi_ppoints", oPC);

    // To heal up enslaved creatures...
    object oSlave = GetLocalObject(oPC, "EnslavedCreature");
    if (GetIsObjectValid(oSlave) && !GetIsDead(oSlave) && !GetIsInCombat(oSlave)) 
            AssignCommand(oSlave, ActionRest());
            //ForceRest(oSlave);

    if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC))
    {
        object oFam =  GetLocalObject(oPC, "BONDED");
        if (GetIsObjectValid(oFam) && !GetIsDead(oFam) && !GetIsInCombat(oFam)) 
            //ForceRest(oFam);
            AssignCommand(oFam, ActionRest());
    }

    if (GetHasFeat(FEAT_LIPS_RAPTUR,oPC)){
        int iLips=GetAbilityModifier(ABILITY_CHARISMA,oPC)+1;
        if (iLips<2)iLips=1;
        SetLocalInt(oPC,"FEAT_LIPS_RAPTUR",iLips);
        SendMessageToPC(oPC," Lips of Rapture : use "+IntToString(iLips-1));
    }

    if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
    GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC)) {
        FloatingTextStringOnCreature("*You feel refreshed*", oPC, FALSE);
        ReplenishSlots(oPC);
    }

    if (GetHasFeat(FEAT_SF_CODE,oPC))
        RemoveSpecificProperty(GetPCSkin(oPC),ITEM_PROPERTY_BONUS_FEAT,IP_CONST_FEAT_SF_CODE);

    // begin flurry of swords array
    if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC))
    {
        DeleteLocalInt(oPC, "FLURRY_TARGET_NUMBER");

        int i;
        for (i = 0 ; i < 10 ; i++)
        {
            string sName = "FLURRY_TARGET_" + IntToString(i);
            SetLocalObject(oPC, sName, OBJECT_INVALID);
        }
    }
    // end flurry or swords array

    if(GetPRCSwitch(PRC_PNP_REST_HEALING))
    {
        int nHP = GetLocalInt(oPC, "PnP_Rest_InitialHP");
        nHP += GetHitDice(oPC);
        int nCurrentHP = GetCurrentHitPoints(oPC);
        int nDamage = nCurrentHP-nHP;
        //check its a positive number
        if(nDamage > 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT, 
                EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oPC);
    }
    
    int nSpellCount = GetPRCSwitch(PRC_DISABLE_SPELL_COUNT);
    int i;
    string sMessage;
    for(i=1;i<nSpellCount;i++)
    {
        int nSpell = GetPRCSwitch(PRC_DISABLE_SPELL_+IntToString(i));
        int nMessage;
        while(GetHasSpell(nSpell, oPC))
        {
            if(!nMessage)
            {
                sMessage += "You cannot use "+GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell)))+" in this module.\n";
                nMessage = TRUE;
            }   
            DecrementRemainingSpellUses(oPC, nSpell);
        }
    }
    if(sMessage != "")
        FloatingTextStringOnCreature(sMessage, oPC, TRUE);
    
    DelayCommand(1.0,PrcFeats(oPC));

    // New Spellbooks
    DelayCommand(0.01, CheckNewSpellbooks(oPC));
    // PnP spellschools
    if(GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS)
        && GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
    {
        //need to put a check in to make sure the player
        //memorized one spell of their specialized
        //school for each spell level
        //also need to remove spells of prohibited schools
    }
    
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERREST_FINISHED);
}

void main()
{
    object oPC = GetLastBeingRested();
    
    //rest kits
    if(GetPRCSwitch(PRC_SUPPLY_BASED_REST))
        ExecuteScript("sbr_onrest", OBJECT_SELF);
    
    // Handle the PRCForceRest() wrapper
    if(GetLocalInt(oPC, "PRC_ForceRested"))
    {
        RestStarted(oPC);
        // A minor delay to break the script association and to lessen TMI chances
        DelayCommand(0.1f, RestFinished(oPC));
        // Clear the flag
        DeleteLocalInt(oPC, "PRC_ForceRested");
    }
    else
    {
        switch(MyGetLastRestEventType()){
            case REST_EVENTTYPE_REST_CANCELLED:{
                RestCancelled(oPC);
                break;
            }
            case REST_EVENTTYPE_REST_STARTED:{
                RestStarted(oPC);
                break;
            }
            case REST_EVENTTYPE_REST_FINISHED:{
                RestFinished(oPC);
                break;
            }
            case REST_EVENTTYPE_REST_INVALID:{
                break;
            }
        }
    }
}
