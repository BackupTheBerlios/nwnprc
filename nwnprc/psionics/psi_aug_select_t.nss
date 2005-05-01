//::///////////////////////////////////////////////
//:: Augment Psionics - Set tens
//:: psi_aug_select_t
//:://////////////////////////////////////////////
/*
    Sets the second digit of augmentation level
    to the selected number.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.05.2005
//:://////////////////////////////////////////////


const int START = 2369; // Spells.2da of 00

void main()
{
    object oPC = OBJECT_SELF;
    int nVal = GetLocalInt(oPC, "Augment") % 10 // Remove the old second digit
               + (GetSpellId() - START) * 10;

    SetLocalInt(oPC, "Augment", nVal);
    FloatingTextStringOnCreature(GetStringByStrRef(16823589) + " " + IntToString(nVal), oPC, FALSE);
}