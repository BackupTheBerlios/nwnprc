//::///////////////////////////////////////////////
//:: Psionics include: Augmentation
//:: psi_inc_augment
//::///////////////////////////////////////////////
/** @file
    Defines structs and functions for handling
    psionic power augmentation.

    @author Ornedan
    @date   Created - 2005.11.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

/// Prefix of the local variable names used for storing an user's profiles
const string PRC_AUGMENT_PROFILE         = "PRC_Augment_Profile_";
/// Index of the currently used profile.
const string PRC_CURRENT_AUGMENT_PROFILE = "PRC_Current_Augment_Profile_Index";
/// The lowest valid value of PRC_CURRENT_AUGMENT_PROFILE
const int PRC_AUGMENT_PROFILE_INDEX_MIN  = 1;
/// The highest valid value of PRC_CURRENT_AUGMENT_PROFILE
const int PRC_AUGMENT_PROFILE_INDEX_MAX  = 49;
/// Prefix of the local variable names used for storing quickselections
const string PRC_AUGMENT_QUICKSELECTION  = "PRC_Augment_Quickselection_";
/// The lowest value the quickslot index can have
const int PRC_AUGMENT_QUICKSELECTION_MIN = 1;
/// The highest value the quickslot index can have
const int PRC_AUGMENT_QUICKSELECTION_MAX = 3;

/// The value of an empty profile. Also known as zero
const int PRC_AUGMENT_NULL_PROFILE = 0x00000000;

//////////////////////////////////////////////////
/*                 Structures                   */
//////////////////////////////////////////////////

/**
 * A structure used for defining how a particular power may be augmented.
 * Use PowerAugmentationProfile() to create.
 */
struct power_augment_profile{
    /**
     * Many powers specify several augmentation options and in addition a
     * "for each N PP spent augmenting this power, something happens".
     * This value is that N.
     */
    int nGenericAugCost;

    /**
     * How many PP the first augmentation option of the power will cost per
     * times used.
     */
    int nAugCost_1;
    /**
     * How many times, at most, can the first augmentation option be used.
     */
    int nMaxAugs_1;

    /**
     * How many PP the second augmentation option of the power will cost per
     * times used.
     */
    int nAugCost_2;
    /**
     * How many times, at most, can the second augmentation option be used.
     */
    int nMaxAugs_2;

    /**
     * How many PP the third augmentation option of the power will cost per
     * times used.
     */
    int nAugCost_3;
    /**
     * How many times, at most, can the third augmentation option be used.
     */
    int nMaxAugs_3;

    /**
     * How many PP the fourth augmentation option of the power will cost per
     * times used.
     */
    int nAugCost_4;
    /**
     * How many times, at most, can the fourth augmentation option be used.
     */
    int nMaxAugs_4;

    /**
     * How many PP the fifth augmentation option of the power will cost per
     * times used.
     */
    int nAugCost_5;
    /**
     * How many times, at most, can the fifth augmentation option be used.
     */
    int nMaxAugs_5;
};

/**
 * Users define how much PP they want to use for each augmentation option or
 * how many times they want to use each option. This structure is for transferring
 * that data.
 */
struct user_augment_profile{
    int nOption_1;
    int nOption_2;
    int nOption_3;
    int nOption_4;
    int nOption_5;

