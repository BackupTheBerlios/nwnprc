#include "prc_racial_const"

//Use this to get the Effective Character Level
//of a creature, instead of depending on GetHitDice.
//ECL is HitDice + Level Adjustment (LA)
//This is used for PC XP/loot distribution and encounter
//difficulty only.
int GetECL(object oTarget);


int GetECL(object oTarget)
{
    int nRage = GetRacialType(oTarget);
    int nECL = 0;
    switch(nRace)
    {
        case RACIAL_TYPE_DUERGAR:
        case RACIAL_TYPE_AASIMAR:
        case RACIAL_TYPE_TIEFLING:
        case RACIAL_TYPE_HOBGOBLIN:
        case RACIAL_TYPE_HALFOGRE:
        case RACIAL_TYPE_HALFDROW:
        case RACIAL_TYPE_GRAYORC:
        case RACIAL_TYPE_AIR_GEN:
        case RACIAL_TYPE_EARTH_GEN:
        case RACIAL_TYPE_FIRE_GEN:
        case RACIAL_TYPE_WATER_GEN:
        case RACIAL_TYPE_SHADOWSWYFT:
        case RACIAL_TYPE_LIZARDFOLK:
        case RACIAL_TYPE_GNOLL:
            nECL = 1;
            break;
        case RACIAL_TYPE_DROW_FEMALE:
        case RACIAL_TYPE_DROW_MALE:
        case RACIAL_TYPE_GITHYANKI:
        case RACIAL_TYPE_GITHZERAI:
        case RACIAL_TYPE_OROG:
        case RACIAL_TYPE_OGRE:
        case RACIAL_TYPE_PURE_YUAN:
        case RACIAL_TYPE_THRIKREEN:
            nECL = 2;
            break;
        case RACIAL_TYPE_AVARIEL:
        case RACIAL_TYPE_DEEP_GNOME:
        case RACIAL_TYPE_FORMIAN:
            nECL = 3;
            break;
        case RACIAL_TYPE_AZER:
        case RACIAL_TYPE_PIXIE:
            nECL = 4;
            break;
        case RACIAL_TYPE_TROLL:
            nECL = 5;
            break;
        case RACIAL_TYPE_RAKSHASA:
        case RACIAL_TYPE_ABOM_YUAN:
        case RACIAL_TYPE_ILLITHID:
            nECL = 7;
            break;
    }
    return nECL;
}
