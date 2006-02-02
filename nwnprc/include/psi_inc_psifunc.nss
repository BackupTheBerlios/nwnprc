//::///////////////////////////////////////////////
//:: Psionics include: Misceallenous
//:: psi_inc_psifunc
//::///////////////////////////////////////////////
/** @file
    Defines various functions and other stuff that
    do something related to the psionics implementation.

    Also acts as inclusion nexus for the general
    psionics includes. In other words, don't include
    them directly in your scripts, instead include this.

    @author Stratovarius
    @date   Created - 2004.10.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const string PRC_WILD_SURGE  = "PRC_WildSurge_Level";
const string PRC_OVERCHANNEL = "PRC_Overchannel_Level";


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Determines from what class's power list the currently being manifested
 * power is manifested from.
 *
 * @param oManifester A creature manifesting a power at this moment
 * @return            CLASS_TYPE_* constant of the class
 */
int GetManifestingClass(object oManifester = OBJECT_SELF);

/**
 * Determines the given creature's manifester level. If a class is specified,
 * then returns the manifester level for that class. Otherwise, returns
 * the manifester level for the currently active manifestation.
 *
 * @param oManifester    The creature whose manifester level to determine
 * @param nSpecificClass The class to determine the creature's manifester
 *                       level in.
 *                       DEFAULT: CLASS_TYPE_INVALID, which means the creature's
 *                       manifester level in regards to an ongoing manifestation
 *                       is determined instead.
 * @return               The manifester level
 */
int GetManifesterLevel(object oManifester, int nSpecificClass = CLASS_TYPE_INVALID);

/**
 * Determines the given creature's highest undmodified manifester level among it's
 * manifesting classes.
 *
 * @param oCreature Creature whose highest manifester level to determine
 * @return          The highest unmodified manifester level the creature can have
 */
int GetHighestManifesterLevel(object oCreature);

/**
 * Gets the level of the power being currently manifested.
 * WARNING: Return value is not defined when a power is not being manifested.
 *
 * @param oManifester The creature currently manifesting a power
 * @return            The level of the power being manifested
 */
int GetPowerLevel(object oManifester);

/**
 * Determines a creature's ability score in the manifesting ability of a given
 * class.
 *
 * @param oManifester Creature whose ability score to get
 * @param nClass      CLASS_TYPE_* constant of a manifesting class
 */
int GetAbilityScoreOfClass(object oManifester, int nClass);

/**
 * Determines the manifesting ability of a class.
 *
 * @param nClass CLASS_TYPE_* constant of the class to determine the manifesting stat of
 * @return       ABILITY_* of the manifesting stat. ABILITY_CHARISMA for non-manifester
 *               classes.
 */
int GetAbilityOfClass(int nClass);

/**
 * Calculates the DC of the power being currently manifested.
 * Base value is 10 + power level + ability modifier in manifesting stat
 *
 * WARNING: Return value is not defined when a power is not being manifested.
 *
 */
int GetManifesterDC(object oManifester = OBJECT_SELF);

/**
 * Determines the spell school matching a discipline according to the
 * standard transparency rules.
 * Disciplines which have no matching spell school are matched with
 * SPELL_SCHOOL_GENERAL.
 *
 * @param nDiscipline Discipline to find matching spell school for
 * @return            SPELL_SCHOOL_* of the match
 */
int DisciplineToSpellSchool(int nDiscipline);

/**
 * Determines the discipline matching a spell school according to the
 * standard transparency rules.
 * Spell schools that have no matching disciplines are matched with
 * DISCIPLINE_NONE.
 *
 * @param nSpellSchool Spell schools to find matching discipline for
 * @return             DISCIPLINE_* of the match
 */
int SpellSchoolToDiscipline(int nSpellSchool);

/**
 * Determines the discipline of a power, using the School column of spells.2da.
 *
 * @param nSpellID The spellID of the power to determine the discipline of
 * @return         DISCIPLINE_* constant. DISCIPLINE_NONE if the power's
 *                 School designation does not match any of the discipline's.
 */
int GetPowerDiscipline(int nSpellID);

