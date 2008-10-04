//::///////////////////////////////////////////////
//:: Divine Recovery
//:: tob_rby_divrcvr.nss
//:://////////////////////////////////////////////
/*
    Up to [turn undead] times per day the character may recover a maneuver as a swift action
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
        SetLocalInt(OBJECT_SELF, "nClass", GetFirstBladeMagicClass(OBJECT_SELF));
	StartDynamicConversation("tob_rby_dvrcvcnv", OBJECT_SELF, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, OBJECT_SELF);

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
   }
}