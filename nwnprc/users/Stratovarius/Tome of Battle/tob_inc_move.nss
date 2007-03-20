//::///////////////////////////////////////////////
//:: Tome of Battle include: Initiating
//:: tob_inc_move
//::///////////////////////////////////////////////
/** @file
    Defines structures and functions for handling
    initiating a maneuver

    @author Stratovarius
    @date   Created - 2007.3.20
    @thanks to Ornedan for his work on Psionics upon which this is based.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const string PRC_INITIATING_CLASS        = "PRC_CurrentManeuver_InitiatingClass";
const string PRC_MANEVEUR_LEVEL           = "PRC_CurrentManeuver_Level";
const string TOB_DEBUG_IGNORE_CONSTRAINTS = "TOB_DEBUG_IGNORE_CONSTRAINTS";

/**
 * The variable in which the maneuver token is stored. If no token exists,
 * the variable is set to point at the initiator itself. That way OBJECT_INVALID
 * means the variable is unitialised.
 */
const string PRC_MANEVEUR_TOKEN_VAR  = "PRC_ManeuverToken";
const string PRC_MANEVEUR_TOKEN_NAME = "PRC_MOVETOKEN";
const float  PRC_MANEVEUR_HB_DELAY   = 0.5f;


//////////////////////////////////////////////////
/*                 Structures                   */
//////////////////////////////////////////////////

/**
 * A structure that contains common data used during maneuver.
 */
struct maneuver{
    /* Generic stuff */
    /// The creature Truespeaking the Maneuver
    object oInitiator;
    /// Whether the maneuver is successful or not
    int bCanManeuver;
    /// The creature's initiator level in regards to this maneuver
    int nInitiatorLevel;
    /// The maneuver's spell ID
    int nSpellId;
    /// The DC for speaking the maneuver
    int nMoveDC;
};

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Determines if the maneuver that is currently being attempted to be TrueSpoken
 * can in fact be truespoken. Determines metamaneuvers used.
 *
 * @param oInitiator  A creature attempting to truespeak a maneuver at this moment.
 * @param oTarget       The target of the maneuver, if any. For pure Area of Effect.
 *                      maneuvers, this should be OBJECT_INVALID. Otherwise the main
 *                      target of the maneuver as returned by PRCGetSpellTargetObject().
 * @param nMetaUtterFlags The metamaneuvers that may be used to modify this maneuver. Any number
 *                      of METAUTTERANCE_* constants ORd together using the | operator.
 *                      For example (METAUTTERANCE_EMPOWER | METAUTTERANCE_EXTEND)
 * @param nLexicon      Whether it is of the Crafted Tool, Evolving Mind or Perfected Map
 *                      Use one of three constants: TYPE_EVOLVING_MIND, TYPE_CRAFTED_TOOL, TYPE_PERFECTED_MAP
 *
 * @return              A maneuver structure that contains the data about whether
 *                      the maneuver was successfully truespeaked, what metamaneuvers
 *                      were used and some other commonly used data, like the 
 *                      TrueNamer's initiator level for this maneuver.
 */
struct maneuver EvaluateManeuver(object oInitiator, object oTarget, int nMetaUtterFlags, int nLexicon);

/**
 * Causes OBJECT_SELF to use the given maneuver.
 *
 * @param nUtter         The index of the maneuver to use in spells.2da or an UTTER_*
 * @param nClass         The index of the class to use the maneuver as in classes.2da or a CLASS_TYPE_*
 * @param nLevelOverride An optional override to normal initiator level. 
 *                       Default: 0, which means the parameter is ignored.
 */
void UseManeuver(int nUtter, int nClass, int nLevelOverride = 0);

/**
 * A debugging function. Takes a maneuver structure and
 * makes a string describing the contents.
 *
 * @param utter A set of maneuver data
 * @return      A string describing the contents of utter
 */
string DebugManeuver2Str(struct maneuver utter);