    /// Whether the values in this structure are to be interpreted as augmentation levels
    /// or as amounts of PP.
    int bValueIsPP;
};


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Constructs an augmentation profile for a power.
 * The default values for each parameter specify that the power in question
 * does not have that augmentation feature.
 *
 * @param nGenericAugCost Many powers have an augmentation clause saying "for
 *                        each N power points used to augment this power,
 *                        X happens". This parameter is used to define the
 *                        value N.
 *                        Valid values: {x = -1 OR x > 0}
 *                        Default: -1, which means that there is no generic
 *                        augmentation for this power.
 *
 * @param nAugCost_1      Cost to use the first augmentation option of this
 *                        power.
 *                        Valid values: {x >= 0}
 *                        Default: 0
 * @param nMaxAugs_1      Number of times the first augmentation option may at
 *                        most be used. Value of -1 means the option may be used
 *                        an unlimited number of times.
 *                        Valid values: {x >= -1}
 *                        Default: 0
 *
 * @param nAugCost_2      Cost to use the second augmentation option of this
 *                        power.
 *                        Valid values: {x >= 0}
 *                        Default: 0
 * @param nMaxAugs_2      Number of times the second augmentation option may at
 *                        most be used. Value of -1 means the option may be used
 *                        an unlimited number of times.
 *                        Valid values: {x >= -1}
 *                        Default: 0 *
 *
 * @param nAugCost_3      Cost to use the third augmentation option of this
 *                        power.
 *                        Valid values: {x >= 0}
 *                        Default: 0
 * @param nMaxAugs_3      Number of times the third augmentation option may at
 *                        most be used. Value of -1 means the option may be used
 *                        an unlimited number of times.
 *                        Valid values: {x >= -1}
 *                        Default: 0
 *
 * @param nAugCost_4      Cost to use the fourth augmentation option of this
 *                        power.
 *                        Valid values: {x >= 0}
 *                        Default: 0
 * @param nMaxAugs_4      Number of times the fourth augmentation option may at
 *                        most be used. Value of -1 means the option may be used
 *                        an unlimited number of times.
 *                        Valid values: {x >= -1}
 *                        Default: 0
 *
 * @param nAugCost_5      Cost to use the fifth augmentation option of this
 *                        power.
 *                        Valid values: {x >= 0}
 *                        Default: 0
 * @param nMaxAugs_5      Number of times the fifth augmentation option may at
 *                        most be used. Value of -1 means the option may be used
 *                        an unlimited number of times.
 *                        Valid values: {x >= -1}
 *                        Default: 0
 *
 * @return                The parameters compiled into a power_augment_profile
 *                        structure.
 */
struct power_augment_profile PowerAugmentationProfile(int nGenericAugCost = -1,
                                                      int nAugCost_1 = 0, int nMaxAugs_1 = 0,
                                                      int nAugCost_2 = 0, int nMaxAugs_2 = 0,
                                                      int nAugCost_3 = 0, int nMaxAugs_3 = 0,
                                                      int nAugCost_4 = 0, int nMaxAugs_4 = 0,
                                                      int nAugCost_5 = 0, int nMaxAugs_5 = 0
                                                      );

/**
 * Reads an augmentation profile from a user and compiles it into
 * a structure.
 *
 * @param oUser           A creature that has power augmentation profiles set up.
 * @param nIndex          The number of the profile to retrieve.
 * @param bQuickSelection Whether the index is a quickselection or a normal profile.
 * @return                The retrieved profile, compiled into a structure
 */
struct user_augment_profile GetUserAugmentationProfile(object oUser, int nIndex, int bQuickSelection = FALSE);

/**
 * Stores a user-specified augmentation profile.
 *
 * @param oUser           The user for whose use to store the profile for.
 * @param nIndex          The index number to store the profile under.
 * @param bQuickSelection Whether the index is a quickselection or a normal profile.
 * @param uap             A structure containing the profile to store.
 */
void StoreUserAugmentationProfile(object oUser, int nIndex, struct user_augment_profile uap, int bQuickSelection = FALSE);

/**
 * Converts the given augmentation profile into a string.
 *
 * @param uap   The augmentation profile to convert to a string.
 * @return      A string of format:
 *              Option 1: N [times|PP], Option 2: N [times|PP], Option 2: N [times|PP], Option 4: N [times|PP], Option 5: N [times|PP]
 */
string UserAugmentationProfileToString(struct user_augmentation_profile uap);

/**
 * Calculates how many times each augmentation option of a power is used and
 * the increased PP cost caused by augmentation.
 * In addition to basic augmentation, currently accounts for:
 * - Wild Surge
 *
 *
 * @param manif The manifestation data related to an ongoing manifestation attempt.
 * @param pap   The power's augmentation profile.
 * @return      The manifestation data with augmentation's effects added in.
 */
struct manifestation EvaluateAugmentation(struct manifestation manif, struct power_augment_profile pap);

/**
 * Overrides the given creature's augmentation settings during it's next
 * manifestation with the given settings.
 *
 * @param oCreature Creature whose augmentation to override
 * @param uap       The profile to use as override
 */
void SetAugmentationOverride(object oCreature, struct user_augment_profile uap);


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "inc_utility"
#include "psi_inc_manifest"


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

