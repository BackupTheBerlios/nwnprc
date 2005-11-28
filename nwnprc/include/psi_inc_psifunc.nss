/*
   ----------------
   prc_psi_ppoints
   ----------------

   19/10/04 by Stratovarius

   Calculates the Manifester level, DC, etc.
   Psion, Psychic Warrior, Wilder. (Soulknife does not have Manifester levels)
*/

// Returns the Manifesting Class
// GetCasterClass wont work, so the casting class is set via a localint
int GetManifestingClass(object oCaster = OBJECT_SELF);

// Returns Manifester Level
int GetManifesterLevel(object oCaster, int nSpecificClass = CLASS_TYPE_INVALID);

// Returns the level of a Power
// ==========================
// oCaster  creature currently manifesting a power
//
// Used for Power cost and DC. Only call from scripts triggered when manifesting a power
int GetPowerLevel(object oCaster);

// Gets the manifester's ability score in the given class's manifesting stat
// =========================================================================
// oCaster  creature whose ability score to get
// nClass   a CLASS_TYPE_* constant
int GetAbilityScoreOfClass(object oCaster, int nClass);

// Get the manifesting ability of a class
// ======================================
// nClass   one of the CLASS_TYPE_* constants
//
// Returns one of the ABILITY_* constants
int GetAbilityOfClass(int nClass);

// Returns the psionic DC
int GetManifesterDC(object oCaster = OBJECT_SELF);

// Checks whether manifester has enough PP to cast
// Also adds in metamagic. Enter 0 for those not applicable to power
// If he does, subtract PP and cast power, else power fails
int GetCanManifest(object oCaster, int nAugCost, object oTarget, int nChain, int nEmp, int nExtend, int nMax, int nSplit, int nTwin, int nWiden);

// Checks to see if the caster has suffered psychic enervation
// from a wild surge. If yes, daze and subtract power points.
// Also checks for Surging Euphoria, and applies it, if needed.
void PsychicEnervation(object oCaster, int nWildSurge);

// Checks to see if the power manifested is a Telepathy one
// This is used with the Wilder's Volatile Mind ability.
int GetIsTelepathyPower();

// Increases the cost of a Telepathy power by an
// amount if the target of the spell is a Wilder
int VolatileMind(object oTarget, object oManifester);

// Checks whether the target has Hostile Mind feat and takes appropriate action if they do
// =======================================================================================
// oCaster  creature manifesting a power
// oTarget  creature being manifested at
void HostileMind(object oCaster, object oTarget);

// Deals damage from overchanneling if it is active
// ================================================
// oCaster  creature manifesting a power
void DoOverchannelDamage(object oCaster);

// Returns the number of powers a character posseses from a specific class
int GetPowerCount(object oPC, int nClass);

// Returns the maximum number of powers a character may posses from a specific class
// =================================================================================
// oPC      character to calculate maximum powers for
// nClass   CLASS_TYPE_PSION / CLASS_TYPE_PSYWAR / CLASS_TYPE_WILDER
int GetMaxPowerCount(object oPC, int nClass);

// Checks the feat.2da prereqs for a specific power
// Only deals with AND/OR feat requirements at the moment
// Also checks that the PC doesnt already have the feat
int CheckPowerPrereqs(int nFeat, object oPC);

// Run this to specify what class is casting it and then it will cheat-cast the real
// power.
void UsePower(int nPower, int nClass, int bIgnorePP = FALSE, int nLevelOverride = 0); //-1); - Freaky that this even passed compilation -Ornedan

// This will roll the dice and perform the needed adjustments for metapsionics and other bonus damage sources
// ==========================================================================================================
// nDiceSize            size of dice to use
// nNumberOfDice        amount of dice to roll
// nMetaPsi             the value gotten from GetCanManifest
// oCaster              manifesting creature
// bDoesHPDamage        whether the power deals hit point damage or not
// oTarget              target creature
// bIsRayOrRangedTouch  whether the power is a ray or a ranged touch attack
int MetaPsionics(int nDiceSize, int nNumberOfDice, int nMetaPsi, object oCaster = OBJECT_SELF,
                 int bDoesHPDamage = FALSE, object oTarget = OBJECT_INVALID, int bIsRayOrRangedTouch = FALSE);

// This will return the amount of augmentation
int GetAugmentLevel(object oCaster = OBJECT_SELF);

// This will return the amount of penetration for a given power
int GetPsiPenetration(object oCaster = OBJECT_SELF);

// Performs the widening operation for Widen MetaPsi
float DoWiden(float fWidth, int nMetaPsi);

// Returns whether the creature is a psionic being or not
// ======================================================
// oCreature    creature to test
int GetIsPsionicCharacter(object oCreature);

// Performs the respawning operation of the Astral Seed spell
void AstralSeedRespawn(object oPlayer = OBJECT_SELF);

// Returns the equivalent added caster levels from Psionic Prestige Classes.
int GetPsionicPRCLevels(object oCaster);

// Returns TRUE if nClass is an psionic manifesting class, FALSE otherwise.
int GetIsPsionicClass(int nClass);

