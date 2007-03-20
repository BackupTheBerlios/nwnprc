//::///////////////////////////////////////////////
//:: Tome of Battle include: Maneuvers Known
//:: tob_inc_moveknwn
//::///////////////////////////////////////////////
/** @file
    Defines functions for adding & removing
    Maneuvers known.

    Data stored:

    - For each Discipline list
    -- Total number of Maneuvers known
    -- A modifier value to maximum Maneuvers known on this list to account for feats and classes that add Maneuvers
    -- An array related to Maneuvers the knowledge of which is not dependent on character level
    --- Each array entry specifies the spells.2da row of the known Maneuvers's class-specific entry
    -- For each character level on which Maneuvers have been gained from this list
    --- An array of Maneuvers gained on this level
    ---- Each array entry specifies the spells.2da row of the known Maneuvers's class-specific entry

    @author Stratovarius
    @date   Created - 2007.03.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

// Included here to provide the values for the constants below
#include "prc_class_const"

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const int MANEUVER_LIST_CRUSADER          = CLASS_TYPE_CRUSADER;
const int MANEUVER_LIST_SWORDSAGE         = CLASS_TYPE_SWORDSAGE;
const int MANEUVER_LIST_WARBLADE          = CLASS_TYPE_WARBLADE;

/// Special Maneuver list. Maneuvers gained via Martial Study or other sources.
const int MANEUVER_LIST_MISC          = CLASS_TYPE_INVALID;//-1;

const string _MANEUVER_LIST_NAME_BASE     = "PRC_ManeuverList_";
const string _MANEUVER_LIST_TOTAL_KNOWN   = "_TotalKnown";
const string _MANEUVER_LIST_MODIFIER      = "_KnownModifier";
const string _MANEUVER_LIST_MISC_ARRAY    = "_ManeuversKnownMiscArray";
const string _MANEUVER_LIST_LEVEL_ARRAY   = "_ManeuversKnownLevelArray_";
const string _MANEUVER_LIST_GENERAL_ARRAY = "_ManeuversKnownGeneralArray";


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Gives the creature the control feats for the given Maneuver and marks the Maneuver
 * in a Maneuvers known array.
 * If the Maneuver's data is already stored in one of the Maneuvers known arrays for
 * the list or adding the Maneuver's data to the array fails, the function aborts.
 *
 * @param oCreature       The creature to gain the Maneuver
 * @param nList           The list the Maneuver comes from. One of MANEUVER_LIST_*
 * @param n2daRow         The 2da row in the lists's 2da file that specifies the Maneuver.
 * @param bLevelDependent If this is TRUE, the Maneuver is tied to a certain level and can
 *                        be lost via level loss. If FALSE, the Maneuver is not dependent
 *                        of a level and cannot be lost via level loss.
 * @param nLevelToTieTo   If bLevelDependent is TRUE, this specifies the level the Maneuver
 *                        is gained on. Otherwise, it's ignored.
 *                        The default value (-1) means that the current level of oCreature
 *                        will be used.
 * @param nDiscipline           Type of the Maneuver: Evolving Mind, Crafted Tool, or Perfected Map
 *
 * @return                TRUE if the Maneuver was successfully stored and control feats added.
 *                        FALSE otherwise.
 */
int AddManeuverKnown(object oCreature, int nList, int n2daRow, int nDiscipline, int bLevelDependent = FALSE, int nLevelToTieTo = -1);

/**
 * Removes all Maneuvers gained from each list on the given level.
 *
 * @param oCreature The creature whose Maneuvers to remove
 * @param nLevel    The level to clear
 */
void RemoveManeuversKnownOnLevel(object oCreature, int nLevel);

/**
 * Gets the value of the Maneuvers known modifier, which is a value that is added
 * to the 2da-specified maximum Maneuvers known to determine the actual maximum.
 *
 * @param oCreature The creature whose modifier to get
 * @param nList     The list the maximum Maneuvers known from which the modifier
 *                  modifies. One of MANEUVER_LIST_*
 * @param nDiscipline  Type of the Maneuver: Evolving Mind, Crafted Tool, or Perfected Map
 */
int GetKnownManeuversModifier(object oCreature, int nList, int nDiscipline);