/**
 * Stores a maneuver structure as a set of local variables. If
 * a structure was already stored with the same name on the same object,
 * it is overwritten.
 *
 * @param oObject The object on which to store the structure
 * @param sName   The name under which to store the structure
 * @param utter   The maneuver structure to store
 */
void SetLocalManeuver(object oObject, string sName, struct maneuver utter);

/**
 * Retrieves a previously stored maneuver structure. If no structure is stored
 * by the given name, the structure returned is empty.
 *
 * @param oObject The object from which to retrieve the structure
 * @param sName   The name under which the structure is stored
 * @return        The structure built from local variables stored on oObject under sName
 */
struct maneuver GetLocalManeuver(object oObject, string sName);

/**
 * Deletes a stored maneuver structure.
 *
 * @param oObject The object on which the structure is stored
 * @param sName   The name under which the structure is stored
 */
void DeleteLocalManeuver(object oObject, string sName);

/**
 * Sets the evaluation functions to ignore constraints on initiating.
 * Call this just prior to EvaluateManeuver() in a maneuver script.
 * That evaluation will then ignore lacking maneuver ability score,
 * maneuver Points and Psionic Focuses.
 *
 * @param oInitiator A creature attempting to truespeak a maneuver at this moment.
 */
void TruenameDebugIgnoreConstraints(object oInitiator);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "true_inc_metautr"
#include "true_inc_truespk" 

//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

/** Internal function.
 * Handles Spellfire absorption when a maneuver is used on a friendly spellfire
 * user.
 */
struct maneuver _DoTruenameSpellfireFriendlyAbsorption(struct maneuver utter, object oTarget)
{
    if(GetLocalInt(oTarget, "SpellfireAbsorbFriendly") &&
       GetIsFriend(oTarget, utter.oInitiator)
       )
    {
        if(CheckSpellfire(utter.oInitiator, oTarget, TRUE))
        {
            PRCShowSpellResist(utter.oInitiator, oTarget, SPELL_RESIST_MANTLE);
            utter.bCanManeuver = FALSE;
        }
    }

    return utter;
}

/** Internal function.
 * Deletes maneuver-related local variables.
 *
 * @param oInitiator The creature currently initiating a maneuver
 */
void _CleanManeuverVariables(object oInitiator)
{
    DeleteLocalInt(oInitiator, PRC_INITIATING_CLASS);
    DeleteLocalInt(oInitiator, PRC_MANEVEUR_LEVEL);
}

/** Internal function.
 * Determines whether a maneuver token exists. If one does, returns it.
 *
 * @param oInitiator A creature whose maneuver token to get
 * @return            The maneuver token if it exists, OBJECT_INVALID otherwise.
 */
object _GetManeuverToken(object oInitiator)
{
    object oUtrToken = GetLocalObject(oInitiator, PRC_MANEVEUR_TOKEN_VAR);

    // If the token object is no longer valid, set the variable to point at initiator
    if(!GetIsObjectValid(oUtrToken))
    {
        oUtrToken = oInitiator;
        SetLocalObject(oInitiator, PRC_MANEVEUR_TOKEN_VAR, oUtrToken);
    }


    // Check if there is no token
    if(oUtrToken == oInitiator)
        oUtrToken = OBJECT_INVALID;

    return oUtrToken;
}

/** Internal function.
 * Destroys the given maneuver token and sets the creature's maneuver token variable
 * to point at itself.
 *
 * @param oInitiator The initiator whose token to destroy
 * @param oUtrToken    The token to destroy
 */
void _DestroyManeuverToken(object oInitiator, object oUtrToken)
{
    DestroyObject(oUtrToken);
    SetLocalObject(oInitiator, PRC_MANEVEUR_TOKEN_VAR, oInitiator);
}

/** Internal function.
 * Destroys the previous maneuver token, if any, and creates a new one.
 *
 * @param oInitiator A creature for whom to create a maneuver token
 * @return            The newly created token
 */