// Returns the CLASS_TYPE of the first Psionic caster class possessed by the character
// or CLASS_TYPE_INVALID if there is none.
int GetFirstPsionicClass (object oCaster = OBJECT_SELF);

// Returns the position that the first Psionic class is in, returns 0 if none.
int GetFirstPsionicClassPosition (object oCaster = OBJECT_SELF);

// Returns the max power level caster can manifest. Should only be used in prc_prereq.
int GetPowerPrereq(int nLevel, int nAbilityScore, int nClass);

// Returns the amount that the cost of the power is to be reduced by
// Used for class abilities such as Thrallherd's Psionic Charm/Dominate
int GetPPCostReduced(int nPP, object oCaster);

//returns the cls_psbk_* file for that class
string GetPsionicFileName(int nClass);

//returns the cls_psipw_* file for that class
string GetPsiBookFileName(int nClass);

//returns TRUE if oPC has the power in any psionic class
//does not include via a racial psi-like ability
int GetHasPower(int nPower, object oPC = OBJECT_SELF);

// Does all the appropriate functions for Psy Warrior unarmed powers.
void DoPsyWarUnarmed(object oCaster, int nPower, int nAugment, float fDuration);

#include "prc_power_const"
#include "lookup_2da_spell"
#include "prc_inc_clsfunc"
#include "inc_utility"
#include "nw_i0_spells"
#include "psi_inc_ppoints"
//#include "psi_inc_focus" Provided by psi_inc_ppoints


// ---------------
// BEGIN FUNCTIONS
// ---------------

string GetPsionicFileName(int nClass)
{
    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psbk"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);
    return sPsiFile;
}

string GetPsiBookFileName(int nClass)
{
    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psipw"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);
    return sPsiFile;
}

int GetManifestingClass(object oCaster)
{
    return GetLocalInt(oCaster, "ManifestingClass");
}

int GetManifesterLevel(object oCaster, int nSpecificClass = CLASS_TYPE_INVALID)
{
    int nLevel;
    int nAdjust = GetLocalInt(oCaster, PRC_CASTERLEVEL_ADJUSTMENT);

    // The function user needs to know the character's manifester level in a specific class
    // instead of whatever the character last manifested a power as
    if(nSpecificClass != CLASS_TYPE_INVALID)
    {
        if(GetIsPsionicClass(nSpecificClass))
        {
            nLevel = GetLevelByClass(nSpecificClass, oCaster);
            // Add levels from +ML PrCs only for the first manifesting class
            if(nSpecificClass == GetFirstPsionicClass(oCaster))
                nLevel += GetPsionicPRCLevels(oCaster);

            return nLevel + nAdjust;
        }
        // A character's manifester level gained from non-manifesting classes is always a nice, round zero
        else
            return 0;
    }

    // Item Spells
    if (GetItemPossessor(GetSpellCastItem()) == oCaster)
    {
        if(DEBUG) SendMessageToPC(oCaster, "Item casting at level " + IntToString(GetCasterLevel(oCaster)));

        return GetCasterLevel(oCaster) + nAdjust;
    }

    // For when you want to assign the caster level.
    else if (GetLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE) != 0)
    {
        if(DEBUG) SendMessageToPC(oCaster, "Forced-level manifesting at level " + IntToString(GetCasterLevel(oCaster)));

        DelayCommand(1.0, DeleteLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE));
        nLevel = GetLocalInt(oCaster, PRC_CASTERLEVEL_OVERRIDE);
    }
    else
    {
        //Gets the level of the manifesting class
        if(DEBUG) SendMessageToPC(oCaster, "Manifesting class: " + IntToString(GetManifestingClass(oCaster)));
        int nManifestingClass = GetManifestingClass(oCaster);
        nLevel = GetLevelByClass(nManifestingClass, oCaster);
        // Add levels from +ML PrCs only for the first manifesting class
        nLevel += nManifestingClass == GetFirstPsionicClass(oCaster) ? GetPsionicPRCLevels(oCaster) : 0;
        if(DEBUG) SendMessageToPC(oCaster, "Level gotten via GetLevelByClass: " + IntToString(nLevel));
    }

    //

    if(nLevel == 0){
        if(DEBUG) DoDebug("Failed to get manifester level for creature " + DebugObject2Str(oCaster) + ", using first class slot");
        nLevel = GetLevelByPosition(1, oCaster);
    }

    //Adding wild surge
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    if (nSurge > 0) nLevel = nLevel + nSurge;

    // Adding overchannel
    int nOverchannel = GetLocalInt(oCaster, "Overchannel");
    if(nOverchannel > 0) nLevel += nOverchannel;

    nLevel += nAdjust;

    FloatingTextStringOnCreature("Manifester Level: " + IntToString(nLevel), oCaster, FALSE);

    return nLevel;
}

int GetPowerLevel(object oCaster)
{
    return GetLocalInt(oCaster, "PowerLevel");
}

int GetAbilityScoreOfClass(object oCaster, int nClass)
{
    return GetAbilityScore(oCaster, GetAbilityOfClass(nClass));
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
    return -1;
}


