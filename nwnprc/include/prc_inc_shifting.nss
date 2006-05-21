//::///////////////////////////////////////////////
//:: Shifting include
//:: prc_inc_shifting
//::///////////////////////////////////////////////
/** @file
    Defines constants, functions and structs
    related to shifting.


    Creature data is stored as two persistant
    arrays, with synchronised indexes.
    - Resref
    - Creature name, as given by GetName() on the
      original creature from which the resref was
      gotten

    @author Ornedan
    @date   Created - 2006.03.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const int SHIFTER_TYPE_SHIFTER   = 1;
const int SHIFTER_TYPE_SOULEATER = 2;
const int SHIFTER_TYPE_POLYMORPH = 3;

const string SHIFTER_FORMS_ARRAY      = "PRC_ShiftingForms_";
const string SHIFTER_NAMES_ARRAY      = "PRC_ShiftingNames_";
const string SHIFTER_TRUEFORM_PREFIX  = "PRC_ShiftingTrueForm_";
const string SHIFTER_ISSHIFTED_MARKER = "PRC_IsShifted";
const string SHIFTER_SHIFT_MUTEX      = "PRC_Shifting_InProcess";


const int STRREF_YOUNEED             = 16828326; // "You need"
const int STRREF_MORECHARLVL         = 16828327; // "more character levels before you can take on that form."
const int STRREF_NOPOLYTOPC          = 16828328; // "You cannot polymorph into a PC."
const int STRREF_FORBIDPOLY          = 16828329; // "Target cannot be polymorphed into."
const int STRREF_SETTINGFORBID       = 16828330; // "The module settings prevent this creature from being polymorphed into."
const int STRREF_PNPSFHT_FEYORSSHIFT = 16828331; // "You cannot use PnP Shifter abilities to polymorph into this creature."
const int STRREF_PNPSHFT_MORELEVEL   = 16828332; // "more PnP Shifter levels before you can take on that form."
const int STRREF_NEED_SPACE          = 16828333; // "Your inventory is too full for the PRC Shifting system to work. Please make space for three (3) helmet-size items (4x4) in your inventory before trying again."
const int STRREF_POLYMORPH_MUTEX     = 16828334; // "The PRC Shifting system will not work while you are affected by a polymorph effect. Please remove it before trying again."


//////////////////////////////////////////////////
/*                 Structures                   */
//////////////////////////////////////////////////

/**
 * A struct for dynamic model data.
 */
struct modelvalues{
	/* Fields for the actual appearance */

    /// The appearance type aka appearance.2da row
    int nAppearanceType;

    /// Body part - Right foot
    int nBodyPart_RightFoot;
    /// Body part - Left Foot
    int nBodyPart_LeftFoot;
    /// Body part - Right Shin
    int nBodyPart_RightShin;
    /// Body part - Left Shin
    int nBodyPart_LeftShin;
    /// Body part - Right Thigh
    int nBodyPart_RightThigh;
    /// Body part - Left Thigh
    int nBodyPart_LeftThight;
    /// Body part - Pelvis
    int nBodyPart_Pelvis;
    /// Body part - Torso
    int nBodyPart_Torso;
    /// Body part - Belt
    int nBodyPart_Belt;
    /// Body part - Neck
    int nBodyPart_Neck;
    /// Body part - Right Forearm
    int nBodyPart_RightForearm;
    /// Body part - Left Forearm
    int nBodyPart_LeftForearm;
    /// Body part - Right Bicep
    int nBodyPart_RightBicep;
    /// Body part - Left Bicep
    int nBodyPart_LeftBicep;
    /// Body part - Right Shoulder
    int nBodyPart_RightShoulder;
    /// Body part - Left Shoulder
    int nBodyPart_LeftShoulder;
    /// Body part - Right Hand
    int nBodyPart_RightHand;
    /// Body part - Left Hand
    int nBodyPart_LeftHand;
    /// Body part - Head
    int nBodyPart_Head;

    /// The wing type
    int nWingType;
    /// The tail type
    int nTailType;

	/* Other stuff */

    /// Portrait ID
    int nPortraitID;
    /// Portrait resref
    int sPortraitResRef;
    /// The footstep type
    int nFootStepType;
};

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

// True form stuff //

/**
 * Stores the given creature's current appearance as it's true appearance.
 *
 * @param oShifter  The creature whose true appearance to store
 * @param bCarefull If this is TRUE, will only store the appearance if the creature
 *                  is not shifted or polymorphed
 * @return          TRUE if the appearance was stored, FALSE if not
 */
int StoreCurrentAppearanceAsTrueAppearance(object oShifter, int bCarefull = TRUE);

/**
 * Restores the given creature to it's stored true appearance.
 *
 * @param oShifter The creature whose appearance to set into an appearance
 *                 previously stored as it's true appearance.
 */
void RestoreTrueAppearance(object oShifter);

// Storage functions  //

/**
 * Stores the target's resref in the 'shifting forms' list of the given creature.
 * Will silently fail if either the shifter or the target are not valid objects
 * or if the target is a PC.
 *
 * @param oShifter     The creature to whose list to store oTarget's resref in
 * @param nShifterType SHIFTER_TYPE_* of the list to store in
 * @param oTarget      The creature whose resref to store for later use in shifting
 */
void StoreForm(object oShifter, int nShifterType, object oTarget);

/**
 * Gets the number of 'forms' stored in the given creature's list.
 *
 * @param oShifter     The creature whose list to examine
 * @param nShifterType SHIFTER_TYPE_* of the list to store examine
 * @return             The number of entries in the arrays making up the list
 */
int GetNumberOfStoredForms(object oShifter, int nShifterType);

/**
 * Reads the resref stored at the given index at a creature's 'forms'
 * list.
 *
 * @param oShifter     The creature from whose list to read
 * @param nShifterType SHIFTER_TYPE_* of the list to read from
 * @param nIndex       The index of the entry to get in the list. Standard
 *                     base-0 indexing.
 * @return             The resref stored at the given index. "" on failure (ex.
 *                     reading from an index outside the list.
 */
