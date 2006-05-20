//::///////////////////////////////////////////////
//:: Name         Perception Reputation System
//:: FileName     prs_inc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is the include for the reputation system.

    This depends on having certain faction-based markers.
    There must be at least 1 object with the tag "FactionMaster" for each faction.
    These objects are used to determine what appearances are acceptable for that
    faction. So if you want Ogres, Ogre Mages, and Ogre Cheiftans to be recongized
    as part of the same faction, there must be a FactionMaster for each of them.

    As well as appearance-based faction recognition, creatures can be made less
    hostile or even friendly by intimidation, persuasion, or wild empathy.

*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 04/06
//:://////////////////////////////////////////////

#include "prc_gateway"

struct reputationChange
{
    int nReaction;
    int nTemporaryReaction;
    float fReactionDuration;
};

//main function
//call from a creatures OnPerception event
void PRS_DoPercep();

//changes the faction of self based on appearance
void PRS_DoSpawn();

//tests if oTarget can persuade oObject to be friendly
//this is based on Intimidate in PnP, but tweaked for NWN purposes
struct reputationChange PRS_DoPersuadeCheck(struct reputationChange rcRep,
    object oTarget, object oObject = OBJECT_SELF);

//tests if oTarget can intimidate oObject to be neutral/friendly
//this is based on Intimidate in PnP, but tweaked for NWN purposes
struct reputationChange PRS_DoInitmidateCheck(struct reputationChange rcRep,
    object oTarget, object oObject = OBJECT_SELF);

//tests if oTarget can use wild empathy to change oObject to be neutral/friendly
//this is based on Intimidate in PnP, but tweaked for NWN purposes
struct reputationChange PRS_DoWildEmpathyCheck(struct reputationChange rcRep,
    object oTarget, object oObject = OBJECT_SELF);


