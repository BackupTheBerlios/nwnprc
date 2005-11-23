//::///////////////////////////////////////////////
//:: Psionics include: Metpasionics
//:: psi_inc_metapsi
//::///////////////////////////////////////////////
/** @file
    Defines structures and functions for handling
    manifesting a power.

    @author Ornedan
    @date   Created - 2005.11.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Structures                   */
//////////////////////////////////////////////////


struct manifestation{
    /* Generic stuff */
    /// The creature manifesting the power
    object oManifester;
    /// Whether the manifestation is successfull or not
    int bCanManifest;
    /// How much Power Points the manifestation costs
    int nPPCost;
    /// How many psionic focus uses the manifester would have remaining at a particular point in the manifestation
    int nPsiFocUsesRemain;
    /// The creature's manifester level in regards to this power
    int nManifesterLevel;

    /* Augmentation */
    /// How many times the first augmentation option of the power is used
    int nTimesAugOptUsed_1;
    /// How many times the second augmentation option of the power is used
    int nTimesAugOptUsed_2;
    /// How many times the third augmentation option of the power is used
    int nTimesAugOptUsed_3;
    /// How many times the fourth augmentation option of the power is used
    int nTimesAugOptUsed_4;
    /// How many times the fifth augmentation option of the power is used
    int nTimesAugOptUsed_5;
    /// How many times the PP used for augmentation triggered the generic augmentation of the power
    int nTimesGenericAugUsed;

    /* Metapsionics */
    /// Whether Chain Power was used with this manifestation
    int bChain;
    /// Whether Empower Power was used with this manifestation
    int bEmpower;
    /// Whether Extend Power was used with this manifestation
    int bExtend;
    /// Whether Maximize Power was used with this manifestation
    int bMaximize;
    /// Whether Split Psionic Ray was used with this manifestation
    int bSplit;
    /// Whether Twin Power was used with this manifestation
    int bTwin;
    /// Whether Widen Power was used with this manifestation
    int bWiden;
}

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

struct manifestation EvaluateManifestation(object oManifester, object oTarget, int nMetaPsiFlags);


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

struct manifestation _GetPPCostReduced(struct manifestation manif)
{
    int nThrall  = GetLevelByClass(CLASS_TYPE_THRALLHERD, manif.oManifester);
    int nSpell   = PRCGetSpellId();

    if(GetLocalInt(manif.oManifester, "ThrallCharm") && nSpell == POWER_CHARMPERSON)
    {
        DeleteLocalInt(manif.oManifester, "ThrallCharm");
        manif.nPPCost -= nThrall;
    }
    if(GetLocalInt(oCaster, "ThrallDom") && nSpell == POWER_DOMINATE)
    {
        DeleteLocalInt(manif.oManifester, "ThrallDom");
        manif.nPPCost -= nThrall;
    }

    // Reduced cost for augmenting the Dominate power. These do not count for the DC increase
    if(nThrall >= 7 && nSpell == POWER_DOMINATE && manif.nTimesAugOptUsed_1 > 0)
    {
        manif.nPPCost -= 2;
        manif.nTimesGenericAugUsed -= 1;
    }
    if(nThrall >= 9 && nSpell == POWER_DOMINATE && manif.nTimesAugOptUsed_2 > 0)
    {
        manif.nPPCost -= 4;
        manif.nTimesGenericAugUsed -= 2;
    }

    if(manif.nPPCost < 1) manif.nPPCost = 1;

    return manif;
}

/** Internal function.
 * A wilder that is of high enough level to posses the Volatile Mind class
 * feature causes extra cost to be applied to telepathy powers manifested
 * on it.
 *
 * @param oTarget     Target of the power being manifested at the moment
 * @param oManifester Creature manifesting the power
 * @return            Either 0 if the character does not posses the Volatile
 *                    Mind class feature or the power is not of the telepathy
 *                    discipline. Otherwise, a number determined by the target's
 *                    Wilder level.
 */
int _VolatileMind(object oTarget, object oManifester)
{
    int nWilder    = GetLevelByClass(CLASS_TYPE_WILDER, oTarget);
    int nTelepathy = GetIsTelepathyPower();
    int nCost = 0;

    if (nWilder > 4 && nTelepathy)
    {
        if (GetIsEnemy(oTarget, oManifester))
        {
            if      (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_4, oTarget)) nCost = 4;
            else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_3, oTarget)) nCost = 3;
            else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_2, oTarget)) nCost = 2;
            else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_1, oTarget)) nCost = 1;
        }
    }

    return nCost;
}

