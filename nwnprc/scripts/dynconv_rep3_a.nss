//:://////////////////////////////////////////////
//:: Dynamic Conversation: Reply chosen
//:: dynconv_rep3_a
//:://////////////////////////////////////////////
/** @file
    Runs the dynamic conversation script with
    reply value 3.

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"


void main()
{
    object oPC = GetPCSpeaker();
    _DynConvInternal_PreScript(oPC);
    string sScript = GetLocalString(oPC, DYNCONV_SCRIPT);
    SetLocalInt(oPC, DYNCONV_VARIABLE, 4); // Number passed is 1 greater than the actual, so that 0 can be used as a special case
    ExecuteScript(sScript, OBJECT_SELF);
    _DynConvInternal_PostScript(oPC);
}