void PRS_PerceptionReaction(object oTarget, object oObject = OBJECT_SELF)
{
    //only do it once for everything seen
    if(GetLocalInt(OBJECT_SELF, "PRS_Done_"+ObjectToString(oTarget)))
        return;
    SetLocalInt(OBJECT_SELF, "PRS_Done_"+ObjectToString(oTarget), TRUE);
//    DoDebug("PRS_Done_"+ObjectToString(oTarget));
    if(!GetIsObjectValid(oTarget)
        || !GetIsObjectValid(oObject)
        || !GetObjectSeen(oTarget, oObject)
        || !GetObjectHeard(oTarget, oObject))
        return;
//DoDebug("PRS_PerceptionReaction("+GetName(oTarget)+", "+GetName(oObject)+")");
    int i;
    //this is the reaction to have
    struct reputationChange rcRep;
    rcRep.nReaction = REPUTATION_TYPE_NEUTRAL;
    rcRep.nTemporaryReaction = REPUTATION_TYPE_NEUTRAL; //default to neutral
    //this is how long to keep it, <=0.0 is permanent
    rcRep.fReactionDuration = 0.0;
    //get the faction master object of the target
    i = 0;
    object oTargetFaction = GetObjectByTag("FactionMaster", i);
    while(GetIsObjectValid(oTargetFaction)
        && !GetAppearanceType(oTargetFaction) != GetAppearanceType(oTarget))
    {
        i++;
        oTargetFaction = GetObjectByTag("FactionMaster", i);
    }
    //get the faction master object
    i = 0;
    object oFaction = GetObjectByTag("FactionMaster", i);
    while(GetIsObjectValid(oFaction)
        && !GetFactionEqual(oFaction, oObject))
    {
        i++;
        oFaction = GetObjectByTag("FactionMaster", i);
    }

    //get how faction master feels about targets fatction
    //if either of them are not valid
    //default neturallity will apply
    if(GetIsObjectValid(oFaction)
        && GetIsObjectValid(oTargetFaction))
    {
        int nFactionReputation = GetReputation(oFaction, oTargetFaction);
        if(nFactionReputation >= 0 && nFactionReputation <= 10)
            rcRep.nReaction = REPUTATION_TYPE_ENEMY;
        else if(nFactionReputation >= 11 && nFactionReputation <= 89)
            rcRep.nReaction = REPUTATION_TYPE_NEUTRAL;
        else if(nFactionReputation >= 90 && nFactionReputation <= 100)
            rcRep.nReaction = REPUTATION_TYPE_FRIEND;
//            DoDebug("FactionMaster valid reputation is "+IntToString(nFactionReputation));
    }

    //if hostile, try to reduce that by using intimidate
    //target must be able to see or hear object
    //object must not be fear-immune and must be intelligent
    if((rcRep.nReaction == REPUTATION_TYPE_ENEMY
            && rcRep.fReactionDuration <= 0.0)
        || (rcRep.nTemporaryReaction == REPUTATION_TYPE_ENEMY
            && rcRep.fReactionDuration > 0.0))
    {
        rcRep = PRS_DoInitmidateCheck(rcRep, oTarget, oObject);
    }

    //if neutral, try to make friendly by using intimidate
    //target must be able to see or hear object
    //object must not be charm-immune and must be intelligent
    if((rcRep.nReaction == REPUTATION_TYPE_NEUTRAL
            && rcRep.fReactionDuration <= 0.0)
        || (rcRep.nTemporaryReaction == REPUTATION_TYPE_NEUTRAL
            && rcRep.fReactionDuration > 0.0))
    {
        rcRep = PRS_DoPersuadeCheck(rcRep, oTarget, oObject);
    }
    //if non-friendly, try to make friendly by using wild empathy
    //target must be able to see or hear object
    if((rcRep.nReaction != REPUTATION_TYPE_FRIEND
            && rcRep.fReactionDuration <= 0.0)
        || (rcRep.nTemporaryReaction != REPUTATION_TYPE_FRIEND
            && rcRep.fReactionDuration > 0.0))
    {
        rcRep = PRS_DoWildEmpathyCheck(rcRep, oTarget, oObject);
    }


    //apply the reaction
    //do permanent first as a "baseline"
    //permanent
    switch(rcRep.nReaction)
    {
        case REPUTATION_TYPE_ENEMY:
//            DoDebug("Making permanent enemy");
            SetIsTemporaryEnemy(oTarget, oObject, FALSE);
            break;
        case REPUTATION_TYPE_NEUTRAL:
//            DoDebug("Making permanent neutral");
            SetIsTemporaryNeutral(oTarget, oObject, FALSE);
            break;
        case REPUTATION_TYPE_FRIEND:
//            DoDebug("Making permanent friend");
            SetIsTemporaryFriend(oTarget, oObject, FALSE);
            break;
    }

    if(rcRep.fReactionDuration > 0.0)
    {
        //temporary
        //may be less than this as it decays
        switch(rcRep.nTemporaryReaction)
        {
            case REPUTATION_TYPE_ENEMY:
//            DoDebug("Making temporary enemy");
                SetIsTemporaryEnemy(oTarget, oObject, TRUE, rcRep.fReactionDuration);
                break;
            case REPUTATION_TYPE_NEUTRAL:
//            DoDebug("Making temporary neutral");
                SetIsTemporaryNeutral(oTarget, oObject, TRUE, rcRep.fReactionDuration);
                break;
            case REPUTATION_TYPE_FRIEND:
//            DoDebug("Making temporary friend");
                SetIsTemporaryFriend(oTarget, oObject, TRUE, rcRep.fReactionDuration);
                break;
        }
    }

    //and now, handle fears
    //if the target is more than CR 8 higher, run away in fear
    //for 1 minute, if it survives after that its overcome its fear
    if(GetChallengeRating(oTarget) > GetChallengeRating(oObject)+8.0)
        AssignCommand(oTarget,
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                EffectFrightened(),
                oObject, 60.0));
}


