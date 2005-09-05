#include "prc_alterations"
#include "prc_class_const"
#include "psi_inc_psifunc"

int CheckMissingPowers(object oPC, int nClass)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    if(!nLevel)
        return FALSE;

    int nCurrentPowers = GetPowerCount(oPC, nClass);
    int nMaxPowers = GetMaxPowerCount(oPC, nClass);

    if(nCurrentPowers < nMaxPowers)
    {
        SetLocalString(oPC, "DynConv_Script", "psi_powconv");
        SetLocalInt(oPC, "nClass", nClass);
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE));
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