int GetManifesterDC(object oCaster)
{
    int nClass = GetManifestingClass(oCaster);
    int nDC = 10;
    nDC += GetPowerLevel(oCaster);
    nDC += (GetAbilityScoreOfClass(oCaster, nClass) - 10)/2;

    // Ignoring power points skips feat evaluation
    if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") == TRUE)
        return nDC;

    if (GetLocalInt(oCaster, "PsionicEndowmentActive") == TRUE && UsePsionicFocus(oCaster))
    {
        nDC += GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT, oCaster) ? 4 : 2;
    }

    return nDC;
}

int GetCanManifest(object oCaster, int nAugCost, object oTarget, int nChain, int nEmp, int nExtend, int nMax, int nSplit, int nTwin, int nWiden)
{
    //SpawnScriptDebugger();

    // If ignoring power points, autopass the check. This also means no metapsionics take effect
    // Used for racial psionic abilities
    if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") == TRUE){
         // Apply Hostile Mind damage, as necessary. It applis to all powers, regardless of PP use
        HostileMind(oCaster, oTarget);
        return TRUE;
    }

    /// NONE OF THE FOLLOWING STATEMENTS UP TO THE ABILITY CHECK SHOULD HAVE ANY SIDE-EFFECTS, SUCH AS DAMAGE ///
    // Build the main variables
    int nLevel = GetPowerLevel(oCaster);
    int nAugment = GetAugmentLevel(oCaster);
    int nPP = GetCurrentPowerPoints(oCaster);
    int nPPCost;
    int nMetaPsi, nMetaPsiUses;
    int nCanManifest = TRUE;
    int nVolatile = VolatileMind(oTarget, oCaster);
    int nPsiHole = GetHasFeat(FEAT_PSIONIC_HOLE, oTarget) ? GetAbilityModifier(ABILITY_WISDOM, oTarget) : 0;
        nPsiHole = nPsiHole > 0 ? nPsiHole : 0; // Psionic Hole will never decrease power cost, even if the target is lacking in wisdom bonus
    int nClass = GetManifestingClass(oCaster);

    // Epic feat Improved Metapsionics - 2 PP per.
    int nImpMetapsiReduction, i = FEAT_IMPROVED_METAPSIONICS_1, bUseSum = GetPRCSwitch(PRC_PSI_IMP_METAPSIONICS_USE_SUM);
    while(i < FEAT_IMPROVED_METAPSIONICS_10 && GetHasFeat(i, oCaster))
    {
        nImpMetapsiReduction += 2;
        i++;
    }


    // Ability score check
    if(GetAbilityScoreOfClass(oCaster, nClass) - 10 < nLevel)
    {
        FloatingTextStringOnCreature("You do not have a high enough ability score to manifest this power", oCaster, FALSE);
        return FALSE; // Immediately quit calculating further
    }


    // Sets base Power Point cost based on power level
    nPPCost = nLevel * 2 - 1;


    // Calculate the added cost from metapsionics
    if (nChain > 0 && GetLocalInt(oCaster, "PsiMetaChain") == TRUE)
    {
        nMetaPsi += bUseSum ? 6 :
                     6 - nImpMetapsiReduction < 1 ? 1 : 6 - nImpMetapsiReduction;
        nCanManifest = 2;
        nMetaPsiUses++;
    }
    if (nEmp > 0 && GetLocalInt(oCaster, "PsiMetaEmpower") == TRUE)
    {
        nMetaPsi += 2;
        nCanManifest = 2;
        nMetaPsiUses++;
    }
    if (nExtend > 0 && GetLocalInt(oCaster, "PsiMetaExtend") == TRUE)
    {
        nMetaPsi += 2;
        nCanManifest = 2;
        nMetaPsiUses++;
    }
    if (nMax > 0 && GetLocalInt(oCaster, "PsiMetaMax") == TRUE)
    {
        nMetaPsi += bUseSum ? 4 :
                     4 - nImpMetapsiReduction < 1 ? 1 : 4 - nImpMetapsiReduction;
        nCanManifest = 2;
        nMetaPsiUses++;
    }
    if (nSplit > 0 && GetLocalInt(oCaster, "PsiMetaSplit") == TRUE)
    {
        nMetaPsi += 2;
        nCanManifest = 2;
        nMetaPsiUses++;
    }
    if (nTwin > 0 && GetLocalInt(oCaster, "PsiMetaTwin") == TRUE)
    {
        nMetaPsi += bUseSum ? 6 :
                     6 - nImpMetapsiReduction < 1 ? 1 : 6 - nImpMetapsiReduction;
        nCanManifest = 2;
        nMetaPsiUses++;
    }
    if (nWiden > 0 && GetLocalInt(oCaster, "PsiMetaWiden") == TRUE)
    {
        nMetaPsi += bUseSum ? 4 :
                     4 - nImpMetapsiReduction < 1 ? 1 : 4 - nImpMetapsiReduction;
        nCanManifest = 2;
        nMetaPsiUses++;
    }


    /// APPLY COST INCREASES THAT DO NOT CAUSE ONE TO LOSE PP ON FAILURE HERE ///
    // Adds in the augmentation cost
    if (nAugment > 0) nPPCost = nPPCost + (nAugCost * nAugment);

    //SendMessageToPC(oCaster, "nPPCost: " + IntToString(nPPCost) + "; nMetaPsi: " + IntToString(nMetaPsi));

    // Add in the metapsionic cost
    nPPCost += bUseSum ? nMetaPsi - nImpMetapsiReduction < 1 ? 1 : nMetaPsi - nImpMetapsiReduction
                : nMetaPsi;

    // Catapsi added cost
    if (GetLocalInt(oCaster, "Catapsi")) nPPCost += 4;

    // The power points added from Wild Surge, to prevent the issue reported by OrtRestave
    nPPCost += GetLocalInt(oCaster, "WildSurge");
    /// /APPLY COST INCREASES THAT DO NOT CAUSE ONE TO LOSE PP ON FAILURE HERE ///


    // If PP Cost is greater than Manifester level
    // I have cut out the Wild Surge reduction because of the addition of Wild Surge boosting to the total nPPCost
    // for the purposes of this equation. This is to fix the bug reported by OrtRestave on the forums.
    // The total cost of the power, counting Wild Surge as cost, vs the Wild Surged Manifester leve should solve this issue
    if ((GetManifesterLevel(oCaster)/* - GetLocalInt(oCaster, "WildSurge")*/) >= nPPCost && nCanManifest)
    {
        // Reduced cost of manifesting a power, but does not allow you to exceed the manifester level cap
        // Right now, only used for Thrallherd
        nPPCost = GetPPCostReduced(nPPCost, oCaster);
        // Now that we have used Wild Surge for the previous check, it is not actually subtracted from PP and is removed
        nPPCost -= GetLocalInt(oCaster, "WildSurge");

        //If Manifest does not have enough points before hostile modifiers, cancel power
        if (nPPCost > nPP)
        {
            FloatingTextStringOnCreature("You do not have enough Power Points to manifest this power", oCaster, FALSE);
            nCanManifest = FALSE;
        }
        // Check if the power would fail after Volatile Mind and Psionic Hole are applied
        else
        {
            /// ADD ALL COST INCREASING FACTORS THAT WILL CAUSE PP LOSS EVEN IF THEY MAKE THE POWER FAIL HERE ///
            nPPCost += nVolatile + nPsiHole;
            if((nPPCost) > nPP)
            {
                FloatingTextStringOnCreature("Your target's abilities cause you to use more Power Points than you have. The power fails", oCaster, FALSE);
                nCanManifest = FALSE;
            }

            // Set the power points to their new value and inform the manifester
            LosePowerPoints(oCaster, nPPCost, TRUE);

            // Psionic focus loss from using metapsionics
            int i = 0;
            for(; i < nMetaPsiUses; i++)
                // No metapsi if you can't pay for it. As it is, this requires one to pay
                // for all metapsi used to get any of it
                if(!UsePsionicFocus(oCaster) && nCanManifest) nCanManifest = 1;

            /// APPLY DAMAGE EFFECTS THAT RESULT FROM SUCCESSFULL MANIFESTATION HERE ///
            // Damage from overchanneling happens only if one actually spends PP
            DoOverchannelDamage(oCaster);
            // Apply Hostile Mind damage, as necessary
            HostileMind(oCaster, oTarget);
            /// /APPLY DAMAGE EFFECTS THAT RESULT FROM SUCCESSFULL MANIFESTATION HERE ///
        }
    }
    else
    {
        FloatingTextStringOnCreature("Your manifester level is not high enough to spend that many Power Points", oCaster, FALSE);
        nCanManifest = FALSE;
    }

    return nCanManifest;
}