string GetStoredForm(object oShifter, int nShifterType, int nIndex);

/**
 * Reads the name stored at the given index at a creature's 'forms'
 * list.
 *
 * @param oShifter     The creature from whose list to read
 * @param nShifterType SHIFTER_TYPE_* of the list to read from
 * @param nIndex       The index of the entry to get in the list. Standard
 *                     base-0 indexing.
 * @return             The name stored at the given index. "" on failure (ex.
 *                     reading from an index outside the list.
 */
string GetStoredFormName(object oShifter, int nShifterType, int nIndex);

/**
 * Deletes the 'shifting forms' entry in a creature's list at a given
 * index.
 *
 * @param oShifter     The creature from whose list to delete
 * @param nShifterType SHIFTER_TYPE_* of the list to delete from
 * @param nIndex       The index of the entry to delete in the list. Standard
 *                     base-0 indexing.
 */
void DeleteStoredForm(object oShifter, int nShifterType, int nIndex);


// Shifting-related functions

/**
 * Determines whether the given creature can shift into the given target.
 *
 * @param oShifter     The creature attempting to shift into oTemplate
 * @param nShifterType SHIFTER_TYPE_*
 * @param oTemplate    The target of the shift
 *
 * @return             TRUE if oShifter can shift into oTemplate, FALSE otherwise
 */
int GetCanShiftIntoCreature(object oShifter, int nShifterType, object oTemplate);

void ShiftIntoCreature(object oShifter, int nShifterType, object oTemplate, int bGainSpellLikeAbilities = FALSE);

void ShiftIntoResRef(object oShifter, int nShifterType, string sResRef, int bGainSpellLikeAbilities = FALSE);

struct modelvalues GetAppearanceData(object oTemplate);

void SetAppearanceData(object oTarget, struct modelvalues mdlval);


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

void _RestoreCreatureItems(object oShifter)
{/// @todo
}

/** Internal function.
 * Looks through the given creature's inventory and deletes all
 * creature items not in the creature item slots.
 *
 * @param oShifter The creature through whose inventory to look
 */
void _RemoveExtraCreatureItems(object oShifter)
{
    int nItemType;
    object oItem  = GetFirstItemInInventory(oShifter);
    object oCWPB  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oShifter);
    object oCWPL  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oShifter);
    object oCWPR  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oShifter);
    object oCSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR,   oShifter);

    while(GetIsObjectValid(oItem))
    {
        nItemType = GetBaseItemType(oItem);

        if(iItemType == BASE_ITEM_CBLUDGWEAPON ||
           iItemType == BASE_ITEM_CPIERCWEAPON ||
           iItemType == BASE_ITEM_CREATUREITEM ||
           iItemType == BASE_ITEM_CSLASHWEAPON ||
           iItemType == BASE_ITEM_CSLSHPRCWEAP
           )
        {
            if(oCheck != oCWPB &&
               oCheck != oCWPL &&
               oCheck != oCWPR &&
               oCheck != oCSkin
               )
                MyDestroyObject(oCheck);
        }
        oCheck = GetNextItemInInventory(oPC);
    }
}

/** Internal function.
 * Determines if beings of the given creature's racial type
 * could usually cast spells.
 */
int _GetCanFormCast(object oTemplate)
{
    int nRacialType = MyPRCGetRacialType(oCreature);

    // Need to have hands, and the ability to speak

    switch (nRacialType)
    {
        case RACIAL_TYPE_ABERRATION:
        case RACIAL_TYPE_MAGICAL_BEAST:
        case RACIAL_TYPE_VERMIN:
        case RACIAL_TYPE_BEAST:
        case RACIAL_TYPE_ANIMAL:
        case RACIAL_TYPE_OOZE:
//    case RACIAL_TYPE_PLANT:
            // These forms can't cast spells
            return FALSE;
        case RACIAL_TYPE_SHAPECHANGER:
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_DRAGON:
        case RACIAL_TYPE_OUTSIDER:
        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_GIANT:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_DWARF:
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HALFELF:
        case RACIAL_TYPE_HALFLING:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        case RACIAL_TYPE_FEY:
            break;

        default:{
            if(DEBUG) DoDebug("prc_inc_shifting: _GetCanFormCast(): Unknown racial type: " + IntToString(nRacialType));
        }
    }

    return TRUE;
}

/** Internal function.
 * Checks a creature's challenge rating to determine if it could be
 * considered harmless.
 */
int _GetIsCreatureHarmless(object oTemplate)
{
    /* This is likely to cause problems - Ornedan
    string sCreatureName = GetName(oCreature);

    // looking for small < 1 CR creatures that nobody looks at twice

    if ((sCreatureName == "Chicken") ||
        (sCreatureName == "Falcon") ||
        (sCreatureName == "Hawk") ||
        (sCreatureName == "Raven") ||
        (sCreatureName == "Bat") ||
        (sCreatureName == "Dire Rat") ||
        (sCreatureName == "Will-O'-Wisp") ||
        (sCreatureName == "Rat") ||
        (GetChallengeRating(oCreature) < 1.0 ))
        return TRUE;
    else
        return FALSE;
    */

    return GetChallengeRating(oCreature) < 1.0;
}

void _CopyAllItemProperties(object oFrom, object oTo)
{
    itemproperty iProp = GetFirstItemProperty(oFrom);

    while(GetIsItemPropertyValid(iProp))
    {
        AddItemProperty(GetItemPropertyDurationType(iProp), iProp, oTo);
        iProp = GetNextItemProperty(oFrom);
    }
}

/** Internal function.
 * Determines the IP_CONST_FEAT_* for the given feat.
 */
