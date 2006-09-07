//::///////////////////////////////////////////////
//:: OnPlayerRest eventscript
//:: prc_rest
//:://////////////////////////////////////////////
/*
    Hooked NPC's into this via prc_npc_rested - 06.03.2004, Ornedan
*/

#include "prc_alterations"
#include "psi_inc_psifunc"
#include "prc_sp_func"
#include "prc_inc_domain"
#include "inc_epicspells"

void PrcFeats(object oPC)
{
    if(DEBUG) DoDebug("prc_rest: Evaluating PC feats for " + DebugObject2Str(oPC));

    SetLocalInt(oPC,"ONREST",1);
    DeletePRCLocalIntsT(oPC);
    EvalPRCFeats(oPC);
    DelayCommand(1.0, DeleteLocalInt(oPC,"ONREST"));
    FeatSpecialUsePerDay(oPC);
}

void RestCancelled(object oPC)
{
    if(GetPRCSwitch(PRC_PNP_REST_HEALING))
    {
        int nHP = GetLocalInt(oPC, "PnP_Rest_InitialHP");
        //cancelled, dont heal anything
        //nHP += GetHitDice(oPC);
        int nCurrentHP = GetCurrentHitPoints(oPC);
        int nDamage = nCurrentHP-nHP;
        //check its a positive number
        if(nDamage > 0)
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY), oPC);
    }
    if(DEBUG) DoDebug("prc_rest: Rest cancelled for " + DebugObject2Str(oPC));
    DelayCommand(1.0,PrcFeats(oPC));
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERREST_CANCELLED);
}

void RestFinished(object oPC)
{
    if(DEBUG) DoDebug("prc_rest: Rest finished for for " + DebugObject2Str(oPC));
    //Restore Power Points for Psionics
    ExecuteScript("prc_psi_ppoints", oPC);
    BonusDomainRest(oPC);

    // To heal up enslaved creatures...
    object oSlave = GetLocalObject(oPC, "EnslavedCreature");
    if (GetIsObjectValid(oSlave) && !GetIsDead(oSlave) && !GetIsInCombat(oSlave))
            AssignCommand(oSlave, ActionRest());
            //ForceRest(oSlave);

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
        //only heal HP if not undead and not a construct
        if(MyPRCGetRacialType(oPC) != RACIAL_TYPE_UNDEAD
            && MyPRCGetRacialType(oPC) != RACIAL_TYPE_CONSTRUCT)
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

    //DelayCommand(1.0,PrcFeats(oPC));
    PrcFeats(oPC);

    //allow players to recruit a new cohort
    DeleteLocalInt(oPC, "CohortRecruited");

    //in large parties, sometimes people dont rest
    //loop over all and forcerest when nessicary
    //assumes NPCs start and finish resting after the PC
    if(!GetIsObjectValid(GetMaster(oPC)))
    {
        int nType;
        for(nType = 1; nType < 6; nType++)
        {
            int i = 1;
            object oOldTest;
            object oTest = GetAssociate(nType, oPC, i);
            while(GetIsObjectValid(oTest) && oTest != oOldTest)
            {
                if(GetCurrentAction(oTest) != ACTION_REST)
                    AssignCommand(oTest, DelayCommand(0.01, PRCForceRest(oTest)));
                i++;
                oOldTest = oTest;
                oTest = GetAssociate(nType, oPC, i);
            }

        }
    }

    // New Spellbooks
    DelayCommand(0.1, CheckNewSpellbooks(oPC));
    // PnP spellschools
    if(GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS)
        && GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
    {
        //need to put a check in to make sure the player
        //memorized one spell of their specialized
        //school for each spell level
        //also need to remove spells of prohibited schools
    }
    //skip time forward if applicable
    AdvanceTimeForPlayer(oPC, HoursToSeconds(8));

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERREST_FINISHED);
}

void RestStarted(object oPC)
{
    if(DEBUG) DoDebug("prc_rest: Rest started for " + DebugObject2Str(oPC));

    if (GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC)){
        SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0);
        SetLocalInt(oPC, "DRUNKEN_MASTER_IS_DRUNK_LIKE_A_DEMON", 0);
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
    
    SetLocalInt(oPC, "PnP_Rest_InitialHP", GetCurrentHitPoints(oPC));
    //clean up bonded summon
    if(GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC))
    {
        object oEle = GetLocalObject(oPC, "BONDED");
        effect eSummon = EffectVisualEffect(VFX_IMP_UNSUMMON);
        ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, GetLocation(oEle));
        AssignCommand(oEle, SetIsDestroyable(TRUE));
        DestroyObject(oEle);
    }
    // Remove Psionic Focus
    if(GetIsPsionicallyFocused(oPC))
    {
        LosePsionicFocus(oPC);
    }
    DeleteLocalInt(oPC, PRC_SPELL_CHARGE_COUNT);
    DeleteLocalInt(oPC, PRC_SPELL_CHARGE_SPELLID);
    DeleteLocalObject(oPC, PRC_SPELL_CONC_TARGET);
    if(GetLocalInt(oPC, PRC_SPELL_HOLD)) FloatingTextStringOnCreature("*Normal Casting*", oPC);
    DeleteLocalInt(oPC, PRC_SPELL_HOLD);
    DeleteLocalInt(oPC, PRC_SPELL_METAMAGIC);
    DeleteLocalManifestation(oPC, PRC_POWER_HOLD_MANIFESTATION);
    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERREST_STARTED);
}

void main()
{
    object oPC = GetLastBeingRested();

    if(DEBUG) DoDebug("prc_rest: Running for " + DebugObject2Str(oPC));
    
    // return here for DMs as they don't need all this stuff
    if(GetIsDM(oPC))
        return;

    //rest kits
    if(GetPRCSwitch(PRC_SUPPLY_BASED_REST))
        ExecuteScript("sbr_onrest", OBJECT_SELF);

    // Handle the PRCForceRest() wrapper
    if(GetLocalInt(oPC, "PRC_ForceRested"))
    {
        if(DEBUG) DoDebug("prc_rest: Handling forced rest");
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
