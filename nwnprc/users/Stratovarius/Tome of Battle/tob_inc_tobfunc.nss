//::///////////////////////////////////////////////
//:: Tome of Battle include: Misceallenous
//:: tob_inc_tobfunc
//::///////////////////////////////////////////////
/** @file
    Defines various functions and other stuff that
    do something related to the Tome of Battle implementation.

    Also acts as inclusion nexus for the general
    tome of battle includes. In other words, don't include
    them directly in your scripts, instead include this.

    @author Stratovarius
    @date   Created - 2007.3.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const int    DISCIPLINE_DESERT_WIND    = 1;
const int    DISCIPLINE_DEVOTED_SPIRIT = 2;
const int    DISCIPLINE_DIAMOND_MIND   = 3;
const int    DISCIPLINE_IRON_HEART     = 4;
const int    DISCIPLINE_SETTING_SUN    = 5;
const int    DISCIPLINE_SHADOW_HAND    = 6;
const int    DISCIPLINE_STONE_DRAGON   = 7;
const int    DISCIPLINE_TIGER_CLAW     = 8;
const int    DISCIPLINE_WHITE_RAVEN    = 9;

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Determines from what class's maneuver list the currently being initiated
 * maneuver is initiated from.
 *
 * @param oInitiator A creature initiating a maneuver at this moment
 * @return            CLASS_TYPE_* constant of the class
 */
int GetInitiatingClass(object oInitiator = OBJECT_SELF);

/**
 * Determines the given creature's Initiator level. If a class is specified,
 * then returns the Initiator level for that class. Otherwise, returns
 * the Initiator level for the currently active maneuver.
 *
 * @param oInitiator   The creature whose Initiator level to determine
 * @param nSpecificClass The class to determine the creature's Initiator
 *                       level in.
 * @param nUseHD         If this is set, it returns the Character Level of the calling creature.
 *                       DEFAULT: CLASS_TYPE_INVALID, which means the creature's
 *                       Initiator level in regards to an ongoing maneuver
 *                       is determined instead.
 * @return               The Initiator level
 */
int GetInitiatorLevel(object oInitiator, int nSpecificClass = CLASS_TYPE_INVALID, int nUseHD = FALSE);

/**
 * Determines whether a given creature uses BladeMagic.
 * Requires either levels in a BladeMagic-related class or
 * natural BladeMagic ability based on race.
 *
 * @param oCreature Creature to test
 * @return          TRUE if the creature can use BladeMagics, FALSE otherwise.
 */
int GetIsBladeMagicUser(object oCreature);

/**
 * Determines the given creature's highest undmodified Initiator level among it's
 * initiating classes.
 *
 * @param oCreature Creature whose highest Initiator level to determine
 * @return          The highest unmodified Initiator level the creature can have
 */
int GetHighestInitiatorLevel(object oCreature);

/**
 * Determines whether a given class is a BladeMagic-related class or not.
 *
 * @param nClass CLASS_TYPE_* of the class to test
 * @return       TRUE if the class is a BladeMagic-related class, FALSE otherwise
 */
int GetIsBladeMagicClass(int nClass);

/**
 * Gets the level of the maneuver being currently initiated.
 * WARNING: Return value is not defined when a maneuver is not being initiated.
 *
 * @param oInitiator The creature currently initiating a maneuver
 * @return            The level of the maneuver being initiated
 */
int GetManeuverLevel(object oInitiator);

/**
 * Returns the name of the maneuver
 *
 * @param nSpellId        SpellId of the maneuver
 */
string GetManeuverName(int nSpellId);

/**
 * Returns the name of the Discipline
 *
 * @param nDiscipline        DISCIPLINE_* to name
 */
string GetDisciplineName(int nDiscipline);

/**
 * Returns the Discipline the maneuver is in
 * @param nSpellId   maneuver to check
 * @param nClass     Class to check with (no class has all maneuvers)
 *
 * @return           DISCIPLINE_*
 */
int GetDisciplineByManeuver(int nSpellId, int nClass);

/**
 * Returns true or false if the initiator has the Discipline
 * @param oInitiator    Person to check
 * @param nDiscipline   Discipline to check
 *
 * @return           TRUE or FALSE
 */
int TOBGetHasDiscipline(object oInitiator, int nDiscipline);

/**
 * Returns true or false if the swordsage has Discipline
 * focus in the chosen discipline
 * @param oInitiator    Person to check
 * @param nDiscipline   Discipline to check
 *
 * @return           TRUE or FALSE
 */
int TOBGetHasDisciplineFocus(object oInitiator, int nDiscipline);

/**
 * Calculates how many initiator levels are gained by a given creature from
 * it's levels in prestige classes.
 *
 * @param oCreature Creature to calculate added initiator levels for
 * @return          The number of initiator levels gained
 */
int GetBladeMagicPRCLevels(object oCreature);

/**
 * Determines whether a given class is a blade magic class or not. A blade magic
 * class is defined as one that gives base initiating.
 *
 * @param nClass CLASS_TYPE_* of the class to test
 * @return       TRUE if the class is a blade magic class, FALSE otherwise
 */
int GetIsBladeMagicClass(int nClass);