object _CreateManeuverToken(object oInitiator)
{
    object oUtrToken = _GetManeuverToken(oInitiator);
    object oStore   = GetObjectByTag("PRC_MANIFTOKEN_STORE"); //GetPCSkin(oInitiator);

    // Delete any previous tokens
    if(GetIsObjectValid(oUtrToken))
        _DestroyManeuverToken(oInitiator, oUtrToken);

    // Create new token and store a reference to it
    oUtrToken = CreateItemOnObject(PRC_MANEVEUR_TOKEN_NAME, oStore);
    SetLocalObject(oInitiator, PRC_MANEVEUR_TOKEN_VAR, oUtrToken);

    Assert(GetIsObjectValid(oUtrToken), "GetIsObjectValid(oUtrToken)", "ERROR: Unable to create maneuver token! Store object: " + DebugObject2Str(oStore), "true_inc_Utter", "_CreateManeuverToken()");

    return oUtrToken;
}

/** Internal function.
 * Determines whether the given initiator is doing something that would
 * interrupt initiating a maneuver or affected by an effect that would do
 * the same.
 *
 * @param oInitiator A creature on which _ManeuverHB() is running
 * @return            TRUE if the creature can continue initiating,
 *                    FALSE otherwise
 */
int _ManeuverStateCheck(object oInitiator)
{
    int nAction = GetCurrentAction(oInitiator);
    // If the current action is not among those that could either be used to truespeak the maneuver or movement, the maneuver fails
    if(!(nAction || ACTION_CASTSPELL     || nAction == ACTION_INVALID      ||
         nAction || ACTION_ITEMCASTSPELL || nAction == ACTION_MOVETOPOINT  ||
         nAction || ACTION_USEOBJECT     || nAction == ACTION_WAIT
       ) )
        return FALSE;

    // Affected by something that prevents one from initiating
    effect eTest = GetFirstEffect(oInitiator);
    int nEType;
    while(GetIsEffectValid(eTest))
    {
        nEType = GetEffectType(eTest);
        if(nEType == EFFECT_TYPE_CUTSCENE_PARALYZE ||
           nEType == EFFECT_TYPE_DAZED             ||
           nEType == EFFECT_TYPE_PARALYZE          ||
           nEType == EFFECT_TYPE_PETRIFY           ||
           nEType == EFFECT_TYPE_SLEEP             ||
           nEType == EFFECT_TYPE_STUNNED
           )
            return FALSE;

        // Get next effect
        eTest = GetNextEffect(oInitiator);
    }

    return TRUE;
}

/** Internal function.
 * Runs while the given creature is initiating. If they move, take other actions
 * that would cause them to interrupt initiating the maneuver or are affected by an
 * effect that would cause such interruption, deletes the maneuver token.
 * Stops if such condition occurs or something else destroys the token.
 *
 * @param oInitiator A creature initiating a maneuver
 * @param lTrueSpeaker The location where the initiator was when starting the maneuver
 * @param oUtrToken    The maneuver token that controls the ongoing maneuver
 */
void _ManeuverHB(object oInitiator, location lTrueSpeaker, object oUtrToken)
{
    if(DEBUG) DoDebug("_ManeuverHB() running:\n"
                    + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                    + "lTrueSpeaker = " + DebugLocation2Str(lTrueSpeaker) + "\n"
                    + "oUtrToken = " + DebugObject2Str(oUtrToken) + "\n"
                    + "Distance between maneuver start location and current location: " + FloatToString(GetDistanceBetweenLocations(lTrueSpeaker, GetLocation(oInitiator))) + "\n"
                      );
    if(GetIsObjectValid(oUtrToken))
    {
        // Continuance check
        if(GetDistanceBetweenLocations(lTrueSpeaker, GetLocation(oInitiator)) > 2.0f || // Allow some variance in the location to account for dodging and random fidgeting
           !_ManeuverStateCheck(oInitiator)                                       // Action and effect check
           )
        {
            if(DEBUG) DoDebug("_ManeuverHB(): initiator moved or lost concentration, destroying token");
            _DestroyManeuverToken(oInitiator, oUtrToken);

            // Inform initiator
            FloatingTextStrRefOnCreature(16828469, oInitiator, FALSE); // "You have lost concentration on the maneuver you were attempting to truespeak!"
        }
        // Schedule next HB
        else
            DelayCommand(PRC_MANEVEUR_HB_DELAY, _ManeuverHB(oInitiator, lTrueSpeaker, oUtrToken));
    }
}