/** Internal function.
 * @param nToDecode Integer from which to extract an user augmentation profile
 * @return          An user augmentation profile created based on nToDecode
 */
struct user_augment_profile _DecodeProfile(int nToDecode)
{
    struct user_augmentation_profile uap;

    // The augmentation profile is stored in one integer, with 6 bits per option.
    // MSB -> [xx555555444444333333222222111111] <- LSB
    int nMask = 0x3F; // 6 LSB
    uap.nOption_1 = nToDecode          & nMask;
    uap.nOption_2 = (nToDecode >>> 6)  & nMask;
    uap.nOption_3 = (nToDecode >>> 12) & nMask;
    uap.nOption_4 = (nToDecode >>> 18) & nMask;
    uap.nOption_5 = (nToDecode >>> 24) & nMask;
}

/** Internal function.
 * @param uapToEncode An user augmentation profile to encode into a single integer
 * @return            Integer built from values in uapToEncode
 */
int _EncodeProfile(struct user_augmentation_profile uapToEncode)
{
    // The augmentation profile is stored in one integer, with 6 bits per option.
    // MSB -> [xx555555444444333333222222111111] <- LSB
    int nProfile = PRC_AUGMENT_NULL_PROFILE;
    int nMask = 0x3F; // 6 LSB

    nProfile |= (uapToEncode.nOption_1 & nMask);
    nProfile |= (uapToEncode.nOption_2 & nMask) << 6;
    nProfile |= (uapToEncode.nOption_3 & nMask) << 12;
    nProfile |= (uapToEncode.nOption_4 & nMask) << 18;
    nProfile |= (uapToEncode.nOption_5 & nMask) << 24;
}


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////


struct power_augment_profile PowerAugmentationProfile(int nGenericAugCost = -1,
                                                      int nAugCost_1 = 0, int nMaxAugs_1 = 0,
                                                      int nAugCost_2 = 0, int nMaxAugs_2 = 0,
                                                      int nAugCost_3 = 0, int nMaxAugs_3 = 0,
                                                      int nAugCost_4 = 0, int nMaxAugs_4 = 0,
                                                      int nAugCost_5 = 0, int nMaxAugs_5 = 0
                                                      )
{
    struct power_augment_profile pap;

    pap.nGenericAugCost = nGenericAugCost;
    pap.nAugCost_1 = nAugCost_1;
    pap.nMaxAugs_1 = nMaxAugs_1;
    pap.nAugCost_2 = nAugCost_2;
    pap.nMaxAugs_2 = nMaxAugs_2;
    pap.nAugCost_3 = nAugCost_3;
    pap.nMaxAugs_3 = nMaxAugs_3;
    pap.nAugCost_4 = nAugCost_4;
    pap.nMaxAugs_4 = nMaxAugs_4;
    pap.nAugCost_5 = nAugCost_5;
    pap.nMaxAugs_5 = nMaxAugs_5;

    return pap;
}


struct user_augment_profile GetUserAugmentationProfile(object oUser, int nIndex, int bQuickSelection = FALSE)
{
    int nProfile = GetPersistantLocalInt(oUser, (bQuickSelection ? PRC_AUGMENT_QUICKSELECTION : PRC_AUGMENT_PROFILE) + IntToString(nIndex));
    struct user_augment_profile uap = _DecodeProfile(nProfile);

    // Get the augmentation levels / PP switch
    uap.bValueIsPP = GetPersistantLocalInt(oUser, PRC_PLAYER_SWITCH_AUGMENT_IS_PP);

    // Validity check on the index
    if(bQuickSelection ?
       (nIndex < PRC_AUGMENT_QUICKSELECTION_MIN ||
        nIndex > PRC_AUGMENT_QUICKSELECTION_MAX
        ):
       (nIndex < PRC_AUGMENT_PROFILE_INDEX_MIN ||
        nIndex > PRC_AUGMENT_PROFILE_INDEX_MAX
        )
       )
    {
        // Null the profile, just in case
        uap.nOption1 = 0;
        uap.nOption2 = 0;
        uap.nOption3 = 0;
        uap.nOption4 = 0;
        uap.nOption5 = 0;
    }

    return uap;
}

