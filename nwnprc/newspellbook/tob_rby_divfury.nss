//::///////////////////////////////////////////////
//:: Divine Fury
//:: tob_rby_divfury.nss
//:://////////////////////////////////////////////
/*
    Up to [turn undead] times per day the character may gain a +4 bonus to attack and +1d10 to damage on a strike
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
        SetLocalInt(OBJECT_SELF, "RKVDivineFury", TRUE);

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
   }
}