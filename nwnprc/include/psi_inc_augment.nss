//::///////////////////////////////////////////////
//:: Psionics include: Augmentation
//:: psi_inc_augment
//::///////////////////////////////////////////////
/** @file
    Defines a structs and functions for handling
    psionic power augmentation.

    @author Ornedan
    @date   Created - 2005.11.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

/// Internal constant
const string PRC_AUGMENT_PROFILE         = "PRC_Augment_Profile_";
/// Internal constant
const string PRC_CURRENT_AUGMENT_PROFILE = "PRC_Current_Augment_Profile_Index";


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
}

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
}



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
 * @param oUser  A creature that has power augmentation profiles set up.
 * @param nIndex The number of the profile to retrieve.
 * @return       The retrieved profile, compiled into a structure
 */
struct user_augment_profile GetUserAugmentationProfile(object oUser, int nIndex);

/**
 * Stores a user-specified augmentation profile.
 *
 * @param oUser  The user for whose use to store the profile for.
 * @param nIndex The index number to store the profile under.
 * @param uap    A structure containing the profile to store.
 */
void StoreUserAugmentationProfile(object oUser, int nIndex, struct user_augment_profile uap);

/**
 * Calculates how many times each augmentation option of a power is used and
 * the increased PP cost caused by augmentation.
 * In addition to basic augmentation, currently accounts for:
 * - Wild Surge
 *
 *
 * @param oUser A creature manifesting a power.
 * @param manif The manifestation data.
 * @param pap   The power's augmentation profile.
 * @return      The manifestation data with augmentation's effects added in.
 */
struct manifestation GetAugmentation(object oUser, struct manifestation manif, struct power_augment_profile pap);


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


struct user_augment_profile GetUserAugmentationProfile(object oUser, int nIndex)
{
    int nProfile = GetPersistantLocalInt(oUser, PRC_AUGMENT_PROFILE + IntToString(nIndex));
    struct user_augment_profile sup;
    
    // The augmentation profile is stored in one integer, with 6 bits per option.
    // MSB -> [xx555555444444333333222222111111] <- LSB
    int nMask = 0x3F; // 6 LSB
    sup.nOption_1 = nProfile & nMask;
    sup.nOption_2 = (nProfile >>> 6) & nMask;
    sup.nOption_3 = (nProfile >>> 12) & nMask;
    sup.nOption_4 = (nProfile >>> 18) & nMask;
    sup.nOption_5 = (nProfile >>> 24) & nMask;
    
    return sup;
}

void StoreUserAugmentationProfile(object oUser, int nIndex, struct user_augment_profile uap)
{
    int nProfile = 0x00000000;
    int nMask = 0x3F; // 6 LSB
    
    nProfile |= (uap.nOption_1 & nMask);
    nProfile |= (uap.nOption_2 & nMask) << 6;
    nProfile |= (uap.nOption_3 & nMask) << 12;
    nProfile |= (uap.nOption_4 & nMask) << 18;
    nProfile |= (uap.nOption_5 & nMask) << 24;
    
    SetPersistantLocalInt(oUser, PRC_AUGMENT_PROFILE + IntToString(nIndex), nProfile);
}

struct manifestation GetAugmentation(object oUser, struct manifestation manif, struct power_augment_profile pap)
{
    // If the user does not have an augmentation profile defined
    if(!GetLocalInt(oUser, PRC_CURRENT_AUGMENT_PROFILE))
    {
        // If the user does have wild surge active, but no augment profile defined, assume all PP going to option 1
        if(GetWildSurge(oUser))
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
        struct user_augment_profile uap = GetUserAugmentationProfile(oUser, GetLocalInt(oUser, PRC_CURRENT_AUGMENT_PROFILE));
        int nSurge = GetWildSurge()
        int nAugPPCost = 0;
        int bAugIsPP = GetLocalInt(oCaster, PRC_PLAYER_SWITCH_AUGMENT_IS_PP);
        
        /* Bloody duplication follows. Real arrays would be nice */
        // Make sure the option is available for use
        if(pap.nMaxAugs_1)
        {
            // Determine how many times the augmentation option has been used
            manif.nTimesAugOptUsed_1 = bAugIsPP ?                            // The user can determine whether their settings are interpreted
                                        uap.nOption_1 / pap.nAugCost_1 : // as static PP costs
                                        uap.nOption_1;                       // or as number of times to use
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
            manif.nTimesAugOptUsed_2 = bAugIsPP ?                            // The user can determine whether their settings are interpreted
                                        uap.nOption_2 / pap.nAugCost_2 : // as static PP costs
                                        uap.nOption_2;                       // or as number of times to use
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
            manif.nTimesAugOptUsed_3 = bAugIsPP ?                            // The user can determine whether their settings are interpreted
                                        uap.nOption_3 / pap.nAugCost_3 : // as static PP costs
                                        uap.nOption_3;                       // or as number of times to use
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
            manif.nTimesAugOptUsed_4 = bAugIsPP ?                            // The user can determine whether their settings are interpreted
                                        uap.nOption_4 / pap.nAugCost_4 : // as static PP costs
                                        uap.nOption_4;                       // or as number of times to use
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
            manif.nTimesAugOptUsed_5 = bAugIsPP ?                            // The user can determine whether their settings are interpreted
                                        uap.nOption_5 / pap.nAugCost_5 : // as static PP costs
                                        uap.nOption_5;                       // or as number of times to use
            // Make sure the number of times the option is used does not exceed the maximum
            if(pap.nMaxAugs_5 != -1 && manif.nTimesAugOptUsed_5 > pap.nMaxAugs_5)
                manif.nTimesAugOptUsed_5 = pap.nMaxAugs_5;
            // Calculate the amount of PP the augmentation will cost
            nAugPPCost += manif.nTimesAugOptUsed_5 * pap.nAugCost_5;
        }
        
        // Calculate number of times a generic augmentation happens with this number of PP
        if(pap.nGenericAugCost != -1)
            manif.nTimesGenericAugUsed = nAugPPCost / pap.nGenericAugCost;
        
        // Account for wild surge
        nAugPPCost -= nSurge;
        
        /*/ Various effects modifying the augmentation go below /*/
        
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
