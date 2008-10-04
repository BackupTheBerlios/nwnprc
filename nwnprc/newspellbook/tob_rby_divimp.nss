//::///////////////////////////////////////////////
//:: Divine Impetus
//:: tob_rby_divimp.nss
//:://////////////////////////////////////////////
/*
    Up to [turn undead] times per day the character may gain an additional swift action
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Oct 4, 2008
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "tob_inc_tobfunc"

void main()
{

   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(40550);
   }
   else
   {
        SetLocalInt(OBJECT_SELF, "RKVDivineImpetus", TRUE);

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
   }
}