#include "prc_alterations"//script for deciding if the entry in the forms list should be shown

#include "inc_utility"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    //object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    int num_creatures = GetPersistantLocalInt( oPC, "num_creatures" );
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    if (nStartIndex+8>num_creatures) //if the entry is past the total number of known forms dont show
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