/**
 * Determines which of the character's classes is their first blade magic initiating
 * class, if any. This is the one which gains initiator level raise benefits from
 * prestige classes.
 *
 * @param oCreature Creature whose classes to test
 * @return          CLASS_TYPE_* of the first blade magic initiating class,
 *                  CLASS_TYPE_INVALID if the creature does not possess any.
 */
int GetFirstBladeMagicClass(object oCreature = OBJECT_SELF);

/**
 * Determines the position of a creature's first blade magic initiating class, if any.
 *
 * @param oCreature Creature whose classes to test
 * @return          The position of the first blade magic class {1, 2, 3} or 0 if
 *                  the creature possesses no levels in blade magic classes.
 */
int GetFirstBladeMagicClassPosition(object oCreature = OBJECT_SELF);

/**
 * Checks whether the PC possesses the feats the given feat has as it's
 * prerequisites. Possession of a feat is checked using GetHasFeat().
 *
 * @param nClass The class that is trying to learn the feat
 * @param nFeat The feat for which determine the possession of prerequisites
 * @param oPC   The creature whose feats to check
 * @return      TRUE if the PC possesses the prerequisite feats AND does not
 *              already posses nFeat, FALSE otherwise.
 */
int CheckManeuverPrereqs(int nClass, int nFeat, object oPC);

/**
 * Checks whether the maneuver is supernatural or not
 * Mainly used to check for AMF areas.
 * Mostly from Swordsage maneuvers
 *
 * @param nMoveId The Maneuver to Check
 * @return        TRUE if Maneuver is (Su), else FALSE
 */
int GetIsManeuverSupernatural(int nMoveId);

/**
 * Checks whether the initiator has an active stance
 *
 * @param oInitiator The Initiator
 * @return        The SpellId or FALSE
 */
int GetHasActiveStance(object oInitiator);

/**
 * Clears spell effects for Stances
 * Will NOT clear nDontClearMove
 *
 * @param oInitiator The Initiator
 * @param nDontClearMove A single Stance not to clear
 */
void ClearStances(object oInitiator, int nDontClearMove);

/**
 * Marks a stance active via local ints
 *
 * @param oInitiator The Initiator
 * @param nStance    The stance to mark active
 */
void MarkStanceActive(object oInitiator, int nStance);

/**
 * This will take an effect that is supposed to be based on size
 * And use vs racial effects to approximate it
 *
 * @param oInitiator The Initiator
 * @param eEffect    The effect to scale
 * @param nSize      0 affects creature one size or more smaller.
 *                   1 affects creatures one size or more larger
 */
effect VersusSizeEffect(object oInitiator, effect eEffect, int nSize);

/**
 * Checks every 6 seconds whether an adept has moved too far for a stance
 *
 * @param oPC        The Initiator
 * @param nMoveId    The stance
 */
void InitiatorMovementCheck(object oPC, int nMoveId);

/**
 * Returns the total bonus to ability Checks for chosen ability
 *
 * @param oPC      The PC
 * @param nAbility The ability to check
 * @return         Total bonus
 */
int GetAbilityCheckBonus(object oPC, int nAbility);

/**
 * Checks whether the maneuver is a stance
 *
 * @param nMoveId    The Maneuver
 * @return           TRUE or FALSE
 */
int GetIsStance(int nMoveId);

/**
 * Dazzles the target: -1 Attack, Search, Spot, and VFX
 *
 * @return           the Dazzle effect
 */
effect EffectDazzle();

/**
 * Sets up everything for the Damage boosts (xd6 + IL fire damage)
 * That the Desert Wind discipline has.
 *
 * @param oPC      The PC
 */
void DoDesertWindBoost(object oPC);

/**
 * Determines which PC in the area is weakest, and 
 * returns that PC.
 *
 * @param oPC      The PC
 * @param fDistance The distance to check in feet
 * @return         The Target
 */
object GetCrusaderHealTarget(object oPC, float fDistance);

/**
 * Marks a PC is charging for a round
 *
 * @param oPC      The PC
 */
void SetIsCharging(object oPC);

/**
 * Get whether a PC is charging for a round
 *
 * @param oPC      The PC
 * @return           TRUE or FALSE
 */
int GetIsCharging(object oPC);

/**
 * This will do a complete PnP charge attack
 * Only call EITHER Attack OR Bull Rush
 *
 * @param oPC           The PC
 * @param oTarget       The Target
 * @param nDoAttack     Do an attack at the end of a charge or not
 * @param nGenerateAoO  Does the movement generate an AoO
 * @param nBullRush     Do a Bull Rush at the end of a charge
 * @param nExtraBonus   An extra bonus to grant the PC on the Bull rush
 * @param nBullAoO      Does the bull rush attempt generate an AoO
 * @param nMustFollow   Does the Bull rush require the pushing PC to follow the target
 *
 * @return              TRUE if the attack or Bull rush hits, else FALSE
 */
int DoCharge(object oPC, object oTarget, int nDoAttack = TRUE, int nGenerateAoO = TRUE, int nBullRush = FALSE, int nExtraBonus = 0, int nBullAoO = TRUE, int nMustFollow = TRUE);

/**
 * This will do a complete PnP Bull rush
 *
 * @param oPC           The PC
 * @param oTarget       The Target
 * @param nExtraBonus   An extra bonus to grant the PC
 * @param nGenerateAoO  Does the Bull rush attempt generate an AoO
 * @param nMustFollow   Does the Bull rush require the pushing PC to follow the target
 *
 * @return              TRUE if the Bull rush succeeds, else FALSE
 */
