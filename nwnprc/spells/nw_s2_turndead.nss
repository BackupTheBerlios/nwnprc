//::///////////////////////////////////////////////
//:: Turn Undead
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks domain powers and class to determine
    the proper turning abilities of the casting
    character.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 2, 2001
//:: Updated On: Jul 15, 2003 - Georg Zoeller
//:://////////////////////////////////////////////
/*
These classes all stack for determining turning:
Cleric
Paladin-2
Anti-Paladin-2
Blackguard-2
True Necromancer
Soldier of Light
Hospitalier-2
Balenorm
Drow Judicator
*/

#include "prc_alterations"
#include "inc_target_list"

//gets the number of class levels that count for turning
int GetTurningClassLevel(int bUndeadOnly = FALSE);

//this does the check and adjusts the highest HD of undead turned
int GetTurningCheckResult(int nLevel, int nChaMod);

//this creates the list of targets that are affected
//use the inc_target_list functions
void MakeTurningTargetList(int nTurningMaxHD, int nTurningTotalHD);

//tests if the target can be turned by self
//includes race, domains, etc.
int GetCanTurn(object oTarget);

//gets the equivalent HD total for turning purposes
//includes turn resistance and SR for outsiders
int GetHitDiceForTurning(object oTarget);

//the main turning function once targets have been listed
//routs to turn/destroy/rebuke/command as appropaite
void DoTurnAttempt(object oTarget, int nTurningMaxHD, int nLevel);

int GetCommandedTotalHD();

//various sub-turning effect funcions

void DoTurn(object oTarget);
void DoDestroy(object oTarget);
void DoRebuke(object oTarget);
void DoCommand(object oTarget, int nLevel);

void main()
{
    //casters level for turning
    int nLevel = GetTurningClassLevel();
        
    //casters charimsa modifier
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA);
    //Heartwarder adds two to cha checks
    if (GetHasFeat(FEAT_HEART_PASSION))
        nChaMod +=2;
    
    //key values for turning
    int nTurningTotalHD = d6(2)+nLevel+nChaMod;
    int nTurningMaxHD = GetTurningCheckResult(nLevel, nChaMod);
    
    //these stack but dont multiply
    //so use a bonus amount and then add that on later
    int nBonusTurningTotalHD;
    int nBonusTurningMaxHD;
    //apply maximize turning
    //+100% if good
    if(GetHasFeat(FEAT_MAXIMIZE_TURNING) 
        && GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
        nBonusTurningTotalHD += nTurningTotalHD;
    //apply empowered turning
    //+50%
    //only if maximize doesnt apply
    else if(GetHasFeat(FEAT_EMPOWER_TURNING))
        nBonusTurningTotalHD += nTurningTotalHD/2;
    //sun domain
    //+d6 total +d4 max
    //Nope, now its PnP :)
    //Destroys any undead that would be turned/rebuked/dominated
    //Usable once per day
    /*
    if(GetHasFeat(FEAT_SUN_DOMAIN_POWER))
    {
        nBonusTurningTotalHD +=d6();
        nBonusTurningMaxHD +=d4();
    }*/
    //add bonus HD    
    nTurningTotalHD += nBonusTurningTotalHD;    
    nTurningMaxHD   += nBonusTurningMaxHD;   
    
    //zone of animation effect
    // You can use a rebuke or command undead attempt to animate 
    //corpses within range of your rebuke or command attempt. 
    //You animate a total number of HD of undead equal to the 
    //number of undead that would be commanded by your result 
    //(though you can’t animate more undead than there are available 
    //corpses within range). You can’t animate more undead with 
    //any single attempt than the maximum number you can command 
    //(including any undead already under your command). These 
    //undead are automatically under your command, though your 
    //normal limit of commanded undead still applies. If the 
    //corpses are relatively fresh, the animated undead are zombies.  
    //Otherwise, they are skeletons. 
    if(GetLocalInt(OBJECT_SELF, "UsingZoneOfAnimation"))
    {
        effect eVFX = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
        int nHDCount = GetCommandedTotalHD();
        while(nHDCount < nTurningMaxHD)
        {
            location lLoc = GetRandomCircleLocation(GetLocation(OBJECT_SELF), FeetToMeters(60.0));
            //skeletal blackguard
            string sResRef = "x2_s_bguard_18"; 
            object oCreated = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lLoc);
            nHDCount += GetHitDiceForTurning(oCreated);
        }
        return;
    }
    
    SendMessageToPC(OBJECT_SELF, "You are turning "+IntToString(nTurningTotalHD)+"HD of creatures whose HD is equal or less than "+IntToString(nTurningMaxHD));
    
    //assemble the list of targets to try to turn
    MakeTurningTargetList(nTurningMaxHD, nTurningTotalHD);
    
    //cycle through target list
    object oTarget = GetTargetListHead(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        DoTurnAttempt(oTarget, nTurningMaxHD, nLevel);
        oTarget = GetTargetListHead(OBJECT_SELF);
    }
}