void StoreUserAugmentationProfile(object oUser, int nIndex, struct user_augment_profile uap, int bQuickSelection = FALSE)
{
    // Validity check on the index
    if(bQuickSelection ?
       (nIndex < PRC_AUGMENT_QUICKSELECTION_MIN ||
        nIndex > PRC_AUGMENT_QUICKSELECTION_MAX
        ):
       (nIndex < PRC_AUGMENT_PROFILE_INDEX_MIN ||
        nIndex > PRC_AUGMENT_PROFILE_INDEX_MAX
        )
       )
    {
        if(DEBUG) DoDebug("StoreUserAugmentationProfile(): Attempt to store outside valid range: " + IntToString(nIndex));
        return;
    }

    SetPersistantLocalInt(oUser, (bQuickSelection ? PRC_AUGMENT_QUICKSELECTION : PRC_AUGMENT_PROFILE) + IntToString(nIndex), _EncodeProfile(uap));
}

string UserAugmentationProfileToString(struct user_augmentation_profile uap)
{
    string sBegin = GetStringByStrRef(16823498) + " "; // "Option"
    string sEnd   = " " + (uap.bValueIsPP ? "PP" : GetStringByStrRef(16823499)); // "times"

    return sBegin + "1: " + IntToString(uap.nOption1) + sEnd
         + sBegin + "2: " + IntToString(uap.nOption2) + sEnd
         + sBegin + "3: " + IntToString(uap.nOption3) + sEnd
         + sBegin + "4: " + IntToString(uap.nOption4) + sEnd
         + sBegin + "5: " + IntToString(uap.nOption5) + sEnd;
}

