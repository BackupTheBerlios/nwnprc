#include "prc_alterations"
#include "prc_class_const"
#include "psi_inc_psifunc"
#include "inc_item_props"

int CheckMissingPowers(object oPC, int nClass)
{ 
    int nLevel = GetLevelByClass(nClass, oPC);
    if(!nLevel)
        return FALSE;
    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psbk"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);
    int nCurrentPowers = GetPowerCount(oPC, nClass);
    int nMaxPowers = StringToInt(Get2DACache(sPsiFile, "PowersKnown", nLevel-1));
    if(nCurrentPowers < nMaxPowers)
    {
        SetLocalString(oPC, "DynConv_Script", "psi_powconv");
        SetLocalInt(oPC, "nClass", nClass);
        ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE);
        return TRUE;
    }
    return FALSE;
}

void main()
{
    object oPC = OBJECT_SELF;
    if(CheckMissingPowers(oPC, CLASS_TYPE_PSION))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_WILDER))
        return;
    if(CheckMissingPowers(oPC, CLASS_TYPE_PSYWAR))
        return;
}