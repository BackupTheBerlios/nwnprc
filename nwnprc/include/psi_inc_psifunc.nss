/* 
   ----------------
   prc_psi_ppoints
   ----------------
   
   19/10/04 by Stratovarius
   
   Calculates the Manifester level, DC, etc.
   Psion, Psychic Warrior, Wilder. (Soulknife does not have Manifester levels)
*/

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_power_const"
#include "lookup_2da_spell"
#include "prc_inc_clsfunc"
#include "inc_eventhook"

// Returns the Manifesting Class
// GetCasterClass wont work, so the casting class is set via a localint
int GetManifestingClass(object oCaster = OBJECT_SELF);

// Returns Manifester Level
int GetManifesterLevel(object oCaster = OBJECT_SELF);

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
int VolatileMind(object oTarget, object oCaster);

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

// Grants psionic focus and activates any feats keyed to it
// ========================================================
// oGainee      creature gaining psionic focus
void GainPsionicFocus(object oGainee = OBJECT_SELF);

// Uses up psionic focus
// =====================
// oUser        creature expending it's psionic focus
//
// If oUser is psionically focused when this is called, returns TRUE.
// Also returns TRUE during the next 0.5s a number of times equal to
// the Epic Psionic Focus feats oUser has.
int UsePsionicFocus(object oUser = OBJECT_SELF);

// Calculates the number of times the given creature may use it's psionic focus when it expends it
// ===============================================================================================
// oCreature    creature whose psionic focus use count to evaluate
//
// Returns 1 + the number of Epic Psionic Focus feats oCreature has.
int GetPsionicFocusUsesPerExpenditure(object oCreature = OBJECT_SELF);

// Causes the given creature to lose psionic focus and any benefits keyed to it
// ============================================================================
// oLoser       creature losing it's psionic focus
void LosePsionicFocus(object oLoser = OBJECT_SELF);

// Returns whether the creature is a psionic being or not
// ======================================================
// oCreature    creature to test
int GetIsPsionicCharacter(object oCreature);

// ---------------
// BEGIN FUNCTIONS
// ---------------


int GetManifestingClass(object oCaster)
{
    return GetLocalInt(oCaster, "ManifestingClass");
}

