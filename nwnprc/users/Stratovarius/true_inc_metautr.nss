//::///////////////////////////////////////////////
//:: Truenaming include: Metautterances
//:: true_inc_metautr
//::///////////////////////////////////////////////
/** @file
    Defines functions for handling metautterances

    @author Stratovarius
    @date   Created - 2006.7.17
    @thanks to Ornedan for his work on Psionics upon which this is based.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

/// No metautterances
const int METAUTTERANCE_NONE          = 0x0;
/// Quicken utterance
const int METAUTTERANCE_QUICKEN       = 0x2;
/// Empower utterance
const int METAUTTERANCE_EMPOWER       = 0x4;
/// Extend utterance
const int METAUTTERANCE_EXTEND        = 0x8;

/// Internal constant. Value is equal to the lowest metautterance constant. Used when looping over metautterance flag variables
const int METAUTTERANCE_MIN           = 0x2;
/// Internal constant. Value is equal to the highest metautterance constant. Used when looping over metautterance flag variables
const int METAUTTERANCE_MAX           = 0x8;

/// Empower Utterance variable name
const string METAUTTERANCE_EMPOWER_VAR   = "PRC_PsiMeta_Empower";
/// Extend Utterance variable name
const string METAUTTERANCE_EXTEND_VAR    = "PRC_PsiMeta_Extend";
/// Quicken Utterance variable name
const string METAUTTERANCE_QUICKEN_VAR   = "PRC_PsiMeta_Quicken";


/// The name of a marker variable that tells that the Utterance being truespoken had Quicken Utterance used on it
const string PRC_UTTERANCE_IS_QUICKENED = "PRC_UtteranceIsQuickened";



//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Determines the metautterances used in this utterance of a utterance
 * and the cost added by their use.
 *
 * @param utter         The utterance data related to this particular utterance
 * @param nMetaUtterFlags An integer containing a set of bitflags that determine
 *                      which metautterance utterances may be used with the Utterance being truespoken
 *
 * @return              The utterance data, modified to account for the metautterances
 */
struct utterance EvaluateMetautterances(struct utterance utter, int nMetaUtterFlags);

/**
 * Calculates a utterance's damage based on the given dice and metautterances.
 *
 * @param nDieSize            Size of the dice to use
 * @param nNumberOfDice       Amount of dice to roll
 * @param manif               The utterance data related to this particular utterance
 * @param nBonus              A bonus amount of damage to add into the total once
 * @param nBonusPerDie        A bonus amount of damage to add into the total for each die rolled
 * @param bDoesHPDamage       Whether the Utterance deals hit point damage, or some other form of point damage
 * @param bIsRayOrRangedTouch Whether the utterance's use involves a ranged touch attack roll or not
 * @return                    The amount of damage the Utterance should deal
 */
int MetautterancesDamage(struct utterance utter, int nDieSize, int nNumberOfDice, int nBonus = 0,
                       int nBonusPerDie = 0, int bDoesHPDamage = FALSE, int bIsRayOrRangedTouch = FALSE);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "inc_utility"
#include "true_inc_utter"


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

struct utterance EvaluateMetautterances(struct utterance utter, int nMetaUtterFlags)
{
    // Total PP cost of metautterances used
    int nMetaPsiPP = 0;
    // A debug variable to make a Utterance ignore normal use constraints
    int bIgnoreConstr = (DEBUG) ? GetLocalInt(utter.oTrueSpeaker, PRC_DEBUG_IGNORE_CONSTRAINTS) : FALSE;
    // A switch value that governs how Improved metautterances epic feat works
    int bUseSum = GetPRCSwitch(PRC_PSI_IMP_METAPSIONICS_USE_SUM);
    // Epic feat Improved metautterances - 2 PP per.
    int nImpMetapsiReduction, i = FEAT_IMPROVED_METAPSIONICS_1;
    while(i < FEAT_IMPROVED_METAPSIONICS_10 && GetHasFeat(i, utter.oTrueSpeaker))
    {
        nImpMetapsiReduction += 2;
        i++;
    }

    /* Calculate the added cost from metautterances and set the use markers for the utterances used */

    // Quicken Utterance - special handling
    if(GetLocalInt(utter.oTrueSpeaker, PRC_UTTERANCE_IS_QUICKENED))
    {
        // If Quicken could not have been used, the utterance fails
        if(!(utter.nPsiFocUsesRemain > 0 || bIgnoreConstr))
            utter.bCanManifest = FALSE;

        nMetaPsiPP += _GetMetaPsiPPCost(METAUTTERANCE_QUICKEN_COST, nImpMetapsiReduction, bUseSum);
        utter.bQuicken = TRUE;
        utter.nPsiFocUsesRemain--;

        // Delete the marker var
        DeleteLocalInt(utter.oTrueSpeaker, PRC_UTTERANCE_IS_QUICKENED);
    }

    if((nMetaUtterFlags & METAUTTERANCE_EMPOWER)             &&
        GetLocalInt(utter.oTrueSpeaker, METAUTTERANCE_EMPOWER_VAR) &&
        (utter.nPsiFocUsesRemain > 0 || bIgnoreConstr)
        )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAUTTERANCE_EMPOWER_COST, nImpMetapsiReduction, bUseSum);
        utter.bEmpower = TRUE;
        utter.nPsiFocUsesRemain--;
    }
    if((nMetaUtterFlags & METAUTTERANCE_EXTEND)            &&
       GetLocalInt(utter.oTrueSpeaker, METAUTTERANCE_EXTEND_VAR) &&
       (utter.nPsiFocUsesRemain > 0 || bIgnoreConstr)
       )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAUTTERANCE_EXTEND_COST, nImpMetapsiReduction, bUseSum);
        utter.bExtend = TRUE;
        utter.nPsiFocUsesRemain--;
    }

    // Add in the cost of the metautterances uses
    utter.nPPCost += _GetMetaPsiPPCost(nMetaPsiPP, nImpMetapsiReduction, !bUseSum); // A somewhat hacky use of the function, but eh, it works

    return manif;
}

int MetautterancesDamage(struct utterance utter, int nDieSize, int nNumberOfDice, int nBonus = 0,
                       int nBonusPerDie = 0, int bDoesHPDamage = FALSE, int bIsRayOrRangedTouch = FALSE)
{
    int nBaseDamage  = 0,
        nBonusDamage = nBonus + (nNumberOfDice * nBonusPerDie);

    // Calculate the base damage
    int i;
    for (i = 0; i < nNumberOfDice; i++)
        nBaseDamage += Random(nDieSize) + 1;


    // Apply general modifying effects
    if(bDoesHPDamage)
    {
        if(bIsRayOrRangedTouch)
       {
       	// Anything that affects Ray Utterances goes here
       }
    }

    // Apply metautterances
    // Empower
   if(utter.bEmpower)
        nBaseDamage += nBaseDamage / 2;

    return nBaseDamage + nBonusDamage;
}

// Test main
//void main(){}
