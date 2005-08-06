//::///////////////////////////////////////////////
//:: Power: Dimension Door - auxiliary script
//:: psi_pow_ddoor_b
//::///////////////////////////////////////////////
/** @ file
    This script is fired from a listener that hears
    a numeric value said by a PC that cast
    Dimension Door within the last 6 seconds.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.08.2005
//:://////////////////////////////////////////////

#include "prc_inc_listener"

void main()
{
    string sNum = GetMatchedSubstring(0);
    object oPC = GetLastSpeaker();
    // I'm not sure how well the string parsing works, so try both direct conversion to float and conversion via integer
    float fVal = StringToFloat(sNum);
    if(fVal == 0.0f)
        fVal = IntToFloat(StringToInt(sNum));
    SetLocalFloat(oPC, "PRC_Spell_DimensionDoor_Distance", fVal);
    SetLocalInt(oPC, "PRC_Spell_DimensionDoor_FirstStageDone", TRUE);

    ExecuteScript("psi_pow_ddoor", oPC);
    // Destroy the listener
    DestroyListener(OBJECT_SELF);
}