void PsychicEnervation(object oCaster, int nWildSurge)
{
    if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") == TRUE)
        return;

    int nDice = d20(1);

    if (nWildSurge >= nDice)
    {
        int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oCaster);

        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDaze = EffectDazed();
        effect eLink = EffectLinkEffects(eMind, eDaze);
        eLink = ExtraordinaryEffect(eLink);

        FloatingTextStringOnCreature("You have become psychically enervated and lost power points", oCaster, FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(1));

        //if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") != TRUE) - Already checked at the start of function -Ornedan
        LosePowerPoints(oCaster, nWilder);
    }
    else if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) >= 4)
    {
        int nEuphoria = 1;
        if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) >= 20) nEuphoria = 3;
        else if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) >= 12) nEuphoria = 2;

        effect eBonAttack = EffectAttackIncrease(nEuphoria);
        effect eBonDam = EffectDamageIncrease(nEuphoria, DAMAGE_TYPE_MAGICAL);
        effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nEuphoria, SAVING_THROW_TYPE_SPELL);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eDur2 = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
        effect eLink = EffectLinkEffects(eSave, eDur);
        eLink = EffectLinkEffects(eLink, eDur2);
        eLink = EffectLinkEffects(eLink, eBonDam);
        eLink = EffectLinkEffects(eLink, eBonAttack);
        eLink = ExtraordinaryEffect(eLink);
        FloatingTextStringOnCreature("Surging Euphoria: " + IntToString(nWildSurge), oCaster, FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nWildSurge));
    }
}