int DoBullRush(object oPC, object oTarget, int nExtraBonus, int nGenerateAoO = TRUE, int nMustFollow = TRUE);

/**
 * This will do a complete PnP Trip
 *
 * @param oPC           The PC
 * @param oTarget       The Target
 * @param nExtraBonus   An extra bonus to grant the PC
 * @param nGenerateAoO  Does the Trip attempt generate an AoO
 * @param nCounterTrip  Can the target attempt a counter trip if you fail
 *
 * @return              TRUE if the Trip succeeds, else FALSE
 */
int DoTrip(object oPC, object oTarget, int nExtraBonus, int nGenerateAoO = TRUE, int nCounterTrip = TRUE);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "tob_move_const"
#include "prc_alterations"
#include "tob_inc_move"
#include "tob_inc_moveknwn"
#include "tob_inc_recovery"

//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

int _CheckPrereqsByDiscipline(object oPC, int nDiscipline, int nCount, int nClass)
{
     // Place to finish, place to start in feat.2da
     int nCheckTo, nCheck, nCheckTo2, nCheck2, nCheckTo3, nCheck3;
     int bUse2 = FALSE;
     int bUse3 = FALSE;
     int nPrereqCount = 0;
     // The range to check for prereqs
     // Some disciplines (5 of the 9) only have one range to check (single class disciplines)
     if (nDiscipline == DISCIPLINE_DESERT_WIND)    { nCheck = -1; nCheckTo = -1; }
     if (nDiscipline == DISCIPLINE_DEVOTED_SPIRIT) { nCheck = 8002; nCheckTo = 8049; }
     if (nDiscipline == DISCIPLINE_IRON_HEART)     { nCheck = -1; nCheckTo = -1; }
     if (nDiscipline == DISCIPLINE_SETTING_SUN)    { nCheck = -1; nCheckTo = -1; }
     if (nDiscipline == DISCIPLINE_SHADOW_HAND)    { nCheck = -1; nCheckTo = -1; }
     
     // These disciplines require looping over two or three areas in feat.2da
     if (nDiscipline == DISCIPLINE_DIAMOND_MIND && nClass == CLASS_TYPE_SWORDSAGE)    { nCheck = -1; nCheckTo = -1; }
     if (nDiscipline == DISCIPLINE_DIAMOND_MIND && nClass == CLASS_TYPE_WARBLADE)     { nCheck2 = -1; nCheckTo2 = -1; bUse2 = TRUE; }
     if (nDiscipline == DISCIPLINE_STONE_DRAGON && nClass == CLASS_TYPE_CRUSADER)     { nCheck = -1; nCheckTo = -1; }
     if (nDiscipline == DISCIPLINE_STONE_DRAGON && nClass == CLASS_TYPE_SWORDSAGE)    { nCheck2 = -1; nCheckTo2 = -1; bUse2 = TRUE; }     
     if (nDiscipline == DISCIPLINE_STONE_DRAGON && nClass == CLASS_TYPE_WARBLADE)     { nCheck3 = -1; nCheckTo3 = -1; bUse3 = TRUE; }     
     if (nDiscipline == DISCIPLINE_TIGER_CLAW   && nClass == CLASS_TYPE_SWORDSAGE)    { nCheck = -1; nCheckTo = -1; }
     if (nDiscipline == DISCIPLINE_TIGER_CLAW   && nClass == CLASS_TYPE_WARBLADE)     { nCheck2 = -1; nCheckTo2 = -1; bUse2 = TRUE; }     
     
     // While it hasn't reached the end of the check, keep going
     while (nCheckTo >= nCheck)	
     {
        // If the PC has a prereq feat, mark it down
        if(GetHasFeat(nCheck, oPC)) nPrereqCount += 1;
        // If the number of prereq feats is at least equal to requirement, return true.
     	if (nPrereqCount >= nCount) return TRUE;        
        
     	nCheck += 1;
     }
     // Diamond Mind, Stone Dragon, Tiger Claw 2nd class check
     while (nCheckTo2 >= nCheck2 && bUse2)	
     {
        // If the PC has a prereq feat, mark it down
        if(GetHasFeat(nCheck2, oPC)) nPrereqCount += 1;
        // If the number of prereq feats is at least equal to requirement, return true.
     	if (nPrereqCount >= nCount) return TRUE;        
        
     	nCheck2 += 1;
     }
     // Stone Dragon 3rd class check
     while (nCheckTo3 >= nCheck3 && bUse3)	
     {
        // If the PC has a prereq feat, mark it down
        if(GetHasFeat(nCheck3, oPC)) nPrereqCount += 1;
        // If the number of prereq feats is at least equal to requirement, return true.
     	if (nPrereqCount >= nCount) return TRUE;        
        
     	nCheck3 += 1;
     }     
     
     // Gotten this far and you haven't met the prereqs
     return FALSE;
}

