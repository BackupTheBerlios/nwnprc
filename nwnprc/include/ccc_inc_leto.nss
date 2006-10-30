/**
 * convoCC letoscript functions
 * 
 */
 
#include "inc_letoscript"
#include "inc_letocommands"

/**
 * functions to set appearance, portrait, soundset
 */
 

// assigns the ccc chosen gender to the clone and resets the soundset
// if it's changed
void DoCloneGender();



/**
 * definitions
 */
 
void DoCloneGender()
{
    object oClone = GetLocalObject(OBJECT_SELF, "Clone");
    if(!GetIsObjectValid(oClone))
        return;
    int nSex = GetLocalInt(OBJECT_SELF, "Gender");
    int nCurrentSex = GetGender(oClone);
    StackedLetoScript(LetoSet("Gender", IntToString(nSex), "byte"));
    // if the gender needs changing, reset the soundset
    if (nSex != nCurrentSex)
        StackedLetoScript(LetoSet("SoundSetFile", IntToString(0), "word"));
    string sResult;
    RunStackedLetoScriptOnObject(oClone, "OBJECT", "SPAWN", "prc_ccc_app_lspw", TRUE);
    sResult = GetLocalString(GetModule(), "LetoResult");
    SetLocalObject(GetModule(), "PCForThread"+sResult, OBJECT_SELF);
}