/**
 * Determines whether a given power is a power of the Telepahty discipline.
 *
 * @param nSpellID The spells.2da row of the power. If left to default,
 *                 PRCGetSpellId() is used.
 * @return         TRUE if the power's discipline is Telepathy, FALSE otherwise
 */
int GetIsTelepathyPower(int nSpellID = -1);

/**
 * Checks whether the PC possesses the feats the given feat has as it's
 * prerequisites. Possession of a feat is checked using GetHasFeat().
 *
 *
 * @param nFeat The feat for which determine the possession of prerequisites
 * @param oPC   The creature whose feats to check
 * @return      TRUE if the PC possesses the prerequisite feats AND does not
 *              already posses nFeat, FALSE otherwise.
 */
int CheckPowerPrereqs(int nFeat, object oPC);

/**
 * Determines the manifester's level in regards to manifester checks to overcome
 * spell resistance.
 *
 * WARNING: Return value is not defined when a power is not being manifested.
 *
 * @param oManifester A creature manifesting a power at the moment
 * @return            The creature's manifester level, adjusted to account for
 *                    modifiers that affect spell resistance checks.
 */
int GetPsiPenetration(object oManifester = OBJECT_SELF);

/**
 * Determines whether a given creature possesses the Psionic subtype.
 * Ways of possessing the subtype:
 * - Being of a naturally psionic race
 * - Having class levels in a psionic class
 * - Possessing the Wild Talent feat
 *
 * @param oCreature Creature to test
 * @return          TRUE if the creature is psionic, FALSE otherwise.
 */
int GetIsPsionicCharacter(object oCreature);

/**
 * Calculates how many manifester levels are gained by a given creature from
 * it's levels in prestige classes.
 *
 * @param oCreature Creature to calculate added manifester levels for
 * @return          The number of manifester levels gained
 */
int GetPsionicPRCLevels(object oCreature);

/**
 * Determines whether a given class is a psionic class or not. A psionic
 * class is defined as one that gives base manifesting.
 *
 * @param nClass CLASS_TYPE_* of the class to test
 * @return       TRUE if the class is a psionic class, FALSE otherwise
 */
int GetIsPsionicClass(int nClass);

/**
 * Determines which of the character's classes is their first psionic manifesting
 * class, if any. This is the one which gains manifester level raise benefits from
 * prestige classes.
 *
 * @param oCreature Creature whose classes to test
 * @return          CLASS_TYPE_* of the first psionic manifesting class,
 *                  CLASS_TYPE_INVALID if the creature does not posses any.
 */
int GetFirstPsionicClass(object oCreature = OBJECT_SELF);

/**
 * Determines the position of a creature's first psionic manifesting class, if any.
 *
 * @param oCreature Creature whose classes to test
 * @return          The position of the first psionic class {1, 2, 3} or 0 if
 *                  the creature possesses no levels in psionic classes.
 */
int GetFirstPsionicClassPosition(object oCreature = OBJECT_SELF);

/**
 * Creates the creature weapon for powers like Bite of the Wolf and Claws of the
 * Beast. If a creature weapon of the correct type is already present, it is
 * used instead of a new one.
 *
 * Preserving existing weapons may cause problems, if so, make the function instead delete the old object - Ornedan
 *
 * @param oCreature     Creatue whose creature weapons to mess with.
 * @param sResRef       Resref of the creature weapon. Assumed to be one of the
 *                      PRC creature weapons, so this considered to is also be
 *                      the tag.
 * @param nIventorySlot Inventory slot where the creature weapon is to be equipped.
 * @param fDuration     If a new weapon is created, it will be destroyed after
 *                      this duration.
 *
 * @return              The newly created creature weapon. Or an existing weapon,
 *                      if there was one.
 */
object CreatePsionicCreatureWeapon(object oCreature, string sResRef, int nInventorySlot, float fDuration);

/**
 * Gets the amount of manifester levels the given creature is Wild Surging by.
 *
 * @param oManifester The creature to test
 * @return            The number of manifester levels added by Wild Surge. 0 if
 *                    Wild Surge is not active.
 */