void _RecursiveStanceCheck(object oPC, object oTestWP, int nMoveId)
{
    // Seeing if this works better
    string sWPTag = "PRC_BMWP_" + GetName(oPC) + GetManeuverName(nMoveId);
    oTestWP = GetWaypointByTag(sWPTag);
    // Distance moved in the last round
    float fDist = GetDistanceBetween(oPC, oTestWP);
    // Giving them a little extra distance because of NWN's dance of death
    float fCheck = FeetToMeters(10.0);
    if(DEBUG) DoDebug("_RecursiveStanceCheck: fDist: " + FloatToString(fDist));
    if(DEBUG) DoDebug("_RecursiveStanceCheck: fCheck: " + FloatToString(fCheck));
    

    // Moved the distance
    if (fDist >= fCheck)
    {
        // Clean up stances or other abilities that are lost when moving too far
        RemoveEffectsFromSpell(oPC, nMoveId);
        if(DEBUG) DoDebug("_RecursiveStanceCheck: Moved too far, cancelling stances.");
        // Clean up the test WP as well
        DestroyObject(oTestWP);
    }
    else // run the check again
    {
    	DelayCommand(6.0, _RecursiveStanceCheck(oPC, oTestWP, nMoveId));
    	if(DEBUG) DoDebug("_RecursiveStanceCheck: DelayCommand(6.0, _RecursiveStanceCheck(oPC, oTestWP, nMoveId)).");
    }
}

void _DoBullRushKnockBack(object oTarget, object oPC, float fFeet)
{
            // Calculate how far the creature gets pushed
            float fDistance = FeetToMeters(fFeet);
            // Determine if they hit a wall on the way
            location lPC           = GetLocation(oPC);
            location lTargetOrigin = GetLocation(oTarget);
            vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(lPC, lTargetOrigin));
            vector vTargetOrigin   = GetPosition(oTarget);
            vector vTarget         = vTargetOrigin + (vAngle * fDistance);

            if(!LineOfSightVector(vTargetOrigin, vTarget))
            {
                // Hit a wall, binary search for the wall
                float fEpsilon    = 1.0f;          // Search precision
                float fLowerBound = 0.0f;          // The lower search bound, initialise to 0
                float fUpperBound = fDistance;     // The upper search bound, initialise to the initial distance
                fDistance         = fDistance / 2; // The search position, set to middle of the range

                do{
                    // Create test vector for this iteration
                    vTarget = vTargetOrigin + (vAngle * fDistance);

                    // Determine which bound to move.
                    if(LineOfSightVector(vTargetOrigin, vTarget))
                        fLowerBound = fDistance;
                    else
                        fUpperBound = fDistance;

                    // Get the new middle point
                    fDistance = (fUpperBound + fLowerBound) / 2;
                }while(fabs(fUpperBound - fLowerBound) > fEpsilon);
            }

            // Create the final target vector
            vTarget = vTargetOrigin + (vAngle * fDistance);

            // Move the target
            location lTargetDestination = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
            AssignCommand(oTarget, ClearAllActions(TRUE));
            AssignCommand(oTarget, JumpToLocation(lTargetDestination));
}

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetInitiatingClass(object oInitiator = OBJECT_SELF)
{
    return GetLocalInt(oInitiator, PRC_INITIATING_CLASS) - 1;
}

int GetInitiatorLevel(object oInitiator, int nSpecificClass = CLASS_TYPE_INVALID, int nUseHD = FALSE)
{
    int nLevel;
    int nTotalHD = GetHitDice(oInitiator);
    int nAdjust = GetLocalInt(oInitiator, PRC_CASTERLEVEL_ADJUSTMENT);

    // If this is set, return the user's HD
    if (nUseHD) return GetHitDice(oInitiator);

    // The function user needs to know the character's Initiator level in a specific class
    // instead of whatever the character last initiated a maneuver as
    if(nSpecificClass != CLASS_TYPE_INVALID)
    {
        if(GetIsBladeMagicClass(nSpecificClass))
        {
            int nClassLevel = GetLevelByClass(nSpecificClass, oInitiator);
            if (nClassLevel > 0)
            {
            	// Initiator level is class level + 1/2 levels in all other classes
                // See ToB p39
		// Max level is therefor the level plus 1/2 of remaining levels
                nLevel = nClassLevel + ((nTotalHD - nClassLevel)/2);
            }
        }
        // A character with no initiator levels has an init level of 1/2 HD
        else
            return nTotalHD/2;
    }

    // Item Spells
    if(GetItemPossessor(GetSpellCastItem()) == oInitiator)
    {
        if(DEBUG) SendMessageToPC(oInitiator, "Item casting at level " + IntToString(GetCasterLevel(oInitiator)));

        return GetCasterLevel(oInitiator) + nAdjust;
    }

    // For when you want to assign the caster level.
    else if(GetLocalInt(oInitiator, PRC_CASTERLEVEL_OVERRIDE) != 0)
    {
        if(DEBUG) SendMessageToPC(oInitiator, "Forced-level initiating at level " + IntToString(GetCasterLevel(oInitiator)));

        DelayCommand(1.0, DeleteLocalInt(oInitiator, PRC_CASTERLEVEL_OVERRIDE));
        nLevel = GetLocalInt(oInitiator, PRC_CASTERLEVEL_OVERRIDE);
    }

    // If everything else fails, use the character's first class position
    if(nLevel == 0)
    {
        if(DEBUG)             DoDebug("Failed to get Initiator level for creature " + DebugObject2Str(oInitiator) + ", using first class slot");
        else WriteTimestampedLogEntry("Failed to get Initiator level for creature " + DebugObject2Str(oInitiator) + ", using first class slot");

        nLevel = GetLevelByPosition(1, oInitiator);
    }

    nLevel += nAdjust;

    // This spam is technically no longer necessary once the Initiator level getting mechanism has been confirmed to work
//    if(DEBUG) FloatingTextStringOnCreature("Initiator Level: " + IntToString(nLevel), oInitiator, FALSE);

    return nLevel;
}

