//:://////////////////////////////////////////////
//:: FileName: "_ev_onplayerrest"
/*
    Purpose: This is the event handler script for a
    module's OnPlayerRest event.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 08, 2004
//:://////////////////////////////////////////////
void main()
{
    // Who is resting?
    object oPC = GetLastPCRested();
    // Cancel their rest immediately.
    AssignCommand(oPC, ClearAllActions(FALSE));
    // Start the special conversation with oPC.
    AssignCommand(oPC,
        ActionStartConversation(OBJECT_SELF, "_rest_button", TRUE, FALSE));
}
