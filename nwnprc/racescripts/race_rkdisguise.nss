//::///////////////////////////////////////////////
//:: Name        Rak disguise
//:: FileName    race_rkdisguise
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// disguise for rak

#include "pnp_shft_main"

void main()
{
    int nCurForm = GetAppearanceType(OBJECT_SELF);
    int nPCForm = GetTrueForm(OBJECT_SELF);

    // Switch to lich
    if (nPCForm == nCurForm)
    {
        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_HUMAN_NPC_FEMALE_12);
    }
    else // Switch to PC
    {
        effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFx,OBJECT_SELF);
        //re-use unshifter code from shifter instead
        //this will also remove complexities with lich/shifter characters
        SetShiftTrueForm(OBJECT_SELF);
        //SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
        
    }
}