/** Internal function.
 * Checks if the initiator is in range to use the maneuver they are trying to use.
 * If not, queues commands to make the initiator to run into range.
 *
 * @param oInitiator A creature initiating a maneuver
 * @param nUtter      SpellID of the maneuver being truespeaked
 * @param lTarget     The target location or the location of the target object
 */
void _ManeuverRangeCheck(object oInitiator, int nUtter, location lTarget)
{
    float fDistance   = GetDistanceBetweenLocations(GetLocation(oInitiator), lTarget);
    float fRangeLimit;
    string sRange     = Get2DACache("spells", "Range", nUtter);

    // Personal range maneuvers are always in range
    if(sRange == "P")
        return;
    // Ranges according to the CCG spells.2da page
    else if(sRange == "T")
        fRangeLimit = 2.25f;
    else if(sRange == "S")
        fRangeLimit = 8.0f;
    else if(sRange == "M")
        fRangeLimit = 20.0f;
    else if(sRange == "L")
        fRangeLimit = 40.0f;

    // See if we are out of range
    if(fDistance > fRangeLimit)
    {
        // Create waypoint for the movement
        object oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lTarget);

        // Move into range, with a bit of fudge-factor
        ActionMoveToObject(oWP, TRUE, fRangeLimit - 0.15f);

        // CleanUp
        ActionDoCommand(DestroyObject(oWP));

        // CleanUp, paranoia
        AssignCommand(oWP, ActionDoCommand(DestroyObject(oWP, 60.0f)));
    }
}

/** Internal function.
 * Assigns the fakecast command that is used to display the conjuration VFX when using an maneuver.
 * Separated from UseManeuver() due to a bug with ActionFakeCastSpellAtObject(), which requires
 * use of ClearAllActions() to work around.
 * The problem is that if the target is an item on the ground, if the actor is out of spell
 * range when doing the fakecast, they will run on top of the item instead of to the edge of
 * the spell range. This only happens if there was a "real action" in the actor's action queue
 * immediately prior to the fakecast.
 */
void _AssignUseManeuverFakeCastCommands(object oInitiator, object oTarget, location lTarget, int nSpellID)
{
    // Nuke actions to prevent the fakecast action from bugging
    ClearAllActions();

    if(GetIsObjectValid(oTarget))
        ActionCastFakeSpellAtObject(nSpellID, oTarget, PROJECTILE_PATH_TYPE_DEFAULT);
    else
        ActionCastFakeSpellAtLocation(nSpellID, lTarget, PROJECTILE_PATH_TYPE_DEFAULT);
}


/** Internal function.
 * Places the cheatcasting of the real maneuver into the initiator's action queue.
 */
