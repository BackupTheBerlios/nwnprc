//::///////////////////////////////////////////////
//:: Thousand Faces
//:: no_sw_thouface
//:://////////////////////////////////////////////
/*
    Allows the Ninjamastah to appear as various
    NPCs of PC playable races.
*/
//:://////////////////////////////////////////////
//:: Created By: Tim Czvetics (NamelessOne)
//:: Created On: Dec 17, 2003
//:://////////////////////////////////////////////
//taken from
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
    int iSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    int iGender = GetGender( OBJECT_SELF );
    int iFace;

    int nCurForm = GetAppearanceType(OBJECT_SELF);
    int nPCForm = GetTrueForm(OBJECT_SELF);

    // Switch to lich
    if (nPCForm == nCurForm)
    {
        //Determine subradial selection
        if(iSpell == SPELLABILITY_NS_DWARF)   //DWARF
        {
            iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_DWARF_NPC_FEMALE : APPEARANCE_TYPE_DWARF_NPC_MALE;
            SetCreatureAppearanceType(OBJECT_SELF, iFace);
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        }
        else if (iSpell == SPELLABILITY_NS_ELF) //ELF
        {
            iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_ELF_NPC_FEMALE : APPEARANCE_TYPE_ELF_NPC_MALE_01;
            SetCreatureAppearanceType(OBJECT_SELF, iFace);
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        }
        else if (iSpell == SPELLABILITY_NS_HALF_ELF) //HALF_ELF
        {
            iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_HUMAN_NPC_FEMALE_01 : APPEARANCE_TYPE_HUMAN_NPC_MALE_01;
            SetCreatureAppearanceType(OBJECT_SELF, iFace);
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        }
        else if (iSpell == SPELLABILITY_NS_HALF_ORC) //HALF_ORC
        {
            iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_HALF_ORC_NPC_FEMALE : APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01;
            SetCreatureAppearanceType(OBJECT_SELF, iFace);
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        }
        else if (iSpell == SPELLABILITY_NS_HUMAN) //HUMAN
        {
            iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_HUMAN_NPC_FEMALE_02 : APPEARANCE_TYPE_HUMAN_NPC_MALE_02;
            SetCreatureAppearanceType(OBJECT_SELF, iFace);
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        }
        else if (iSpell == SPELLABILITY_NS_GNOME) //GNOME
        {
            iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_GNOME_NPC_FEMALE : APPEARANCE_TYPE_GNOME_NPC_MALE;
            SetCreatureAppearanceType(OBJECT_SELF, iFace);
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        }
        else if (iSpell == SPELLABILITY_NS_HALFLING) //HALFLING
        {
            iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_HALFLING_NPC_FEMALE : APPEARANCE_TYPE_HALFLING_NPC_MALE;
            SetCreatureAppearanceType(OBJECT_SELF, iFace);
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        }
        else if (iSpell == SPELLABILITY_NS_OFF) //RETURN TO ORIGINAL APPEARANCE
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            //re-use unshifter code from shifter instead
            //this will also remove complexities with lich/shifter characters
            SetShiftTrueForm(OBJECT_SELF);
            //SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
        }
    }   
    else // Switch to PC
    {
        effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        //re-use unshifter code from shifter instead
        //this will also remove complexities with lich/shifter characters
        SetShiftTrueForm(OBJECT_SELF);
        //SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
        
    }
}    