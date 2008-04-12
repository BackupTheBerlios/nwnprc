/*
    Choose which maneuvers to ready for the Warblade
*/
#include "tob_inc_tobfunc"
#include "inc_dynconv"
void main()
{
	object oInitiator = OBJECT_SELF;
	ClearReadiedManeuvers(oInitiator, MANEUVER_LIST_WARBLADE);
	SetLocalInt(oInitiator, "nClass", CLASS_TYPE_WARBLADE);
	StartDynamicConversation("tob_moverdy", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
}