void _UseManeuverAux(object oInitiator, object oUtrToken, int nSpellId,
                  object oTarget, location lTarget,
                  int nUtter, int nClass, int nLevelOverride,
                  int bQuickened
                  )
{
    if(DEBUG) DoDebug("_UseManeuverAux() running:\n"
                    + "oInitiator = " + DebugObject2Str(oInitiator) + "\n"
                    + "oUtrToken = " + DebugObject2Str(oUtrToken) + "\n"
                    + "nSpellId = " + IntToString(nSpellId) + "\n"
                    + "oTarget = " + DebugObject2Str(oTarget) + "\n"
                    + "lTarget = " + DebugLocation2Str(lTarget) + "\n"
                    + "nUtter = " + IntToString(nUtter) + "\n"
                    + "nClass = " + IntToString(nClass) + "\n"
                    + "nLevelOverride = " + IntToString(nLevelOverride) + "\n"
                    + "bQuickened = " + BooleanToString(bQuickened) + "\n"
                      );

    // Make sure nothing has interrupted this maneuver
    if(GetIsObjectValid(oUtrToken))
    {
        if(DEBUG) DoDebug("_UseManeuverAux(): Token was valid, queueing actual maneuver");
        // Set the class to truespeak as
        SetLocalInt(oInitiator, PRC_INITIATING_CLASS, nClass + 1);

        // Set the maneuver's level
        SetLocalInt(oInitiator, PRC_MANEVEUR_LEVEL, StringToInt(lookup_spell_innate(nSpellId)));

        // Set whether the maneuver was quickened
        SetLocalInt(oInitiator, PRC_MANEVEUR_IS_QUICKENED, bQuickened);

        // Queue the real maneuver
        //ActionCastSpell(nUtter, nLevelOverride, 0, 0, METAMAGIC_NONE, CLASS_TYPE_INVALID, TRUE, TRUE, oTarget);

        if(nLevelOverride != 0)
            AssignCommand(oInitiator, ActionDoCommand(SetLocalInt(oInitiator, PRC_CASTERLEVEL_OVERRIDE, nLevelOverride)));
        if(GetIsObjectValid(oTarget))
            AssignCommand(oInitiator, ActionCastSpellAtObject(nUtter, oTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        else
            AssignCommand(oInitiator, ActionCastSpellAtLocation(nUtter, lTarget, METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        if(nLevelOverride != 0)
            AssignCommand(oInitiator, ActionDoCommand(DeleteLocalInt(oInitiator, PRC_CASTERLEVEL_OVERRIDE)));

        // Destroy the maneuver token for this maneuver
        _DestroyManeuverToken(oInitiator, oUtrToken);
    }
}


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

struct maneuver EvaluateManeuver(object oInitiator, object oTarget, int nMetaUtterFlags, int nLexicon)
{
    /* Get some data */
    int bIgnoreConstraints = (DEBUG) ? GetLocalInt(oInitiator, TOB_DEBUG_IGNORE_CONSTRAINTS) : FALSE;
    // initiator-related stuff
    int nInitiatorLevel = GetTruespeakerLevel(oInitiator);
    int nUtterLevel      = GetManeuverLevel(oInitiator);
    int nClass           = GetTruespeakingClass(oInitiator);

    /* Initialise the maneuver structure */
    struct maneuver utter;
    utter.oInitiator      = oInitiator;
    utter.bCanManeuver         = TRUE;                                   // Assume successfull maneuver by default
    utter.nInitiatorLevel = nInitiatorLevel;
    utter.nSpellId          = PRCGetSpellId();
    utter.nMoveDC          = GetBaseManeuverDC(oTarget, oInitiator, nLexicon);

    // Account for metamaneuvers. This includes adding the appropriate DC boosts.
    utter = EvaluateMetamaneuvers(utter, nMetaUtterFlags);
    // Account for the law of resistance
    utter.nMoveDC += GetLawOfResistanceDCIncrease(oInitiator, utter.nSpellId);
    // DC change for targeting self and using a Personal Truename
    utter.nMoveDC += AddPersonalTruenameDC(oInitiator, oTarget);  
    // DC change for ignoring Spell Resistance
    utter.nMoveDC += AddIgnoreSpellResistDC(oInitiator);
    // DC change for specific maneuvers
    utter.nMoveDC += AddManeuverSpecificDC(oInitiator);
    
    // Check the Law of Sequence. Returns True if the maneuver is active
    if (CheckLawOfSequence(oInitiator, utter.nSpellId))
    {
    	utter.bCanManeuver = FALSE;
    	FloatingTextStringOnCreature("You already have " + GetManeuverName(utter.nSpellId) + " active. Maneuver Failed.", oInitiator, FALSE);
    }
    
    // Skip paying anything if something has prevented successfull maneuver already by this point
    if(utter.bCanManeuver)
    {
        /* Roll the dice, and see if we succeed or fail.
         */
        if(GetIsSkillSuccessful(oInitiator, SKILL_TRUESPEAK, utter.nMoveDC) || bIgnoreConstraints)
        {
        	// Increases the DC of the subsequent maneuvers
        	DoLawOfResistanceDCIncrease(oInitiator, utter.nSpellId);
                // Spellfire friendly absorption - This may set bCananifest to FALSE
                utter = _DoTruenameSpellfireFriendlyAbsorption(utter, oTarget);
                //* APPLY SIDE-EFFECTS THAT RESULT FROM SUCCESSFULL UTTERANCE ABOVE *//

        }
        // Failed the DC roll
        else
        {
            // No need for an output here because GetIsSkillSuccessful does it for us.
            utter.bCanManeuver = FALSE;
        }
    }//end if

    if(DEBUG) DoDebug("EvaluateManeuver(): Final result:\n" + DebugManeuver2Str(utter));

    // Initiate maneuver-related variable CleanUp
    DelayCommand(0.5f, _CleanManeuverVariables(oInitiator));

    return utter;
}

void UseManeuver(int nUtter, int nClass, int nLevelOverride = 0)
{
    object oInitiator = OBJECT_SELF;
    object oSkin       = GetPCSkin(oInitiator);
    object oTarget     = PRCGetSpellTargetObject();
    object oUtrToken;
    location lTarget   = PRCGetSpellTargetLocation();
    int nSpellID       = PRCGetSpellId();
    int nUtterDur      = StringToInt(Get2DACache("spells", "ConjTime", nUtter)) + StringToInt(Get2DACache("spells", "CastTime", nUtter));
    int bQuicken       = FALSE;

    // Normally swift action maneuvers check
    if(Get2DACache("feat", "Constant", GetClassFeatFromPower(nUtter, nClass)) == "SWIFT_ACTION" && // The maneuver is swift action to use
       TakeSwiftAction(oInitiator)                                                                // And the initiator can take a swift action now
       )
    {
        nUtterDur = 0;
    }
    // Quicken maneuver check
    else if(nUtterDur <= 6000                                 && // If the maneuver could be quickened by having initiating time of 1 round or less
            GetLocalInt(oInitiator, METAUTTERANCE_QUICKEN_VAR) && // And the initiator has Quicken maneuver active
            TakeSwiftAction(oInitiator)                         // And the initiator can take a swift action
            )
    {
        // Set the maneuver time to 0 to skip VFX
        nUtterDur = 0;
        // And set the Quicken maneuver used marker to TRUE
        bQuicken = TRUE;
    }

    if(DEBUG) DoDebug("UseManeuver(): initiator is " + DebugObject2Str(oInitiator) + "\n"
                    + "nUtter = " + IntToString(nUtter) + "\n"
                    + "nClass = " + IntToString(nClass) + "\n"
                    + "nLevelOverride = " + IntToString(nLevelOverride) + "\n"
                    + "maneuver duration = " + IntToString(nUtterDur) + "ms \n"
                    + "bQuicken = " + BooleanToString(bQuicken) + "\n"
                    //+ "Token exists = " + BooleanToString(GetIsObjectValid(oUtrToken))
                      );

    // Create the maneuver token. Deletes any old tokens and cancels corresponding maneuvers as a side effect
    oUtrToken = _CreateManeuverToken(oInitiator);

    /// @todo Hook to the initiator's OnDamaged event for the concentration checks to avoid losing the maneuver

    // Nuke action queue to prevent cheating with creative maneuver stacking.
    // Probably not necessary anymore - Ornedan
    if(DEBUG) SendMessageToPC(oInitiator, "Clearing all actions in preparation for second stage of the maneuver.");
    ClearAllActions();

    // If out of range, move to range
    _ManeuverRangeCheck(oInitiator, nUtter, GetIsObjectValid(oTarget) ? GetLocation(oTarget) : lTarget);

    // Start the maneuver monitor HB
    ActionDoCommand(_ManeuverHB(oInitiator, GetLocation(oInitiator), oUtrToken));

    // Assuming the spell isn't used as a swift action, fakecast for visuals
    if(nUtterDur > 0)
    {
        // Hack. Workaround of a bug with the fakecast actions. See function comment for details
        ActionDoCommand(_AssignUseManeuverFakeCastCommands(oInitiator, oTarget, lTarget, nSpellID));
    }

    // Action queue the function that will cheatcast the actual maneuver
    DelayCommand(nUtterDur / 1000.0f, AssignCommand(oInitiator, ActionDoCommand(_UseManeuverAux(oInitiator, oUtrToken, nSpellID, oTarget, lTarget, nUtter, nClass, nLevelOverride, bQuicken))));
}

string DebugManeuver2Str(struct maneuver utter)
{
    string sRet;

    sRet += "oInitiator = " + DebugObject2Str(utter.oInitiator) + "\n";
    sRet += "bCanManeuver = " + BooleanToString(utter.bCanManeuver) + "\n";
    sRet += "nInitiatorLevel = "  + IntToString(utter.nInitiatorLevel) + "\n";

    sRet += "bEmpower  = " + BooleanToString(utter.bEmpower)  + "\n";
    sRet += "bExtend   = " + BooleanToString(utter.bExtend)   + "\n";
    sRet += "bQuicken  = " + BooleanToString(utter.bQuicken);//    + "\n";

    return sRet;
}

void SetLocalManeuver(object oObject, string sName, struct maneuver utter)
{
    //SetLocal (oObject, sName + "_", );
    SetLocalObject(oObject, sName + "_oInitiator", utter.oInitiator);

    SetLocalInt(oObject, sName + "_bCanManeuver",      utter.bCanManeuver);
    SetLocalInt(oObject, sName + "_nInitiatorLevel",  utter.nInitiatorLevel);
    SetLocalInt(oObject, sName + "_nSpellID",          utter.nSpellId);

    SetLocalInt(oObject, sName + "_bEmpower",  utter.bEmpower);
    SetLocalInt(oObject, sName + "_bExtend",   utter.bExtend);
    SetLocalInt(oObject, sName + "_bQuicken",  utter.bQuicken);
}

struct maneuver GetLocalManeuver(object oObject, string sName)
{
    struct maneuver utter;
    utter.oInitiator = GetLocalObject(oObject, sName + "_oInitiator");

    utter.bCanManeuver      = GetLocalInt(oObject, sName + "_bCanManeuver");
    utter.nInitiatorLevel  = GetLocalInt(oObject, sName + "_nInitiatorLevel");
    utter.nSpellId          = GetLocalInt(oObject, sName + "_nSpellID");

    utter.bEmpower  = GetLocalInt(oObject, sName + "_bEmpower");
    utter.bExtend   = GetLocalInt(oObject, sName + "_bExtend");
    utter.bQuicken  = GetLocalInt(oObject, sName + "_bQuicken");

    return utter;
}

void DeleteLocalManeuver(object oObject, string sName)
{
    DeleteLocalObject(oObject, sName + "_oInitiator");

    DeleteLocalInt(oObject, sName + "_bCanManeuver");
    DeleteLocalInt(oObject, sName + "_nInitiatorLevel");
    DeleteLocalInt(oObject, sName + "_nSpellID");

    DeleteLocalInt(oObject, sName + "_bEmpower");
    DeleteLocalInt(oObject, sName + "_bExtend");
    DeleteLocalInt(oObject, sName + "_bQuicken");
}

void TruenameDebugIgnoreConstraints(object oInitiator)
{
    SetLocalInt(oInitiator, TOB_DEBUG_IGNORE_CONSTRAINTS, TRUE);
    DelayCommand(0.0f, DeleteLocalInt(oInitiator, TOB_DEBUG_IGNORE_CONSTRAINTS));
}

// Test main
//void main(){}