int _GetIPFeatFromFeat(int nFeat)
{
    switch (nFeat)
    {
        case FEAT_ALERTNESS:                        return IP_CONST_FEAT_ALERTNESS;
        case FEAT_AMBIDEXTERITY:                    return IP_CONST_FEAT_AMBIDEXTROUS;
        case FEAT_ARMOR_PROFICIENCY_HEAVY:          return IP_CONST_FEAT_ARMOR_PROF_HEAVY;
        case FEAT_ARMOR_PROFICIENCY_LIGHT:          return IP_CONST_FEAT_ARMOR_PROF_LIGHT;
        case FEAT_ARMOR_PROFICIENCY_MEDIUM:         return IP_CONST_FEAT_ARMOR_PROF_MEDIUM;
        case FEAT_CLEAVE:                           return IP_CONST_FEAT_CLEAVE;
        case FEAT_COMBAT_CASTING:                   return IP_CONST_FEAT_COMBAT_CASTING;
        case FEAT_DODGE:                            return IP_CONST_FEAT_DODGE;
        case FEAT_EXTRA_TURNING:                    return IP_CONST_FEAT_EXTRA_TURNING;
        case FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE: return IP_CONST_FEAT_IMPCRITUNARM;
        case FEAT_IMPROVED_KNOCKDOWN:               return IP_CONST_FEAT_IMPROVED_KNOCKDOWN;
        case FEAT_KNOCKDOWN:                        return IP_CONST_FEAT_KNOCKDOWN;
        case FEAT_POINT_BLANK_SHOT:                 return IP_CONST_FEAT_POINTBLANK;
        case FEAT_IMPROVED_POWER_ATTACK:            // Missing IPFeat
        case FEAT_POWER_ATTACK:                     return IP_CONST_FEAT_POWERATTACK;
        case FEAT_GREATER_SPELL_FOCUS_ABJURATION:   // Missing IPFeat
        case FEAT_EPIC_SPELL_FOCUS_ABJURATION:      // Missing IPFeat
        case FEAT_SPELL_FOCUS_ABJURATION:           return IP_CONST_FEAT_SPELLFOCUSABJ;
        case FEAT_GREATER_SPELL_FOCUS_CONJURATION:  // Missing IPFeat
        case FEAT_EPIC_SPELL_FOCUS_CONJURATION:     // Missing IPFeat
        case FEAT_SPELL_FOCUS_CONJURATION:          return IP_CONST_FEAT_SPELLFOCUSCON;
        case FEAT_GREATER_SPELL_FOCUS_DIVINIATION:  // Missing IPFeat
        case FEAT_EPIC_SPELL_FOCUS_DIVINATION:      // Missing IPFeat
        case FEAT_SPELL_FOCUS_DIVINATION:           return IP_CONST_FEAT_SPELLFOCUSDIV;
        case FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT:  // Missing IPFeat
        case FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT:     // Missing IPFeat
        case FEAT_SPELL_FOCUS_ENCHANTMENT:          return IP_CONST_FEAT_SPELLFOCUSENC;
        case FEAT_GREATER_SPELL_FOCUS_EVOCATION:    // Missing IPFeat
        case FEAT_EPIC_SPELL_FOCUS_EVOCATION:       // Missing IPFeat
        case FEAT_SPELL_FOCUS_EVOCATION:            return IP_CONST_FEAT_SPELLFOCUSEVO;
        case FEAT_GREATER_SPELL_FOCUS_ILLUSION:     // Missing IPFeat
        case FEAT_EPIC_SPELL_FOCUS_ILLUSION:        // Missing IPFeat
        case FEAT_SPELL_FOCUS_ILLUSION:             return IP_CONST_FEAT_SPELLFOCUSILL;
        case FEAT_GREATER_SPELL_FOCUS_NECROMANCY:   // Missing IPFeat
        case FEAT_EPIC_SPELL_FOCUS_NECROMANCY:      // Missing IPFeat
        case FEAT_SPELL_FOCUS_NECROMANCY:           return IP_CONST_FEAT_SPELLFOCUSNEC;
        case FEAT_GREATER_SPELL_PENETRATION:        // Missing IPFeat
        case FEAT_EPIC_SPELL_PENETRATION:           // Missing IPFeat
        case FEAT_SPELL_PENETRATION:                return IP_CONST_FEAT_SPELLPENETRATION;
        case FEAT_IMPROVED_TWO_WEAPON_FIGHTING:     // Missing IPFeat
        case FEAT_TWO_WEAPON_FIGHTING:              return IP_CONST_FEAT_TWO_WEAPON_FIGHTING;
        case FEAT_WEAPON_FINESSE:                   return IP_CONST_FEAT_WEAPFINESSE;
        case FEAT_WEAPON_PROFICIENCY_EXOTIC:        return IP_CONST_FEAT_WEAPON_PROF_EXOTIC;
        case FEAT_WEAPON_PROFICIENCY_MARTIAL:       return IP_CONST_FEAT_WEAPON_PROF_MARTIAL;
        case FEAT_WEAPON_PROFICIENCY_SIMPLE:        return IP_CONST_FEAT_WEAPON_PROF_SIMPLE;
        case FEAT_IMPROVED_UNARMED_STRIKE:          return IP_CONST_FEAT_WEAPSPEUNARM;
        case FEAT_DISARM:                           return IP_CONST_FEAT_DISARM;
        case FEAT_HIDE_IN_PLAIN_SIGHT:              return IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT;
        case FEAT_MOBILITY:                         return IP_CONST_FEAT_MOBILITY;
        case FEAT_RAPID_SHOT:                       return IP_CONST_FEAT_RAPID_SHOT;
        case FEAT_SHIELD_PROFICIENCY:               return IP_CONST_FEAT_SHIELD_PROFICIENCY;
        case FEAT_SNEAK_ATTACK:                     return IP_CONST_FEAT_SNEAK_ATTACK_1D6;
        case FEAT_USE_POISON:                       return IP_CONST_FEAT_USE_POISION; // 1.67 fixed this typo.
        case FEAT_WHIRLWIND_ATTACK:                 return IP_CONST_FEAT_WHIRLWIND;
        case FEAT_WEAPON_PROFICIENCY_CREATURE:      return IP_CONST_FEAT_WEAPON_PROF_CREATURE;
    }
    // If no match was found, return an invalid value
    return -1;
}

