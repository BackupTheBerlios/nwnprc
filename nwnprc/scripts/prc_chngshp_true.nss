//:://////////////////////////////////////////////
//:: CHange Shape - return to true form
//:: prc_chngshp_true
//:://////////////////////////////////////////////
/** @file
    Undoes any shifting that the character may
    have undergone. Also removes any polymorph
    effects.
    
    Note: Also attempts to clear old shifter style shifting.
    Depending on which one overrides, may need to change the
    order of the if statements.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modded by Fox
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_shifting"
#include "pnp_shft_poly"

void main()
{
    object oPC = OBJECT_SELF;
    
    if(GetSpellId() == SPELL_IRDA_CHANGE_SHAPE_TRUE)
         IncrementRemainingFeatUses(oPC, FEAT_IRDA_CHANGE_SHAPE);
    
    //clear old style shifting first
    if(GetLocalInt(oPC, "shifting"))
    {
        effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        //re-use unshifter code from shifter instead
        //this will also remove complexities with lich/shifter characters
        SetShiftTrueForm(OBJECT_SELF);
    }

    // Attempt to unshift and if it fails, inform the user with a message so they don't wonder whether something is happening or not
    else if(UnShift(oPC, TRUE) == UNSHIFT_FAIL)
        FloatingTextStrRefOnCreature(16828383, oPC, FALSE); // "Failed to return to true form!"
}
