//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_alter
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// alter self for the lich

#include "prc_alterations"


void main()
{
    //all disabled - NWN2
    /*
    if(GetPRCSwitch(PRC_LICH_ALTER_SELF_DISABLE))
    {
        FloatingTextStringOnCreature("Lich Alter Self has been disabled in this module.", OBJECT_SELF);
        return;
    }
    StoreAppearance(OBJECT_SELF);
    int nCurForm = GetAppearanceType(OBJECT_SELF);
    int nPCForm = GetTrueForm(OBJECT_SELF);

    // Switch to lich
    if (nPCForm == nCurForm)
    {
        int nLichLevel = GetLevelByClass(CLASS_TYPE_LICH,OBJECT_SELF);
        if (nLichLevel < 10)
        {
            effect eFx = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFx,OBJECT_SELF);
            SetCreatureAppearanceType(OBJECT_SELF,APPEARANCE_TYPE_LICH);
            SetPortraitResRef(OBJECT_SELF, "Lich");
            SetPortraitId(OBJECT_SELF, 241);
        }
        else if (nLichLevel == 10)
        {
            effect eFx = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eFx,OBJECT_SELF);
            SetCreatureAppearanceType(OBJECT_SELF,APPEARANCE_TYPE_DEMI_LICH); // DemiLich
            SetPortraitResRef(OBJECT_SELF, "demilich");
            SetPortraitId(OBJECT_SELF, 724);
        }
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
    */
}