int GetIsTelepathyPower()
{
    int nSpell = PRCGetSpellId();
    if (nSpell == 2371 || nSpell == 2373 || nSpell == 2374)
    {
        return TRUE;
    }

    return FALSE;
}

int VolatileMind(object oTarget, object oManifester)
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


void HostileMind(object oCaster, object oTarget)
{
    if(GetIsTelepathyPower())
    {
        int nDC = 10 + GetHitDice(oTarget) / 2 + GetAbilityModifier(ABILITY_CHARISMA, oTarget);
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oCaster, nDC, SAVING_THROW_TYPE_NONE))
        {
            //Apply damage and some VFX
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(2)), oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SPELL_FAIL_HEA), oTarget);
        }
    }
}


void DoOverchannelDamage(object oCaster)
{
    int nOverchannel = GetLocalInt(oCaster, "Overchannel");
    if(nOverchannel > 0)
    {
        int nDam = d8(nOverchannel * 2 - 1);
        // Check if Talented applies
        if(GetPowerLevel(oCaster) <= 3)
        {
            if(GetLocalInt(oCaster, "TalentedActive") && UsePsionicFocus(oCaster))
                return;
            /* Should we be merciful and let the feat be "retroactively activated" if the damage were enough to kill?
            else if(GetCurrentHitPoints(oCaster) < nDam && GetHasFeat(FEAT_TALENTED, oCaster) && UsePsionicFocus(oCaster))
                return;*/
        }
        effect eDam = EffectDamage(nDam);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oCaster);
    }
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

int GetPowerCount(object oPC, int nClass)
{
    if(!persistant_array_exists(oPC, "PsiPowerCount"))
        return 0;
    return persistant_array_get_int(oPC, "PsiPowerCount", nClass);
}

int GetMaxPowerCount(object oPC, int nClass)
{
    int nLevel = GetLevelByClass(nClass, oPC);
        nLevel += GetFirstPsionicClass(oPC) == nClass ? GetPsionicPRCLevels(oPC) : 0;
    if(!nLevel)
        return 0;
    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psbk"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);
    int nMaxPowers = StringToInt(Get2DACache(sPsiFile, "PowersKnown", nLevel-1));

    // Apply the epic feat Power Knowledge - +2 powers known per
    int nFeat;
    switch(nClass)
    {
        case CLASS_TYPE_PSION:
            nFeat = FEAT_POWER_KNOWLEDGE_PSION_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_PSION_10 &&
                  GetHasFeat(nFeat, oPC))
                { nMaxPowers += 2; nFeat++; }
            break;
        case CLASS_TYPE_WILDER:
            nFeat = FEAT_POWER_KNOWLEDGE_WILDER_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_WILDER_10 &&
                  GetHasFeat(nFeat, oPC))
                { nMaxPowers += 2; nFeat++; }
            break;
        case CLASS_TYPE_PSYWAR:
            nFeat = FEAT_POWER_KNOWLEDGE_PSYWAR_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_PSYWAR_10 &&
                  GetHasFeat(nFeat, oPC))
                { nMaxPowers += 2; nFeat++; }
            break;
    }

    return nMaxPowers;
}

void UsePower(int nPower, int nClass, int bIgnorePP = FALSE, int nLevelOverride = 0)
{
    //SpawnScriptDebugger();
    SendMessageToPC(OBJECT_SELF, "UsePower: nPower = " + IntToString(nPower) + "; nClass = " + IntToString(nClass) + "; bIgnorePP = " + (bIgnorePP ? "true":"false") + "; nLevelOverride = " + IntToString(nLevelOverride));
    PrintString("UsePower: nPower = " + IntToString(nPower) + "; nClass = " + IntToString(nClass) + "; bIgnorePP = " + (bIgnorePP ? "true":"false") + "; nLevelOverride = " + IntToString(nLevelOverride));
    //set the class
    SetLocalInt(OBJECT_SELF, "ManifestingClass", nClass);

    //DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "ManifestingClass")); Commented out since it will always be refreshed when a new power is manifested -Ornedan
    //set the spell power
    SetLocalInt(OBJECT_SELF, "PowerLevel", StringToInt(lookup_spell_innate(PRCGetSpellId())));
    //pass in the spell
    //override level
    if(nLevelOverride != 0)
    {
        SetLocalInt(OBJECT_SELF, PRC_CASTERLEVEL_OVERRIDE, nLevelOverride);
        //DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, PRC_CASTERLEVEL_OVERRIDE)); Commented out since it will be removed once it has been used and moreover, one second delay is too short-Ornedan
    }
    //Ignore power points?
    SetLocalInt(OBJECT_SELF, "IgnorePowerPoints", bIgnorePP);

    SendMessageToPC(OBJECT_SELF, "Clearing all actions in preparation for second stage of the power.");
    /*AssignCommand(OBJECT_SELF, */ClearAllActions()/*)*/;

    ActionCastSpell(nPower, nLevelOverride);
}

