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
 * May print the given string, depending on whether debug printing is needed.
 *
 * @param sString The string to print
 */
void DoDebug(string sString)
{
    SendMessageToPC(GetFirstPC(), sString);
    WriteTimestampedLogEntry(sString);
}
