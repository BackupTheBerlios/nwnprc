/*
    Choose which maneuvers to ready for the Swordsage
*/
#include "tob_inc_tobfunc"
#include "inc_dynconv"
void main()
{
	object oInitiator = OBJECT_SELF;
	SetLocalInt(oInitiator, "nClass", CLASS_TYPE_SWORDSAGE);
	StartDynamicConversation("tob_moverdy", oInitiator, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oInitiator);
}