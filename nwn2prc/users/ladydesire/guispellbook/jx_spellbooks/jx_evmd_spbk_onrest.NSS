#include "jx_inc_spbk_process_sprdy"


void main()
{
	object oPC = GetLastPCRested();
	int iRestEventType = GetLastRestEventType();

	// Replenish the spell slots for the PC when she rests
	if (iRestEventType == REST_EVENTTYPE_REST_STARTED)
		JXReplenishSpellSlots(oPC, TRUE);
		
/*	switch (iRestEventType)
	{
		case REST_EVENTTYPE_REST_INVALID:
			SendMessageToPC(oPC, "Rest invalid");
			break;
		case REST_EVENTTYPE_REST_STARTED:
			SendMessageToPC(oPC, "Rest started");
			break;
		case REST_EVENTTYPE_REST_FINISHED:
			SendMessageToPC(oPC, "Rest finished");
			break;
		case REST_EVENTTYPE_REST_CANCELLED:
			SendMessageToPC(oPC, "Rest cancelled");
			break;
	}*/
}