struct manifestation EvaluateAugmentation(struct manifestation manif, struct power_augment_profile pap)
{
    // If the user does not have an augmentation profile defined
    if(!GetLocalInt(manif.oManifester, PRC_CURRENT_AUGMENT_PROFILE))
    {
        // If the user does have wild surge active, but no augment profile defined, assume all PP going to option 1
        if(GetWildSurge(manif.oManifester))
        {
            int nSurge = GetWildSurge();
            int nTimesAugd = nSurge / pap.nAugCost_1;
            if(pap.nMaxAugs_1 != -1 && nTimesAugd > pap.nMaxAugs_1)
                nTimesAugd = pap.nMaxAugments;
            manif.nTimesAugOptUsed_1 = nTimesAugd;
            if(pap.nGenericAugCost != -1)
                manif.nTimesGenericAugUsed = (nTimesAugd * pap.nAugCost_1) / pap.nGenericAugCost;
        }
    }
    else
    {
        // Get the user's augmentation profile
        struct user_augment_profile uap = GetUserAugmentationProfile(manif.oManifester, GetLocalInt(manif.oManifester, PRC_CURRENT_AUGMENT_PROFILE));
        int nSurge = GetWildSurge(manif.oManifester);
        int nAugPPCost = 0;

        /* Bloody duplication follows. Real arrays would be nice */
        // Make sure the option is available for use
        if(pap.nMaxAugs_1)
        {
            // Determine how many times the augmentation option has been used
            manif.nTimesAugOptUsed_1 = uap.bValueIsPP ?                  // The user can determine whether their settings are interpreted
                                        uap.nOption_1 / pap.nAugCost_1 : // as static PP costs
                                        uap.nOption_1;                   // or as number of times to use
            // Make sure the number of times the option is used does not exceed the maximum
            if(pap.nMaxAugs_1 != -1 && manif.nTimesAugOptUsed_1 > pap.nMaxAugs_1)
                manif.nTimesAugOptUsed_1 = pap.nMaxAugs_1;
            // Calculate the amount of PP the augmentation will cost
            nAugPPCost += manif.nTimesAugOptUsed_1 * pap.nAugCost_1;
        }
        // Make sure the option is available for use
        if(pap.nMaxAugs_2)
        {
            // Determine how many times the augmentation option has been used
            manif.nTimesAugOptUsed_2 = uap.bValueIsPP ?                  // The user can determine whether their settings are interpreted
                                        uap.nOption_2 / pap.nAugCost_2 : // as static PP costs
                                        uap.nOption_2;                   // or as number of times to use
            // Make sure the number of times the option is used does not exceed the maximum
            if(pap.nMaxAugs_2 != -1 && manif.nTimesAugOptUsed_2 > pap.nMaxAugs_2)
                manif.nTimesAugOptUsed_2 = pap.nMaxAugs_2;
            // Calculate the amount of PP the augmentation will cost
            nAugPPCost += manif.nTimesAugOptUsed_2 * pap.nAugCost_2;
        }
        // Make sure the option is available for use
        if(pap.nMaxAugs_3)
        {
            // Determine how many times the augmentation option has been used
            manif.nTimesAugOptUsed_3 = uap.bValueIsPP ?                  // The user can determine whether their settings are interpreted
                                        uap.nOption_3 / pap.nAugCost_3 : // as static PP costs
                                        uap.nOption_3;                   // or as number of times to use
            // Make sure the number of times the option is used does not exceed the maximum
            if(pap.nMaxAugs_3 != -1 && manif.nTimesAugOptUsed_3 > pap.nMaxAugs_3)
                manif.nTimesAugOptUsed_3 = pap.nMaxAugs_3;
            // Calculate the amount of PP the augmentation will cost
            nAugPPCost += manif.nTimesAugOptUsed_3 * pap.nAugCost_3;
        }
        // Make sure the option is available for use
        if(pap.nMaxAugs_4)
        {
            // Determine how many times the augmentation option has been used
            manif.nTimesAugOptUsed_4 = uap.bValueIsPP ?                  // The user can determine whether their settings are interpreted
                                        uap.nOption_4 / pap.nAugCost_4 : // as static PP costs
                                        uap.nOption_4;                   // or as number of times to use
            // Make sure the number of times the option is used does not exceed the maximum
            if(pap.nMaxAugs_4 != -1 && manif.nTimesAugOptUsed_4 > pap.nMaxAugs_4)
                manif.nTimesAugOptUsed_4 = pap.nMaxAugs_4;
            // Calculate the amount of PP the augmentation will cost
            nAugPPCost += manif.nTimesAugOptUsed_4 * pap.nAugCost_4;
        }
        // Make sure the option is available for use
        if(pap.nMaxAugs_5)
        {
            // Determine how many times the augmentation option has been used
            manif.nTimesAugOptUsed_5 = uap.bValueIsPP ?                  // The user can determine whether their settings are interpreted
                                        uap.nOption_5 / pap.nAugCost_5 : // as static PP costs
                                        uap.nOption_5;                   // or as number of times to use
            // Make sure the number of times the option is used does not exceed the maximum
            if(pap.nMaxAugs_5 != -1 && manif.nTimesAugOptUsed_5 > pap.nMaxAugs_5)
                manif.nTimesAugOptUsed_5 = pap.nMaxAugs_5;
            // Calculate the amount of PP the augmentation will cost
            nAugPPCost += manif.nTimesAugOptUsed_5 * pap.nAugCost_5;
        }

        // Calculate number of times a generic augmentation happens with this number of PP
        if(pap.nGenericAugCost != -1)
            manif.nTimesGenericAugUsed = nAugPPCost / pap.nGenericAugCost;


        /*/ Various effects modifying the augmentation go below /*/

        // Account for wild surge
        nAugPPCost -= nSurge;

        // If the surge provides more PP than was used by this augmentation profile, attempt to place the rest into option 1
        if(nAugPPCost < 0)
        {
            int nSurgeLeft = -nAugPPCost;
            nAugPPCost = 0;

            // Calculate the additional augmentations
            int nTimesAugd = nSurgeLeft / pap.nAugCost_1;
            if(pap.nMaxAugs_1 != -1 && (manif.nTimesAugOptUsed_1 + nTimesAugd) > pap.nMaxAugs_1)
                nTimesAugd += pap.nMaxAugments - (manif.nTimesAugOptUsed_1 + nTimesAugd);
            // Add them in
            manif.nTimesAugOptUsed_1 += nTimesAugd;

            // Calculate increase to generic augmentation
            if(pap.nGenericAugCost != -1)
                manif.nTimesGenericAugUsed += (nTimesAugd * pap.nAugCost_1) / pap.nGenericAugCost;
        }

        /*/ Various effects modifying the augmentation go above /*/


        // Store the PP cost increase
        manif.nPPCost += nAugPPCost;
    }

    return manif;
}
/*
void SetAugmentationOverride(object oCreature, struct user_augment_profile uap)
{
    SetLocalInt(oCreature) // TODO!!
}*/