//private function
//only used by DoTurnAttempt
//TRUE == Turn
//FALSE == Rebuke
int GetIsTurnNotRebuke(object oTarget)
{
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
    {
        if((GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD
                && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
            || (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL
                && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) 
        )   
            return FALSE;
        else
            return TRUE;
    }
    else if(GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
    {
        return FALSE;
    }
    return TRUE;    
}

void DoTurnAttempt(object oTarget, int nTurningMaxHD, int nLevel)
{ 

    //signal the event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    
    //constructs are damaged not turned/destroyed/rebuked/commanded
    if(MyPRCGetRacialType(oTarget)==RACIAL_TYPE_CONSTRUCT)
    {
        int nDamage = d3(nTurningMaxHD);
        effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
        eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_SUNSTRIKE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    }
    else
    {
        //sun domain
        //destroys instead of turn/rebuke/command
        //useable once per day only
        if(GetLocalInt(OBJECT_SELF, "UsingSunDomain"))
        {
            DoDestroy(oTarget);
        }
        else
        {
            int nTargetHD = GetHitDiceForTurning(oTarget);
            if(GetIsTurnNotRebuke(oTarget))
            {
                //if half of level, destroy
                //otherwise turn
                if(nTargetHD < nLevel/2)    DoDestroy(oTarget);
                else                        DoTurn(oTarget);            
            }
            else
            {
                //if half of level, command
                //otherwise rebuke
                if(nTargetHD < nLevel/2)    DoCommand(oTarget, nLevel);
                else                        DoRebuke(oTarget);            
            }            
        }
    }
    
    // Check for Exalted Turning
    //take 3d6 damage if they do
    if (GetHasFeat(FEAT_EXALTED_TURNING)
        && GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_EVIL)
    {
        effect eDamage = EffectDamage(d6(3), DAMAGE_TYPE_DIVINE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    }   
}

void DoTurn(object oTarget)
{
    //create the effect 
    effect eTurn = EffectTurned();
    eTurn = EffectLinkEffects(eTurn, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
    eTurn = EffectLinkEffects(eTurn, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    //apply the effect for 60 seconds
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTurn, oTarget, 60.0);
}

void DoDestroy(object oTarget)
{
    //create the effect 
    //supernatural so it penetrates immunity to death
    effect eDestroy = SupernaturalEffect(EffectDeath());
    //apply the effect
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDestroy, oTarget);
}

void DoRebuke(object oTarget)
{
    //rebuke effect
    //The character is frozen in fear and can take no actions. 
    //A cowering character takes a -2 penalty to Armor Class and loses 
    //her Dexterity bonus (if any). 
    //create the effect 
    effect eRebuke = EffectEntangle(); //this removes dex bonus
    eRebuke = EffectLinkEffects(eRebuke, EffectACDecrease(2));
    eRebuke = EffectLinkEffects(eRebuke, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
    eRebuke = EffectLinkEffects(eRebuke, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    //apply the effect for 60 seconds
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRebuke, oTarget, 60.0);    
    //handle unable to take actions
    AssignCommand(oTarget, ClearAllActions());
    AssignCommand(oTarget, DelayCommand(60.0, SetCommandable(TRUE)));
    AssignCommand(oTarget, SetCommandable(FALSE));
}

void DoCommand(object oTarget, int nLevel)
{    
    //Undead Mastery multiplies total HD by 10
    //non-undead have their HD score multiplied by 10 to compensate
    if(GetHasFeat(FEAT_UNDEAD_MASTERY))
        nLevel *= 10;   
        
    int nCommandedTotalHD = GetCommandedTotalHD();
    
    int nTargetHD = GetHitDiceForTurning(oTarget);
    //undead mastery only applies to undead
    //so non-undead have thier HD multiplied by 10
    if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD
        && GetHasFeat(FEAT_UNDEAD_MASTERY))
        nTargetHD *= 10;
        
    if(nCommandedTotalHD + nTargetHD <= nLevel)
    {
        //create the effect 
        //supernatural dominated vs cutscenedominated
        //supernatural will last over resting
        //Why not use both?
        //effect eCommand = SupernaturalEffect(EffectDominated());
        effect eCommand = SupernaturalEffect(EffectCutsceneDominated());
        eCommand = EffectLinkEffects(eCommand, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCommand, oTarget);        
    }
    //not enough commanding power left
    //rebuke instead
    else
        DoRebuke(oTarget);
}


void MakeTurningTargetList(int nTurningMaxHD, int nTurningTotalHD)
{
    int nHDCount;
    int i = 1;
    object oTest = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, i);
    while(GetIsObjectValid(oTest)
        && GetDistanceToObject(oTest) < FeetToMeters(60.0)
        && nHDCount <= nTurningTotalHD)
    {
        int nTargetHD = GetHitDiceForTurning(oTest);
        if(GetCanTurn(oTest)
            && nTargetHD <= nTurningMaxHD
            && nHDCount+nTargetHD <= nTurningTotalHD)
        {    
            AddToTargetList(oTest, OBJECT_SELF, INSERTION_BIAS_DISTANCE);
            nHDCount += nTargetHD;
        }    
        
        //move to next test
        i++;
        oTest = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, i);
    }
}

int GetCanTurn(object oTarget)
{
    //is not an enemy
    if(!spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE ,OBJECT_SELF))
        return FALSE;
        
    //already turned
//NOTE: At the moment this breaks down in "turning conflicts" where clerics try to
//turn each others undead. Fix later.
    if(GetHasSpellEffect(GetSpellId(), oTarget))
        return FALSE;
        
    //can turn the targets race
    int nTargetRace = MyPRCGetRacialType(oTarget);
    switch(nTargetRace)
    {
        case RACIAL_TYPE_UNDEAD:
            //drow judicators cant turn undead on their own
            //so check that it has at least 1 level in another class with turning
            if(!GetTurningClassLevel(TRUE))
                return FALSE;               
            break;
        case RACIAL_TYPE_OUTSIDER:  
            if(!GetHasFeat(FEAT_GOOD_DOMAIN_POWER)
                && !GetHasFeat(FEAT_EVIL_DOMAIN_POWER)
                && !GetHasFeat(FEAT_EPIC_PLANAR_TURNING)
                && !GetLevelByClass(CLASS_TYPE_ANTI_PALADIN))
                return FALSE;
            break;
        case RACIAL_TYPE_ELEMENTAL:  
            if(!GetHasFeat(FEAT_AIR_DOMAIN_POWER)
                && !GetHasFeat(FEAT_EARTH_DOMAIN_POWER)
                && !GetHasFeat(FEAT_FIRE_DOMAIN_POWER)
                && !GetHasFeat(FEAT_WATER_DOMAIN_POWER))
                return FALSE;
            break;
        case RACIAL_TYPE_VERMIN: 
            if(!GetHasFeat(FEAT_PLANT_DOMAIN_POWER)
                && !GetLevelByClass(CLASS_TYPE_JUDICATOR))
                return FALSE;
            break;
        case RACIAL_TYPE_CONSTRUCT: 
            //constructs are damaged rather than turned, but deal with that later
            if(!GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER))
                return FALSE;
            break;
        default: return FALSE;
    }
    
    //PROJECTION CHECK
    if (GetLocalInt(oTarget, "BaelnornProjection_Active"))
        return FALSE;
        
    //TURN IMMUNITY CHECK
    if(GetHasFeat(FEAT_TURNING_IMMUNITY, oTarget))
        return FALSE;
        
    return TRUE;
}