/** Internal function.
 * Calculates the extra cost caused by the Psionic Hole feat.
 *
 * @param oTarget The target of a power currently being manifested
 * @return        If the target has the Psionic Hole feat, the greater of
 *                it's Wisdom modifier and 0. Otherwise, just 0.
 */
int _PsionicHole(object oTarget)
{
    int nCost = 0;

    if(GetHasFeat(FEAT_PSIONIC_HOLE, oTarget))
        // Psionic Hole will never decrease power cost, even if the target is lacking in wisdom bonus
        nCost = max(GetAbilityModifier(ABILITY_WISDOM, oTarget), 0);

    return nCost;
}

/** Internal function.
 * Applies Hostile Mind damage if the target posses the feat and is being
 * targeted with a telepathy power.
 *
 * @param oManifester A creature currently manifesting a power at oTarget
 * @param oTarget     The target of the power being manifested.
 */
void _HostileMind(object oManifester, object oTarget)
{
    if(GetHasFeat(FEAT_HOSTILE_MIND, oTarget) && GetIsTelepathyPower())
    {
        // Save DC is 10 + HD/2 + ChaMod
        int nDC = 10 + GetHitDice(oTarget) / 2 + GetAbilityModifier(ABILITY_CHARISMA, oTarget);
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oManifester, nDC, SAVING_THROW_TYPE_NONE))
        {
            //Apply damage and some VFX
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                                  EffectLinkEffects(EffectDamage(d6(2)), EffectVisualEffect(VFX_FNF_SPELL_FAIL_HEA)),
                                  oManifester
                                  );
        }
    }
}

string DebugManifestation2Str(struct manifestation manif)
{
    string sRet;

    sRet += "oManifester = " DebugObject2Str(oManifester) + "\n";
    sRet += "bCanManifest = " + BooleanToString(bCanManifest) + "\n";
    sRet += "nPPCost = " + IntToString(nPPCost) + "\n";
    sRet += "nPsiFocUsesRemain = " + IntToString(nPsiFocUsesRemain) + "\n";
    sRet += "nManifesterLevel = " + IntToString(nManifesterLevel) + "\n";

    sRet += "nTimesAugOptUsed_1 = " + IntToString(nTimesAugOptUsed_1) + "\n";
    sRet += "nTimesAugOptUsed_2 = " + IntToString(nTimesAugOptUsed_2) + "\n";
    sRet += "nTimesAugOptUsed_3 = " + IntToString(nTimesAugOptUsed_3) + "\n";
    sRet += "nTimesAugOptUsed_4 = " + IntToString(nTimesAugOptUsed_4) + "\n";
    sRet += "nTimesAugOptUsed_5 = " + IntToString(nTimesAugOptUsed_5) + "\n";
    sRet += "nTimesGenericAugUsed = " + IntToString(nTimesGenericAugUsed) + "\n";

    sRet += "bChain    = " + BooleanToString(bChain)    + "\n";
    sRet += "bEmpower  = " + BooleanToString(bEmpower)  + "\n";
    sRet += "bExtend   = " + BooleanToString(bExtend)   + "\n";
    sRet += "bMaximize = " + BooleanToString(bMaximize) + "\n";
    sRet += "bSplit    = " + BooleanToString(bSplit)    + "\n";
    sRet += "bTwin     = " + BooleanToString(bTwin)     + "\n";
    sRet += "bWiden    = " + BooleanToString(bWiden);//    + "\n";
}


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "psi_inc_augment" // Provides inc_utility
#include "psi_inc_metapsi"
#include "psi_inc_ppoints" // Provides psi_inc_focus and psi_inc_psifunc


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

struct manifestation EvaluateManifestation(object oManifester, object oTarget, struct power_augment_profile pap, int nMetaPsiFlags)
{
    /* Get some data */
    // Manifester-related stuff
    int nManifesterLevel = GetManifesterLevel(oManifester);
    int nPowerLevel      = GetPowerLevel(oManifester);
    int nClass           = GetManifestingClass(oManifester);
    int nWildSurge       = GetWildSurge(oManifester);
    int nManifesterPP    = GetCurrentPowerPoints(oManifester);
    // Target-specific stuff
    int nVolatileMindCost = _VolatileMind(oTarget, oManifester);
    int nPsionicHoleCost  = _PsionicHole(oTarget);

