// :: race_unarmed
// :: by WodahsEht 9/27/04
// ::
// :: Determines the appropriate natural attacks for races.

#include "prc_inc_unarmed"
#include "prc_racial_const"

void main ()
{
    int iRace = GetRacialType(OBJECT_SELF);
    
    if (iRace == RACIAL_TYPE_MINOTAUR   ||
        iRace == RACIAL_TYPE_TANARUKK   ||
        iRace == RACIAL_TYPE_TROLL      ||
        iRace == RACIAL_TYPE_RAKSHASA   ||
        iRace == RACIAL_TYPE_CENTAUR    ||
        iRace == RACIAL_TYPE_ILLITHID   ||
        iRace == RACIAL_TYPE_LIZARDFOLK)
    {
         UnarmedFeats(OBJECT_SELF);
         UnarmedFists(OBJECT_SELF);
    }
}