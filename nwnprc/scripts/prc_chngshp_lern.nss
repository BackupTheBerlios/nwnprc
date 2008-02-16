//:://////////////////////////////////////////////
//:: Change Shape use
//:: prc_chngshp_lern
//:://////////////////////////////////////////////
/** @file
    Targets some creature to have it be stored
    as a known template and attempts to shift
    into it.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modified by Fox
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting"


void main()
{
    object oPC     = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nSpellID   = GetSpellId();

    // Store the PC's current appearance as true appearance
    /// @note This may be a bad idea, we have no way of knowing if the current appearance really is the "true appearance" - Ornedan
    StoreCurrentAppearanceAsTrueAppearance(oPC, TRUE);

    // See if the creature is shiftable to. If so, store it as a template and shift
    if(GetCanShiftIntoCreature(oPC, SHIFTER_TYPE_CHANGESHAPE, oTarget))
    {
        StoreShiftingTemplate(oPC, SHIFTER_TYPE_CHANGESHAPE, oTarget);
        // Make sure the character has uses left for shifting
        int bPaid = FALSE;
        // Pay if Irda
        if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_LEARN)
        {
            DecrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
            bPaid = TRUE;
        }
                    
        else
            bPaid = TRUE;

        // Start shifting. If this fails immediately, refund the shifting use
        if(!ShiftIntoCreature(oPC, SHIFTER_TYPE_CHANGESHAPE, oTarget))
        {
            // In case of shifting failure, refund the shifting use
            if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_LEARN)
                IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
        }
    }
    // Couldn't shift, refund the feat use
    else
        if(nSpellID == SPELL_IRDA_CHANGE_SHAPE_LEARN)
            IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
}
