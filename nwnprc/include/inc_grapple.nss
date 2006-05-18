//::///////////////////////////////////////////////
//:: Name       inc_grapple
//:: FileName   inc_grapple
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is an include for grapple related functions and stuff
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 09/04/2006
//:://////////////////////////////////////////////

#include "prc_alterations"

int GetGrappleSizeMod(int nSize)
{
    switch(nSize)
    {
        case CREATURE_SIZE_FINE:            return -16;
        case CREATURE_SIZE_DIMINUTIVE:      return -12;
        case CREATURE_SIZE_TINY:            return -8;
        case CREATURE_SIZE_SMALL:           return -4;
        case CREATURE_SIZE_MEDIUM:          return  0;
        case CREATURE_SIZE_LARGE:           return  4;
        case CREATURE_SIZE_HUGE:            return  8;
        case CREATURE_SIZE_GARGANTUAN:      return  12;
        case CREATURE_SIZE_COLOSSAL:        return  16;
    }
    return 0;
}

int GetGrappleMod(object oTarget)
{
    int nGrapple;
    if(!GetIsObjectValid(oTarget))
        return 0;
    nGrapple += GetBaseAttackBonus(oTarget);
    nGrapple += GetGrappleSizeMod(PRCGetCreatureSize(oTarget));
    nGrapple += GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    //drunken masters drunken embrace
    if(GetHasFeat(FEAT_PRESTIGE_DRUNKEN_EMBRACE, oTarget))
        nGrapple += 4;
    
    return nGrapple;
}

int DoGrappleCheck(object oAttacker, object oDefender, 
    int nAttackerMod = 0, int nDefenderMod = 0, 
    string sAttackerName = "", string sDefenderName = "")
{
    int nResult;
    int nDefenderGrapple;
    int nDefenderRoll = d20();
    nDefenderGrapple += GetGrappleMod(oDefender);
    nDefenderGrapple += nDefenderRoll;
    int nAttackerGrapple;
    int nAttackerRoll = d20();
    nAttackerGrapple += GetGrappleMod(oAttacker);
    nAttackerGrapple += nAttackerRoll;
    //defender has benefit
    if(nAttackerGrapple > nDefenderGrapple)
        nResult = TRUE;
        
    string sMessage;
    if(GetIsPC(oAttacker)) sMessage += COLOR_LIGHT_BLUE;
    else                   sMessage += COLOR_LIGHT_PURPLE;
    if(GetIsObjectValid(oAttacker))
        sMessage += GetName(oAttacker);
    else    
        sMessage += sAttackerName;
    sMessage += COLOR_ORANGE;
    sMessage += " grapples ";
    if(GetIsObjectValid(oDefender))
        sMessage += GetName(oDefender);
    else    
        sMessage += sDefenderName;
    sMessage += " : ";
    
    if(nResult)
        sMessage += "*hit*";
    else
        sMessage += "*miss*";
        
    sMessage += " : ("+IntToString(nAttackerRoll)+" + "+IntToString(nAttackerGrapple-nAttackerRoll)+" = "+IntToString(nAttackerGrapple);
    sMessage += " vs "+IntToString(nDefenderRoll)+" + "+IntToString(nDefenderGrapple-nDefenderRoll)+" = "+IntToString(nDefenderGrapple)+")";
    SendMessageToPC(oAttacker, sMessage);
    SendMessageToPC(oDefender, sMessage);
    return nResult;
}

int GetIsGrappled(object oTarget)
{
    int nGrappled;
    return nGrappled;
}

int GetIsGrappledByObject(object oTarget, object oGrappler)
{
    int nGrappled;
    return nGrappled;
}


void StartGrapple