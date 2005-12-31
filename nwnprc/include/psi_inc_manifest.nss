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

const string PRC_MANIFESTING_CLASS = "PRC_CurrentManifest_ManifestingClass";
const string PRC_POWER_LEVEL       = "PRC_CurrentManifest_PowerLevel";
const string PRC_IS_PSILIKE        = "PRC_CurrentManifest_IsPsiLikeAbility";


//////////////////////////////////////////////////
/*                 Structures                   */
//////////////////////////////////////////////////

/**
 * A structure that contains common data used during power manifestation.
 */
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
    /// The power's spell ID
    int nSpellID;

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
};

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * @todo Write
 */
struct manifestation EvaluateManifestation(object oManifester, object oTarget, struct power_augment_profile pap, int nMetaPsiFlags);

/**
 * Causes OBJECT_SELF to use the given power.
 *
 * @param nPower         The index of the power to use in spells.2da or a POWER_*
 * @param nClass         The index of the class to use the power as in classes.2da or a CLASS_TYPE_*
 * @param bIsPsiLike     Whether the power to be used is to be a normal use or a psi-like ability, which
 *                       acts somewhat differently.
 *                       Default: FALSE, meaning a normal power.
 * @param nLevelOverride An optional override to normal manifester level. This is necessary when
 *                       using the power as a psi-like ability.
 *                       Default: 0, which means the parameter is ignored.
 */
void UsePower(int nPower, int nClass, int bIsPsiLike = FALSE, int nLevelOverride = 0);

/**
 * A debugging function. Takes a manifestation structure and
 * makes a string describing the contents.
 *
 * @param manif A set of manifestation data
 * @return      A string describing the contents of manif
 */
string DebugManifestation2Str(struct manifestation manif);

/**
 * Stores a manifestation structure as a set of local variables. If
 * a structure was already stored with the same name on the same object,
 * it is overwritten.
 *
 * @param oObject The object on which to store the structure
 * @param sName   The name under which to store the structure
 * @param manif   The manifestation structure to store
 */
void SetLocalManifestation(object oObject, string sName, struct manifestation manif);

/**
 * Retrieves a previously stored manifestation structure. If no structure is stored
 * by the given name, the structure returned is empty.
 *
 * @param oObject The object from which to retrieve the structure
 * @param sName   The name under which the structure is stored
 * @return        The structure built from local variables stored on oObject under sName
 */
struct manifestation GetLocalManifestation(object oObject, string sName);

/**
 * Deletes a stored manifestation structure.
 *
 * @param oObject The object on which the structure is stored
 * @param sName   The name under which the structure is stored
 */
void DeleteLocalManifestation(object oObject, string sName);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "psi_inc_ppoints" // Provides psi_inc_focus and psi_inc_psifunc
#include "psi_inc_augment" // Provides inc_utility
#include "psi_inc_metapsi"


//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

/** Internal function.
 * Calculates PP cost reduction from various factors. Currently accounts for:
 * - Thrallherd
 *
 * @param manif The manifestation data relating to this particular manifesation
 * @retrun      The manifestation data, possibly with modified costs
 */
struct manifestation _GetPPCostReduced(struct manifestation manif)
{
    int nSpell   = PRCGetSpellId();
    int nThrall  = GetLevelByClass(CLASS_TYPE_THRALLHERD, manif.oManifester);

    if(nThrall > 0)
    {
        if(GetLocalInt(manif.oManifester, "ThrallCharm") && nSpell == POWER_CHARMPERSON)
        {
            DeleteLocalInt(manif.oManifester, "ThrallCharm");
            manif.nPPCost -= nThrall;
        }
        if(GetLocalInt(manif.oManifester, "ThrallDom") && nSpell == POWER_DOMINATE)
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
    }

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