int GetIsBladeMagicUser(object oCreature)
{
    return !!(GetLevelByClass(CLASS_TYPE_CRUSADER, oCreature) ||
              GetLevelByClass(CLASS_TYPE_SWORDSAGE,    oCreature)||
              GetLevelByClass(CLASS_TYPE_WARBLADE,    oCreature)
             );
}

int GetHighestInitiatorLevel(object oCreature)
{
    return max(max(PRCGetClassByPosition(1, oCreature) != CLASS_TYPE_INVALID ? GetInitiatorLevel(oCreature, PRCGetClassByPosition(1, oCreature)) : 0,
                   PRCGetClassByPosition(2, oCreature) != CLASS_TYPE_INVALID ? GetInitiatorLevel(oCreature, PRCGetClassByPosition(2, oCreature)) : 0
                   ),
               PRCGetClassByPosition(3, oCreature) != CLASS_TYPE_INVALID ? GetInitiatorLevel(oCreature, PRCGetClassByPosition(3, oCreature)) : 0
               );
}

int GetIsBladeMagicClass(int nClass)
{
    return (nClass==CLASS_TYPE_CRUSADER          ||
            nClass==CLASS_TYPE_SWORDSAGE         ||
            nClass==CLASS_TYPE_WARBLADE 
            );
}

int GetManeuverLevel(object oInitiator)
{
    return GetLocalInt(oInitiator, PRC_MANEUVER_LEVEL);
}

string GetManeuverName(int nSpellId)
{
	return GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId)));
}

string GetDisciplineName(int nDiscipline)
{
	string sName;
	if (nDiscipline == DISCIPLINE_DESERT_WIND)          sName = GetStringByStrRef(16829714);
	else if (nDiscipline == DISCIPLINE_DEVOTED_SPIRIT)  sName = GetStringByStrRef(16829715);
	else if (nDiscipline == DISCIPLINE_DIAMOND_MIND)    sName = GetStringByStrRef(16829716);
	else if (nDiscipline == DISCIPLINE_IRON_HEART)      sName = GetStringByStrRef(16829717);
	else if (nDiscipline == DISCIPLINE_SETTING_SUN)     sName = GetStringByStrRef(16829718);
	else if (nDiscipline == DISCIPLINE_SHADOW_HAND)     sName = GetStringByStrRef(16829719);
	else if (nDiscipline == DISCIPLINE_STONE_DRAGON)    sName = GetStringByStrRef(16829720);
	else if (nDiscipline == DISCIPLINE_TIGER_CLAW)      sName = GetStringByStrRef(16829721);
	else if (nDiscipline == DISCIPLINE_WHITE_RAVEN)     sName = GetStringByStrRef(16829722);

	return sName;
}

int GetDisciplineByManeuver(int nSpellId, int nClass)
{
     // Get the class-specific base
     string sFile = Get2DACache("classes", "FeatsTable", nClass);
     sFile = "cls_move" + GetStringRight(sFile, GetStringLength(sFile) - 8);
     
     int i, nManeuver;
     for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
     {
         nManeuver = StringToInt(Get2DACache(sFile, "SpellID", i));
         if(nManeuver == nSpellId)
         {
             return StringToInt(Get2DACache(sFile, "Discipline", i));
         }
     }
     // This should never happen
     return -1;
}

int GetBladeMagicPRCLevels(object oCreature)
{
    int nLevel = 0;
/*
    // Cerebremancer and Psychic Theurge add initiator levels on each level
    nLevel += GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oCreature);
    nLevel += GetLevelByClass(CLASS_TYPE_PSYCHIC_THEURGE, oCreature);

    // No initiator level boost at level 1 and 10 for Thrallherd
    if(GetLevelByClass(CLASS_TYPE_THRALLHERD, oCreature))
    {
        nLevel += GetLevelByClass(CLASS_TYPE_THRALLHERD, oCreature) - 1;
        if(GetLevelByClass(CLASS_TYPE_THRALLHERD, oCreature) >= 10) nLevel -= 1;
    }
    // No initiator level boost at level 1 and 6 for Iron Mind
    if(GetLevelByClass(CLASS_TYPE_IRONMIND, oCreature))
    {
        nLevel += GetLevelByClass(CLASS_TYPE_IRONMIND, oCreature) - 1;
        if(GetLevelByClass(CLASS_TYPE_IRONMIND, oCreature) >= 6) nLevel -= 1;
    }
    // No initiator level boost at level 1 for Sanctified Mind
    if(GetLevelByClass(CLASS_TYPE_SANCTIFIED_MIND, oCreature))
    {
        nLevel += GetLevelByClass(CLASS_TYPE_SANCTIFIED_MIND, oCreature) - 1;
    }
*/
    return nLevel;
}

