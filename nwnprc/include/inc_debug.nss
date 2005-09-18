//:://////////////////////////////////////////////
//:: Debug printing function
//:: inc_debug
//:://////////////////////////////////////////////
/** @file
    This file contains a debug printing function, the
    purpose of which is to be leavable in place in code,
    so that debug printing can be centrally turned off
    by commenting out the contents of the function.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

/**
 * Prefix all your debug calls with an if(DEBUG) so that they get stripped away
 * during compilation as dead code when this is turned off.
 */
const int DEBUG = TRUE;

/**
 * May print the given string, depending on whether debug printing is needed.
 *
 * @param sString The string to print
 */
void DoDebug(string sString, object oAdditionalRecipient = OBJECT_INVALID)
{
    SendMessageToPC(GetFirstPC(), sString);
    if(oAdditionalRecipient != OBJECT_INVALID)
        SendMessageToPC(oAdditionalRecipient, sString);
    WriteTimestampedLogEntry(sString);
}