/**
 * Sets the value of the Maneuvers known modifier, which is a value that is added
 * to the 2da-specified maximum Maneuvers known to determine the actual maximum.
 *
 * @param oCreature The creature whose modifier to set
 * @param nList     The list the maximum Maneuvers known from which the modifier
 *                  modifies. One of MANEUVER_LIST_*
 * @param nDiscipline  Type of the Maneuver: Evolving Mind, Crafted Tool, or Perfected Map
 */
void SetKnownManeuversModifier(object oCreature, int nList, int nNewValue, int nDiscipline);

/**
 * Gets the number of Maneuvers a character character possesses from a
 * specific list and lexicon
 *
 * @param oCreature The creature whose Maneuvers to check
 * @param nList     The list to check. One of MANEUVER_LIST_*
 * @return          The number of Maneuvers known oCreature has from nList
 */
int GetManeuverCount(object oCreature, int nList);

/**
 * Gets the maximum number of Maneuvers a character may posses from a given list
 * at this time. Calculated based on class levels, feats and a misceallenous
 * modifier. There are three Types of Maneuvers, so it checks each seperately.
 *
 * @param oCreature Character to determine maximum Maneuvers for
 * @param nList     MANEUVER_LIST_* of the list to determine maximum Maneuvers for
 * @return          Maximum number of Maneuvers that oCreature may know from the given list.
 */
int GetMaxManeuverCount(object oCreature, int nList);

/**
 * Determines whether a character has a given Maneuver, gained via some Maneuver list.
 *
 * @param nUtter    MANEUVER_* of the Maneuver to test
 * @param oCreature Character to test for the possession of the Maneuver
 * @return          TRUE if the character has the Maneuver, FALSE otherwise
 */
int GetHasManeuver(int nUtter, object oCreature = OBJECT_SELF);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "true_inc_trufunc"

//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

void _ManeuverRecurseRemoveArray(object oCreature, string sArrayName, string sUtterFile, int nArraySize, int nCurIndex)
{
    if(DEBUG) DoDebug("_ManeuverRecurseRemoveArray():\n"
                    + "oCreature = " + DebugObject2Str(oCreature) + "\n"
                    + "sArrayName = '" + sArrayName + "'\n"
                    + "sUtterFile = '" + sUtterFile + "'\n"
                    + "nArraySize = " + IntToString(nArraySize) + "\n"
                    + "nCurIndex = " + IntToString(nCurIndex) + "\n"
                      );

    // Determine whether we've already parsed the whole array or not
    if(nCurIndex >= nArraySize)
    {
        if(DEBUG) DoDebug("_ManeuverRecurseRemoveArray(): Running itemproperty removal loop.");
        // Loop over itemproperties on the skin and remove each match
        object oSkin = GetPCSkin(oCreature);
        itemproperty ipTest = GetFirstItemProperty(oSkin);
        while(GetIsItemPropertyValid(ipTest))
        {
            // Check if the itemproperty is a bonus feat that has been marked for removal
            if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_BONUS_FEAT                                            &&
               GetLocalInt(oCreature, "PRC_UtterFeatRemovalMarker_" + IntToString(GetItemPropertySubType(ipTest)))
               )
            {
                if(DEBUG) DoDebug("_ManeuverRecurseRemoveArray(): Removing bonus feat itemproperty:\n" + DebugIProp2Str(ipTest));
                // If so, remove it
                RemoveItemProperty(oSkin, ipTest);
            }

            ipTest = GetNextItemProperty(oSkin);
        }
    }
    // Still parsing the array
    else
    {
        // Set the marker
        string sName = "PRC_UtterFeatRemovalMarker_" + Get2DACache(sUtterFile, "IPFeatID",
                                                                   GetPowerfileIndexFromSpellID(persistant_array_get_int(oCreature, sArrayName, nCurIndex))
                                                                   );
        if(DEBUG) DoDebug("_ManeuverRecurseRemoveArray(): Recursing through array, marker set:\n" + sName);

        SetLocalInt(oCreature, sName, TRUE);
        // Recurse to next array index
        _ManeuverRecurseRemoveArray(oCreature, sArrayName, sUtterFile, nArraySize, nCurIndex + 1);
        // After returning, delete the local
        DeleteLocalInt(oCreature, sName);
    }
}

