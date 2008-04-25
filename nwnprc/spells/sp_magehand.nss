/*
    sp_magehand

    Transmutation
    Level: Brd 0, Sor/Wiz 0
    Components: V, S
    Casting Time: 1 standard action
    Range: Close (25 ft. + 5 ft./2 levels)
    Target: One nonmagical, unattended object weighing up to 5 lb.
    Duration: Concentration
    Saving Throw: None
    Spell Resistance: No
    You point your finger at an object and can lift it and move it at will from a distance. As a move action, you can propel the object as far as 15 feet in any direction, though the spell ends if the distance between you and the object ever exceeds the spell’s range.

    By: Flaming_Sword
    Created: Sept 29, 2006
    Modified: Sept 29, 2006

    Copied from psionics
*/

#include "prc_sp_func"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nMaxWeight = 50;

    // Target needs to be an item
    if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // And light enough
        if(GetWeight(oTarget) <= nMaxWeight)
        {
            CopyItem(oTarget, oCaster, FALSE);
            MyDestroyObject(oTarget); // Make sure the item does get destroyed
        }
        else
            FloatingTextStrRefOnCreature(16824062, oCaster, FALSE); // "This item is too heavy for you to pick up"
    }
    else
        FloatingTextStrRefOnCreature(16826245, oCaster, FALSE); // "* Target is not an item *"

    PRCSetSchool();
}