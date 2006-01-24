//::///////////////////////////////////////////////
//:: Augment Psionics - Quickselect
//:: psi_aug_qslot
//:://////////////////////////////////////////////
/** @file
    Sets augmentation to the value of the selected
    quickselection.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.05.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "psi_inc_augment"


const int SLOT_1 = 2356;
const int SLOT_2 = 2357;
const int SLOT_3 = 2358;


void main()
{
    object oPC = OBJECT_SELF;

    // Determine which quickslot was used
    int nSpellID = PRCGetSpellId();
    int nSlot;
    switch(nSpellID)
    {
        case SLOT_1: nSlot = 1; break;
        case SLOT_2: nSlot = 2; break;
        case SLOT_3: nSlot = 3; break;

        default: nSlot = -1;
    }

    if(nSlot == -1)
    {
        if(DEBUG) DoDebug("prc_aug_qslot: ERROR: Unknown spellID - " + IntToString(nSpellID));
        return;
    }

    // The quickslot indexes are stored as negative to differentiate them from normal slots
    SetLocalInt(oPC, PRC_CURRENT_AUGMENT_PROFILE, -nSlot);

    //                           "Current augmentation"
    FloatingTextStringOnCreature(GetStringByStrRef(16823589) + " - " + UserAugmentationProfileToString(GetUserAugmentationProfile(oPC, nSlot, TRUE)), oPC, FALSE);
}
