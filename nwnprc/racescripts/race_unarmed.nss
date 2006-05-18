// :: race_unarmed
// :: by WodahsEht 9/27/04
// ::
// :: Determines the appropriate natural attacks for races.


#include "prc_alterations"

void main ()
{
    int iRace = GetRacialType(OBJECT_SELF);
    
    if (
        //iRace == RACIAL_TYPE_MINOTAUR   ||    //1 gore 1d8                    //large
        iRace == RACIAL_TYPE_TANARUKK   ||      //1 bite 1d6                    //medium    
        //iRace == RACIAL_TYPE_TROLL      ||    //2 claws 1d6 + 1 bite 1d6      //large
        iRace == RACIAL_TYPE_RAKSHASA   ||      //2 claws 1d4 + 1 bite 1d6      //medium
        iRace == RACIAL_TYPE_CENTAUR    ||      //2 hooves 1d6                  //large
        iRace == RACIAL_TYPE_ILLITHID   ||      //4 tentacles 1d4               //medium
        iRace == RACIAL_TYPE_WEMIC      ||      //2 claws 1d6                   //large
        iRace == RACIAL_TYPE_LIZARDFOLK)        //2 claws 1d6 + 1 bite 1d4      //medium
    {
         //UnarmedFeats(OBJECT_SELF);
         //UnarmedFists(OBJECT_SELF);
         SetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS, TRUE);
         SetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS, TRUE);
    }
}