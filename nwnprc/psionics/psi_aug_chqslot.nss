//::///////////////////////////////////////////////
//:: Augment Psionics - Change Quickselect
//:: psi_aug_chqslot
//:://////////////////////////////////////////////
/*
    Sets the local int signifying that next use of
    a quickslot is to store the current value
    of augmentation instead of changing it.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.05.2005
//:://////////////////////////////////////////////


void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, "ChangeAugmentQuickselect", TRUE);
    SendMessageToPCByStrRef(oPC, 16824183);
    // Ten seconds to change the selection
    DelayCommand(10.0f, DeleteLocalInt(oPC, "ChangeAugmentQuickselect"));
}