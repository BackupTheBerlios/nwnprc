//:://////////////////////////////////////////////
//:: Generic Listener object OnConversation script
//:: prc_glist_onconv
//:://////////////////////////////////////////////
/** @file
    The generic listener's OnConversation script.
    This script handles calling the specified
    scripts when the listener hears something
    mathing one of it's patterns.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 19.06.2005
//:://////////////////////////////////////////////


void main()
{
//SendMessageToPC(GetFirstPC(), "Running prc_glist_onconv");
    // If listening to a single creature, check whether it was the one speaking
    if(GetLocalInt(OBJECT_SELF, "PRC_GenericListener_ListenToSingle") &&
       GetLastSpeaker() != GetLocalObject(OBJECT_SELF, "PRC_GenericListener_ListeningTo"))
        return;

    // Run the script defined for this pattern
    int nPattern = GetListenPatternNumber();
    ExecuteScript(GetLocalString(OBJECT_SELF, "PRC_GenericListener_ListenScript_" + IntToString(nPattern)), OBJECT_SELF);
}