int GetWildSurge(object oManifester);

/**
 * Applies modifications to a power's damage that depend on some property
 * of the target.
 * Currently accounts for:
 *  - Mental Resistance
 *  - Greater Power Specialization
 *  - Intellect Fortress
 *
 * @param oTarget     A creature being dealt damage by a power
 * @param oManifester The creature manifesting the damaging power
 * @param nDamage     The amount of damage the creature would be dealt
 *
 * @param bIsHitPointDamage Is the damage HP damage or something else?
 * @param bIsEnergyDamage   Is the damage caused by energy or something else? Only relevant if the damage is HP damage.
 *
 * @return The amount of damage, modified by oTarget's abilities
 */
int GetTargetSpecificChangesToDamage(object oTarget, object oManifester, int nDamage,
                                     int bIsHitPointDamage = TRUE, int bIsEnergyDamage = FALSE);


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "prc_power_const"
#include "prc_alterations"
#include "psi_inc_manifest" // Provides psi_inc_augment, psi_inc_focus, psi_inc_metapsi and psi_inc_ppoints
#include "psi_inc_powknown"


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetManifestingClass(object oManifester = OBJECT_SELF)
{
    return GetLocalInt(oManifester, PRC_MANIFESTING_CLASS) - 1;
}

int GetManifesterLevel(object oManifester, int nSpecificClass = CLASS_TYPE_INVALID)
{
    int nLevel;
    int nAdjust = GetLocalInt(oManifester, PRC_CASTERLEVEL_ADJUSTMENT);

    // The function user needs to know the character's manifester level in a specific class
    // instead of whatever the character last manifested a power as
    if(nSpecificClass != CLASS_TYPE_INVALID)
    {
        if(GetIsPsionicClass(nSpecificClass))
        {
            nLevel = GetLevelByClass(nSpecificClass, oManifester);
            // Add levels from +ML PrCs only for the first manifesting class
            if(nSpecificClass == GetFirstPsionicClass(oManifester))
                nLevel += GetPsionicPRCLevels(oManifester);

            return nLevel + nAdjust;
        }
        // A character's manifester level gained from non-manifesting classes is always a nice, round zero
        else
            return 0;
    }

    // Item Spells
    if(GetItemPossessor(GetSpellCastItem()) == oManifester)
    {
        if(DEBUG) SendMessageToPC(oManifester, "Item casting at level " + IntToString(GetCasterLevel(oManifester)));

        return GetCasterLevel(oManifester) + nAdjust;
    }

    // For when you want to assign the caster level.
    else if(GetLocalInt(oManifester, PRC_CASTERLEVEL_OVERRIDE) != 0)
    {
        if(DEBUG) SendMessageToPC(oManifester, "Forced-level manifesting at level " + IntToString(GetCasterLevel(oManifester)));

        DelayCommand(1.0, DeleteLocalInt(oManifester, PRC_CASTERLEVEL_OVERRIDE));
        nLevel = GetLocalInt(oManifester, PRC_CASTERLEVEL_OVERRIDE);
    }
    else if(GetManifestingClass(oManifester) != CLASS_TYPE_INVALID)
    {
        //Gets the level of the manifesting class
        if(DEBUG) SendMessageToPC(oManifester, "Manifesting class: " + IntToString(GetManifestingClass(oManifester)));
        int nManifestingClass = GetManifestingClass(oManifester);
        nLevel = GetLevelByClass(nManifestingClass, oManifester);
        // Add levels from +ML PrCs only for the first manifesting class
        nLevel += nManifestingClass == GetFirstPsionicClass(oManifester) ? GetPsionicPRCLevels(oManifester) : 0;
        if(DEBUG) SendMessageToPC(oManifester, "Level gotten via GetLevelByClass: " + IntToString(nLevel));
    }

    // If everything else fails, use the character's first class position
    if(nLevel == 0)
    {
        if(DEBUG)             DoDebug("Failed to get manifester level for creature " + DebugObject2Str(oManifester) + ", using first class slot");
        else WriteTimestampedLogEntry("Failed to get manifester level for creature " + DebugObject2Str(oManifester) + ", using first class slot");

        nLevel = GetLevelByPosition(1, oManifester);
    }


    // The bonuses inside only apply to normal manifestation
    if(!GetLocalInt(oManifester, PRC_IS_PSILIKE))
    {
        //Adding wild surge
        int nSurge = GetWildSurge(oManifester);
        if (nSurge > 0) nLevel += nSurge;

        // Adding overchannel
        int nOverchannel = GetLocalInt(oManifester, PRC_OVERCHANNEL);
        if(nOverchannel > 0) nLevel += nOverchannel;
    }

    nLevel += nAdjust;

    // This spam is technically no longer necessary once the manifester level getting mechanism has been confirmed to work
    if(DEBUG) FloatingTextStringOnCreature("Manifester Level: " + IntToString(nLevel), oManifester, FALSE);

    return nLevel;
}

