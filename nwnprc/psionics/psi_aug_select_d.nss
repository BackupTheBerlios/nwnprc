//::///////////////////////////////////////////////
//:: Augment Psionics - Set single digit
//:: psi_aug_select_d
//:://////////////////////////////////////////////
/*
    Sets the first digit of augmentation level
    to the selected number.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.05.2005
//:://////////////////////////////////////////////


const int START = 2359; // Spells.2da of 0

void main()
{
    object oPC = OBJECT_SELF;
    int nVal = ((GetLocalInt(oPC, "Augment") / 10) * 10) // Remove the old first digit
               + GetSpellId() - START;

    SetLocalInt(oPC, "Augment", nVal);
    FloatingTextStringOnCreature(GetStringByStrRef(16823589) + " " + IntToString(nVal), oPC, FALSE);
}