int MetaPsionics(int nDiceSize, int nNumberOfDice, int nMetaPsi, object oCaster = OBJECT_SELF,
                 int bDoesHPDamage = FALSE, object oTarget = OBJECT_INVALID, int bIsRayOrRangedTouch = FALSE)
{
    int nBaseDamage,  // Implicit initializations to zero
        nBonusDamage;

    // Calculate the base damage
    int i;
    for (i = 0; i < nNumberOfDice; i++)
        nBaseDamage += Random(nDiceSize) + 1;


    // Apply general modifying effects
    if(bDoesHPDamage)
    {
        if(bIsRayOrRangedTouch &&
           GetHasFeat(FEAT_POWER_SPECIALIZATION, oCaster))
        {
            if(GetLocalInt(oCaster, "PowerSpecializationActive") && UsePsionicFocus(oCaster))
                nBonusDamage += GetAbilityModifier(GetAbilityOfClass(GetManifestingClass(oCaster)));
            else
                nBonusDamage += 2;
        }
        if(GetHasFeat(FEAT_GREATER_POWER_SPECIALIZATION, oCaster) &&
           GetDistanceBetween(oTarget, oCaster) <= 9.144f)
            nBonusDamage += 2;
    }

    // Ignoring power points ignores metapsionics, too
    if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") == TRUE)
        return nBaseDamage + nBonusDamage;

    // Apply metapsionics
    if(nMetaPsi == 2)
    {
        // Both empower & maximize
        if(GetLocalInt(oCaster, "PsiMetaEmpower") && GetLocalInt(oCaster, "PsiMetaMax"))
        {
            nBaseDamage = nBaseDamage / 2 + nDiceSize * nNumberOfDice;
            FloatingTextStringOnCreature("Empowered and Maximized Power", oCaster, FALSE);
        }
        // Just empower
        else if(GetLocalInt(oCaster, "PsiMetaEmpower"))
        {
            nBaseDamage += nBaseDamage / 2;
            FloatingTextStringOnCreature("Empowered Power", oCaster, FALSE);
        }
        // Just maximize
        else if(GetLocalInt(oCaster, "PsiMetaMax"))
        {
            nBaseDamage = nDiceSize * nNumberOfDice;
            FloatingTextStringOnCreature("Maximized Power", oCaster, FALSE);
        }
    }


    return nBaseDamage + nBonusDamage;
}

int GetAugmentLevel(object oCaster = OBJECT_SELF)
{
    int nAug = GetLocalInt(oCaster, "Augment");
    if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") == TRUE)
        return 0;
    return nAug;
}

int GetPsiPenetration(object oCaster = OBJECT_SELF)
{
    int nPen = GetManifesterLevel(oCaster);
    if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") == TRUE)
        return nPen;

    // Check for Power Pen feats being used
    if(GetLocalInt(oCaster, "PowerPenetrationActive") == TRUE && UsePsionicFocus(oCaster))
    {
        nPen += GetHasFeat(FEAT_GREATER_POWER_PENETRATION, oCaster) ? 8 : 4;
    }


    return nPen;
}

float DoWiden(float fWidth, int nMetaPsi)
{
    if (nMetaPsi == 2)
    {
        if (fWidth == RADIUS_SIZE_SMALL)    fWidth = RADIUS_SIZE_MEDIUM;
        if (fWidth == RADIUS_SIZE_MEDIUM)   fWidth = RADIUS_SIZE_LARGE;
        if (fWidth == RADIUS_SIZE_LARGE)    fWidth = RADIUS_SIZE_HUGE;
        if (fWidth == RADIUS_SIZE_HUGE)     fWidth = RADIUS_SIZE_GARGANTUAN;
        if (fWidth == RADIUS_SIZE_GARGANTUAN)   fWidth = RADIUS_SIZE_COLOSSAL;
        else fWidth *= 2;
    }

    return fWidth;
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

void AstralSeedRespawn(object oPlayer = OBJECT_SELF)
{
    effect eRes = EffectResurrection();
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRes, oPlayer);
    object oSeed = GetLocalObject(oPlayer, "ASTRAL_SEED");
    location lSeed = GetLocation(oSeed);
    DelayCommand(2.0, JumpToLocation(lSeed));

    // effect set
    effect ePara = EffectCutsceneParalyze();
    effect eGhost = EffectCutsceneGhost();
    effect eInvis = EffectEthereal();

    //Massive effect linkage, go me
    effect eSpell = EffectSpellImmunity(SPELL_ALL_SPELLS);
    effect eDam1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100);
    effect eDam2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
    effect eDam3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
    effect eDam4 = EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 100);
    effect eDam5 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
    effect eDam6 = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
    effect eDam7 = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 100);
    effect eDam8 = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    effect eDam9 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
    effect eDam10 = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, 100);
    effect eDam11 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100);
    effect eDam12 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);

    effect eLink = EffectLinkEffects(eSpell, eDam1);
    eLink = EffectLinkEffects(eLink, eDam2);
    eLink = EffectLinkEffects(eLink, eDam3);
    eLink = EffectLinkEffects(eLink, eDam4);
    eLink = EffectLinkEffects(eLink, eDam5);
    eLink = EffectLinkEffects(eLink, eDam6);
    eLink = EffectLinkEffects(eLink, eDam7);
    eLink = EffectLinkEffects(eLink, eDam8);
    eLink = EffectLinkEffects(eLink, eDam9);
    eLink = EffectLinkEffects(eLink, eDam10);
    eLink = EffectLinkEffects(eLink, eDam11);
    eLink = EffectLinkEffects(eLink, eDam12);
    eLink = EffectLinkEffects(eLink, ePara);
    eLink = EffectLinkEffects(eLink, eGhost);
    eLink = EffectLinkEffects(eLink, eInvis);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPlayer, HoursToSeconds(24),TRUE,-1,100);
    int nHD = GetHitDice(oPlayer);
    int nCurrentLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    nHD -= 1;
    int nLevelDown = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = (nCurrentLevel + nLevelDown)/2;
    SetXP(oPlayer,nNewXP);

    DeleteLocalObject(oPlayer, "ASTRAL_SEED");
    DeleteLocalInt(oPlayer, "AstralSeed");

    //pw death hook
    ExecuteScript("prc_pw_astralseed", oPlayer);
    if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oPlayer))
        SetPersistantLocalInt(oPlayer, "persist_dead", FALSE);
}