int GetTurningCheckResult(int nLevel, int nChaMod)
{
    int nScore = d20()+nChaMod;
    switch(nScore)
    {
        case  0: 
            return nLevel-4;
        case  1:
        case  2:
        case  3:
            return nLevel-3;        
        case  4:
        case  5:
        case  6:
            return nLevel-2;
        case  7:
        case  8:
        case  9:
            return nLevel-1;
        case 10:
        case 11:
        case 12:
            return nLevel;
        case 13:
        case 14:
        case 15:
            return nLevel+1;
        case 16:
        case 17:
        case 18:
            return nLevel+2;
        case 19:
        case 20:
        case 21:
            return nLevel+3;             
        default:
            if(nScore < 0)
                return nLevel-4;
            else
                return nLevel+4;
    }
    //somethings gone wrong here
    return 0;
}

int GetTurningClassLevel(int bUndeadOnly = FALSE)
{
    int nLevel;
    //full classes
    nLevel += GetLevelByClass(CLASS_TYPE_CLERIC);
    nLevel += GetLevelByClass(CLASS_TYPE_TRUENECRO);
    nLevel += GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT);
    nLevel += GetLevelByClass(CLASS_TYPE_BAELNORN);
    //offset classes
    if(GetLevelByClass(CLASS_TYPE_PALADIN)-2>0)
        nLevel += GetLevelByClass(CLASS_TYPE_PALADIN)-2;
    if(GetLevelByClass(CLASS_TYPE_BLACKGUARD)-2>0)
        nLevel += GetLevelByClass(CLASS_TYPE_BLACKGUARD)-2;
    if(GetLevelByClass(CLASS_TYPE_HOSPITALER)-2>0)
        nLevel += GetLevelByClass(CLASS_TYPE_HOSPITALER)-2;
    //not undead turning classes    
    if(!bUndeadOnly)
    {
        nLevel += GetLevelByClass(CLASS_TYPE_JUDICATOR);
        if(GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)-3>0)
            nLevel += GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)-3;
    }    
    return nLevel;
}