    if(nTelepathy   && // Only affects telepathy powers.
       nWilder >= 5 && // Only wilders need apply
       // Since the "As a standard action, a wilder can choose to lower this effect for 1 round."
       // bit is not particularly doable in NWN, we implement it so that the class feature
       // only affects powers from hostile manifesters
       GetIsEnemy(oTarget, oManifester)
       )
    {
        nCost = ((nWilder - 5) / 4) + 1;
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

/** Internal function.
 * Applies the damage caused by use of Overchannel feat.
 *
 * @param oManifester The creature currently manifesting a power
 * @param bIsPsiLike  Whether the power being manifester is a psi-like ability or not
 */
void _DoOverchannelDamage(object oManifester, int bIsPsiLike)
{
    int nOverchannel = GetLocalInt(oManifester, PRC_OVERCHANNEL);
    if(nOverchannel > 0 && !bIsPsiLike)
    {
        int nDam = d8(nOverchannel * 2 - 1);
        // Check if Talented applies
        if(GetPowerLevel(oManifester) <= 3)
        {
            if(GetLocalInt(oManifester, "TalentedActive") && UsePsionicFocus(oManifester))
                return;
            /* Should we be merciful and let the feat be "retroactively activated" if the damage were enough to kill?
            else if(GetCurrentHitPoints(oCaster) < nDam && GetHasFeat(FEAT_TALENTED, oCaster) && UsePsionicFocus(oCaster))
                return;*/
        }
        effect eDam = EffectDamage(nDam);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oManifester);
    }
}

/** Internal function.
 * If the manifester is a wilder who is using Wild Surge, rolls and
 * applies Psychic Enervation or Surging Euphoria based on the result.
 *
 * @param oManifester The creature currently manifesting a power
 */
void _SurgingEuphoriaOrPsychicEnervation(object oManifester, int nWildSurge)
{
    int nWilder    = GetLevelByClass(CLASS_TYPE_WILDER, oManifester);

    // Only Wilders need apply (at least so far)
    if(nWilder > 0 && nWildSurge)
    {
        // Psychic Enervation has a 5% chance to happen per point Wild Surged by
        if(nWildSurge >= d20())
        {
            effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
            effect eDaze = EffectDazed();
            effect eLink = EffectLinkEffects(eMind, eDaze);
            eLink = ExtraordinaryEffect(eLink);

            FloatingTextStrRefOnCreature(16823620, oManifester, FALSE); // "You have become psychically enervated and lost power points"
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oManifester, RoundsToSeconds(1));

            LosePowerPoints(oManifester, nWilder);
        }
        // Need minimum wilder level 4 to be eligible for Surging Euphoria. And it only happens when there is no Enervation
        else if(nWilder >= 4)
        {
            // Euphoria is 1 at levels 4 - 11, 2 at L 12 - 19, 3 at L 20 - 27, etc.
            int nEuphoria = ((nWilder - 4) / 8) + 1;

            effect eBonAttack = EffectAttackIncrease(nEuphoria);
            effect eBonDam    = EffectDamageIncrease(nEuphoria, DAMAGE_TYPE_MAGICAL);
            effect eVis       = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
            effect eSave      = EffectSavingThrowIncrease(SAVING_THROW_ALL, nEuphoria, SAVING_THROW_TYPE_SPELL);
            effect eDur       = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eDur2      = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
            effect eLink      = EffectLinkEffects(eSave, eDur);
            eLink = EffectLinkEffects(eLink, eDur2);
            eLink = EffectLinkEffects(eLink, eBonDam);
            eLink = EffectLinkEffects(eLink, eBonAttack);
            eLink = ExtraordinaryEffect(eLink);

            FloatingTextStringOnCreature(GetStringByStrRef(16823616) + ": " + IntToString(nWildSurge), oManifester, FALSE); // "Surging Euphoria: "
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oManifester, RoundsToSeconds(nWildSurge));
        }
    }
}

/** Internal function.
 * Applies the PP loss caused by the target having Mind Trap active.
 *
 * @param oManifester A creature currently manifesting a power at oTarget
 * @param oTarget     The target of the power being manifested
 */
void _DoMindTrapPPLoss(object oManifester, object oTarget)
{
    if(oManifester != oTarget                            && // Does not apply to own powers
       GetLocalInt(oTarget, "PRC_Power_MindTrap_Active") && // The target does have Mind Trap active
       GetIsTelepathyPower()                                // And the power being used is a telepathy power
       )
    {
        LosePowerPoints(oManifester, d6());
    }
}

/** Internal function.
 * Deletes manifestation-related local variables.
 *
 * @param oManifester The creature currently manifesting a power
 */