int GetFirstBladeMagicClass(object oCreature = OBJECT_SELF)
{
    int nBladeMagicPos = GetFirstBladeMagicClassPosition(oCreature);
    if (!nBladeMagicPos) return CLASS_TYPE_INVALID; // no Blade Magic initiating class

    return PRCGetClassByPosition(nBladeMagicPos, oCreature);
}

int GetFirstBladeMagicClassPosition(object oCreature = OBJECT_SELF)
{
    if (GetIsBladeMagicClass(PRCGetClassByPosition(1, oCreature)))
        return 1;
    if (GetIsBladeMagicClass(PRCGetClassByPosition(2, oCreature)))
        return 2;
    if (GetIsBladeMagicClass(PRCGetClassByPosition(3, oCreature)))
        return 3;

    return 0;
}

int CheckManeuverPrereqs(int nClass, int nFeat, object oPC)
{
    // Having the power already automatically disqualifies one from taking it again
    if(GetHasFeat(nFeat, oPC))
    return FALSE;
    // This does NOT use these slots properly
    // FEAT1 is the DISCIPLINE that is required
    // FEAT2 is the NUMBER of Maneuvers from the Discipline required
    if(Get2DACache("feat", "PREREQFEAT1", nFeat) != "")
    {
        int nDiscipline = StringToInt(Get2DACache("feat", "PREREQFEAT1", nFeat));
        int nCount      = StringToInt(Get2DACache("feat", "PREREQFEAT2", nFeat));
        // if it returns false, exit, otherwise they can take the maneuver
        if (!_CheckPrereqsByDiscipline(oPC, nDiscipline, nCount, nClass)) return FALSE;
    }

    // if you've reached this far then return TRUE
    return TRUE;
}

int GetIsManeuverSupernatural(int nMoveId)
{
	if (nMoveId == MOVE_DW_BLISTERING_FLOURISH) return TRUE;

	// If nothing returns TRUE, fail
	return FALSE;
}

int GetHasActiveStance(object oInitiator)
{
	if (GetHasSpellEffect(MOVE_SD_STONEFOOT_STANCE, oInitiator)) return MOVE_SD_STONEFOOT_STANCE;

	// If nothing returns TRUE, fail
	return FALSE;
}

void ClearStances(object oInitiator, int nDontClearMove)
{
	// Clears spell effects, will not clear DontClearMove
	// This is used to allow Warblades to have two stances.
	if (GetHasSpellEffect(MOVE_SD_STONEFOOT_STANCE, oInitiator) && nDontClearMove != MOVE_SD_STONEFOOT_STANCE) 
		RemoveEffectsFromSpell(oInitiator, MOVE_SD_STONEFOOT_STANCE);
}

void MarkStanceActive(object oInitiator, int nStance)
{
	// If the first stance is active, use second
	// This should only be called with the first active when it is legal to have two stances
	if (GetLocalInt(oInitiator, "TOBStanceOne") > 0) SetLocalInt(oInitiator, "TOBStanceTwo", nStance);
	else SetLocalInt(oInitiator, "TOBStanceOne", nStance);
}

effect VersusSizeEffect(object oInitiator, effect eEffect, int nSize)
{
	// Right now this only deals with medium and small PCs
	int nPCSize = PRCGetCreatureSize(oInitiator);
	effect eLink;
	// Creatures larger than PC
	if (nSize == 1)	
	{
		eLink = VersusRacialTypeEffect(eEffect, RACIAL_TYPE_ABERRATION);
		eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_CONSTRUCT));
		eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_DRAGON));
		eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_ELEMENTAL));
		eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_GIANT));
		eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_OUTSIDER));
		if (nPCSize == CREATURE_SIZE_SMALL)
		{
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_ANIMAL));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_BEAST));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_DWARF));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_ELF));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_HALFELF));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_HALFORC));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_HUMAN));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_HUMANOID_GOBLINOID));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_HUMANOID_MONSTROUS));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_HUMANOID_ORC));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_HUMANOID_REPTILIAN));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_MAGICAL_BEAST));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_OOZE));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_SHAPECHANGER));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_UNDEAD));		
		}
	}// Smaller
	if (nSize == 0)	
	{
		eLink = VersusRacialTypeEffect(eEffect, RACIAL_TYPE_FEY);
		eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_VERMIN));
		if (nPCSize == CREATURE_SIZE_MEDIUM)
		{
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_GNOME));
			eLink = EffectLinkEffects(eLink, VersusRacialTypeEffect(eEffect, RACIAL_TYPE_HALFLING));	
		}
	}	
	
	return eLink;
}

void InitiatorMovementCheck(object oPC, int nMoveId)
{
    // Check to see if the WP is valid
    string sWPTag = "PRC_BMWP_" + GetName(oPC) + GetManeuverName(nMoveId);
    object oTestWP = GetWaypointByTag(sWPTag);
    if (!GetIsObjectValid(oTestWP))
    {
        // Create waypoint for the movement
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);
        if(DEBUG) DoDebug("InitiatorMovementCheck: WP for " + DebugObject2Str(oPC) + " didn't exist, creating. Tag: " + sWPTag);
    }
    // Start the recursive HB check for movement
    _RecursiveStanceCheck(oPC, oTestWP, nMoveId);
}

