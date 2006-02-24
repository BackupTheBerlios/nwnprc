//Cohort HB script

#include "prc_alterations"
#include "prc_inc_leadersh"

void main()
{
    if(!GetIsObjectValid(GetMaster(OBJECT_SELF)))
        RemoveCohortFromPlayer(OBJECT_SELF, OBJECT_INVALID);
}