void _CleanManifestationVariables(object oManifester)
{
    DeleteLocalInt(oManifester, PRC_MANIFESTING_CLASS);
    DeleteLocalInt(oManifester, PRC_POWER_LEVEL);
    DeleteLocalInt(oManifester, PRC_IS_PSILIKE);
    DeleteLocalInt(oManifester, PRC_AUGMENT_OVERRIDE);
}


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
    int bIsPsiLike       = GetLocalInt(oManifester, PRC_IS_PSILIKE);
    // Target-specific stuff
    int nVolatileMindCost = _VolatileMind(oTarget, oManifester);
    int nPsionicHoleCost  = _PsionicHole(oTarget);

    /* Initialise the manifestation structure */
    struct manifestation manif;
    manif.oManifester       = oManifester;
    manif.bCanManifest      = TRUE;                                   // Assume successfull manifestation by default
    manif.nPPCost           = nPowerLevel * 2 - 1;                    // Initialise the cost to the base cost of the power
    manif.nPsiFocUsesRemain = GetPsionicFocusesAvailable(oManifester);// Determine how many times psionic focus could be used
    manif.nManifesterLevel  = nManifesterLevel;
    manif.nSpellID          = PRCGetSpellId();

    // Run an ability score check to see if the manifester can manifest the power at all
    if(GetAbilityScoreOfClass(oManifester, nClass) - 10 < nPowerLevel)
    {
        FloatingTextStrRefOnCreature(16826411, oManifester, FALSE); // "You do not have a high enough ability score to manifest this power"
        manif.bCanManifest = FALSE;
        return manif;
    }

    // Account for augmentation. This factors in Wild Surge cost reduction
    manif = EvaluateAugmentation(manif, pap);

    // Account for metapsionics
    if(!bIsPsiLike) // Skipped for psi-like abilities
        manif = EvaluateMetapsionics(manif, nMetaPsiFlags);


    //* APPLY COST INCREASES THAT DO NOT CAUSE ONE TO LOSE PP ON FAILURE HERE *//
    // Catapsi check
    if(GetLocalInt(oManifester, "PRC_IsInCatapsi") &&                                                // Manifester is in Catapsi field
       !PRCMySavingThrow(SAVING_THROW_WILL, oManifester, GetLocalInt(oManifester, "PRC_Catapsi_DC"), // And fails the will save VS it
                         SAVING_THROW_TYPE_MIND_SPELLS, GetLocalObject(oManifester, "PRC_Catapsi_Manifester")
                         )
       )
    {
       manif.nPPCost += 4;
    }

    //* APPLY COST INCREASES THAT DO NOT CAUSE ONE TO LOSE PP ON FAILURE ABOVE *//

    /* The manifester level value includes the manifester level increase from
     * Wild Surge, but since the calculated cost already contains the augmentation
     * cost reduction provided by Wild Surge, it should not apply here.
     */
    if((nManifesterLevel - nWildSurge) >= manif.nPPCost || bIsPsiLike)
    {
        // Reduced cost of manifesting a power, but does not allow you to exceed the manifester level cap
        if(!bIsPsiLike) // Skipped for psi-like abilities
            manif = _GetPPCostReduced(manif);

        //If the manifester does not have enough points before hostile modifiers, cancel power
        if(manif.nPPCost > nManifesterPP && !bIsPsiLike)
        {
            FloatingTextStrRefOnCreature(16826412, oManifester, FALSE); // "You do not have enough Power Points to manifest this power"
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

            if(manif.nPPCost > nManifesterPP && !bIsPsiLike)
            {
                FloatingTextStrRefOnCreature(16826413, oManifester, FALSE); // "Your target's abilities cause you to use more Power Points than you have. The power fails"
                manif.bCanManifest = FALSE;
            }

            // Psi-like abilities ignore PP costs and metapsi
            if(!bIsPsiLike)
            {
                // Set the power points to their new value and inform the manifester
                LosePowerPoints(oManifester, manif.nPPCost, TRUE);

                // Psionic focus loss from using metapsionics. Has a side effect of telling the manifester which metapsionics were actually active
                PayMetapsionicsFocuses(manif);
            }

            //* APPLY DAMAGE EFFECTS THAT RESULT FROM SUCCESSFULL MANIFESTATION HERE *//
            // Damage from overchanneling happens only if one actually spends PP
            _DoOverchannelDamage(oManifester, bIsPsiLike);
            // Apply Hostile Mind damage, as necessary
            _HostileMind(oManifester, oTarget);
            // Apply Wild Surge side-effects
            _SurgingEuphoriaOrPsychicEnervation(oManifester, nWildSurge);
            // Apply Mind Trap PP loss
            _DoMindTrapPPLoss(oManifester, oTarget);
            //* APPLY DAMAGE EFFECTS THAT RESULT FROM SUCCESSFULL MANIFESTATION ABOVE *//
        }
    }
    // Cost was over the manifester cap
    else
    {// "Your manifester level is not high enough to spend X Power Points"
        FloatingTextStringOnCreature(GetStringByStrRef(16826410) + " " + IntToString(manif.nPPCost) + " " + GetStringByStrRef(16826409), oManifester, FALSE);
        manif.bCanManifest = FALSE;
    }

    if(DEBUG) DoDebug("EvaluateManifestation(): Final result:\n" + DebugManifestation2Str(manif));

    // Initiate manifestation-related variable cleanup
    DelayCommand(0.5f, _CleanManifestationVariables(oManifester));

    return manif;
}