int GetAbilityCheckBonus(object oPC, int nAbility)
{
	int nBonus = 0;
	if (nAbility == ABILITY_STRENGTH)
	{
		if (GetHasSpellEffect(MOVE_SD_STONEFOOT_STANCE, oPC)) nBonus += 2;
		if (GetHasSpellEffect(MOVE_SS_STEP_WIND,        oPC)) nBonus += 4;
	}
	else if (nAbility == ABILITY_DEXTERITY)
	{
		if (GetHasSpellEffect(MOVE_SS_STEP_WIND,        oPC)) nBonus += 4;
	}
	if(DEBUG) DoDebug("GetAbilityCheckBonus: nBonus " + IntToString(nBonus));
	return nBonus;
}

int GetIsStance(int nMoveId)
{
	if(DEBUG) DoDebug("GetIsStance running");	
	if (StringToInt(Get2DACache(sManeuverFile, "Stance", i)) == 1) return TRUE;
	
	return FALSE;
}

effect EffectDazzle()
{
	effect eLink = EffectLinkEffects(EffectAttackDecrease(1), EffectSkillDecrease(SKILL_SEARCH, 1));
	       eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_SPOT, 1));
	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_PWBLIND));

	if(DEBUG) DoDebug("EffectDazzle running");	       
	return eLink;
}

void DoDesertWindBoost(object oPC)
{
	if(DEBUG) DoDebug("DoDesertWindBoost running");
	effect eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FLAME_M), EffectVisualEffect(VFX_IMP_PULSE_FIRE));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        object oItem = IPGetTargetedOrEquippedMeleeWeapon();
        // Add eventhook to the item
        AddEventScript(oItem, EVENT_ITEM_ONHIT, "tob_dw_onhit", TRUE, FALSE);
        DelayCommand(6.0, RemoveEventScript(oItem, EVENT_ITEM_ONHIT, "tob_dw_onhit", TRUE, FALSE));
        // Add the OnHit
        IPSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 6.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        SetLocalInt(oPC, "DesertWindBoot", PRCGetSpellId());
        DelayCommand(6.0, DeleteLocalInt(oPC, "DesertWindBoot"));
}

object GetCrusaderHealTarget(object oPC, float fDistance)
{
    	int nMaxHP = 0;
    	int nCurrentHP = 0;
    	int nCurrentMax = 0;
    	object oReturn;
    	//Get the first target in the radius around the caster
    	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fDistance), GetLocation(oPC));
    	while(GetIsObjectValid(oTarget) && GetIsPC(oTarget))
    	{
    		if(DEBUG) DoDebug("GetCrusaderHealTarget: oTarget " + GetName(oTarget));
		nCurrentHP = GetCurrentHitPoints(oTarget);
		nMaxHP = GetMaxHitPoints(oTarget);
		// Check HP vs current biggest loss
		// Set the target
		if ((nMaxHP - nCurrentHP) > nCurrentMax)
		{
			nCurrentMax = nMaxHP - nCurrentHP;
			oReturn = oTarget;
		}
        	//Get the next target in the specified area around the caster
        	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fDistance), GetLocation(oPC));
    	}
    	if(DEBUG) DoDebug("GetCrusaderHealTarget: oReturn " + GetName(oReturn));
    	return oReturn;
}

void SetIsCharging(object oPC)
{
	SetLocalInt(oPC, "PCIsCharging", TRUE);
	// You count as having charged for the entire round
	DelayCommand(6.0, DeleteLocalInt(oPC, "PCIsCharging"));
}

int GetIsCharging(object oPC)
{
	return GetLocalInt(oPC, "PCIsCharging");
}

int DoCharge(object oPC, object oTarget, int nDoAttack = TRUE, int nGenerateAoO = TRUE, int nBullRush = FALSE, int nExtraBonus = 0, int nBullAoO = TRUE, int nMustFollow = TRUE)
{
	if (!nGenerateAoO)
	{
		// Huge bonus to tumble to prevent AoOs from movement
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_TUMBLE, 50), oPC, 6.0);
	}
	// Return value
	int nSucceed = FALSE;
	float fDistance = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget));
	// PnP rules use feet, might as well convert it now.
	fDistance = MetersToFeet(fDistance);
	if(fDistance >= 10.0)
	{
		// Mark the PC as charging
		SetIsCharging(oPC);
		// These are the bonuses to attacks/AC on a charge
		effect eNone;
	        effect eCharge = EffectLinkEffects(EffectAttackIncrease(2), EffectACDecrease(2));
	        eCharge = EffectLinkEffects(eCharge, EffectMovementSpeedIncrease(99));
	        eCharge = SupernaturalEffect(eCharge);
	        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0);
	        // Move to the target
	        AssignCommand(oPC, ClearAllActions());
	       	AssignCommand(oPC, ActionMoveToObject(oTarget, TRUE));
	       	if (nDoAttack) // Perform the Attack
	       	{
			PerformAttack(oPC, oAreaTarget, eNone, 0.0, 0, 0, 0, FALSE, "Charge Hit", "Charge Miss");
			// Local int set when Perform Attack hits
			nSucceed = GetLocalInt(oTarget, "PRCCombat_StruckByAttack");
		}
		if (nBullRush)
			nSucceed = DoBullRush(oPC, oTarget, nExtraBonus, nBullAoO, nMustFollow);
	}
	else
	{
		FloatingTextStringOnCreature("You are too close to charge " + GetName(oTarget), oPC);
	}	
}

