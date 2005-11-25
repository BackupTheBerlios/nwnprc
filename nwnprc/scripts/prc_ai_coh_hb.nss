//Cohort HB script

#include "prc_alterations"
#include "prc_inc_leadersh"

void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("x0_ch_hen_heart", OBJECT_SELF);
    else
    {
        RemoveCohortFromPlayer(OBJECT_SELF, OBJECT_INVALID);
    }
    ExecuteScript("prc_npc_hb", OBJECT_SELF);
}