void _RemoveManeuverArray(object oCreature, int nList, int nLevel, int nDiscipline)
{
    if(DEBUG) DoDebug("_RemoveManeuverArray():\n"
                    + "oCreature = " + DebugObject2Str(oCreature) + "\n"
                    + "nList = " + IntToString(nList) + "\n"
                    + "nDiscipline = " + IntToString(nDiscipline) + "\n"
                      );

    string sBase  = _MANEUVER_LIST_NAME_BASE + IntToString(nList) + IntToString(nDiscipline);
    string sArray = sBase + _MANEUVER_LIST_LEVEL_ARRAY + IntToString(nLevel);
    int nSize = persistant_array_get_size(oCreature, sArray);

    // Reduce the total by the array size
    SetPersistantLocalInt(oCreature, sBase + _MANEUVER_LIST_TOTAL_KNOWN,
                          GetPersistantLocalInt(oCreature, sBase + _MANEUVER_LIST_TOTAL_KNOWN) - nSize
                          );

    // Remove each Maneuver in the array
    _ManeuverRecurseRemoveArray(oCreature, sArray, GetAMSDefinitionFileName(nList), nSize, 0);

    // Remove the array itself
    persistant_array_delete(oCreature, sArray);
}


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int AddManeuverKnown(object oCreature, int nList, int n2daRow, int nDiscipline, int bLevelDependent = FALSE, int nLevelToTieTo = -1)
{
    string sBase      = _POWER_LIST_NAME_BASE + IntToString(nList);
    string sArray     = sBase;
    string sPowerFile = GetAMSDefinitionFileName(/*PowerListToClassType(*/nList/*)*/);
    string sTestArray;
    int i, j, nSize, bReturn;

    // Get the spells.2da row corresponding to the cls_psipw_*.2da row
    int nSpells2daRow = StringToInt(Get2DACache(sPowerFile, "SpellID", n2daRow));

    // Determine the array name.
    if(bLevelDependent)
    {
        // If no level is specified, default to the creature's current level
        if(nLevelToTieTo == -1)
            nLevelToTieTo = GetHitDice(oCreature);

        sArray += _POWER_LIST_LEVEL_ARRAY + IntToString(nLevelToTieTo);
    }
    else
    {
        sArray += _POWER_LIST_GENERAL_ARRAY;
    }

    // Make sure the power isn't already in an array. If it is, abort and return FALSE
    // Loop over each level array and check that it isn't there.
    for(i = 1; i <= GetHitDice(oCreature); i++)
    {
        sTestArray = sBase + _POWER_LIST_LEVEL_ARRAY + IntToString(i);
        if(persistant_array_exists(oCreature, sTestArray))
        {
            nSize = persistant_array_get_size(oCreature, sTestArray);
            for(j = 0; j < nSize; j++)
                if(persistant_array_get_int(oCreature, sArray, j) == nSpells2daRow)
                    return FALSE;
        }
    }
    // Check the non-level-dependent array
    sTestArray = sBase + _POWER_LIST_GENERAL_ARRAY;
    if(persistant_array_exists(oCreature, sTestArray))
    {
        nSize = persistant_array_get_size(oCreature, sTestArray);
        for(j = 0; j < nSize; j++)
            if(persistant_array_get_int(oCreature, sArray, j) == nSpells2daRow)
                return FALSE;
    }

    // All checks are made, now start adding the new power
    // Create the array if it doesn't exist yet
    if(!persistant_array_exists(oCreature, sArray))
        persistant_array_create(oCreature, sArray);

    // Store the power in the array
    if(persistant_array_set_int(oCreature, sArray, persistant_array_get_size(oCreature, sArray), nSpells2daRow) != SDL_SUCCESS)
    {
        if(DEBUG) DoDebug("psi_inc_powknown: AddPowerKnown(): ERROR: Unable to add power to known array\n"
                        + "oCreature = " + DebugObject2Str(oCreature) + "\n"
                        + "nList = " + IntToString(nList) + "\n"
                        + "n2daRow = " + IntToString(n2daRow) + "\n"
                        + "bLevelDependent = " + BooleanToString(bLevelDependent) + "\n"
                        + "nLevelToTieTo = " + IntToString(nLevelToTieTo) + "\n"
                        + "nSpells2daRow = " + IntToString(nSpells2daRow) + "\n"
                          );
        return FALSE;
    }

    // Increment powers known total
    SetPersistantLocalInt(oCreature, sBase + _POWER_LIST_TOTAL_KNOWN,
                          GetPersistantLocalInt(oCreature, sBase + _POWER_LIST_TOTAL_KNOWN) + 1
                          );

    // Give the power's control feats
    object oSkin        = GetPCSkin(oCreature);
    string sPowerFeatIP = Get2DACache(sPowerFile, "IPFeatID", n2daRow);
    itemproperty ipFeat = PRCItemPropertyBonusFeat(StringToInt(sPowerFeatIP));
    IPSafeAddItemProperty(oSkin, ipFeat, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    // Second power feat, if any
    sPowerFeatIP = Get2DACache(sPowerFile, "IPFeatID2", n2daRow);
    if(sPowerFeatIP != "")
    {
        ipFeat = PRCItemPropertyBonusFeat(StringToInt(sPowerFeatIP));
        IPSafeAddItemProperty(oSkin, ipFeat, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    }

    return TRUE;
}

void RemoveManeuversKnownOnLevel(object oCreature, int nLevel)
{
    if(DEBUG) DoDebug("psi_inc_powknown: RemovePowersKnownOnLevel():\n"
                    + "oCreature = " + DebugObject2Str(oCreature) + "\n"
                    + "nLevel = " + IntToString(nLevel) + "\n"
                      );

    string sPostFix = _POWER_LIST_LEVEL_ARRAY + IntToString(nLevel);
    // For each power list, determine if an array exists for this level.
    if(persistant_array_exists(oCreature, _POWER_LIST_NAME_BASE + IntToString(POWER_LIST_PSION) + sPostFix))
        // If one does exist, clear it
        _RemovePowerArray(oCreature, POWER_LIST_PSION, nLevel);

    if(persistant_array_exists(oCreature, _POWER_LIST_NAME_BASE + IntToString(POWER_LIST_WILDER) + sPostFix))
        _RemovePowerArray(oCreature, POWER_LIST_WILDER, nLevel);

    if(persistant_array_exists(oCreature, _POWER_LIST_NAME_BASE + IntToString(POWER_LIST_PSYWAR) + sPostFix))
        _RemovePowerArray(oCreature, POWER_LIST_PSYWAR, nLevel);

    if(persistant_array_exists(oCreature, _POWER_LIST_NAME_BASE + IntToString(POWER_LIST_FIST_OF_ZUOKEN) + sPostFix))
        _RemovePowerArray(oCreature, POWER_LIST_FIST_OF_ZUOKEN, nLevel);

    if(persistant_array_exists(oCreature, _POWER_LIST_NAME_BASE + IntToString(POWER_LIST_WARMIND) + sPostFix))
        _RemovePowerArray(oCreature, POWER_LIST_WARMIND, nLevel);

    if(persistant_array_exists(oCreature, _POWER_LIST_NAME_BASE + IntToString(POWER_LIST_MISC) + sPostFix))
        _RemovePowerArray(oCreature, POWER_LIST_MISC, nLevel);
}

int GetKnownManeuversModifier(object oCreature, int nList, int nDiscipline)
{
    return GetPersistantLocalInt(oCreature, _MANEUVER_LIST_NAME_BASE + IntToString(nList) + IntToString(nDiscipline) + _MANEUVER_LIST_MODIFIER);
}

void SetKnownManeuversModifier(object oCreature, int nList, int nNewValue, int nDiscipline)
{
    SetPersistantLocalInt(oCreature, _MANEUVER_LIST_NAME_BASE + IntToString(nList) + IntToString(nDiscipline) + _MANEUVER_LIST_MODIFIER, nNewValue);
}

int GetManeuverCount(object oCreature, int nList)
{
    return GetPersistantLocalInt(oCreature, _MANEUVER_LIST_NAME_BASE + IntToString(nList) + IntToString(nDiscipline) + _MANEUVER_LIST_TOTAL_KNOWN);
}

int GetMaxManeuverCount(object oCreature, int nList)
{
    int nMaxPowers = 0;

    switch(nList)
    {
        case POWER_LIST_PSION:{
            // Determine base powers known
            int nLevel = GetLevelByClass(CLASS_TYPE_PSION, oCreature);
                nLevel += GetFirstPsionicClass(oCreature) == CLASS_TYPE_PSION ? GetPsionicPRCLevels(oCreature) : 0;
            if(nLevel == 0)
                break;
            nMaxPowers = StringToInt(Get2DACache(GetAMSKnownFileName(CLASS_TYPE_PSION), "PowersKnown", nLevel - 1));

            // Calculate feats
            // Apply the epic feat Power Knowledge - +2 powers known per
            int nFeat = FEAT_POWER_KNOWLEDGE_PSION_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_PSION_10 &&
                  GetHasFeat(nFeat, oCreature))
            {
                nMaxPowers += 2;
                nFeat++;
            }

            // Add in the custom modifier
            nMaxPowers += GetKnownPowersModifier(oCreature, nList);
            break;
        }
        case POWER_LIST_WILDER:{
            // Determine base powers known
            int nLevel = GetLevelByClass(CLASS_TYPE_WILDER, oCreature);
                nLevel += GetFirstPsionicClass(oCreature) == CLASS_TYPE_WILDER ? GetPsionicPRCLevels(oCreature) : 0;
            if(nLevel == 0)
                break;
            nMaxPowers = StringToInt(Get2DACache(GetAMSKnownFileName(CLASS_TYPE_WILDER), "PowersKnown", nLevel - 1));

            // Calculate feats
            // Apply the epic feat Power Knowledge - +2 powers known per
            int nFeat = FEAT_POWER_KNOWLEDGE_WILDER_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_WILDER_10 &&
                  GetHasFeat(nFeat, oCreature))
            {
                nMaxPowers += 2;
                nFeat++;
            }

            // Add in the custom modifier
            nMaxPowers += GetKnownPowersModifier(oCreature, nList);
            break;
        }
        case POWER_LIST_PSYWAR:{
            // Determine base powers known
            int nLevel = GetLevelByClass(CLASS_TYPE_PSYWAR, oCreature);
                nLevel += GetFirstPsionicClass(oCreature) == CLASS_TYPE_PSYWAR ? GetPsionicPRCLevels(oCreature) : 0;
            if(nLevel == 0)
                break;
            nMaxPowers = StringToInt(Get2DACache(GetAMSKnownFileName(CLASS_TYPE_PSYWAR), "PowersKnown", nLevel - 1));

            // Calculate feats
            // Apply the epic feat Power Knowledge - +2 powers known per
            int nFeat = FEAT_POWER_KNOWLEDGE_PSYWAR_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_PSYWAR_10 &&
                  GetHasFeat(nFeat, oCreature))
            {
                nMaxPowers += 2;
                nFeat++;
            }

            // Add in the custom modifier
            nMaxPowers += GetKnownPowersModifier(oCreature, nList);
            break;
        }
        case POWER_LIST_FIST_OF_ZUOKEN:{
            // Determine base powers known
            int nLevel = GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oCreature);
                nLevel += GetFirstPsionicClass(oCreature) == CLASS_TYPE_FIST_OF_ZUOKEN ? GetPsionicPRCLevels(oCreature) : 0;
            if(nLevel == 0)
                break;
            nMaxPowers = StringToInt(Get2DACache(GetAMSKnownFileName(CLASS_TYPE_FIST_OF_ZUOKEN), "PowersKnown", nLevel - 1));

            // Calculate feats
            // Apply the epic feat Power Knowledge - +2 powers known per
            int nFeat = FEAT_POWER_KNOWLEDGE_FIST_OF_ZUOKEN_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_FIST_OF_ZUOKEN_10 &&
                  GetHasFeat(nFeat, oCreature))
            {
                nMaxPowers += 2;
                nFeat++;
            }

            // Add in the custom modifier
            nMaxPowers += GetKnownPowersModifier(oCreature, nList);
            break;
        }
        case POWER_LIST_WARMIND:{
            // Determine base powers known
            int nLevel = GetLevelByClass(CLASS_TYPE_WARMIND, oCreature);
                nLevel += GetFirstPsionicClass(oCreature) == CLASS_TYPE_WARMIND ? GetPsionicPRCLevels(oCreature) : 0;
            if(nLevel == 0)
                break;
            nMaxPowers = StringToInt(Get2DACache(GetAMSKnownFileName(CLASS_TYPE_WARMIND), "PowersKnown", nLevel - 1));

            // Calculate feats
            // Apply the epic feat Power Knowledge - +2 powers known per
            int nFeat = FEAT_POWER_KNOWLEDGE_WARMIND_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_WARMIND_10 &&
                  GetHasFeat(nFeat, oCreature))
            {
                nMaxPowers += 2;
                nFeat++;
            }

            // Add in the custom modifier
            nMaxPowers += GetKnownPowersModifier(oCreature, nList);
            break;
        }

        case POWER_LIST_MISC:
            DoDebug("GetMaxPowerCount(): ERROR: Using unfinishes power list!");
            break;

        default:{
            string sErr = "GetMaxPowerCount(): ERROR: Unknown power list value: " + IntToString(nList);
            if(DEBUG) DoDebug(sErr);
            else      WriteTimestampedLogEntry(sErr);
        }
    }

    return nMaxPowers;
}

