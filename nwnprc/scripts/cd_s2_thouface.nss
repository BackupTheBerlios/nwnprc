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

#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

const string sOriginalAppearance = "#TFORIGAPP";  //label for tracking ninjamastah's original appearance

int GetIsShapeChanged( object oE=OBJECT_SELF );
void SetOriginalAppearanceType( object oE=OBJECT_SELF );
int GetOriginalAppearanceType( object oE=OBJECT_SELF );

void main()
{
    int iSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );
    int iFace;
    int iGender = GetGender( OBJECT_SELF );

    //don't let ninjamastah use thousand faces if they are polymorphed
    if ( GetIsShapeChanged( OBJECT_SELF ) == TRUE )
    {
        SendMessageToPC( OBJECT_SELF, "You cannot use this ability if your form is altered." );
        return;
    }

    //call function that logs appearance type if it is the first use of this ability
    SetOriginalAppearanceType( OBJECT_SELF );

    //Determine subradial selection
    if(iSpell == SPELLABILITY_NS_DWARF)   //DWARF
    {
        iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_DWARF_NPC_FEMALE : APPEARANCE_TYPE_DWARF_NPC_MALE;
    }
    else if (iSpell == SPELLABILITY_NS_ELF) //ELF
    {
        iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_ELF_NPC_FEMALE : APPEARANCE_TYPE_ELF_NPC_MALE_01;
    }
    else if (iSpell == SPELLABILITY_NS_HALF_ELF) //HALF_ELF
    {
        iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_HUMAN_NPC_FEMALE_01 : APPEARANCE_TYPE_HUMAN_NPC_MALE_01;
    }
    else if (iSpell == SPELLABILITY_NS_HALF_ORC) //HALF_ORC
    {
        iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_HALF_ORC_NPC_FEMALE : APPEARANCE_TYPE_HALF_ORC_NPC_MALE_01;
    }
    else if (iSpell == SPELLABILITY_NS_HUMAN) //HUMAN
    {
        iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_HUMAN_NPC_FEMALE_02 : APPEARANCE_TYPE_HUMAN_NPC_MALE_02;
    }
    else if (iSpell == SPELLABILITY_NS_GNOME) //GNOME
    {
        iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_GNOME_NPC_FEMALE : APPEARANCE_TYPE_GNOME_NPC_MALE;
    }
    else if (iSpell == SPELLABILITY_NS_HALFLING) //HALFLING
    {
        iFace = iGender == GENDER_FEMALE ? APPEARANCE_TYPE_HALFLING_NPC_FEMALE : APPEARANCE_TYPE_HALFLING_NPC_MALE;
    }
    else if (iSpell == SPELLABILITY_NS_OFF) //RETURN TO ORIGINAL APPEARANCE
    {
        iFace = GetOriginalAppearanceType( OBJECT_SELF );
    }

    //Apply the change
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, 1.0 );
    DelayCommand( 0.5, SetCreatureAppearanceType( OBJECT_SELF, iFace ) );
}

/*
====================
GetIsShapeChanged

Checks to see if oE has the effects of any shapechanging spells or feats.
Returns TRUE is they do and FALSE if not.
====================
*/
int GetIsShapeChanged( object oE=OBJECT_SELF )
{
    int iS = FALSE;

    if ( GetHasSpellEffect( SPELL_POLYMORPH_SELF, oE ) || GetHasSpellEffect( SPELL_SHAPECHANGE, oE ) ||
        GetHasFeatEffect( FEAT_WILD_SHAPE, oE ) || GetHasFeatEffect( FEAT_ELEMENTAL_SHAPE, oE ) ||
        GetHasFeatEffect( FEAT_EPIC_WILD_SHAPE_DRAGON, oE ) || GetHasFeatEffect( FEAT_EPIC_WILD_SHAPE_UNDEAD, oE ) ||
        GetHasFeatEffect( FEAT_HUMANOID_SHAPE, oE ) || GetHasFeatEffect( FEAT_GREATER_WILDSHAPE_1, oE ) ||
        GetHasFeatEffect( FEAT_GREATER_WILDSHAPE_2, oE ) || GetHasFeatEffect( FEAT_GREATER_WILDSHAPE_3, oE ) ||
        GetHasFeatEffect( FEAT_GREATER_WILDSHAPE_4, oE ) )
    {
        iS = TRUE;
    }
    return iS;
}

/*
====================
SetOriginalAppearanceType

If oE does not have a recorded original appearance type then it is probably the first
time they are using Thousand Faces. Record their current appearance type so that we can
revert to it later.

Note: Increments the appearance type by 1 before recording it. This is because
GetOriginalAppearanceType uses GetLocalInt() and it is possible that it would return
0 which would also be a match for APPEARANCE_TYPE_DWARF, making it difficult to distinguish
between a failed GetLocalInt() and a stored APPEARANCE_TYPE_DWARF.
====================
*/
void SetOriginalAppearanceType( object oE=OBJECT_SELF )
{
    int iA = GetLocalInt( oE, sOriginalAppearance );

    if ( iA == 0 )
    {
        //add one to appearance type so we can avoid confusion for APPEARANCE_TYPE_DWARF
        SetLocalInt( oE, sOriginalAppearance, GetAppearanceType( oE ) + 1 );
    }
}

/*
====================
GetOriginalAppearanceType

Return the APPEARANCE_TYPE_* value that was stored on the creature during the first use of
Thousand Faces. If no value is stored the value returned will be -1.

Note: See the notes for SetOriginalAppearanceType for an explanation of why the retrieved
local integer is decremented.
====================
*/
int GetOriginalAppearanceType( object oE=OBJECT_SELF )
{
    //subtract one to match up with adjustment in SetOriginalAppearance
    int iA = GetLocalInt( oE, sOriginalAppearance ) - 1;

    return iA;
}

