//::///////////////////////////////////////////////
//:: Psionics include: Metpasionics
//:: psi_inc_metapsi
//::///////////////////////////////////////////////
/** @file
    Defines functions for handling metapsionics.

    @author Ornedan
    @date   Created - 2005.11.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

/// No metapsionics
const int METAPSIONIC_NONE          = 0x0;
/// Chain Power
const int METAPSIONIC_CHAIN         = 0x2;
/// Empower Power
const int METAPSIONIC_EMPOWER       = 0x4;
/// Extend Power
const int METAPSIONIC_EXTEND        = 0x8;
/// Maximize Power
const int METAPSIONIC_MAXIMIZE      = 0x10;
/// Split Psionic Ray
const int METAPSIONIC_SPLIT         = 0x20;
/// Twin Power
const int METAPSIONIC_TWIN          = 0x40;
/// Widen Power
const int METAPSIONIC_WIDEN         = 0x80;

/// The name of the array targets returned by EvaluateChainPower will be stored in
const string PRC_CHAIN_POWER_ARRAY  = "PRC_ChainPowerTargets";


/// Internal constant. How much PP Chain Power costs to use
const int METAPSIONIC_CHAIN_COST    = 6;
/// Internal constant. How much PP Empower Power costs to use
const int METAPSIONIC_EMPOWER_COST  = 2;
/// Internal constant. How much PP Extend Power costs to use
const int METAPSIONIC_EXTEND_COST   = 2;
/// Internal constant. How much PP Maximize Power costs to use
const int METAPSIONIC_MAXIMIZE_COST = 4;
/// Internal constant. How much PP Split Psionic Ray costs to use
const int METAPSIONIC_SPLIT_COST    = 2;
/// Internal constant. How much PP Twin Power costs to use
const int METAPSIONIC_TWIN_COST     = 6;
/// Internal constant. How much PP Widen Power costs to use
const int METAPSIONIC_WIDEN_COST    = 4;

/// Internal constant. Value is equal to the lowest metapsionic constant. Used when looping over metapsionic flag variables
const int METAPSIONIC_MIN           = 0x2;
/// Internal constant. Value is equal to the highest metapsionic constant. Used when looping over metapsionic flag variables
const int METAPSIONIC_MAX           = 0x80;


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 *
 * @param manif
 * @param nMetaPsiFlags
 * @return
 */
struct manifesation EvaluateMetapsionics(struct manifestation manif, int nMetaPsiFlags);

/**
 * Calls UsePsionicFocus() on the manifester to pay for psionics focus
 * expenditure caused by metapsionics use in the power being currently
 * manifested.
 * Also informs the manifester which metapsionics were actually used
 * if the manifestation was successfull.
 *
 * @param manif The manifestation data relating to this particular manifesation
 * @return      The manifestation data, modified to turn off those metapsionics
 *              the manifester could not pay focus for.
 */
struct manifestation PayMetapsionicsFocuses(struct manifestation manif);

/**
 * Calculates a power's damage based on the given dice and metapsionics.
 *
 * @param nDieSize            Size of the dice to use
 * @param nNumberOfDice       Amount of dice to roll
 * @param manif               The manifestation data relating to this particular manifesation
 * @param nBonus              A bonus amount of damage to add into the total once
 * @param nBonusPerDie        A bonus amount of damage to add into the total for each die rolled
 * @param bDoesHPDamage       Whether the power deals hit point damage, or some other form of point damage
 * @param bIsRayOrRangedTouch Whether the power's use involves a ranged touch attack roll or not
 * @return                    The amount of damage the power should deal
 */
int MetaPsionicsDamage(struct manifestation manif, int nDieSize, int nNumberOfDice, int nBonus = 0,
                       int nBonusPerDie = 0, int bDoesHPDamage = FALSE, int bIsRayOrRangedTouch = FALSE);

/**
 * Accounts for the effects of Widen Power on the area size variables
 * of a power, if it is active.
 *
 * @param fBase The base value of the power's area size variable
 * @param manif The manifestation data relating to this particular manifesation
 * @return      The base modified by whether Widen Power was active.
 *              If it was, the returned value is twice fBase, otherwise
 *              it's fBase
 */
float EvaluateWidenPower(struct manifestation manif, float fBase);

/**
 * Builds the list of a power's targets, accounting for the effects
 * of Chain Power. If it is not active, the target list only contains the
 * primary target.
 * The list is stored in a local array on the manifester named
 * PRC_CHAIN_POWER_ARRAY. It will be automatically deleted at the end of
 * current script unless otherwise specified.
 *
 * NOTE: This only builds the list of targets, all effects have to be
 * applied by the powerscript.
 *
 * @param manif
 * @param oPrimaryTarget
 * @param bAutoDelete
 */
