//::///////////////////////////////////////////////
//:: Augment Psionics - Quickselect
//:: psi_aug_qslot
//:://////////////////////////////////////////////
/*
    Sets augmentation to the value of the selected
    quickselection.
    Or stores the current augmentation level in
    the selected quickselection if Change Quickselect
    has been used.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.05.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_utility"

/*
const int SLOT_1 = 2356;
const int SLOT_2 = 2357;
const int SLOT_3 = 2358;
*/

void main()
{
    object oPC = OBJECT_SELF;
    
    // Check what we are supposed to do
    if(GetLocalInt(oPC, "ChangeAugmentQuickselect"))
    {// Change the quickselection
        int nVal = GetLocalInt(oPC, "Augment");
        SetPersistantLocalInt(oPC, "AugmentQuickselect_" + IntToString(PRCGetSpellId()), nVal);
        DeleteLocalInt(oPC, "ChangeAugmentQuickselect");
        SendMessageToPC(oPC, GetStringByStrRef(16824182) + " " + IntToString(nVal));
    }
    // Change the augmentation level
    else
    {
        int nVal = GetPersistantLocalInt(oPC, "AugmentQuickselect_" + IntToString(PRCGetSpellId()));
        SetLocalInt(oPC, "Augment", nVal);
        FloatingTextStringOnCreature(GetStringByStrRef(16823589) + " " + IntToString(nVal), oPC, FALSE);
    }
}