int GetManifesterLevel(object oCaster)
{
    int nLevel;
    // Item Spells
    if (GetItemPossessor(GetSpellCastItem()) == oCaster)
    {
        SendMessageToPC(oCaster, "Item casting at level " + IntToString(GetCasterLevel(oCaster)));

        return GetCasterLevel(oCaster);
    }

    // For when you want to assign the caster level.
    else if (GetLocalInt(oCaster, "PRC_Castlevel_Override") != 0)
    {
        SendMessageToPC(oCaster, "Forced-level manifesting at level " + IntToString(GetCasterLevel(oCaster)));

        DelayCommand(1.0, DeleteLocalInt(oCaster, "PRC_Castlevel_Override"));
        nLevel = GetLocalInt(oCaster, "PRC_Castlevel_Override");
    }
    else
    {
        //Gets the level of the manifesting class
        SendMessageToPC(oCaster, "Manifesting class: " + IntToString(GetManifestingClass(oCaster)));
        nLevel = GetLevelByClass(GetManifestingClass(oCaster), oCaster);
        SendMessageToPC(oCaster, "Level gotten via GetLevelByClass: " + IntToString(nLevel));
    }

    if (nLevel == 0){
        SendMessageToPC(oCaster, "Failed to get manifester level, using first class slot");
        nLevel = GetLevelByPosition(1, oCaster);
    }

    //Adding wild surge
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    if (nSurge > 0) nLevel = nLevel + nSurge;
    
    // Adding overchannel
    int nOverchannel = GetLocalInt(oCaster, "Overchannel");
    if(nOverchannel > 0) nLevel += nOverchannel;

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
    
    // Apply Hostile Mind damage, as necessary. This applies to everything, so it needs to go first.
    HostileMind(oCaster, oTarget);
    
    // If ignoring power points, autopass the check. This also means no metapsionics take effect
    // Used for racial psionic abilities
    if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") == TRUE)
        return TRUE;
    
    int nLevel = GetPowerLevel(oCaster);
    int nAugment = GetAugmentLevel(oCaster);
    int nPP = GetLocalInt(oCaster, "PowerPoints");
    int nPPCost;
    int nMetaPsi;
    int nCanManifest = TRUE;
    int nVolatile = VolatileMind(oTarget, oCaster);
    int nPsiHole = GetHasFeat(FEAT_PSIONIC_HOLE, oTarget) ? GetAbilityModifier(ABILITY_WISDOM, oTarget) : 0;
        nPsiHole = nPsiHole > 0 ? nPsiHole : 0; // Psionic Hole will never decrease power cost, even if the target is lacking in wisdom bonus
    int nClass = GetManifestingClass(oCaster);
    // Epic feat Improved Metapsionics - 2 PP per.
    int nImpMetapsiReduction, i = FEAT_IMPROVED_METAPSIONICS_1, bUseSum = GetPRCSwitch(PRC_PSI_IMP_METAPSIONICS_USE_SUM);
    while(i < FEAT_IMPROVED_METAPSIONICS_10 && GetHasFeat(i, oCaster))
        nImpMetapsiReduction += 2;
    
    
    if(GetAbilityScoreOfClass(oCaster, nClass) - 10 < nLevel)
    {
        FloatingTextStringOnCreature("You do not have a high enough ability score to manifest this power", oCaster, FALSE);
        nCanManifest = FALSE;
    }

    // Sets Power Point cost based on power level
    nPPCost = nLevel * 2 - 1;

    // Adds in the augmentation cost
    if (nAugment > 0) nPPCost = nPPCost + (nAugCost * nAugment);

    // Add in the cost from Metapsionics
    if (nChain > 0 && GetLocalInt(oCaster, "PsiMetaChain") == TRUE && UsePsionicFocus(oCaster))
    {
        nMetaPsi += bUseSum ? 6 :
                     6 - nImpMetapsiReduction < 1 ? 1 : 6 - nImpMetapsiReduction;
        nCanManifest = 2;
    }
    if (nEmp > 0 && GetLocalInt(oCaster, "PsiMetaEmpower") == TRUE && UsePsionicFocus(oCaster))
    {
        nMetaPsi += 2;
        nCanManifest = 2;
    }
    if (nExtend > 0 && GetLocalInt(oCaster, "PsiMetaExtend") == TRUE && UsePsionicFocus(oCaster))
    {
        nMetaPsi += 2;
        nCanManifest = 2;
    }
    if (nMax > 0 && GetLocalInt(oCaster, "PsiMetaMax") == TRUE && UsePsionicFocus(oCaster))
    {
        nMetaPsi += bUseSum ? 4 :
                     4 - nImpMetapsiReduction < 1 ? 1 : 4 - nImpMetapsiReduction;
        nCanManifest = 2;
    }
    if (nSplit > 0 && GetLocalInt(oCaster, "PsiMetaSplit") == TRUE && UsePsionicFocus(oCaster))
    {
        nMetaPsi += 2;
        nCanManifest = 2;
    }
    if (nTwin > 0 && GetLocalInt(oCaster, "PsiMetaTwin") == TRUE && UsePsionicFocus(oCaster))
    {
        nMetaPsi += bUseSum ? 6 :
                     6 - nImpMetapsiReduction < 1 ? 1 : 6 - nImpMetapsiReduction;
        nCanManifest = 2;
    }
    if (nWiden > 0 && GetLocalInt(oCaster, "PsiMetaWiden") == TRUE && UsePsionicFocus(oCaster))
    {
        nMetaPsi += bUseSum ? 4 :
                     4 - nImpMetapsiReduction < 1 ? 1 : 4 - nImpMetapsiReduction;
        nCanManifest = 2;
    }
    
    SendMessageToPC(oCaster, "nPPCost: " + IntToString(nPPCost) + "; nMetaPsi: " + IntToString(nMetaPsi));
    
    nPPCost += bUseSum ? nMetaPsi - nImpMetapsiReduction < 1 ? 1 : nMetaPsi - nImpMetapsiReduction
                : nMetaPsi;

    // If PP Cost is greater than Manifester level
    if (GetManifesterLevel(oCaster) >= nPPCost && nCanManifest)
    {
        //If Manifest does not have enough points before hostile modifiers, cancel power
        if (nPPCost > nPP)
        {
            FloatingTextStringOnCreature("You do not have enough Power Points to manifest this power", oCaster, FALSE);
            nCanManifest = FALSE;
        }
        // Check if the power would fail after Volatile Mind and Psionic Hole are applied
        else
        {
            if((nPPCost + nVolatile + nPsiHole) > nPP)
            {
                FloatingTextStringOnCreature("Your target's abilities cause you to use more Power Points than you have. The power fails", oCaster, FALSE);
                nCanManifest = FALSE;
                SetLocalInt(oCaster, "PowerPoints", 0);
            }
            else //Manifester has enough points, so subtract cost and manifest power
            {
                //Adds in the cost for volatile mind and psionic hole
                nPPCost += nVolatile + nPsiHole;
                nPP = nPP - nPPCost;
                FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
                SetLocalInt(oCaster, "PowerPoints", nPP);
            }
            // Damage from overchanneling happens only if one actually spends PP
            DoOverchannelDamage(oCaster);
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
        int nPP = GetLocalInt(oCaster, "PowerPoints");

        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDaze = EffectDazed();
        effect eLink = EffectLinkEffects(eMind, eDaze);
        eLink = ExtraordinaryEffect(eLink);

        FloatingTextStringOnCreature("You have become psychically enervated and lost power points", oCaster, FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(1));

        nPP = nPP - nWilder;
        FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
        //if(GetLocalInt(OBJECT_SELF, "IgnorePowerPoints") != TRUE) - Already checked at the start of function -Ornedan
        SetLocalInt(oCaster, "PowerPoints", nPP);
    }
    else
    {
        int nEuphoria = 1;
        if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) > 19) nEuphoria = 3;
        else if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) > 11) nEuphoria = 2;

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
    int nSpell = GetSpellId();
    if (nSpell == 2371 || nSpell == 2373 || nSpell == 2374)
    {
        return TRUE;
    }

    return FALSE;
}