void EvaluateChainPower(struct manifestation manif, object oPrimaryTarget, int bAutoDelete = TRUE);


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

/** Internal function.
 * @param nCost     The base cost of the metapsionic power to calculate the actual cost for
 * @param nIMPsiRed The amount the PP cost might be reduced by due to Improved Metapsionics feats
 * @param bUseSum   Whether to account for Improved Metapsionics here or not
 * @return          Either nCost or the greater of nCost - nIMPsiRed and 1
 */
int _GetMetaPsiPPCost(int nCost, int nIMPsiRed, int bUseSum)
{
    return nCost <= 2 ? // Metapsionic powers costing 2 or less are not affected by Improved Metapsionics
            nCost :
             bUseSum ? nCost :
             // When calculating Improved Metapsionics separately, it cannot make the cost of a single metapsionic use go below 1
             max(nCost - nIMPsiRed, 1);
}


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

//#include "inc_utility"
#include "psi_inc_manifest"


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

struct manifesation EvaluateMetapsionics(struct manifestation manif, int nMetaPsiFlags)
{
    // Total PP cost of metapsionics used
    int nMetaPsiPP = 0;
    // A switch value that governs how Improved Metapsionics epic feat works
    int bUseSum = GetPRCSwitch(PRC_PSI_IMP_METAPSIONICS_USE_SUM);
    // Epic feat Improved Metapsionics - 2 PP per.
    int nImpMetapsiReduction, i = FEAT_IMPROVED_METAPSIONICS_1;
    while(i < FEAT_IMPROVED_METAPSIONICS_10 && GetHasFeat(i, manif.oManifester))
    {
        nImpMetapsiReduction += 2;
        i++;
    }

    // Calculate the added cost from metapsionics and set the use markers for the powers used
    if((nMetaPsiFlags & METAPSIONIC_CHAIN)            && // The power allows this metapsionic to apply
       GetLocalInt(manif.oManifester, "PsiMetaChain") && // The manifester is using the metapsionic
       manif.nPsiFocUsesRemain > 0                       // The manifester can pay the psionic focus expenditure
       )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_CHAIN_COST, nImpMetapsiReduction, bUseSum);
        manif.bChain = TRUE;
        manif.nPsiFocUsesRemain--;
    }
    if((nMetaPsiFlags & METAPSIONIC_EMPOWER)   &&
        GetLocalInt(manif.oManifester, "PsiMetaEmpower") &&
        manif.nPsiFocUsesRemain > 0
        )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_EMPOWER_COST, nImpMetapsiReduction, bUseSum);
        manif.bEmpower = TRUE;
        manif.nPsiFocUsesRemain--;
    }
    if((nMetaPsiFlags & METAPSIONIC_EXTEND)  &&
       GetLocalInt(manif.oManifester, "PsiMetaExtend") &&
       manif.nPsiFocUsesRemain > 0
       )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_EXTEND_COST, nImpMetapsiReduction, bUseSum);
        manif.bExtend = TRUE;
        manif.nPsiFocUsesRemain--;
    }
    if((nMetaPsiFlags & METAPSIONIC_MAXIMIZE) &&
       GetLocalInt(manif.oManifester, "PsiMetaMax")     &&
       manif.nPsiFocUsesRemain > 0
       )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_MAXIMIZE_COST, nImpMetapsiReduction, bUseSum);
        manif.bMaximize = TRUE;
        manif.nPsiFocUsesRemain--;
    }
    if((nMetaPsiFlags & METAPSIONIC_SPLIT)  &&
       GetLocalInt(manif.oManifester, "PsiMetaSplit") &&
       manif.nPsiFocUsesRemain > 0
       )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_SPLIT_COST, nImpMetapsiReduction, bUseSum);
        manif.bSplit = TRUE;
        manif.nPsiFocUsesRemain--;
    }
    if((nMetaPsiFlags & METAPSIONIC_TWIN)  &&
       GetLocalInt(manif.oManifester, "PsiMetaTwin") &&
       manif.nPsiFocUsesRemain > 0
       )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_TWIN_COST, nImpMetapsiReduction, bUseSum);
        manif.bTwin = TRUE;
        manif.nPsiFocUsesRemain--;
    }
    if((nMetaPsiFlags & METAPSIONIC_WIDEN)  &&
       GetLocalInt(manif.oManifester, "PsiMetaWiden") &&
       manif.nPsiFocUsesRemain > 0
       )
    {
        nMetaPsiPP += _GetMetaPsiPPCost(METAPSIONIC_WIDEN_COST, nImpMetapsiReduction, bUseSum);
        manif.bWiden = TRUE;
        manif.nPsiFocUsesRemain--;
    }

    // Add in the cost of the metapsionics uses
    manif.nPPCost += _GetMetaPsiPPCost(nMetaPsiPP, nImpMetapsiReduction, !bUseSum); // A somewhat hacky use of the function, but eh, it works
}


