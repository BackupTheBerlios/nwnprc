//::///////////////////////////////////////////////
//:: FileName pnp_shft_qclr
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 31/08/2004 6:31:18 PM
//:://////////////////////////////////////////////
#include "pnp_shft_main"

void main()
{
    // Set the variables
    SetLocalInt(GetPCSpeaker(), "pnp_shft_qs", 0);
    object oPC = GetPCSpeaker();
    /*
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    if ( !GetIsObjectValid(oMimicForms) )
        oMimicForms = CreateItemOnObject( "sparkoflife", oPC );

    SetPlotFlag(oMimicForms, TRUE);
    SetDroppableFlag(oMimicForms, FALSE);
    SetItemCursedFlag(oMimicForms, FALSE);
    */

    int iMaxIndex = GetPersistantLocalInt(oPC, "num_creatures");
    int i;
    string sTemp;
    int iIndex;
    int iEpic;

    for ( i=1; i<11; i++ )
    {
        iIndex = persistant_array_get_int(oPC, "QuickSlotIndex", i);
        iEpic  = persistant_array_get_int(oPC, "QuickSlotEpic",  i);
        if(!(iIndex>iMaxIndex))
        {
            if (iMaxIndex==0)
            {
                sTemp = "Empty";
                SetCustomToken(99+i, sTemp);
            }
            else
            {
                if(iEpic==TRUE)
                    sTemp="Epic: ";
                else
                    sTemp = "";
                sTemp += persistant_array_get_string(oPC, "shift_choice_name", iIndex);
                SetCustomToken(99+i, sTemp);
            }
        }
        else
        {
            sTemp = "Empty";
            SetCustomToken(99+i, sTemp);
        }
    }


}





