/*
    Recover all swordsage maneuvers
    Only functions in combat, otherwise call delayed recovery
*/
#include "tob_inc_tobfunc"
#include "inc_dynconv"
void main()
{
	object oInitiator = OBJECT_SELF;
	if (GetIsInCombat(oInitiator))
	{
		AssignCommand(oInitiator, ClearAllActions(TRUE));
		StartDynamicConversation("tob_swd_rcrcnv", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
	}
	else
	{
		// Delayed Recovery Mechanics
		ExecuteScript("tob_gen_recover", oInitiator);
	}
}