struct manifestation PayMetapsionicsFocuses(struct manifestation manif)
{
    string sInform = "";

    // Check each of the metapsionics and pay focus for each active one. If for some reason the
    // manifester cannot pay focus, deactivate the metapsionic. No PP refunds, though, since
    // the system attempts to keep track of how many focuses the user has available
    // and shouldn't allow them to exceed that count. It happening is therefore a bug.
    if(manif.bChain && !UsePsionicFocus(manif.oManifester))
    {
        if(DEBUG) DoDebug(DebugObject2Str(manif.oManifester) + " unable to pay psionic focus for Chain Power!");
        manif.bChain = FALSE;
    }
    else
        sInform += (sInform == "" ? "": ", ") + GetStringByStrRef(16826631); // "Chained"
    if(manif.bEmpower && !UsePsionicFocus(manif.oManifester))
    {
        if(DEBUG) DoDebug(DebugObject2Str(manif.oManifester) + " unable to pay psionic focus for Empower Power!");
        manif.bEmpower = FALSE;
    }
    else
        sInform += (sInform == "" ? "": ", ") + GetStringByStrRef(16826632); // "Empowered"
    if(manif.bExtend && !UsePsionicFocus(manif.oManifester))
    {
        if(DEBUG) DoDebug(DebugObject2Str(manif.oManifester) + " unable to pay psionic focus for Extend Power!");
        manif.bExtend = FALSE;
    }
    else
        sInform += (sInform == "" ? "": ", ") + GetStringByStrRef(16826633); // "Extended"
    if(manif.bMaximize && !UsePsionicFocus(manif.oManifester))
    {
        if(DEBUG) DoDebug(DebugObject2Str(manif.oManifester) + " unable to pay psionic focus for Maximize Power!");
        manif.bMaximize = FALSE;
    }
    else
        sInform += (sInform == "" ? "": ", ") + GetStringByStrRef(16826634); // "Maximized"
    if(manif.bSplit && !UsePsionicFocus(manif.oManifester))
    {
        if(DEBUG) DoDebug(DebugObject2Str(manif.oManifester) + " unable to pay psionic focus for Split Psionic Ray!");
        manif.bSplit = FALSE;
    }
    else
        sInform += (sInform == "" ? "": ", ") + GetStringByStrRef(16826635); // "Split"
    if(manif.bTwin && !UsePsionicFocus(manif.oManifester))
    {
        if(DEBUG) DoDebug(DebugObject2Str(manif.oManifester) + " unable to pay psionic focus for Twin Power!");
        manif.bTwin = FALSE;
    }
    else
        sInform += (sInform == "" ? "": ", ") + GetStringByStrRef(16826636); // "Twinned"
    if(manif.bWiden && !UsePsionicFocus(manif.oManifester))
    {
        if(DEBUG) DoDebug(DebugObject2Str(manif.oManifester) + " unable to pay psionic focus for Widen Power!");
        manif.bWiden = FALSE;
    }
    else
        sInform += (sInform == "" ? "": ", ") + GetStringByStrRef(16826637); // "Widened"

    // Finalise and display the information string if the manifestation was successfull
    if(manif.bCanManifest)
    {
        // Determine the index of the last comma
        /// @todo This is badly structured, rewrite
        string sTemp = sInform;
        int nComma,
            nTemp = FindSubString(sTemp, ", ");
        if(nTemp != -1)
        {
            sTemp = GetSubString(sTemp,
                                 nTemp + 2, // Crop off the comma and the following space
                                 GetStringLength(sTemp) // I'm lazy
                                 );
            nComma += nTemp +2;
            while((nTemp = FindSubString(sTemp, ", ")) != -1)
            {
                nComma += nTemp + 2;
                sTemp = GetSubString(sTemp, nTemp + 2, GetStringLength(sTemp));
            }

            // Replace the last comma with an "and"
            sInform = GetStringLeft(sInform, nComma - 2)
                    + " " + GetStringByStrRef(16826638) + " " // " and "
                    + GetSubString(sInform, nComma, GetStringLength(sInform) - nComma);
        }


        // Finish the information string
        sInform += " " + GetStringByStrRef(16826639); // "Power"

        FloatingTextStringOnCreature(sInform, manif.oManifester, FALSE);
    }

    return manif;
}


