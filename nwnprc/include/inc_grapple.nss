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

int GetGrappleSizeMod(int nSize)
{
    switch(nSize)
    {
        case CREATURE_SIZE_TINY:   return -8;
        case CREATURE_SIZE_SMALL:  return -4;
        case CREATURE_SIZE_MEDIUM: return  0;
        case CREATURE_SIZE_LARGE:  return  4;
        case CREATURE_SIZE_HUGE:   return  8;
    }
    return 0;
}

int GetGrappleMod(object oTarget)
{
    int nGrapple;
    nGrapple += GetBaseAttackBonus(oTarget);
    nGrapple += GetGrappleSizeMod(PRCGetCreatureSize(oTarget));
    nGrapple += GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    //drunken masters drunken embrace
    if(GetHasFeat(FEAT_PRESTIGE_DRUNKEN_EMBRACE, oTarget))
        nGrapple += 4;
    
    return nGrapple;
}