int GetPsionicPRCLevels (object oCaster)
{
    int nLevel = GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCaster);
    nLevel += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCaster);

    // No manifester level boost at level 1 and 10 for Thrallherd
    if(GetLevelByClass(CLASS_TYPE_THRALLHERD, oCaster))
    {
        nLevel += GetLevelByClass(CLASS_TYPE_THRALLHERD, oCaster) - 1;
        if (GetLevelByClass(CLASS_TYPE_THRALLHERD, oCaster) >= 10) nLevel -= 1;
    }

    return nLevel;
}

int GetIsPsionicClass(int nClass)
{
    return (nClass==CLASS_TYPE_PSION ||
            nClass==CLASS_TYPE_PSYWAR ||
            nClass==CLASS_TYPE_WILDER ||
            nClass==CLASS_TYPE_FIST_OF_ZUOKEN);
}

int GetFirstPsionicClassPosition (object oCaster = OBJECT_SELF)
{
    if (GetIsPsionicClass(PRCGetClassByPosition(1, oCaster)))
        return 1;
    if (GetIsPsionicClass(PRCGetClassByPosition(2, oCaster)))
        return 2;
    if (GetIsPsionicClass(PRCGetClassByPosition(3, oCaster)))
        return 3;

    return 0;
}

int GetFirstPsionicClass (object oCaster = OBJECT_SELF)
{
    int iPsionicPos = GetFirstPsionicClassPosition(oCaster);
    if (!iPsionicPos) return CLASS_TYPE_INVALID; // no Psionic casting class

    return PRCGetClassByPosition(iPsionicPos, oCaster);
}

int GetPowerPrereq(int nLevel, int nAbilityScore, int nClass)
{
    //check ability modifier
    if(nAbilityScore <= 10)
        return 0;

    FloatingTextStringOnCreature("Psionic Class: " + IntToString(nClass), OBJECT_SELF, FALSE);
    FloatingTextStringOnCreature("Class Level: " + IntToString(nLevel), OBJECT_SELF, FALSE);

    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psbk"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);

    FloatingTextStringOnCreature("Filename: " + sPsiFile, OBJECT_SELF, FALSE);

    int nMaxLevel = StringToInt(Get2DACache(sPsiFile, "MaxPowerLevel", nLevel - 1));

    FloatingTextStringOnCreature("Max Power Level: " + IntToString(nMaxLevel), OBJECT_SELF, FALSE);
    //FloatingTextStringOnCreature("Power Level: " + IntToString(nSpellLevel), OBJECT_SELF, FALSE);

    // Return the lesser of maximum manifestable according to class and maximum manifestable according to ability
    return nMaxLevel < nAbilityScore - 10 ? nMaxLevel : nAbilityScore - 10;
    /*
    int N = 0;
    if (nMaxLevel >= nSpellLevel)
    {
        FloatingTextStringOnCreature("Max Level > Power Level", OBJECT_SELF, FALSE);
        N = nSpellLevel;
    }

    FloatingTextStringOnCreature("N: " + IntToString(N), OBJECT_SELF, FALSE);

    return N;
    */
}

int GetPPCostReduced(int nPP, object oCaster)
{
    int nThrall = GetLevelByClass(CLASS_TYPE_THRALLHERD, OBJECT_SELF);
    int nAugment = GetAugmentLevel(oCaster);
    int nSpell = PRCGetSpellId();

    if (GetLocalInt(oCaster, "ThrallCharm") && nSpell == POWER_CHARMPERSON)
    {
        DeleteLocalInt(oCaster, "ThrallCharm");
        nPP -= nThrall;
    }
    if (GetLocalInt(oCaster, "ThrallDom") && nSpell == POWER_DOMINATE)
    {
        DeleteLocalInt(oCaster, "ThrallDom");
        nPP -= nThrall;
    }

    // Reduced cost for augmenting the Dominate power.
    if (nThrall >= 7 && nAugment > 0 && nSpell == POWER_DOMINATE) nPP -= 2;
    if (nThrall >= 9 && nAugment > 2 && nSpell == POWER_DOMINATE) nPP -= 4;

    if (nPP < 1) nPP = 1;

    return nPP;
}