struct reputationChange PRS_DoPersuadeCheck(struct reputationChange rcRep,
    object oTarget, object oObject = OBJECT_SELF)
{
    //if neutral, try to make friendly by using intimidate
    //target must be able to see or hear self
    //self must not be charm-immune and must be intelligent
    int nPersuade = GetSkillRank(SKILL_PERSUADE, oTarget);
    if(nPersuade > 0
        && (GetObjectSeen(oObject, oTarget)
            || GetObjectHeard(oObject, oTarget))
        && GetAbilityScore(oObject, ABILITY_INTELLIGENCE) > 3
        && !GetIsImmune(oObject, IMMUNITY_TYPE_CHARM, oTarget)
        && !GetIsImmune(oObject, IMMUNITY_TYPE_DOMINATE, oTarget)
        )
    {
        //this is different from diplomacy in PnP
        //basically it works similar to intimidate, but turns neutral into ally
        //rather than hostile into neutral

        int nDC;
        int nRoll;
        //rolls are stored for 6 seconds
        if(GetLocalInt(oTarget, "PRS_persuade_roll"))
            nRoll = GetLocalInt(oTarget, "PRS_persuade_roll");
        else
        {
            nRoll = nPersuade;
            SetLocalInt(oTarget, "PRS_persuade_roll", nRoll);
            AssignCommand(oTarget, DelayCommand(6.0, DeleteLocalInt(oTarget, "PRS_persuade_roll")));
        }
        if(GetLocalInt(oTarget, "PRS_persuade_DC"))
            nRoll = GetLocalInt(oTarget, "PRS_persuade_DC");
        else
        {
            //should add charm mods here too, but no easy way to get it
            nDC = GetHitDice(oObject)+GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
            SetLocalInt(oObject, "PRS_persuade_DC", nDC);
            AssignCommand(oObject, DelayCommand(6.0, DeleteLocalInt(oObject, "PRS_persuade_DC")));
        }

        //if no chance of success, abort
        if(nRoll+20 < nDC+1)
            return rcRep;

        //add the dice
        nDC += d20();
        nRoll += d20();

        //work out result
        if(nRoll > nDC+10)
        {
            //Brilliant sucess, permanent friendship
            rcRep.nReaction = REPUTATION_TYPE_FRIEND;
            rcRep.fReactionDuration = 0.0;
            string sMess = "* Persuade Critical Sucess "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else if(nRoll > nDC)
        {
            //Sucess, 1d6x10 minutes of friendship
            rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
            rcRep.nTemporaryReaction = REPUTATION_TYPE_FRIEND;
            string sMess = "* Persuade Sucess "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else if(nRoll < nDC-10)
        {
            //Total faliure, 1d6x10 minutes of hostility
            rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
            rcRep.nTemporaryReaction = REPUTATION_TYPE_ENEMY;
            string sMess = "* Persuade Critical Faliure "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else
        {
            //normal failure, do nothing
            string sMess = "* Persuade Failure "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
    }
    return rcRep;
}

struct reputationChange PRS_DoInitmidateCheck(struct reputationChange rcRep,
    object oTarget, object oObject = OBJECT_SELF)
{
    //if hostile, try to reduce that by using intimidate
    //target must be able to see or hear self
    //self must not be fear-immune and must be intelligent
    int nIntimidate = GetSkillRank(SKILL_INTIMIDATE, oTarget);
    if(nIntimidate > 0
        && (GetObjectSeen(oObject, oTarget)
            || GetObjectHeard(oObject, oTarget))
        && GetAbilityScore(oObject, ABILITY_INTELLIGENCE) > 3
        && !GetIsImmune(oObject, IMMUNITY_TYPE_FEAR, oTarget)
        )
    {
        int nDC;
        int nRoll;
        //rolls are stored for 6 seconds
        if(GetLocalInt(oTarget, "PRS_intimidate_roll"))
            nRoll = GetLocalInt(oTarget, "PRS_intimidate_roll");
        else
        {
            nRoll = nIntimidate;
            SetLocalInt(oTarget, "PRS_intimidate_roll", nRoll);
            AssignCommand(oTarget, DelayCommand(6.0, DeleteLocalInt(oTarget, "PRC_intimidate_roll")));
        }
        if(GetLocalInt(oTarget, "PRS_intimidate_DC"))
            nRoll = GetLocalInt(oTarget, "PRS_intimidate_DC");
        else
        {
            //should add fear mods here too, but no easy way to get it
            nDC = GetHitDice(oObject)+GetAbilityModifier(ABILITY_WISDOM, oObject);
            SetLocalInt(oObject, "PRS_intimidate_DC", nDC);
            AssignCommand(oObject, DelayCommand(6.0, DeleteLocalInt(oObject, "PRS_intimidate_DC")));
        }
        //size has an effect too
        nRoll += (GetCreatureSize(oTarget)-GetCreatureSize(oObject))*4;

        //if no chance of success, abort
        if(nRoll+20 < nDC+1)
            return rcRep;

        //add the dice
        nDC += d20();
        nRoll += d20();

        //show it to player
        //work out result
        if(nRoll > nDC+10)
        {
            //Brilliant sucess, 1d6x10 minutes of friendship
            rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
            rcRep.nTemporaryReaction = REPUTATION_TYPE_FRIEND;
            string sMess = "* Intimidate Critical Sucess "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else if(nRoll > nDC)
        {
            //Sucess, 1d6x10 minutes of neutrality
            rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
            rcRep.nTemporaryReaction = REPUTATION_TYPE_NEUTRAL;
            string sMess = "* Intimidate Sucess "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else if(nRoll < nDC-10)
        {
            //Total failure, 1d6x10 minutes of hostility
            //Not really applicable since your probably hostile anyway
            //otherwise you wouldnt be intimidating them!
            rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
            rcRep.nTemporaryReaction = REPUTATION_TYPE_ENEMY;
            string sMess = "* Intimidate Critical Failure "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else
        {
            //normal failure, do nothing
            string sMess = "* Intimidate Failure "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
    }
    return rcRep;
}

struct reputationChange PRS_DoWildEmpathyCheck(struct reputationChange rcRep,
    object oTarget, object oObject = OBJECT_SELF)
{
    //will make hostiles -> neutral and even neutral -> friendly
    //target must be able to see or hear self
    //self must animal or magic animal with int = 3
    int nWildEmapthy = GetLevelByClass(CLASS_TYPE_DRUID, oTarget)
        + GetLevelByClass(CLASS_TYPE_RANGER, oTarget);
        //Add PRC Brownie here
    if(nWildEmapthy > 0
        && (GetObjectSeen(oObject, oTarget)
            || GetObjectHeard(oObject, oTarget))
        && (GetRacialType(oObject) == RACIAL_TYPE_ANIMAL
            || GetRacialType(oObject) == RACIAL_TYPE_BEAST
            || (GetRacialType(oObject) == RACIAL_TYPE_MAGICAL_BEAST
                && GetAbilityScore(oObject, ABILITY_INTELLIGENCE) > 3))
        )
    {
        int nDC;
        int nRoll;
        //rolls are stored for 6 seconds
        if(GetLocalInt(oTarget, "PRS_wildemp_roll"))
            nRoll = GetLocalInt(oTarget, "PRS_wildemp_roll");
        else
        {
            nRoll = nWildEmapthy+GetAbilityModifier(ABILITY_CHARISMA, oTarget);
            SetLocalInt(oTarget, "PRS_wildemp_roll", nRoll);
            AssignCommand(oTarget, DelayCommand(6.0, DeleteLocalInt(oTarget, "PRS_wildemp_roll")));
        }
        if(GetLocalInt(oTarget, "PRS_wildemp_DC"))
            nRoll = GetLocalInt(oTarget, "PRS_wildemp_DC");
        else
        {
            nDC = GetHitDice(oObject)+GetAbilityModifier(ABILITY_CHARISMA, oObject);
            SetLocalInt(oObject, "PRS_wildemp_DC", nDC);
            AssignCommand(oObject, DelayCommand(6.0, DeleteLocalInt(oObject, "PRS_wildemp_DC")));
        }
        //-4 penalty if trying a magical beast
        if(GetRacialType(oObject) == RACIAL_TYPE_MAGICAL_BEAST)
            nRoll -= 4;

        //if no chance of success, abort
        if(nRoll+20 < nDC+1)
            return rcRep;
        //add the dice
        nDC += d20();
        nRoll += d20();

        //show it to player
        //work out result
        if(nRoll > nDC+10)
        {
            //Brilliant sucess, 1d6x10 minutes of friendship if hostile
            //1d6x10 hours of firenship if neutral
            if((rcRep.nReaction == REPUTATION_TYPE_NEUTRAL
                    && rcRep.fReactionDuration <= 0.0)
                || (rcRep.nTemporaryReaction == REPUTATION_TYPE_NEUTRAL
                    && rcRep.fReactionDuration > 0.0))
            {
                rcRep.nTemporaryReaction = REPUTATION_TYPE_FRIEND;
                rcRep.fReactionDuration = HoursToSeconds(d6()*10);
            }
            else if((rcRep.nReaction == REPUTATION_TYPE_ENEMY
                    && rcRep.fReactionDuration <= 0.0)
                || (rcRep.nTemporaryReaction == REPUTATION_TYPE_ENEMY
                    && rcRep.fReactionDuration > 0.0))
            {
                rcRep.nTemporaryReaction = REPUTATION_TYPE_FRIEND;
                rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
            }
            string sMess = "* Wild Empathy Critical Sucess "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else if(nRoll > nDC)
        {
            //Sucess, 1d6x10 minutes of neutrality if hostile
            //1d6x10 minutes of friendship if neutral
            if((rcRep.nReaction == REPUTATION_TYPE_NEUTRAL
                    && rcRep.fReactionDuration <= 0.0)
                || (rcRep.nTemporaryReaction == REPUTATION_TYPE_NEUTRAL
                    && rcRep.fReactionDuration > 0.0))
            {
                rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
                rcRep.nTemporaryReaction = REPUTATION_TYPE_FRIEND;
            }
            else if((rcRep.nReaction == REPUTATION_TYPE_ENEMY
                    && rcRep.fReactionDuration <= 0.0)
                || (rcRep.nTemporaryReaction == REPUTATION_TYPE_ENEMY
                    && rcRep.fReactionDuration > 0.0))
            {
                rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
                rcRep.nTemporaryReaction = REPUTATION_TYPE_NEUTRAL;
            }
            string sMess = "* Wild Empathy Sucess "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else if(nRoll < nDC-10)
        {
            //Total failure, 1d6x10 minutes of hostility
            rcRep.fReactionDuration = IntToFloat(d6())*60.0*10.0;
            rcRep.nTemporaryReaction = REPUTATION_TYPE_ENEMY;
            string sMess = "* Wild Empathy Critical Failure "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
        else
        {
            //normal failure, do nothing
            string sMess = "* Wild Empathy Failure "+IntToString(nRoll)+" vs DC "+IntToString(nDC)+" *";
            FloatingTextStringOnCreature(sMess, oTarget, TRUE);
            DoDebug(sMess);
        }
    }
    return rcRep;
}

void PRS_DoPercep()
{
    //only do stuff when something seen
    if(!GetLastPerceptionHeard()
       && !GetLastPerceptionSeen())
        return;
    object oTarget = GetLastPerceived();
    //delay it so the lists have time to update etc
    DelayCommand(0.1,
        PRS_PerceptionReaction(oTarget, OBJECT_SELF));
}

void PRS_DoSpawn()
{
    int i = 0;
    object oTargetFaction = GetObjectByTag("FactionMaster", i);
    while(GetIsObjectValid(oTargetFaction)
        && !GetAppearanceType(oTargetFaction) != GetAppearanceType(OBJECT_SELF))
    {
        i++;
        oTargetFaction = GetObjectByTag("FactionMaster", i);
    }
    if(GetIsObjectValid(oTargetFaction))
        ChangeFaction(OBJECT_SELF, oTargetFaction);
}