    /* Initialise the manifestation structure */
    struct manifest manif;
    manif.oManifester       = oManifester;
    manif.bCanManifest      = TRUE;            // Assume successfull manifestation by default
    manif.nPPCost           = nLevel * 2 - 1;  // Initialise the cost to the base cost of the power
    manif.nPsiFocUsesRemain = GetPsionicFocusesAvailable(oManifester);
    manif.nManifesterLevel  = GetManifesterLevel(oManifester);

    // Run an ability score check to see if the manifester can manifest the power at all
    if(GetAbilityScoreOfClass(oManifester, nClass) - 10 < nPowerLevel)
    {
        SendMessageToPCByStrRef(oManifester, ); // "You do not have a high enough ability score to manifest this power"
        manif.bCanManifest = FALSE;
        return manif;
    }

    // Account for augmentation. This factors in Wild Surge cost reduction
    manif = EvaluateAugmentation(manif, pap);

    // Account for metapsionics
    manif = EvaluateMetapsionics(manif, nMetaPsiFlags);


    //* APPLY COST INCREASES THAT DO NOT CAUSE ONE TO LOSE PP ON FAILURE HERE *//
    // Catapsi added cost
    if(GetLocalInt(oManifester, "Catapsi"))
        manif.nPPCost += 4;

    //* APPLY COST INCREASES THAT DO NOT CAUSE ONE TO LOSE PP ON FAILURE ABOVE *//

    /* The manifester level value includes the manifester level increase from
     * Wild Surge, but since the calculated cost already contains the augmentation
     * cost reduction provided by Wild Surge, it should not apply here.
     */
    if((nManifesterLevel - nWildSurge) >= manif.nPPCost)
    {
        // Reduced cost of manifesting a power, but does not allow you to exceed the manifester level cap
        manif = _GetPPCostReduced(manif);

        //If the manifester does not have enough points before hostile modifiers, cancel power
        if(manif.nPPCost > nManifesterPP)
        {
            SendMessageToPCByStrRef(oManifester, ); // "You do not have enough Power Points to manifest this power"
            manif.bCanManifest = FALSE;
        }
        // The manifester has enough power points that they would be able to use the power, barring extra costs
        else
        {
            //* ADD ALL COST INCREASING FACTORS THAT WILL CAUSE PP LOSS EVEN IF THEY MAKE THE POWER FAIL HERE *//
            // Psionic Hole does not count against manifester level cap, but causes the power to fail if the manifester can't pay
            manif.nPPCost += nPsionicHoleCost;
            // Volatile Mind behaves the same
            manif.nPPCost += nVolatileMindCost;
            //* ADD ALL COST INCREASING FACTORS THAT WILL CAUSE PP LOSS EVEN IF THEY MAKE THE POWER FAIL ABOVE *//

            if(manif.nPPCost > nManifesterPP)
            {
                SendMessateToPCByStrRe(oManifester, ); // "Your target's abilities cause you to use more Power Points than you have. The power fails"
                manif.bCanManifest = FALSE;
            }

            // Set the power points to their new value and inform the manifester
            LosePowerPoints(oManifester, manif.nPPCost, TRUE);

            // Psionic focus loss from using metapsionics
            PayMetapsionicsFocuses(manif);

            //* APPLY DAMAGE EFFECTS THAT RESULT FROM SUCCESSFULL MANIFESTATION HERE *//
            // Damage from overchanneling happens only if one actually spends PP
            DoOverchannelDamage(oManifester);
            // Apply Hostile Mind damage, as necessary
            _HostileMind(oManifester, oTarget);
            //* APPLY DAMAGE EFFECTS THAT RESULT FROM SUCCESSFULL MANIFESTATION ABOVE *//
        }
    }
    // Cost was over the manifester cap
    else
    {
        SendMessageToPCByStrRef(oManifester, ); // "Your manifester level is not high enough to spend that many Power Points"
        manif.bCanManifest = FALSE;
    }

    if(DEBUG) DoDebug("EvaluateManifestation(): Final result:\n" + DebugManifestation2Str(manif));

    // Initiate manifestation-related variable cleanup
    DelayCommand(0.5f, _CleanManifestationVariables(oManifester));

    return manif;
}