int VolatileMind(object oTarget, object oCaster)
{
    int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oTarget);
    int nTelepathy = GetIsTelepathyPower();
    int nCost = 0;

    if (nWilder > 4 && nTelepathy == TRUE)
    {
        if (GetIsEnemy(oTarget, oCaster))
        {
            if      (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_4, oTarget)) nCost = 4;
            else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_3, oTarget)) nCost = 3;
            else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_2, oTarget)) nCost = 2;
            else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_1, oTarget)) nCost = 1;
        }
    }

    //FloatingTextStringOnCreature("Volatile Mind Cost: " + IntToString(nCost), oTarget, FALSE);
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
    if(GetHasFeat(nFeat, oPC))
        return FALSE;
    if(Get2DACache("feat", "PREREQFEAT1", nFeat) != ""
    && !GetHasFeat(StringToInt(Get2DACache("feat", "PREREQFEAT1", nFeat)), oPC))
        return FALSE;
    if(Get2DACache("feat", "PREREQFEAT2", nFeat) != ""
    && !GetHasFeat(StringToInt(Get2DACache("feat", "PREREQFEAT2", nFeat)), oPC))
        return FALSE;
    if(   (Get2DACache("feat", "OrReqFeat0", nFeat) != ""
        && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat0", nFeat)), oPC))
       || (Get2DACache("feat", "OrReqFeat1", nFeat) != ""
        && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat1", nFeat)), oPC))
       || (Get2DACache("feat", "OrReqFeat2", nFeat) != ""
        && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat2", nFeat)), oPC))
       || (Get2DACache("feat", "OrReqFeat3", nFeat) != ""
        && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat3", nFeat)), oPC))
       || (Get2DACache("feat", "OrReqFeat4", nFeat) != ""
        && !GetHasFeat(StringToInt(Get2DACache("feat", "OrReqFeat4", nFeat)), oPC))
       )
        return FALSE;
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
            nFeat = FEAT_POWER_KNOWLEDGE_PSYWAR_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_PSYWAR_10 &&
                  GetHasFeat(nFeat, oPC))
                { nMaxPowers += 2; nFeat++; }
            break;
        case CLASS_TYPE_PSYWAR:
            nFeat = FEAT_POWER_KNOWLEDGE_WILDER_1;
            while(nFeat <= FEAT_POWER_KNOWLEDGE_WILDER_10 &&
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
    //set the class
    SetLocalInt(OBJECT_SELF, "ManifestingClass", nClass);

    //DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "ManifestingClass")); Commented out since it will always be refreshed when a new power is manifested -Ornedan
    //set the spell power
    SetLocalInt(OBJECT_SELF, "PowerLevel", StringToInt(lookup_spell_innate(GetSpellId())));
    //pass in the spell
    //override level
    if(nLevelOverride != 0)
    {
        SetLocalInt(OBJECT_SELF, "PRC_Castlevel_Override", nLevelOverride);
        //DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "PRC_Castlevel_Override")); Commented out since it will be removed once it has been used and moreover, one second delay is too short-Ornedan
    }
    //Ignore power points?
    SetLocalInt(OBJECT_SELF, "IgnorePowerPoints", bIgnorePP);
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
        if (fWidth == RADIUS_SIZE_SMALL)	fWidth = RADIUS_SIZE_MEDIUM;
        if (fWidth == RADIUS_SIZE_MEDIUM)	fWidth = RADIUS_SIZE_LARGE;
        if (fWidth == RADIUS_SIZE_LARGE)	fWidth = RADIUS_SIZE_HUGE;
        if (fWidth == RADIUS_SIZE_HUGE)		fWidth = RADIUS_SIZE_GARGANTUAN;
        if (fWidth == RADIUS_SIZE_GARGANTUAN)	fWidth = RADIUS_SIZE_COLOSSAL;
        else fWidth *= 2;
    }

    return fWidth;
}



void GainPsionicFocus(object oGainee = OBJECT_SELF)
{
    SetLocalInt(oGainee, "PsionicFocus", TRUE);
    
    // Speed Of Thought
    if(GetHasFeat(FEAT_SPEED_OF_THOUGHT, oGainee) &&
       GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oGainee)) < 6 // Check for heavy armor
      )
    {
        AssignCommand(oGainee, ActionCastSpellAtObject(SPELL_FEAT_SPEED_OF_THOUGHT_BONUS, oGainee, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        // Schedule a script to remove the bonus should they equip heavy armor
        AddEventScript(oGainee, EVENT_ONPLAYEREQUIPITEM, "psi_spdfthgt_oeq", TRUE, FALSE);
        // Schedule another script to add the bonus back if the unequip the armor
        AddEventScript(oGainee, EVENT_ONPLAYERUNEQUIPITEM, "psi_spdfthgt_ueq", TRUE, FALSE);
    }
    // Psionic Dodge
    if(GetHasFeat(FEAT_PSIONIC_DODGE, oGainee))
        SetCompositeBonus(GetPCSkin(oGainee), "PsionicDodge", 1, ITEM_PROPERTY_AC_BONUS);
}


int UsePsionicFocus(object oUser = OBJECT_SELF)
{
    int bToReturn = FALSE;
    // First, check if we have focus on
    if(GetLocalInt(oUser, "PsionicFocus"))
    {
        SetLocalInt(oUser, "PsionicFocusUses", GetPsionicFocusUsesPerExpenditure(oUser) - 1);
        DelayCommand(0.5f, DeleteLocalInt(oUser, "PsionicFocusUses"));
        SendMessageToPC(oUser, "You have used your Psionic Focus");
        
        bToReturn = TRUE;
    }
    // We don't. Check if there are uses remaining
    else if(GetLocalInt(oUser, "PsionicFocusUses"))
    {
        SetLocalInt(oUser, "PsionicFocusUses", GetLocalInt(oUser, "PsionicFocusUses") - 1);
        
        bToReturn = TRUE;
    }
    
    // Lose focus if it was used
    if(bToReturn) LosePsionicFocus(oUser);
    
    return bToReturn;
}

void LosePsionicFocus(object oLoser = OBJECT_SELF)
{
    // Only remove focus if it's present
    if(GetLocalInt(oLoser, "PsionicFocus"))
    {
        SetLocalInt(oLoser, "PsionicFocus", FALSE);
        
        // Loss of Speed of Thought effects
        RemoveSpellEffects(SPELL_FEAT_SPEED_OF_THOUGHT_BONUS, oLoser, oLoser);
        RemoveEventScript(oLoser, EVENT_ONPLAYEREQUIPITEM, "psi_spdfthgt_oeq", TRUE);
        RemoveEventScript(oLoser, EVENT_ONPLAYERUNEQUIPITEM, "psi_spdfthgt_ueq", TRUE);
        // Loss of Psionic Dodge effects
        SetCompositeBonus(GetPCSkin(oLoser), "PsionicDodge", 0, ITEM_PROPERTY_AC_BONUS);
        
        // Inform oLoser about the event
        FloatingTextStringOnCreature("You have lost your Psionic Focus", oLoser, FALSE);
    }
}


int GetIsPsionicallyFocused(object oCreature = OBJECT_SELF)
{
    return GetLocalInt(oCreature, "PsionicFocus");
}

int GetPsionicFocusUsesPerExpenditure(object oCreature = OBJECT_SELF)
{
    int nFocusUses = 1;
    int i;
    for(i = FEAT_EPIC_PSIONIC_FOCUS_1; i <= FEAT_EPIC_PSIONIC_FOCUS_10; i++)
        if(GetHasFeat(i, oCreature)) nFocusUses++;
    
    return nFocusUses;
}


int GetPsionicFocusUsingFeatsActive(object oCreature = OBJECT_SELF)
{
    int nFeats;
    
    if(GetLocalInt(oCreature, "TalentedActive"))            nFeats++;
    if(GetLocalInt(oCreature, "PowerSpecializationActive")) nFeats++;
    if(GetLocalInt(oCreature, "PowerPenetrationActive"))    nFeats++;
    if(GetLocalInt(oCreature, "PsionicEndowmentActive"))    nFeats++;
    
    // TODO: Add in metapsionics here
    if(GetLocalInt(oCreature, "PsiMetaChain"))   nFeats++;
    if(GetLocalInt(oCreature, "PsiMetaEmpower")) nFeats++;
    if(GetLocalInt(oCreature, "PsiMetaExtend"))  nFeats++;
    if(GetLocalInt(oCreature, "PsiMetaMax"))     nFeats++;
    if(GetLocalInt(oCreature, "PsiMetaSplit"))   nFeats++;
    if(GetLocalInt(oCreature, "PsiMetaTwin"))    nFeats++;
    if(GetLocalInt(oCreature, "PsiMetaWiden"))   nFeats++;
    
    return nFeats;
}




int GetIsPsionicCharacter(object oCreature)
{
    return !!(GetLevelByClass(CLASS_TYPE_PSION, oCreature)  ||
              GetLevelByClass(CLASS_TYPE_PSYWAR, oCreature) ||
              GetLevelByClass(CLASS_TYPE_WILDER, oCreature) ||
              GetHasFeat(FEAT_WILD_TALENT, oCreature)
              // Racial psionicity signifying feats go here
             );
}