void UsePower(int nPower, int nClass, int bIsPsiLike = FALSE, int nLevelOverride = 0)
{
    object oManifester = OBJECT_SELF;
    if(DEBUG) DoDebug("UsePower(): Manifester is " + DebugObject2Str(oManifester) + "\n"
                    + "nPower = " + IntToString(nPower) + "\n"
                    + "nClass = " + IntToString(nClass) + "\n"
                    + "bIsPsiLike = " + BooleanToString(bIsPsiLike) + "\n"
                    + "nLevelOverride = " + IntToString(nLevelOverride)
                      );

    // Set the class to manifest as
    SetLocalInt(oManifester, PRC_MANIFESTING_CLASS, nClass + 1);

    // Set the power's level
    SetLocalInt(oManifester, PRC_POWER_LEVEL, StringToInt(lookup_spell_innate(PRCGetSpellId())));

    /* Unnecessary, since this is already done by ActionCastSpell
    //override level
    if(nLevelOverride != 0)
        SetLocalInt(oManifester, PRC_CASTERLEVEL_OVERRIDE, nLevelOverride);*/

    // Set whether the power is to run as a psi-like ability
    SetLocalInt(oManifester, PRC_IS_PSILIKE, bIsPsiLike);

    // Nuke action queue to prevent cheating with creative power stacking
    if(DEBUG) SendMessageToPC(oManifester, "Clearing all actions in preparation for second stage of the power.");
    ClearAllActions();

    ActionCastSpell(nPower, nLevelOverride);
}

string DebugManifestation2Str(struct manifestation manif)
{
    string sRet;

    sRet += "oManifester = " + DebugObject2Str(manif.oManifester) + "\n";
    sRet += "bCanManifest = " + BooleanToString(manif.bCanManifest) + "\n";
    sRet += "nPPCost = "           + IntToString(manif.nPPCost) + "\n";
    sRet += "nPsiFocUsesRemain = " + IntToString(manif.nPsiFocUsesRemain) + "\n";
    sRet += "nManifesterLevel = "  + IntToString(manif.nManifesterLevel) + "\n";

    sRet += "nTimesAugOptUsed_1 = " + IntToString(manif.nTimesAugOptUsed_1) + "\n";
    sRet += "nTimesAugOptUsed_2 = " + IntToString(manif.nTimesAugOptUsed_2) + "\n";
    sRet += "nTimesAugOptUsed_3 = " + IntToString(manif.nTimesAugOptUsed_3) + "\n";
    sRet += "nTimesAugOptUsed_4 = " + IntToString(manif.nTimesAugOptUsed_4) + "\n";
    sRet += "nTimesAugOptUsed_5 = " + IntToString(manif.nTimesAugOptUsed_5) + "\n";
    sRet += "nTimesGenericAugUsed = " + IntToString(manif.nTimesGenericAugUsed) + "\n";

    sRet += "bChain    = " + BooleanToString(manif.bChain)    + "\n";
    sRet += "bEmpower  = " + BooleanToString(manif.bEmpower)  + "\n";
    sRet += "bExtend   = " + BooleanToString(manif.bExtend)   + "\n";
    sRet += "bMaximize = " + BooleanToString(manif.bMaximize) + "\n";
    sRet += "bSplit    = " + BooleanToString(manif.bSplit)    + "\n";
    sRet += "bTwin     = " + BooleanToString(manif.bTwin)     + "\n";
    sRet += "bWiden    = " + BooleanToString(manif.bWiden);//    + "\n";

    return sRet;
}