/** Internal function.
 * Builds the shifter spell-like and activatable supernatural abilities item.
 *
 * @param oTemplate The target creature of an ongoing shift
 * @param oItem     The item to create the activatable itemproperties on.
 * @return          oItem, or the item created by the function
 */
void _CreateShifterActiveAbilitiesItem(object oTemplate, object oItem)
{
    itemproperty iProp;
    int total_props = 0; //max of 8 properties on one item
    int max_props = 7;

    //first, auras--only want to allow one aura power to transfer
    if ( GetHasSpell(SPELLABILITY_AURA_BLINDING, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(750,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_COLD, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(751,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_ELECTRICITY, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(752,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_FEAR, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(753,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_FIRE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(754,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_MENACE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(755,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_PROTECTION, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(756,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_STUN, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(757,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_UNEARTHLY_VISAGE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(758,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_UNNATURAL, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(759,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //now, bolts
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_CHARISMA, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(760,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_CONSTITUTION, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(761,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_DEXTERITY, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(762,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_INTELLIGENCE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(763,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_STRENGTH, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(764,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_WISDOM, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(765,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ACID, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(766,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_CHARM, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(767,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_COLD, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(768,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_CONFUSE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(769,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DAZE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(770,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DEATH, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(771,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DISEASE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(772,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DOMINATE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(773,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_FIRE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(774,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_KNOCKDOWN, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(775,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_LEVEL_DRAIN, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(776,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_LIGHTNING, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(777,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_PARALYZE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(778,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_POISON, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(779,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_SHARDS, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(780,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_SLOW, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(781,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_STUN, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(782,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_WEB, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(783,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //now, cones
    if ( GetHasSpell(SPELLABILITY_CONE_ACID, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(784,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_COLD, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(785,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_DISEASE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(786,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_FIRE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(787,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_LIGHTNING, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(788,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_POISON, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(789,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_SONIC, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(790,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //various petrify attacks
    if ( GetHasSpell(SPELLABILITY_BREATH_PETRIFY, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(791,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_PETRIFY, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(792,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_TOUCH_PETRIFY, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(793,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //dragon stuff (fear aura, breaths)
    if ( GetHasSpell(SPELLABILITY_DRAGON_FEAR, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(796,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_ACID, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(400,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_COLD, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(401,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_FEAR, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(402,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_FIRE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(403,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_GAS, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(404,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_LIGHTNING, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(405,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(698, oCreature) && (total_props <= max_props) ) //NEGATIVE
    {
        iProp = ItemPropertyCastSpell(794,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_PARALYZE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(406,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_SLEEP, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(407,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_SLOW, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(408,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_WEAKEN, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(409,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(771, oCreature) && (total_props <= max_props) ) //PRISMATIC
    {
        iProp = ItemPropertyCastSpell(795,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //gaze attacks
    if ( GetHasSpell(SPELLABILITY_GAZE_CHARM, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(797,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_CONFUSION, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(798,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DAZE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(799,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DEATH, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(800,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_CHAOS, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(801,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_EVIL, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(802,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_GOOD, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(803,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_LAW, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(804,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DOMINATE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(805,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DOOM, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(806,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_FEAR, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(807,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_PARALYSIS, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(808,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_STUNNED, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(809,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //miscellaneous abilities
    if ( GetHasSpell(SPELLABILITY_GOLEM_BREATH_GAS, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(810,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HELL_HOUND_FIREBREATH, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(811,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_KRENSHAR_SCARE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(812,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //howls
    if ( GetHasSpell(SPELLABILITY_HOWL_CONFUSE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(813,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DAZE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(814,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DEATH, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(815,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DOOM, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(816,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_FEAR, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(817,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_PARALYSIS, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(818,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_SONIC, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(819,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_STUN, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(820,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //pulses
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_CHARISMA, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(821,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_CONSTITUTION, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(822,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_DEXTERITY, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(823,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_INTELLIGENCE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(824,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_STRENGTH, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(825,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_WISDOM, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(826,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_COLD, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(827,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DEATH, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(828,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DISEASE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(829,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DROWN, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(830,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_FIRE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(831,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_HOLY, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(832,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_LEVEL_DRAIN, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(833,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_LIGHTNING, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(834,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_NEGATIVE, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(835,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_POISON, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(836,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_SPORES, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(837,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_WHIRLWIND, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(838,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //monster summon abilities
    if ( GetHasSpell(SPELLABILITY_SUMMON_SLAAD, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(839,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_SUMMON_TANARRI, oCreature) && (total_props <= max_props) )
    {
        iProp = ItemPropertyCastSpell(840,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //abilities without const refs
    if ( GetHasSpell(552, oCreature) && (total_props <= max_props) ) //PSIONIC CHARM
    {
        iProp = ItemPropertyCastSpell(841,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(551, oCreature) && (total_props <= max_props) ) //PSIONIC MINDBLAST
    {
        iProp = ItemPropertyCastSpell(842,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(713, oCreature) && (total_props <= max_props) ) //MINDBLAST 10M
    {
        iProp = ItemPropertyCastSpell(843,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(741, oCreature) && (total_props <= max_props) ) //PSIONIC BARRIER
    {
        iProp = ItemPropertyCastSpell(844,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(763, oCreature) && (total_props <= max_props) ) //PSIONIC CONCUSSION
    {
        iProp = ItemPropertyCastSpell(845,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(731, oCreature) && (total_props <= max_props) ) //BEBILITH WEB
    {
        iProp = ItemPropertyCastSpell(846,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(736, oCreature) && (total_props <= max_props) ) //BEHOLDER EYES
    {
        iProp = ItemPropertyCastSpell(847,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(770, oCreature) && (total_props <= max_props) ) //CHAOS SPITTLE
    {
        iProp = ItemPropertyCastSpell(848,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(757, oCreature) && (total_props <= max_props) ) //SHADOWBLEND
    {
        iProp = ItemPropertyCastSpell(849,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(774, oCreature) && (total_props <= max_props) ) //DEFLECTING FORCE
    {
        iProp = ItemPropertyCastSpell(850,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //some spell-like abilities
    if (((GetHasSpell(SPELL_DARKNESS,oCreature)) ||
        (GetHasSpell(SPELLABILITY_AS_DARKNESS,oCreature))) &&
        (total_props <= max_props))
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ((GetHasSpell(SPELL_DISPLACEMENT,oCreature)) && (total_props <= max_props))
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPLACEMENT_9,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (((GetHasSpell(SPELLABILITY_AS_INVISIBILITY,oCreature)) ||
        (GetHasSpell(SPELL_INVISIBILITY,oCreature))) &&
        (total_props <= max_props))
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ((GetHasSpell(SPELL_WEB,oCreature)) && (total_props <= max_props))
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEB_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
}

/** Internal function.
 * Determines if the given resref has already been stored in the
 * forms array of the given creature's shifting list for
 * a particular shifting type.
 *
 * @param oShifter     The creature
 * @param nShifterType The shifting list to look in
 * @param sResRef      The resref to look for
 * @return             TRUE if the resref is present in the array
 */
int _GetIsFormStored(object oShifter, int nShifterType, string sResRef)
{
    string sFormsArray = SHIFTER_FORMS_ARRAY + IntToString(nShifterType);
    int i, nArraySize  = persistant_array_size(oShifter, sFormsArray);

    // Lowercase the searched for string
    sResRef = GetStringLowerCase(sResRef);

    for(i = 0; i < nArraySize; i++)
    {
        if(sResRef == persistant_array_get_string(oShifter, sFormsArray, i))
            return TRUE;
    }

    return FALSE;
}

/** Internal function.
 * Performs some checks to see if the given creature can shift without
 * the system falling apart.
 *
 * @param oShifter The creature that would be shifted
 * @return         TRUE if all is OK, FALSE otherwise
 */
int _GetCanShift(object oShifter)
{
    // Mutex - If another shifting process is active, fail immediately without disturbing it
    if(GetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX))
        return FALSE;

    // Test space in inventory for creating the creature items
    int bReturn = TRUE;
    object o1 = CreateItemOnObject("pnp_shft_tstpkup", oShifter),
           o2 = CreateItemOnObject("pnp_shft_tstpkup", oShifter),
           o3 = CreateItemOnObject("pnp_shft_tstpkup", oShifter);

    if(!(GetItemPossessor(o1) == oShifter &&
         GetItemPossessor(o2) == oShifter &&
         GetItemPossessor(o3) == oShifter
       ))
    {
        bReturn = FALSE;
        SendMessageToPCByStrRef(oShifter, STRREF_NEED_SPACE); // "Your inventory is too full for the PRC Shifting system to work. Please make space for three (3) helmet-size items (4x4) in your inventory before trying again."
    }

    DestroyObject(o1);
    DestroyObject(o2);
    DestroyObject(o3);

    // Polymorph effect and shifting are mutually exclusive. Letting them stack is inviting massive fuckups
    effect eTest = GetFirstEffect(oShifter);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) = EFFECT_TYPE_POLYMORPH)
        {
            bReturn = FALSE;
            SendMessageToPCByStrRef(oShifter, STRREF_POLYMORPH_MUTEX); // "The PRC Shifting system will not work while you are affected by a polymorph effect. Please remove it before trying again."
        }

        eTest = GetNextEffect(oShifter);
    }

    return bReturn;
}

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int StoreCurrentAppearanceAsTrueAppearance(object oShifter, int bCarefull = TRUE)
{
    // If requested, check that the creature isn't shifted or polymorphed
    if(bCarefull)
    {
        if(GetPersistantLocalInt(oShifter, SHIFTER_ISSHIFTED_MARKER))
            return FALSE;

        effect eTest = GetFirstEffect(oShifter);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
                return FALSE;

            eTest = GetNextEffect(oShifter);
        }
    }

    // Get the form data
    struct modelvalues mvalTrueAppearance = GetAppearanceData(oShifter);

    // Store it
    SetPersitantLocalInt(SHIFTER_TRUEFORM_PREFIX + "Appearance", mvalTrueAppearance.nAppearanceType);
    /// @todo Fill in the rest of the data once intergrating 1.67

    return TRUE;
}

void RestoreTrueAppearance(object oShifter)
{/// @todo
}

// Storage functions  //

void StoreForm(object oShifter, int nShifterType, object oTarget)
{
    // Some paranoia - both the target and the object to store on must be valid. And PCs are never legal for storage - PC resref should be always empty
    if(!(GetIsObjectValid(oShifter) && GetIsObjectValid(oTarget) && GetResRef(oTarget) != ""))
        return;

    string sFormsArray = SHIFTER_FORMS_ARRAY + IntToString(nShifterType);
    string sNamesArray = SHIFTER_NAMES_ARRAY + IntToString(nShifterType);

    // Determine array existence
    if(!persistant_array_exists(oShifter, sFormsArray))
        persistant_array_create(oShifter, sFormsArray);
    if(!persistant_array_exists(oShifter, sNamesArray))
        persistant_array_create(oShifter, sNamesArray);

    // Get the storeable data
    string sResRef = GetResRef(oTarget);
    string sName   = GetName(oTarget);
    int nArraySize = persistant_array_size(oShifter, sFormsArray);

    // Check for the form already being present
    if(_GetIsFormStored(oShifter, nShifterType, sResRef))
        return;

    persistant_array_set_string(oShifter, sFormsArray, nArraySize, sResRef);
    persistant_array_set_string(oShifter, sNamesArray, nArraySize, sName);
}

int GetNumberOfStoredForms(object oShifter, int nShifterType)
{
    if(!persistant_array_exists(oShifter, SHIFTER_FORMS_ARRAY + IntToString(nShifterType)))
        return 0;

    return persistant_array_size(oShifter, SHIFTER_FORMS_ARRAY + IntToString(nShifterType));
}

string GetStoredForm(object oShifter, int nShifterType, int nIndex)
{
    return persistant_array_get_string(oShifter, SHIFTER_FORMS_ARRAY + IntToString(nShifterType), nIndex);
}

string GetStoredFormName(object oShifter, int nShifterType, int nIndex)
{
    return persistant_array_get_string(oShifter, SHIFTER_NAMES_ARRAY + IntToString(nShifterType), nIndex);
}

void DeleteStoredForm(object oShifter, int nShifterType, int nIndex)
{
    string sFormsArray = SHIFTER_FORMS_ARRAY + IntToString(nShifterType);
    string sNamesArray = SHIFTER_NAMES_ARRAY + IntToString(nShifterType);

    // Determine array existence
    if(!persistant_array_exists(oShifter, sFormsArray))
        return;
    if(!persistant_array_exists(oShifter, sNamesArray))
        return;

    // Move array entries
    int i, nArraySize = persistant_array_size(oShifter, sFormsArray);
    for(i = nIndex; i < nArraySize - 1; i++)
    {
        persistant_array_set_string(oShifter, sFormsArray, i,
                                    persistant_array_get_string(oShifter, sFormsArray, i + 1)
                                    );
        persistant_array_set_string(oShifter, sNamesArray, i,
                                    persistant_array_get_string(oShifter, sNamesArray, i + 1)
                                    );
    }

    // Shrink the arrays
    persistant_array_shrink(oShifter, sFormsArray, nArraySize - 1);
    persistant_array_shrink(oShifter, sNamesArray, nArraySize - 1);
}


// Shifting-related functions

int GetCanShiftIntoCreature(object oShifter, int nShifterType, object oTemplate)
{
    // Base assumption: Can shift into the target
    int bReturn = TRUE;

    // Some basic checks
    if(GetIsObjectValid(oShifter) && GetIsObjectValid(oTarget))
    {
        // PC check
        if(GetIsPC(oTemplate))
        {
            bReturn = FALSE;
            SendMessageToPCByStrRef(oShifter, STRREF_NOPOLYTOPC); // "You cannot polymorph into a PC."
        }
        // Shifting prevention feat
        else if(GetHasFeat(SHIFTER_BLACK_LIST, oTemplate))
        {
            bReturn = FALSE;
            SendMessageToPCByStrRef(oShifter, STRREF_FORBIDPOLY); // "Target cannot be polymorphed into."
        }

        // Test switch-based limitations
        if(bReturn)
        {
            int nSize       = PRCGetCreatureSize(oTemplate);
            int nRacialType = MyPRCGetRacialType(oTemplate);

            // Size switches
            if(nSize >= CREATURE_SIZE_HUGE   && GetPRCSwitch(PNP_SHFT_S_HUGE))
                bReturn = FALSE;
            if(nSize == CREATURE_SIZE_LARGE  && GetPRCSwitch(PNP_SHFT_S_LARGE))
                bReturn = FALSE;
            if(nSize == CREATURE_SIZE_MEDIUM && GetPRCSwitch(PNP_SHFT_S_MEDIUM))
                bReturn = FALSE;
            if(nSize == CREATURE_SIZE_SMALL  && GetPRCSwitch(PNP_SHFT_S_SMALL))
                bReturn = FALSE;
            if(nSize <= CREATURE_SIZE_TINY   && GetPRCSwitch(PNP_SHFT_S_TINY))
                bReturn = FALSE;

            // Type switches
            if(nRacialType == RACIAL_TYPE_OUTSIDER           && GetPRCSwitch(PNP_SHFT_F_OUTSIDER))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_ELEMENTAL          && GetPRCSwitch(PNP_SHFT_F_ELEMENTAL))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_CONSTRUCT          && GetPRCSwitch(PNP_SHFT_F_CONSTRUCT))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_UNDEAD             && GetPRCSwitch(PNP_SHFT_F_UNDEAD))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_DRAGON             && GetPRCSwitch(PNP_SHFT_F_DRAGON))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_ABERRATION         && GetPRCSwitch(PNP_SHFT_F_ABERRRATION))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_OOZE               && GetPRCSwitch(PNP_SHFT_F_OOZE))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_MAGICAL_BEAST      && GetPRCSwitch(PNP_SHFT_F_MAGICAL_BEAST))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_GIANT              && GetPRCSwitch(PNP_SHFT_F_GIANT))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_VERMIN             && GetPRCSwitch(PNP_SHFT_F_VERMIN))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_BEAST              && GetPRCSwitch(PNP_SHFT_F_BEAST))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_ANIMAL             && GetPRCSwitch(PNP_SHFT_F_ANIMAL))
                bReturn = FALSE;
            if(nRacialType == RACIAL_TYPE_HUMANOID_MONSTROUS && GetPRCSwitch(PNP_SHFT_F_HUMANOID_MONSTROUS))
                bReturn = FALSE;
            if(GetPRCSwitch(PNP_SHFT_F_HUMANOID)            &&
               (nRacialType == RACIAL_TYPE_DWARF              ||
                nRacialType == RACIAL_TYPE_ELF                ||
                nRacialType == RACIAL_TYPE_GNOME              ||
                nRacialType == RACIAL_TYPE_HUMAN              ||
                nRacialType == RACIAL_TYPE_HALFORC            ||
                nRacialType == RACIAL_TYPE_HALFELF            ||
                nRacialType == RACIAL_TYPE_HALFLING           ||
                nRacialType == RACIAL_TYPE_HUMANOID_ORC       ||
                nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN
               ))
                bReturn = FALSE;

            if(!bReturn)
                SendMessageToPCByStrRef(oShifter, STRREF_SETTINGFORBID); // "The module settings prevent this creature from being polymorphed into."
        }

        // Still OK, test HD or CR
        if(bReturn)
        {
            // Check target's HD or CR
            int nShifterHD  = GetHitDice(oShifter);
            int nTemplateHD = GetPRCSwitch(PNP_SHFT_USECR) ?
                               FloatToInt(GetChallengeRating(oTemplate)) :
                               GetHitDice(oTemplate);
            if(nTemplateHD > nShifterHD)
            {
                bReturn = FALSE;
                // "You need X more character levels before you can take on that form."
                SendMessageToPC(oShifter, GetStringByStrRef(STRREF_YOUNEED) + " " + IntToString(nTemplateHD - nShifterHD) + " " + GetStringByStrRef(STRREF_MORECHARLVL));
            }
        }// end if - Checking HD or CR

        // Move onto shifting type-specific checks if there haven't been any problems yet
        if(bReturn)
        {
            if(nShifterType == SHIFTER_TYPE_SHIFTER)
            {
                int nShifterLevel  = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER, oShifter);
                int nLevelRequired = 0;

                int nSize       = PRCGetCreatureSize(oTemplate);
                int nRacialType = MyPRCGetRacialType(oTemplate);

                // Fey and shapechangers are forbidden targets for PnP Shifter
                if(nTRacialType == RACIAL_TYPE_FEY || nTRacialType == RACIAL_TYPE_SHAPECHANGER)
                {
                    bReturn = FALSE;
                    SendMessageToPCByStrRef(oShifter, STRREF_PNPSFHT_FEYORSSHIFT); // "You cannot use PnP Shifter abilities to polymorph into this creature."
                }
                else
                {
                    // Size tests
                    if(nSize >= CREATURE_SIZE_HUGE)
                        nLevelRequired = max(nLevelRequired, 7);
                    if(nSize == CREATURE_SIZE_LARGE)
                        nLevelRequired = max(nLevelRequired, 3);
                    if(nSize == CREATURE_SIZE_MEDIUM)
                        nLevelRequired = max(nLevelRequired, 1);
                    if(nSize == CREATURE_SIZE_SMALL)
                        nLevelRequired = max(nLevelRequired, 1);
                    if(nSize <= CREATURE_SIZE_TINY)
                        nLevelRequired = max(nLevelRequired, 3);

                    // Type tests
                    if(nRacialType == RACIAL_TYPE_OUTSIDER)
                        nLevelRequired = max(nLevelRequired, 9);
                    if(nRacialType == RACIAL_TYPE_ELEMENTAL)
                        nLevelRequired = max(nLevelRequired, 9);
                    if(nRacialType == RACIAL_TYPE_CONSTRUCT)
                        nLevelRequired = max(nLevelRequired, 8);
                    if(nRacialType == RACIAL_TYPE_UNDEAD)
                        nLevelRequired = max(nLevelRequired, 8);
                    if(nRacialType == RACIAL_TYPE_DRAGON)
                        nLevelRequired = max(nLevelRequired, 7);
                    if(nRacialType == RACIAL_TYPE_ABERRATION)
                        nLevelRequired = max(nLevelRequired, 6);
                    if(nRacialType == RACIAL_TYPE_OOZE)
                        nLevelRequired = max(nLevelRequired, 6);
                    if(nRacialType == RACIAL_TYPE_MAGICAL_BEAST)
                        nLevelRequired = max(nLevelRequired, 5);
                    if(nRacialType == RACIAL_TYPE_GIANT)
                        nLevelRequired = max(nLevelRequired, 4);
                    if(nRacialType == RACIAL_TYPE_VERMIN)
                        nLevelRequired = max(nLevelRequired, 4);
                    if(nRacialType == RACIAL_TYPE_BEAST)
                        nLevelRequired = max(nLevelRequired, 3);
                    if(nRacialType == RACIAL_TYPE_ANIMAL)
                        nLevelRequired = max(nLevelRequired, 2);
                    if(nRacialType == RACIAL_TYPE_HUMANOID_MONSTROUS)
                        nLevelRequired = max(nLevelRequired, 2);
                    if(nRacialType == RACIAL_TYPE_DWARF              ||
                       nRacialType == RACIAL_TYPE_ELF                ||
                       nRacialType == RACIAL_TYPE_GNOME              ||
                       nRacialType == RACIAL_TYPE_HUMAN              ||
                       nRacialType == RACIAL_TYPE_HALFORC            ||
                       nRacialType == RACIAL_TYPE_HALFELF            ||
                       nRacialType == RACIAL_TYPE_HALFLING           ||
                       nRacialType == RACIAL_TYPE_HUMANOID_ORC       ||
                       nRacialType == RACIAL_TYPE_HUMANOID_REPTILIAN
                       )
                        nLevelRequired = max(nLevelRequired, 1);

                    // Test level required
                    if(nLevelRequired > nShifterLevel)
                    {
                        bReturn = FALSE;
                        // "You need X more PnP Shifter levels before you can take on that form."
                        SendMessageToPC(oShifter, GetStringByStrRef(STRREF_YOUNEED) + " " + IntToString(nLevelRequired - nShifterLevel) + " " + GetStringByStrRef(STRREF_PNPSHFT_MORELEVEL));
                    }
                }// end else - Not outright forbidden due to target being Fey or Shapeshifter
            }// end if - PnP Shifter checks
        }// end if - Check shifting list specific stuff
    }
    // Failed one of the basic checks
    else
        bReturn = FALSE;

    return bReturn;
}

void ShiftIntoCreature(object oShifter, int nShifterType, object oTemplate, int bGainSpellLikeAbilities = FALSE)
{
    // Make sure there is nothing that would prevent the successfull execution of the shift from happening
    if(!_GetCanShift(oShifter))
        return;

    // Mutex
    SetLocalInt(oShifter, SHIFTER_SHIFT_MUTEX, TRUE);

    // Unshift if already shifted
    if(GetPersistantLocalInt(oShifter, SHIFTER_ISSHIFTED_MARKER))
        UnShift(oShifter);

    /* Start the actual shifting */
    // Get the shifter's creature items
    object oShifterHide = GetPCSkin(oShifter); // Use the PRC wrapper for this to make sure we get the right object
    object oShifterCWpR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oShifter);
    object oShifterCWpL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oShifter);
    object oShifterCWpR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oShifter);

    // Get the template's creature items
    object oTemplateHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,   oTemplate);
    object oTemplateCWpR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTemplate);
    object oTemplateCWpL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTemplate);
    object oTemplateCWpR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTemplate);

    // Handle hide
    _ShifterCopyItemProps(oTemplateHide, oShifterHide);
}

void ShiftIntoResRef(object oShifter, int nShifterType, string sResRef, int bGainSpellLikeAbilities = FALSE)
{
    // Spawn an instance of the template creature in Limbo
    location lSpawn  = GetLocation(GetWaypointByTag("PRC_SHIFTING_TEMPLATE_SPAWN"));
    object oTemplate = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn);

    // Call the primary shifting function
    ShiftIntoCreature(oShifter, nShifterType, oTemplate, bGainSpellLikeAbilities);

    // Destroy the template creature
    MyDestroyObject(oTemplate);
}

struct modelvalues GetAppearanceData(object oTemplate)
{
	struct modelvalues mdlval;
	// The appearance type
    mdlval.nAppearanceType = GetAppearanceType(oTemplate);
    // Body parts
    mdlval.nBodyPart_RightFoot     = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,     oTemplate);
    mdlval.nBodyPart_LeftFoot      = GetCreatureBodyPart(CREATURE_PART_LEFT_FOOT,      oTemplate);
    mdlval.nBodyPart_RightShin     = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,     oTemplate);
    mdlval.nBodyPart_LeftShin      = GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,      oTemplate);
    mdlval.nBodyPart_RightThigh    = GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,    oTemplate);
    mdlval.nBodyPart_LeftThight    = GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,     oTemplate);
    mdlval.nBodyPart_Pelvis        = GetCreatureBodyPart(CREATURE_PART_PELVIS,         oTemplate);
    mdlval.nBodyPart_Torso         = GetCreatureBodyPart(CREATURE_PART_TORSO,          oTemplate);
    mdlval.nBodyPart_Belt          = GetCreatureBodyPart(CREATURE_PART_BELT,           oTemplate);
    mdlval.nBodyPart_Neck          = GetCreatureBodyPart(CREATURE_PART_NECK,           oTemplate);
    mdlval.nBodyPart_RightForearm  = GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM,  oTemplate);
    mdlval.nBodyPart_LeftForearm   = GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,   oTemplate);
    mdlval.nBodyPart_RightBicep    = GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,    oTemplate);
    mdlval.nBodyPart_LeftBicep     = GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,     oTemplate);
    mdlval.nBodyPart_RightShoulder = GetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, oTemplate);
    mdlval.nBodyPart_LeftShoulder  = GetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER,  oTemplate);
    mdlval.nBodyPart_RightHand     = GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND,     oTemplate);
    mdlval.nBodyPart_LeftHand      = GetCreatureBodyPart(CREATURE_PART_LEFT_HAND,      oTemplate);
    mdlval.nBodyPart_Head          = GetCreatureBodyPart(CREATURE_PART_HEAD,           oTemplate);
    // Wings
    mdlval.nWingType = GetCreatureWingType(oTemplate);
    // Tail
    mdlval.nTailType = GetCreatureTailType(oTemplate);
    // Portrait ID
    mdlval.nPortraitID     = GetPortraitId(oTemplate);
    // Portrait resref
    mdlval.sPortraitResRef = GetPortraitResRef(oTemplate);
    // Footstep type
    mdlval.nFootStepType = GetFootstepType(oTemplate);


    return mdlval;
}

void SetAppearanceData(object oTarget, struct modelvalues mdlval)
{
	// The appearance type
	SetCreatureAppearanceType(oTarget, mdlval.nnAppearanceType);
	// Body parts
	SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT     , mdlval.nBodyPart_RightFoot     , oTarget);
	SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT      , mdlval.nBodyPart_LeftFoot      , oTarget);
	SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN     , mdlval.nBodyPart_RightShin     , oTarget);
	SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN      , mdlval.nBodyPart_LeftShin      , oTarget);
	SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH    , mdlval.nBodyPart_RightThigh    , oTarget);
	SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH     , mdlval.nBodyPart_LeftThight    , oTarget);
	SetCreatureBodyPart(CREATURE_PART_PELVIS         , mdlval.nBodyPart_Pelvis        , oTarget);
	SetCreatureBodyPart(CREATURE_PART_TORSO          , mdlval.nBodyPart_Torso         , oTarget);
	SetCreatureBodyPart(CREATURE_PART_BELT           , mdlval.nBodyPart_Belt          , oTarget);
	SetCreatureBodyPart(CREATURE_PART_NECK           , mdlval.nBodyPart_Neck          , oTarget);
	SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM  , mdlval.nBodyPart_RightForearm  , oTarget);
	SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM   , mdlval.nBodyPart_LeftForearm   , oTarget);
	SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP    , mdlval.nBodyPart_RightBicep    , oTarget);
	SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP     , mdlval.nBodyPart_LeftBicep     , oTarget);
	SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER , mdlval.nBodyPart_RightShoulder , oTarget);
	SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER  , mdlval.nBodyPart_LeftShoulder  , oTarget);
	SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND     , mdlval.nBodyPart_RightHand     , oTarget);
	SetCreatureBodyPart(CREATURE_PART_LEFT_HAND      , mdlval.nBodyPart_LeftHand      , oTarget);
	SetCreatureBodyPart(CREATURE_PART_HEAD           , mdlval.nBodyPart_Head          , oTarget);
	// Wings
	SetCreatureWingType(mdlval.nWingType, oTarget);
	// Tail
    SetCreatureTailType(mdlval.nTailType, oTarget);
    // Portrait ID
    mdlval.nPortraitID
    // Portrait resref
    mdlval.sPortraitResRef
    // Footstep type
    SetFootstepType(mdlval.nFootStepType, oTarget);


    /// @todo Test whether portrait change commands take place instantenously
}


// Test main
//void main(){}