int GetHitDiceForTurning(object oTarget)
{
    
    //Hit Dice
    int nHD = GetHitDice(oTarget);
    
    //Turn Resistance
    nHD += GetTurnResistanceHD(oTarget);
    
    //Outsiders get SR (halved if turner has planar turning)
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
    {   
        int nSR = PRCGetSpellResistance(oTarget, OBJECT_SELF);
        if(GetHasFeat(FEAT_EPIC_PLANAR_TURNING))
            nSR /= 2;
        nHD += nSR;
    }
    
    //return the total
    return nHD;
}

int GetCommandedTotalHD()
{
    int i;
    int nCommandedTotalHD;
    object oTest = GetAssociate(ASSOCIATE_TYPE_DOMINATED, OBJECT_SELF, i);
    while(GetIsObjectValid(oTest))
    {
        if(GetHasSpellEffect(GetSpellId(), oTest))
        {
            int nTestHD = GetHitDiceForTurning(oTest);
            if(MyPRCGetRacialType(oTest) != RACIAL_TYPE_UNDEAD
                && GetHasFeat(FEAT_UNDEAD_MASTERY))
                nTestHD *= 10;
            nCommandedTotalHD += nTestHD;
        }    
        i++;
        oTest = GetAssociate(ASSOCIATE_TYPE_DOMINATED, OBJECT_SELF, i);
    }
    return nCommandedTotalHD;
}