int DoBullRush(object oPC, object oTarget, int nExtraBonus, int nGenerateAoO = TRUE, int nMustFollow = TRUE)
{
	// The basic modifiers
	int nSucceed = FALSE;
	int nPCStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nTargetStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
	int nPCBonus = GetSizeModifier(oPC);
	int nTargetBonus = GetSizeModifier(oTarget);
	// Get a +2 bonus for charging during a bullrush
	if (GetIsCharging(oPC)) nPCBonus += 2;
	// Other ability bonuses
	nPCBonus += GetAbilityCheckBonus(oPC, ABILITY_STRENGTH);
	// Do the AoO for moving into the enemy square
	if (nGenerateAoO)
	{
		location lTarget = GetLocation(oPC);
		// Use the function to get the closest creature as a target
		object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		while(GetIsObjectValid(oAreaTarget))
		{
		    // All enemies in range get a free AoO shot
		    if(oAreaTarget != oPC && // Don't hit yourself
		       GetIsInMeleeRange(oPC, oAreaTarget) && // They must be in melee range
		       GetIsEnemy(oAreaTarget, oPC)) // Only enemies are going to take AoOs
		    {
		        // Perform the Attack
			PerformAttack(oPC, oAreaTarget, eNone, 0.0, 0, 0, 0, FALSE, "Attack of Opportunity Hit", "Attack of Opportunity Miss");
		    }
		
		//Select the next target within the spell shape.
		oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
        	}	
	}
	int nPCCheck = nPCStr + nPCBonus + d20();
	int nTargetCheck = nTargetStr + nTargetBonus + d20();
	// Now roll the ability check
	if (nPCCheck >= nTargetCheck)
	{
		// Knock them back 5 feet
		float fFeet = 5.0;
		// For every 5 points greater, knock back an additional 5 feet.
		fFeet += 5.0 * ((nPCCheck - nTargetCheck) / 5);
		nSucceed = TRUE;
		_DoBullRushKnockBack(oTarget, oPC, fFeet);
		// If the PC has to keep pushing to knock back, move the PC along, 5 feet less
		if (nMustFollow) _DoBullRushKnockBack(oPC, oTarget, (fFeet - 5.0));
	}
	else
		FloatingTextStringOnCreature("You have failed your Strength check for your Bull Rush Attempt",oPC);
	
	// Let people know if we made the hit or not
	return nSucceed;
}

int DoTrip(object oPC, object oTarget, int nExtraBonus, int nGenerateAoO = TRUE, int nCounterTrip = TRUE)
{
	// The basic modifiers
	int nSucceed = FALSE;
	int nPCStat, nTargetStat;
	// Use the higher of the two mods
	if (GetAbilityModifier(ABILITY_STRENGTH, oPC) > GetAbilityModifier(ABILITY_DEXTERITY, oPC))
		nPCStat = GetAbilityModifier(ABILITY_STRENGTH, oPC) + GetAbilityCheckBonus(oPC, ABILITY_STRENGTH);
	else
		nPCStat = GetAbilityModifier(ABILITY_DEXTERITY, oPC) + GetAbilityCheckBonus(oPC, ABILITY_DEXTERITY);
	// Use the higher of the two mods	
	if (GetAbilityModifier(ABILITY_STRENGTH, oTarget) > GetAbilityModifier(ABILITY_DEXTERITY, oTarget))
		nTargetStat = GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetAbilityCheckBonus(oTarget, ABILITY_STRENGTH);
	else
		nTargetStat = GetAbilityModifier(ABILITY_DEXTERITY, oTarget) + GetAbilityCheckBonus(oTarget, ABILITY_DEXTERITY);
	// Get mods for size
	int nPCBonus = GetSizeModifier(oPC);
	int nTargetBonus = GetSizeModifier(oTarget);
	
	// Do the AoO for a trip attempt
	if (nGenerateAoO)
	{
		// Perform the Attack
		effect eNone;
		PerformAttack(oPC, oTarget, eNone, 0.0, 0, 0, 0, FALSE, "Attack of Opportunity Hit", "Attack of Opportunity Miss");	
	}
	int nPCCheck = nPCStat + nPCBonus + nExtraBonus + d20();
	int nTargetCheck = nTargetStat + nTargetBonus + d20();
	// Now roll the ability check
	if (nPCCheck >= nTargetCheck)
	{
		FloatingTextStringOnCreature("You have succeeded your ability check for your Trip attempt",oPC);
		// Knock em down
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
		nSucceed = TRUE;
	}
	else // If you fail, enemy gets a counter trip attempt, using Strength
	{
		nTargetStat = GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetAbilityCheckBonus(oTarget, ABILITY_STRENGTH);
		FloatingTextStringOnCreature("You have failed your ability check for your Trip attempt",oPC);
		// Roll counter trip attempt
		nTargetCheck = nTargetStat + nTargetBonus + d20();
		nPCCheck = nPCStat + nPCBonus + d20();
		// If counters aren't allowed, don't knock em down
		// Its down here to allow the text message to go through
		if (nTargetCheck >= nPCCheck && nCounterTrip)
		{
			// Knock em down
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oPC, 6.0);
		}
	}
	
	// Let people know if we made the hit or not
	return nSucceed;
}

// Test main
//void main(){}