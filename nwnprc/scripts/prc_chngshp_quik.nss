//:://////////////////////////////////////////////
//:: Change Shape - Quickslot use
//:: prc_chngshp_quik
//:://////////////////////////////////////////////
/** @file
    Fires when one of the Change Shape quickslots
    is used. Determines which of the slots was
    used based on spellID and, if that slot is not
    empty, shifts to the form listed in the slot.


    @author Ornedan
    @date   Created  - 2006.10.07
    modified by Fox for Change Shape from PnP Shifter
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting"

void main()
{
    object oPC   = OBJECT_SELF;
    int nSpellID = PRCGetSpellId();
    int bPaid    = FALSE;
    int nSlot;
    string sSource;

    // Determine which quickslot was used
    switch(nSpellID)
    {
        case SPELL_IRDA_CHANGE_SHAPE_QS1:       nSlot = 1; sSource = "Irda_Shape_Quick_"; break;
        case SPELL_FEYRI_CHANGE_SHAPE_QS1:      nSlot = 1; sSource = "Feyri_Shape_Quick_"; break;
        case SPELL_CHANGLING_CHANGE_SHAPE_QS1:
        case SPELL_QUICK_CHANGE_SHAPE_QS1:      nSlot = 1; sSource = "Changeling_Shape_Quick_"; break;
        case SPELL_IRDA_CHANGE_SHAPE_QS2:       nSlot = 2; sSource = "Irda_Shape_Quick_"; break;
        case SPELL_CHANGLING_CHANGE_SHAPE_QS2:
        case SPELL_QUICK_CHANGE_SHAPE_QS2:      nSlot = 2; sSource = "Changeling_Shape_Quick_"; break;
        case SPELL_FEYRI_CHANGE_SHAPE_QS2:      nSlot = 2; sSource = "Feyri_Shape_Quick_"; break;

        default:
            if(DEBUG) DoDebug("prc_chngshp_quik: ERROR: Unknown nSpellID value: " + IntToString(nSpellID));
            return;
    }

    // Read the data from this slot
    string sResRef = GetPersistantLocalString(oPC, sSource + IntToString(nSlot) + "_ResRef");

    // Make sure the slot wasn't empty
    if(sResRef == "")
    {
        FloatingTextStrRefOnCreature(16828382, oPC, FALSE); // "This Quick Shift Slot is empty!"
        if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_QS1 || nSpellID == SPELL_IRDA_CHANGE_SHAPE_QS2)
             IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
        return;
    }

    // See if the shifting starts successfully
    if(!ShiftIntoResRef(oPC, SHIFTER_TYPE_CHANGESHAPE, sResRef))
    {
        // In case of shifting failure, refund the shifting use
        if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_QS1 || nSpellID == SPELL_IRDA_CHANGE_SHAPE_QS2)
            IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
    }
    
}