int GetHasPower(int nPower, object oPC = OBJECT_SELF)
{
    if((GetLevelByClass(CLASS_TYPE_PSION, oPC)
            && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_PSION), oPC))
        ||(GetLevelByClass(CLASS_TYPE_PSYWAR, oPC)
            && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_PSYWAR), oPC))
        ||(GetLevelByClass(CLASS_TYPE_WILDER, oPC)
            && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_WILDER), oPC))
        ||(GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oPC)
            && GetHasFeat(GetClassFeatFromPower(nPower, CLASS_TYPE_FIST_OF_ZUOKEN), oPC))
        //add new psionic classes here
        )
        return TRUE;
    return FALSE;
}

void DoPsyWarUnarmed(object oCaster, int nPower, int nAugment, float fDuration)
{
	int nPsyWar = GetLevelByClass(CLASS_TYPE_PSYWAR, oCaster) + GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oCaster);
	int nDamage;
	int nEnhance = 0;
	string sWeapType;

	RemoveUnarmedAttackEffects(oCaster);
	// Make sure they can actually equip them
	UnarmedFeats(oCaster);

	object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
	object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster);

	if (nPower == POWER_BITE_WOLF)
	{
		if (nPsyWar >= 20) nDamage = MONST_DAMAGE_5D8;
		else if (nPsyWar >= 15) nDamage = MONST_DAMAGE_4D8;
		else if (nPsyWar >= 10) nDamage = MONST_DAMAGE_3D8;
		else if (nPsyWar >= 5) nDamage = MONST_DAMAGE_2D8;
		else nDamage = MONST_DAMAGE_1D8;
		// Bite attack
		sWeapType = "PRC_UNARMED_P";
	}

	else if (nPower == POWER_CLAWS_BEAST)
	{
		// Number of times the power has been augmented determines the damage.
		if (nAugment >= 9) nDamage = MONST_DAMAGE_5D6;
		else if (nAugment >= 7) nDamage = MONST_DAMAGE_4D6;
		else if (nAugment >= 5) nDamage = MONST_DAMAGE_3D6;
		else if (nAugment >= 3) nDamage = MONST_DAMAGE_2D6;
		else if (nAugment >= 2) nDamage = MONST_DAMAGE_1D8;
		else if (nAugment >= 1) nDamage = MONST_DAMAGE_1D6;
		else nDamage = MONST_DAMAGE_1D4;
		// Bite attack
		sWeapType = "PRC_UNARMED_S";
	}

	else if (nPower == POWER_METAPHYSICAL_CLAW)
	{
		// Number of times the power has been augmented determines the enhancement bonus.
		if (nAugment >= 5) nEnhance = 5;
		else if (nAugment >= 4) nEnhance = 4;
		else if (nAugment >= 3) nEnhance = 3;
		else if (nAugment >= 2) nEnhance = 2;
		else nEnhance = 1;
	}

	// Only create a new creature weapon if one of those powers is called
	if (nPower = POWER_BITE_WOLF || nPower == POWER_CLAWS_BEAST)
	{
		// Equip the creature weapon.
		if (!GetIsObjectValid(oWeapL) || GetTag(oWeapL) != sWeapType)
		{
			if (GetHasItem(oCaster, sWeapType))
			{
				oWeapL = GetItemPossessedBy(oCaster, sWeapType);
				SetIdentified(oWeapL, TRUE);
				AssignCommand(oCaster, ActionEquipItem(oWeapL, INVENTORY_SLOT_CWEAPON_L));
			}
			else
			{
				oWeapL = CreateItemOnObject(sWeapType, oCaster);
				SetIdentified(oWeapL, TRUE);
				AssignCommand(oCaster,ActionEquipItem(oWeapL, INVENTORY_SLOT_CWEAPON_L));
			}
		}
	}

	// Clean up the mess of extra fists made on taking first level.
	DelayCommand(1.0,CleanExtraFists(oCaster));

	// Weapon finesse or intuitive attack?
	SetLocalInt(oCaster, "UsingCreature", TRUE);
	ExecuteScript("prc_intuiatk", oCaster);
	DelayCommand(1.0f, DeleteLocalInt(oCaster, "UsingCreature"));

	// Add the appropriate damage to the fist.
	AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyMonsterDamage(nDamage),oWeapL, fDuration);
	// Enhancement bonus from Metaphsyical Claw
	AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyEnhancementBonus(nEnhance),oWeapL, fDuration);

	// This adds creature weapon finesse
	ApplyUnarmedAttackEffects(oCaster);

	// This is so you dont keep the claws after the duration ends
	DestroyObject(oWeapL, (fDuration + 6.0));
}