void SetLocalManifestation(object oObject, string sName, struct manifestation manif)
{
    //SetLocal (oObject, sName + "_", );
    SetLocalObject(oObject, sName + "_oManifester", manif.oManifester);

    SetLocalInt(oObject, sName + "_bCanManifest",      manif.bCanManifest);
    SetLocalInt(oObject, sName + "_nPPCost",           manif.nPPCost);
    SetLocalInt(oObject, sName + "_nPsiFocUsesRemain", manif.nPsiFocUsesRemain);
    SetLocalInt(oObject, sName + "_nManifesterLevel",  manif.nManifesterLevel);
    SetLocalInt(oObject, sName + "_nSpellID",          manif.nSpellID);

    SetLocalInt(oObject, sName + "_nTimesAugOptUsed_1", manif.nTimesAugOptUsed_1);
    SetLocalInt(oObject, sName + "_nTimesAugOptUsed_2", manif.nTimesAugOptUsed_2);
    SetLocalInt(oObject, sName + "_nTimesAugOptUsed_3", manif.nTimesAugOptUsed_3);
    SetLocalInt(oObject, sName + "_nTimesAugOptUsed_4", manif.nTimesAugOptUsed_4);
    SetLocalInt(oObject, sName + "_nTimesAugOptUsed_5", manif.nTimesAugOptUsed_5);
    SetLocalInt(oObject, sName + "_nTimesGenericAugUsed", manif.nTimesGenericAugUsed);

    SetLocalInt(oObject, sName + "_bChain",    manif.bChain);
    SetLocalInt(oObject, sName + "_bEmpower",  manif.bEmpower);
    SetLocalInt(oObject, sName + "_bExtend",   manif.bExtend);
    SetLocalInt(oObject, sName + "_bMaximize", manif.bMaximize);
    SetLocalInt(oObject, sName + "_bSplit",    manif.bSplit);
    SetLocalInt(oObject, sName + "_bTwin",     manif.bTwin);
    SetLocalInt(oObject, sName + "_bWiden",    manif.bWiden);
}

struct manifestation GetLocalManifestation(object oObject, string sName)
{
    struct manifestation manif;
    manif.oManifester = GetLocalObject(oObject, sName + "_oManifester");

    manif.bCanManifest      = GetLocalInt(oObject, sName + "_bCanManifest");
    manif.nPPCost           = GetLocalInt(oObject, sName + "_nPPCost");
    manif.nPsiFocUsesRemain = GetLocalInt(oObject, sName + "_nPsiFocUsesRemain");
    manif.nManifesterLevel  = GetLocalInt(oObject, sName + "_nManifesterLevel");
    manif.nSpellID          = GetLocalInt(oObject, sName + "_nSpellID");

    manif.nTimesAugOptUsed_1 = GetLocalInt(oObject, sName + "_nTimesAugOptUsed_1");
    manif.nTimesAugOptUsed_2 = GetLocalInt(oObject, sName + "_nTimesAugOptUsed_2");
    manif.nTimesAugOptUsed_3 = GetLocalInt(oObject, sName + "_nTimesAugOptUsed_3");
    manif.nTimesAugOptUsed_4 = GetLocalInt(oObject, sName + "_nTimesAugOptUsed_4");
    manif.nTimesAugOptUsed_5 = GetLocalInt(oObject, sName + "_nTimesAugOptUsed_5");
    manif.nTimesGenericAugUsed = GetLocalInt(oObject, sName + "_nTimesGenericAugUsed");

    manif.bChain    = GetLocalInt(oObject, sName + "_bChain");
    manif.bEmpower  = GetLocalInt(oObject, sName + "_bEmpower");
    manif.bExtend   = GetLocalInt(oObject, sName + "_bExtend");
    manif.bMaximize = GetLocalInt(oObject, sName + "_bMaximize");
    manif.bSplit    = GetLocalInt(oObject, sName + "_bSplit");
    manif.bTwin     = GetLocalInt(oObject, sName + "_bTwin");
    manif.bWiden    = GetLocalInt(oObject, sName + "_bWiden");

    return manif;
}

void DeleteLocalManifestation(object oObject, string sName)
{
    DeleteLocalObject(oObject, sName + "_oManifester");

    DeleteLocalInt(oObject, sName + "_bCanManifest");
    DeleteLocalInt(oObject, sName + "_nPPCost");
    DeleteLocalInt(oObject, sName + "_nPsiFocUsesRemain");
    DeleteLocalInt(oObject, sName + "_nManifesterLevel");
    DeleteLocalInt(oObject, sName + "_nSpellID");

    DeleteLocalInt(oObject, sName + "_nTimesAugOptUsed_1");
    DeleteLocalInt(oObject, sName + "_nTimesAugOptUsed_2");
    DeleteLocalInt(oObject, sName + "_nTimesAugOptUsed_3");
    DeleteLocalInt(oObject, sName + "_nTimesAugOptUsed_4");
    DeleteLocalInt(oObject, sName + "_nTimesAugOptUsed_5");
    DeleteLocalInt(oObject, sName + "_nTimesGenericAugUsed");

    DeleteLocalInt(oObject, sName + "_bChain");
    DeleteLocalInt(oObject, sName + "_bEmpower");
    DeleteLocalInt(oObject, sName + "_bExtend");
    DeleteLocalInt(oObject, sName + "_bMaximize");
    DeleteLocalInt(oObject, sName + "_bSplit");
    DeleteLocalInt(oObject, sName + "_bTwin");
    DeleteLocalInt(oObject, sName + "_bWiden");
}
