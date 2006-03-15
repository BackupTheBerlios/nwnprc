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

#include "pnp_shft_main"

void main()
{
    StoreAppearance(OBJECT_SELF);
    int nCurForm = GetAppearanceType(OBJECT_SELF);
    int nPCForm = GetTrueForm(OBJECT_SELF);
    if(GetPRCSwitch(PRC_LICH_ALTER_SELF_DISABLE))
        return;

    // Switch to lich
    if (nPCForm == nCurForm)
    {
        int nLichLevel = GetLevelByClass(CLASS_TYPE_LICH,OBJECT_SELF);
        if (nLichLevel < 10)
        {
            effect eFx = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            SetCreatureAppearanceType(OBJECT_SELF,APPEARANCE_TYPE_LICH);
            /*1.67 code
            SetPortraitId(OBJECT_SELF, 241);
            SetPortraitResRef(OBJECT_SELF, "Lich");
            */
        }
        else if (nLichLevel == 10)
        {
            effect eFx = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            SetCreatureAppearanceType(OBJECT_SELF,430); // DemiLich
            /*1.67 code
            SetPortraitId(OBJECT_SELF, 724);
            SetPortraitResRef(OBJECT_SELF, "demilich");
            */
        }
    }
    else // Switch to PC
    {
        effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        //re-use unshifter code from shifter instead
        //this will also remove complexities with lich/shifter characters
        //also take advantage of new stuff from 1.67 patch
        SetShiftTrueForm(OBJECT_SELF);
        //SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
    }
}