int GetHighestManifesterLevel(object oCreature)
{
    return max(max(PRCGetClassByPosition(1, oCreature) != CLASS_TYPE_INVALID ? GetManifesterLevel(oCreature, PRCGetClassByPosition(1, oCreature)) : 0,
                   PRCGetClassByPosition(2, oCreature) != CLASS_TYPE_INVALID ? GetManifesterLevel(oCreature, PRCGetClassByPosition(2, oCreature)) : 0
                   ),
               PRCGetClassByPosition(3, oCreature) != CLASS_TYPE_INVALID ? GetManifesterLevel(oCreature, PRCGetClassByPosition(3, oCreature)) : 0
               );
}
int GetPowerLevel(object oManifester)
{
    return GetLocalInt(oManifester, PRC_POWER_LEVEL);
}

int GetAbilityScoreOfClass(object oManifester, int nClass)
{
    return GetAbilityScore(oManifester, GetAbilityOfClass(nClass));
}

int GetAbilityOfClass(int nClass){
    switch(nClass)
    {
        case CLASS_TYPE_PSION:
            return ABILITY_INTELLIGENCE;
        case CLASS_TYPE_WILDER:
            return ABILITY_CHARISMA;
        case CLASS_TYPE_PSYWAR:
            return ABILITY_WISDOM;
        case CLASS_TYPE_FIST_OF_ZUOKEN:
            return ABILITY_WISDOM;
        default:
            return ABILITY_CHARISMA;
    }

    // Technically, never gets here but the compiler does not realise that
    return -1;
}

int GetManifesterDC(object oManifester = OBJECT_SELF)
{
    int nClass = GetManifestingClass(oManifester);
    int nDC = 10;
    nDC += GetPowerLevel(oManifester);
    nDC += GetAbilityModifier(GetAbilityOfClass(nClass), oManifester);//(GetAbilityScoreOfClass(oManifester, nClass) - 10)/2;

    // Stuff that applies only to powers, not psi-like abilities goes inside
    if(GetLocalInt(oManifester, PRC_IS_PSILIKE))
    {
        if (GetLocalInt(oManifester, "PsionicEndowmentActive") == TRUE && UsePsionicFocus(oManifester))
        {
            nDC += GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT, oManifester) ? 4 : 2;
        }
    }

    return nDC;
}

int DisciplineToSpellSchool(int nDiscipline)
{
    int nSpellSchool = SPELL_SCHOOL_GENERAL;

    switch(nDiscipline)
    {
        case DISCIPLINE_CLAIRSENTIENCE:   nSpellSchool = SPELL_SCHOOL_DIVINATION;    break;
        case DISCIPLINE_METACREATIVITY:   nSpellSchool = SPELL_SCHOOL_CONJURATION;   break;
        case DISCIPLINE_PSYCHOKINESIS:    nSpellSchool = SPELL_SCHOOL_EVOCATION;     break;
        case DISCIPLINE_PSYCHOMETABOLISM: nSpellSchool = SPELL_SCHOOL_TRANSMUTATION; break;
        case DISCIPLINE_TELEPATHY:        nSpellSchool = SPELL_SCHOOL_ENCHANTMENT;   break;

        default: nSpellSchool = SPELL_SCHOOL_GENERAL; break;
    }

    return nSpellSchool;
}