int GetHasManeuver(int nUtter, object oCreature = OBJECT_SELF)
{
    if((GetLevelByClass(CLASS_TYPE_PSION, oCreature)
        && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_PSION), oCreature)
        ) ||
       (GetLevelByClass(CLASS_TYPE_PSYWAR, oCreature)
        && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_PSYWAR), oCreature)
        ) ||
       (GetLevelByClass(CLASS_TYPE_WILDER, oCreature)
        && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_WILDER), oCreature)
        ) ||
       (GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oCreature)
        && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_FIST_OF_ZUOKEN), oCreature)
        ) ||
       (GetLevelByClass(CLASS_TYPE_WARMIND, oCreature)
        && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_WARMIND), oCreature)
        )
        // add new psionic classes here
       )
        return TRUE;
    return FALSE;
}

string DebugListKnownManeuvers(object oCreature)
{
    string sReturn = "Maneuvers known by " + DebugObject2Str(oCreature) + ":\n";
    int i, j, k, numUtterLists = 6;
    int nUtterList, nSize;
    string sTemp, sArray, sArrayBase, sUtterFile;
    // Loop over all Maneuver lists
    for(i = 1; i <= numUtterLists; i++)
    {
        // Some padding
        sReturn += "  ";
        // Get the Maneuver list for this loop
        switch(i)
        {
            case 1: nUtterList = MANEUVER_LIST_ManeuverR;      sReturn += "Truenamer";       break;

            // This should always be last
            case 2: nUtterList = MANEUVER_LIST_MISC;           sReturn += "Misceallenous";   break;
        }
        sReturn += " Maneuvers known:\n";

        // Determine if the character has any Maneuvers from this list
        sUtterFile = GetAMSDefinitionFileName(nUtterList);
        sArrayBase = _MANEUVER_LIST_NAME_BASE + IntToString(nUtterList);

        // Loop over levels
        for(j = 1; j <= GetHitDice(oCreature); j++)
        {
            sArray = sArrayBase + _MANEUVER_LIST_LEVEL_ARRAY + IntToString(j);
            if(persistant_array_exists(oCreature, sArray))
            {
                sReturn += "   Gained on level " + IntToString(j) + ":\n";
                nSize = persistant_array_get_size(oCreature, sArray);
                for(k = 0; k < nSize; k++)
                    sReturn += "    " + GetStringByStrRef(StringToInt(Get2DACache(sUtterFile, "Name",
                                                                                  GetPowerfileIndexFromSpellID(persistant_array_get_int(oCreature, sArray, k))
                                                                                  )
                                                                      )
                                                          )
                            + "\n";
            }
        }

        // Non-leveldependent Maneuvers
        sArray = sArrayBase + _MANEUVER_LIST_GENERAL_ARRAY;
        if(persistant_array_exists(oCreature, sArray))
        {
            sReturn += "   Non-leveldependent:\n";
            nSize = persistant_array_get_size(oCreature, sArray);
            for(k = 0; k < nSize; k++)
                sReturn += "    " + GetStringByStrRef(StringToInt(Get2DACache(sUtterFile, "Name",
                                                                                  GetPowerfileIndexFromSpellID(persistant_array_get_int(oCreature, sArray, k))
                                                                                  )
                                                                      )
                                                          )
                        + "\n";
        }
    }

    return sReturn;
}
// Test main
//void main(){}