int MetaPsionicsDamage(struct manifestation manif, int nDieSize, int nNumberOfDice, int nBonus = 0,
                       int nBonusPerDie = 0, int bDoesHPDamage = FALSE, int bIsRayOrRangedTouch = FALSE)
{
    int nBaseDamage  = 0,
        nBonusDamage = nBonus + (nNumberOfDice * nBonusPerDie);

    // Calculate the base damage
    int i;
    for (i = 0; i < nNumberOfDice; i++)
        nBaseDamage += Random(nDiceSize) + 1;


    // Apply general modifying effects
    if(bDoesHPDamage)
    {
        if(bIsRayOrRangedTouch &&
           GetHasFeat(FEAT_POWER_SPECIALIZATION, manif.oManifester))
        {
            if(GetLocalInt(manif.oManifester, "PowerSpecializationActive") && UsePsionicFocus(manif.oManifester))
                nBonusDamage += GetAbilityModifier(GetAbilityOfClass(GetManifestingClass(manif.oManifester)));
            else
                nBonusDamage += 2;
       }
        /// @todo Farm out to a separate function that accounts for a single target's modifications. That one should handle all the other target specific stuff, too
        /*
        if(GetHasFeat(FEAT_GREATER_POWER_SPECIALIZATION, manif.oManifester) &&
           GetDistanceBetween(oTarget, manif.oManifester) <= 9.144f)
            nBonusDamage += 2;
        */
    }

    // Apply metapsionics
    // Both empower & maximize
    if(manif.bEmpower && manif.bMaximize)
    {
        nBaseDamage = nBaseDamage / 2 + nDiceSize * nNumberOfDice;
        FloatingTextStrRefOnCreature(, manif.oManifester, FALSE); // "Empowered and Maximized Power"
    }
    // Just empower
    else if(manif.bEmpower)
    {
        nBaseDamage += nBaseDamage / 2;
        FloatingTextStrRefOnCreature(, manif.oManifester, FALSE); // "Empowered Power"
    }
    // Just maximize
    else if(manif.bMaximize)
    {
        nBaseDamage = nDiceSize * nNumberOfDice;
        FloatingTextStrRefOnCreature(, manif.oManifester, FALSE); // "Maximized Power"
    }


    return nBaseDamage + nBonusDamage;
}


float EvaluateWidenPower(struct manifestation manif, float fBase)
{
    return manif.bWiden ? // Is Widen Power active
            fBase * 2 :   // Yes
            fBase;        // No
}


void EvaluateChainPower(struct manifestation manif, object oPrimaryTarget, int bAutoDelete = TRUE)
{
    // Delete the array if, for some reason, one exists already
    if(array_exists(manif.oManifester, PRC_CHAIN_POWER_ARRAY))
        array_delete(manif.oManifester, PRC_CHAIN_POWER_ARRAY);
    // Create the array
    if(!array_create(manif.oManifester, PRC_CHAIN_POWER_ARRAY))
        if(DEBUG) DoDebug("EvaluateChainPower(): ERROR: Cannot create target array!\n"
                        + "manif = " + DebugManifestation2Str(manif) + "\n"
                        + "oPrimaryTarget = " + DebugObject2Str(oPrimaryTarget) + "\n"
                        + "bAutoDelete = " + BooleanToString(bAutoDelete) + "\n"
                          );

	// Add the primary target to the array
	array_set_object(manif.oManifester, PRC_CHAIN_POWER_ARRAY, 0, oPrimaryTarget);

	// Determine if Chain Power is active at all
	if(manif.bChain)
	{
	    // It is, determine amount of secondary targets and range to look for the over
	    int nMaxTargets = min(manif.nManifesterLevel, 20); // Chain Power maxes out at 20 secondary targets
	    float fRange = FeetToMeters(30.0f);
	    location lTarget = GetLocation(oPrimaryTarget);
	    object oSecondaryTarget;

	    // Build the target list as a linked list
	    oSecondaryTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	while(GetIsObjectValid(oTarget))
    	{
    		if(oSecondaryTarget != manif.oManifester &&     // Not the manifester
               oSecondaryTarget != oPrimaryTarget    &&     // Not the main target
               spellsIsTarget(oSecondaryTarget,             // Chain Power allows one to avoid hitting friendlies
                              SPELL_TARGET_STANDARDHOSTILE, // and we assume the manifester does so
                              manif.oManifester))
    		{
    			AddToTargetList(oSecondaryTarget, manif.oManifester, INSERTION_BIAS_CR, TRUE);
    		}// end if - target is valid for this

    		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    	}// end while - loop through all potential targets

    	// Extract the linked list into the array
    	while(GetIsObjectValid(oSecondaryTarget = GetTargetListHead(manif.oManifester)))
    	    array_set_object(manif.oManifester, PRC_CHAIN_POWER_ARRAY,
    	                     array_get_size(manif.oManifester, PRC_CHAIN_POWER_ARRAY),
    	                     oSecondaryTarget
    	                     );
	}// end if - is Chain Power active in this manifestation

	// Schedule array deletion if so specified
	if(bAutoDelete)
	    DelayCommand(0.0f, array_delete(manif.oManifester, PRC_CHAIN_POWER_ARRAY));
}