int SpellSchoolToDiscipline(int nSpellSchool)
{
    int nDiscipline = DISCIPLINE_NONE;

    switch(nDiscipline)
    {
        case SPELL_SCHOOL_GENERAL:       nDiscipline = DISCIPLINE_NONE;             break;
        case SPELL_SCHOOL_ABJURATION:    nDiscipline = DISCIPLINE_NONE;             break;
        case SPELL_SCHOOL_CONJURATION:   nDiscipline = DISCIPLINE_METACREATIVITY;   break;
        case SPELL_SCHOOL_DIVINATION:    nDiscipline = DISCIPLINE_CLAIRSENTIENCE;   break;
        case SPELL_SCHOOL_ENCHANTMENT:   nDiscipline = DISCIPLINE_TELEPATHY;        break;
        case SPELL_SCHOOL_EVOCATION:     nDiscipline = DISCIPLINE_PSYCHOKINESIS;    break;
        case SPELL_SCHOOL_ILLUSION:      nDiscipline = DISCIPLINE_NONE;             break;
        case SPELL_SCHOOL_NECROMANCY:    nDiscipline = DISCIPLINE_NONE;             break;
        case SPELL_SCHOOL_TRANSMUTATION: nDiscipline = DISCIPLINE_PSYCHOMETABOLISM; break;

        default: nDiscipline = DISCIPLINE_NONE;
    }

    return nDiscipline;
}

int GetPowerDiscipline(int nSpellID)
{
    string sSpellSchool = lookup_spell_school(nSpellID);
    int nDiscipline;

    if      (sSpellSchool == "A") nDiscipline = DISCIPLINE_NONE;
    else if (sSpellSchool == "C") nDiscipline = DISCIPLINE_METACREATIVITY;
    else if (sSpellSchool == "D") nDiscipline = DISCIPLINE_CLAIRSENTIENCE;
    else if (sSpellSchool == "E") nDiscipline = DISCIPLINE_TELEPATHY;
    else if (sSpellSchool == "V") nDiscipline = DISCIPLINE_PSYCHOKINESIS;
    else if (sSpellSchool == "I") nDiscipline = DISCIPLINE_NONE;
    else if (sSpellSchool == "N") nDiscipline = DISCIPLINE_NONE;
    else if (sSpellSchool == "T") nDiscipline = DISCIPLINE_PSYCHOMETABOLISM;
    else if (sSpellSchool == "G") nDiscipline = DISCIPLINE_PSYCHOPORTATION;

    return nDiscipline;
}

int GetIsTelepathyPower(int nSpellID = -1)
{
    if(nSpellID == -1) nSpellID = PRCGetSpellId();

    return GetPowerDiscipline(nSpellID) == DISCIPLINE_TELEPATHY;
}

