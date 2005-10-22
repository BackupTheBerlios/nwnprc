//:://////////////////////////////////////////////
//:: Psionic Power gain calculation script
//:: psi_powergain
//:://////////////////////////////////////////////
/** @file
    This script determines whether a given character
    has power slots left unfilled. If the character
    does have some, it launches the power gain
    conversation.


    @date Modified - 2005.09.23
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_class_const"
#include "psi_inc_psifunc"
#include "inc_dynconv"


int CheckMissingPowers(object oPC, int nClass)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    if(!nLevel)
        return FALSE;

    int nCurrentPowers = GetPowerCount(oPC, nClass);
    int nMaxPowers = GetMaxPowerCount(oPC, nClass);

    if(nCurrentPowers < nMaxPowers)
    {
        // Mark the class for which the PC is to gain powers and start the conversation
        SetLocalInt(oPC, "nClass", nClass);
        StartDynamicConversation("psi_powconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

        return TRUE;
    }
    return FALSE;
}

void main()
{
    object oPC = OBJECT_SELF;
    if(GetLocalInt(oPC, "nPCShifted"))
        return;
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            return;
        eTest = GetNextEffect(oPC);
    }
    if(CheckMissingPowers(oPC, CLASS_TYPE_PSION))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_WILDER))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_PSYWAR))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_FIST_OF_ZUOKEN))
        return;
}