int CheckPowerPrereqs(int nFeat, object oPC)
{
    // Having the power already automatically disqualifies one from taking it again
    if(GetHasFeat(nFeat, oPC))
    return FALSE;
    // We assume that the 2da is correctly formatted, and as such, a prereq slot only contains
    // data if the previous slots in order also contains data.
    // ie, no PREREQFEAT2 if PREREQFEAT1 is empty
    if(Get2DACache("feat", "PREREQFEAT1", nFeat) != "")
    {
        if(!GetHasFeat(StringToInt(Get2DACache("feat", "PREREQFEAT1", nFeat)), oPC))
        return FALSE;
        if(Get2DACache("feat", "PREREQFEAT2", nFeat) != ""
        && !GetHasFeat(StringToInt(Get2DACache("feat", "PREREQFEAT2", nFeat)), oPC))
        return FALSE;
    }

    if(Get2DACache("feat", "OrReqFeat0", nFeat) != "")
    {
        if(!GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat0", nFeat)), oPC))
            return FALSE;
        if(Get2DACache("feat", "OrReqFeat1", nFeat) != "")
        {
            if(!GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat1", nFeat)), oPC))
                return FALSE;
            if(Get2DACache("feat", "OrReqFeat2", nFeat) != "")
            {
                if(!GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat2", nFeat)), oPC))
                    return FALSE;
                if(Get2DACache("feat", "OrReqFeat3", nFeat) != "")
                {
                    if(!GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat3", nFeat)), oPC))
                        return FALSE;
                    if(Get2DACache("feat", "OrReqFeat4", nFeat) != "")
                    {
                        if(!GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat4", nFeat)), oPC))
                            return FALSE;
    }   }   }   }   }

    //if youve reached this far then return TRUE
    return TRUE;
}

int GetPsiPenetration(object oManifester = OBJECT_SELF)
{
    int nPen = GetManifesterLevel(oManifester);

    // The stuff inside applies only to normal manifestation, not psi-like abilities
    if(!GetLocalInt(oManifester, PRC_IS_PSILIKE))
    {
        // Check for Power Pen feats being used
        if(GetLocalInt(oManifester, "PowerPenetrationActive") == TRUE && UsePsionicFocus(oManifester))
        {
            nPen += GetHasFeat(FEAT_GREATER_POWER_PENETRATION, oManifester) ? 8 : 4;
        }
    }

    return nPen;
}

int GetIsPsionicCharacter(object oCreature)
{
    return !!(GetLevelByClass(CLASS_TYPE_PSION,          oCreature) ||
              GetLevelByClass(CLASS_TYPE_PSYWAR,         oCreature) ||
              GetLevelByClass(CLASS_TYPE_WILDER,         oCreature) ||
              GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oCreature) ||
              GetHasFeat(FEAT_WILD_TALENT, oCreature)
              // Racial psionicity signifying feats go here
             );
}

int GetPsionicPRCLevels(object oCreature)
{
    int nLevel = 0;

    // Cerebremancer and Psychic Theurge add manifester levels on each level
    nLevel += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCreature);
    nLevel += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCreature);

    // No manifester level boost at level 1 and 10 for Thrallherd
    if(GetLevelByClass(CLASS_TYPE_THRALLHERD, oCreature))
    {
        nLevel += GetLevelByClass(CLASS_TYPE_THRALLHERD, oCreature) - 1;
        if(GetLevelByClass(CLASS_TYPE_THRALLHERD, oCreature) >= 10) nLevel -= 1;
    }

    return nLevel;
}

int GetIsPsionicClass(int nClass)
{
    return (nClass==CLASS_TYPE_PSION          ||
            nClass==CLASS_TYPE_PSYWAR         ||
            nClass==CLASS_TYPE_WILDER         ||
            nClass==CLASS_TYPE_FIST_OF_ZUOKEN
            );
}

int GetFirstPsionicClass(object oCreature = OBJECT_SELF)
{
    int iPsionicPos = GetFirstPsionicClassPosition(oCreature);
    if (!iPsionicPos) return CLASS_TYPE_INVALID; // no Psionic casting class

    return PRCGetClassByPosition(iPsionicPos, oCreature);
}

int GetFirstPsionicClassPosition(object oCreature = OBJECT_SELF)
{
    if (GetIsPsionicClass(PRCGetClassByPosition(1, oCreature)))
        return 1;
    if (GetIsPsionicClass(PRCGetClassByPosition(2, oCreature)))
        return 2;
    if (GetIsPsionicClass(PRCGetClassByPosition(3, oCreature)))
        return 3;

    return 0;
}
void LocalCleanExtraFists(object oCreature)
{
    int iIsCWeap, iIsEquip;

    object oClean = GetFirstItemInInventory(oCreature);

    while (GetIsObjectValid(oClean))
    {
        iIsCWeap = GetIsPRCCreatureWeapon(oClean);

        iIsEquip = oClean == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L) ||
                   oClean == GetItemInSlot(INVENTORY_SLOT_CWEAPON_R) ||
                   oClean == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B);

        if (iIsCWeap && !iIsEquip)
        {
            DestroyObject(oClean);
        }

        oClean = GetNextItemInInventory(oCreature);
    }
}
object GetPsionicCreatureWeapon(object oCreature, string sResRef, int nInventorySlot, float fDuration)
{
    int bCreatedWeapon = FALSE;
    object oCWeapon = GetItemInSlot(nInventorySlot, oCreature);

    RemoveUnarmedAttackEffects(oCreature);
    // Make sure they can actually equip them
    UnarmedFeats(oCreature);

    // Determine if a creature weapon of the proper type already exists in the slot
    if(!GetIsObjectValid(oCWeapon)                                       ||
       GetStringUpperCase(GetTag(oCWeapon)) != GetStringUpperCase(sResRef) // Hack: The resref's and tags of the PRC creature weapons are the same
       )
    {
        if (GetHasItem(oCreature, sResRef))
        {
            oCWeapon = GetItemPossessedBy(oCreature, sResRef);
            SetIdentified(oCWeapon, TRUE);
            //AssignCommand(oCreature, ActionEquipItem(oCWeapon, INVENTORY_SLOT_CWEAPON_L));
            ForceEquip(oCreature, oCWeapon, nInventorySlot);
        }
        else
        {
            oCWeapon = CreateItemOnObject(sResRef, oCreature);
            SetIdentified(oCWeapon, TRUE);
            //AssignCommand(oCreature, ActionEquipItem(oCWeapon, INVENTORY_SLOT_CWEAPON_L));
            ForceEquip(oCreature, oCWeapon, nInventorySlot);
            bCreatedWeapon = TRUE;
        }
    }


    // Clean up the mess of extra fists made on taking first level.
    DelayCommand(6.0f, LocalCleanExtraFists(oCreature));

    // Weapon finesse or intuitive attack?
    SetLocalInt(oCreature, "UsingCreature", TRUE);
    ExecuteScript("prc_intuiatk", oCreature);
    DelayCommand(1.0f, DeleteLocalInt(oCreature, "UsingCreature"));

    // Add OnHitCast: Unique if necessary
    if(GetHasFeat(FEAT_REND, oCreature))
        IPSafeAddItemProperty(oCWeapon, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);

    // This adds creature weapon finesse
    ApplyUnarmedAttackEffects(oCreature);

    // Destroy the weapon if it was created by this function
    if(bCreatedWeapon)
        DestroyObject(oCWeapon, (fDuration + 6.0));

    return oCWeapon;
}

int GetWildSurge(object oManifester)
{
    int nWildSurge = GetLocalInt(oManifester, PRC_IS_PSILIKE) ?
                      0 :                                       // Wild Surge does not apply to psi-like abilities
                      GetLocalInt(oManifester, PRC_WILD_SURGE);

    if(FALSE) DoDebug("GetWildSurge():\n"
                    + "oManifester = " + DebugObject2Str(oManifester) + "\n"
                    + "nWildSurge = " + IntToString(nWildSurge) + "\n"
                      );

    return nWildSurge;
}

int GetTargetSpecificChangesToDamage(object oTarget, object oManifester, int nDamage,
                                     int bIsHitPointDamage = TRUE, int bIsEnergyDamage = FALSE)
{
    // Greater Power Specialization - +2 damage on all HP-damaging powers when target is within 30ft
    if(bIsHitPointDamage                                                &&
       GetHasFeat(FEAT_GREATER_POWER_SPECIALIZATION, oManifester)       &&
       GetDistanceBetween(oTarget, oManifester) <= FeetToMeters(30.0f)
       )
            nDamage += 2;
    // Intellect Fortress - Halve damage dealt by powers that allow PR. Goes before DR (-like) reductions
    if(GetLocalInt(oTarget, "PRC_Power_IntellectFortress_Active")    &&
       Get2DACache("spells", "ItemImmunity", PRCGetSpellId()) == "1"
       )
        nDamage /= 2;
    // Mental Resistance - 3 damage less for all non-energy damage and ability damage
    if(GetHasFeat(FEAT_MENTAL_RESISTANCE, oTarget) && !bIsEnergyDamage)
        nDamage -= 3;

    // Reasonable return values only
    if(nDamage < 0) nDamage = 0;

    return nDamage;
}

// Test main
//void main(){}
