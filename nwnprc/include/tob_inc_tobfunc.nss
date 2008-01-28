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

const int    GRAPPLE_ATTACK          = 1;
const int    GRAPPLE_OPPONENT_WEAPON = 2;
const int    GRAPPLE_ESCAPE          = 3;
const int    GRAPPLE_TOB_CRUSHING    = 4;

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
 * @param nMoveId    maneuver to check
 * @param nClass     Class to check with (no class has all maneuvers)
 # @param nSpellFeat Whether nMoveId is a feat or a spell id
 *
 * @return           DISCIPLINE_*
 */
int GetDisciplineByManeuver(int nMoveId, int nClass, int nSpellFeat = -1);

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
 * Or whether the adept has moved far enough to get a bonus from a stance
 *
 * @param oPC        The Initiator
 * @param nMoveId    The stance
 * @param fFeet      The distance to check
 */
void InitiatorMovementCheck(object oPC, int nMoveId, float fFeet = 10.0);

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
 * @param nDamage       A damage bonus on the charge
 * @param nDamageType   Damage type of the bonus.
 * @param nBullRush     Do a Bull Rush at the end of a charge
 * @param nExtraBonus   An extra bonus to grant the PC on the Bull rush
 * @param nBullAoO      Does the bull rush attempt generate an AoO
 * @param nMustFollow   Does the Bull rush require the pushing PC to follow the target
 * @param nAttack       Bonus to the attack roll // I forgot to add it before, I'm an idiot ok?
 * @param nPounce	FALSE for normal behaviour, TRUE to do a full attack at the end of a charge // Same comment as above
 *
 * @return              TRUE if the attack or Bull rush hits, else FALSE
 */
int DoCharge(object oPC, object oTarget, int nDoAttack = TRUE, int nGenerateAoO = TRUE, int nDamage = 0, int nDamageType = -1, int nBullRush = FALSE, int nExtraBonus = 0, int nBullAoO = TRUE, int nMustFollow = TRUE, int nAttack = 0, int nPounce = FALSE);

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
 *                      It sets a local int known as TripDifference that is the amount you succeeded or failed by.
 */
int DoTrip(object oPC, object oTarget, int nExtraBonus, int nGenerateAoO = TRUE, int nCounterTrip = TRUE);

/**
 * Will take an int and transform it into one of the DAMAGE_BONUS constants (From 1 to 20).
 *
 * @param nCheck     Int to convert
 * @return           DAMAGE_BONUS_1 to DAMAGE_BONUS_20
 */
int GetIntToDamage(int nCheck);

/**
 * Returns true or false if the swordsage has Insightful Strike in the chosen discipline
 * @param oInitiator    Person to check
 *
 * @return              TRUE or FALSE
 */
int GetHasInsightfulStrike(object oInitiator);

/**
 * Returns true or false if the swordsage has Defensive Stance
 * ONLY CALL THIS FROM WITHIN STANCES
 * @param oInitiator    Person to check
 * @param nDiscipline   DISCIPLINE_ constant of the school of the maneuver.
 *
 * @return              TRUE or FALSE
 */
int GetHasDefensiveStance(object oInitiator, int nDiscipline);

/**
 * This will do a complete PnP Grapple
 *
 * @param oPC           The PC
 * @param oTarget       The Target
 * @param nExtraBonus   An extra bonus to grant the PC
 * @param nGenerateAoO  Does the Grapple attempt generate an AoO
 *
 * @return              TRUE if the Trip succeeds, else FALSE
 */
int DoGrapple(object oPC, object oTarget, int nExtraBonus, int nGenerateAoO = TRUE);

/**
 * Marks a target as grappled.
 *
 * @param oTarget           The Target
 */
void SetGrapple(object oTarget);

/**
 * Returns true or false if the creature is grappled.
 *
 * @param oTarget       Person to check
 *
 * @return              TRUE or FALSE
 */
int GetGrapple(object oTarget);

/**
 * Ends a grapple between the two creatures
 *
 * @param oPC               The PC
 * @param oTarget           The Target
 */
void EndGrapple(object oPC, object oTarget);

/**
 * The options that can be performed during a grapple.
 *
 * @param oPC           The PC
 * @param oTarget       The Target
 * @param nExtraBonus   An extra bonus to grant the PC
 * @param nSwitch       The options to use. One of:  GRAPPLE_ATTACK, GRAPPLE_OPPONENT_WEAPON, GRAPPLE_ESCAPE, GRAPPLE_TOB_CRUSHING
 *
 * @return              TRUE if the Trip succeeds, else FALSE
 */
void DoGrappleOptions(object oPC, object oTarget, int nExtraBonus, int nSwitch = -1);

/**
 * Returns true or false if the creature's right hand weapon is light
 *
 * @param oPC           Person to check
 *
 * @return              TRUE or FALSE
 */
int GetIsLightWeapon(object oPC);

/**
 * This will do a complete PnP Overrun. See tob_stdr_bldrrll for an example of how to use.
 * Overrun is part of a move action.
 *
 * @param oPC           The PC
 * @param oTarget       The Target
 * @param nExtraBonus   An extra bonus to grant the PC
 * @param nGenerateAoO  Does the Overrun attempt generate an AoO
 * @param nAvoid        Can the target avoid you
 * @param nCounterTrip  Can the target attempt a counter if you fail
 *
 * @return              TRUE if the Overrun succeeds, else FALSE
 *                      It sets a local int known as OverrunDifference that is the amount you succeeded or failed by.
 */
int DoOverrun(object oPC, object oTarget, int nGenerateAoO = TRUE, int nExtraBonus = 0, int nAvoid = TRUE, int nCounter = TRUE);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "tob_move_const"
#include "prc_alterations"
#include "tob_inc_move"
#include "tob_inc_moveknwn"

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

void _RecursiveStanceCheck(object oPC, object oTestWP, int nMoveId, float fFeet = 10.0)
{
    // Seeing if this works better
    string sWPTag = "PRC_BMWP_" + GetName(oPC) + GetManeuverName(nMoveId);
    oTestWP = GetWaypointByTag(sWPTag);
    // Distance moved in the last round
    float fDist = GetDistanceBetween(oPC, oTestWP);
    // Giving them a little extra distance because of NWN's dance of death
    float fCheck = FeetToMeters(fFeet);
    if(DEBUG) DoDebug("_RecursiveStanceCheck: fDist: " + FloatToString(fDist));
    if(DEBUG) DoDebug("_RecursiveStanceCheck: fCheck: " + FloatToString(fCheck));
    

    // Moved the distance
    if (fDist >= fCheck)
    {
        // Stances that clean up
        if (nMoveId = MOVE_SD_STONEFOOT_STANCE) 
        {
                RemoveEffectsFromSpell(oPC, nMoveId);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Moved too far, cancelling stances.");
                // Clean up the test WP as well
                DestroyObject(oTestWP);
        }
        // Stances that clean up
        else if (nMoveId = MOVE_MOUNTAIN_FORTRESS) 
        {
                RemoveEffectsFromSpell(oPC, nMoveId);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Moved too far, cancelling stances.");
                // Clean up the test WP as well
                DestroyObject(oTestWP);
        }        
        // Stances that clean up
        else if (nMoveId = MOVE_SD_ROOT_MOUNTAIN) 
        {
                RemoveEffectsFromSpell(oPC, nMoveId);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Moved too far, cancelling stances.");
                // Clean up the test WP as well
                DestroyObject(oTestWP);
        }        
        else if (nMoveId = MOVE_SH_CHILD_SHADOW)
        {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectConcealment(20)), oPC, 6.0);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Applying bonuses.");
                // Clean up the test WP 
                DestroyObject(oTestWP);
                // Create waypoint for the movement for next round
                CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);          
        }
        else if (nMoveId = MOVE_IH_ABSOLUTE_STEEL)
        {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(2)), oPC, 6.0);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Applying bonuses.");
                // Clean up the test WP 
                DestroyObject(oTestWP);
                // Create waypoint for the movement for next round
                CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);          
        }
        
        else if (nMoveId = MOVE_SD_GIANTS_STANCE)
        {
                DeleteLocalInt(oPC, "DWGiantsStance");
                DeleteLocalInt(oPC, "PRC_Power_Expansion_SizeIncrease");
                RemoveEffectsFromSpell(oPC, nMoveId);
                DestroyObject(oTestWP);        
        }
        
        else if (nMoveId = MOVE_IH_DANCING_BLADE_FORM)
        {
                DeleteLocalInt(oPC, "DWDancingBladeForm");
                DestroyObject(oTestWP);
        }
        
    }
    // If they still have the spell, keep going
    if (GetHasSpellEffect(nMoveId, oPC))
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

int _DoGrappleCheck(object oPC, object oTarget, int nExtraBonus)
{
        // The basic modifiers
        int nSucceed = FALSE;
        int nPCStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        int nTargetStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
        int nPCBonus = GetSizeModifier(oPC);
        int nTargetBonus = GetSizeModifier(oTarget);
        // Other ability bonuses
        nPCBonus += GetAbilityCheckBonus(oPC, ABILITY_STRENGTH);
        // Extra bonus
        nPCBonus += nExtraBonus;
        
        //cant grapple incorporeal or ethereal things
        if((GetIsEthereal(oTarget) && !GetIsEthereal(oPC))
                || GetIsIncorporeal(oTarget))
        {
                FloatingTextStringOnCreature("You cannot grapple an Ethereal or Incorporeal creature",oPC, FALSE);
                return FALSE;
        }

        int nPCCheck = nPCStr + nPCBonus + d20();
        int nTargetCheck = nTargetStr + nTargetBonus + d20();
        // Now roll the ability check
        if (nPCCheck >= nTargetCheck)
        {
                return TRUE;
        }
        
        // Didn't grapple successfully
        return FALSE;
}

int _RestrictedDiscipline(object oInitiator, int nDiscipline)
{
	// There's no restrictions
	if (GetPersistantLocalInt(oInitiator, "RestrictedDiscipline1") == 0) return TRUE;
	
	string sString = "RestrictedDiscipline";
	int i;
     	for(i = 1; i < 6; i++)
     	{
     		// Cycle through the local ints
     		sString += IntToString(i);
     		if (nDiscipline == GetPersistantLocalInt(oInitiator, sString)) return TRUE;
	}
	
	// Down here, every check is failed
	return FALSE;
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

int GetDisciplineByManeuver(int nMoveId, int nClass, int nSpellFeat = -1)
{
     // Get the class-specific base
     string sFile = Get2DACache("classes", "FeatsTable", nClass);
     sFile = "cls_move" + GetStringRight(sFile, GetStringLength(sFile) - 8);
     
     string sSearch = "SpellID";
     if (nSpellFeat != -1) sSearch = "FeatID";
     
     int i, nManeuver;
     for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
     {
         nManeuver = StringToInt(Get2DACache(sFile, sSearch, i));
         if(nManeuver == nMoveId)
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
    int nDiscipline = StringToInt(Get2DACache("feat", "PREREQFEAT1", nFeat));
    if (!_RestrictedDiscipline(oPC, nDiscipline)) return FALSE;
    int nCount      = StringToInt(Get2DACache("feat", "PREREQFEAT2", nFeat));
    // if it returns false, exit, otherwise they can take the maneuver
    if (!_CheckPrereqsByDiscipline(oPC, nDiscipline, nCount, nClass)) return FALSE;


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

void InitiatorMovementCheck(object oPC, int nMoveId, float fFeet = 10.0)
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
    _RecursiveStanceCheck(oPC, oTestWP, nMoveId, fFeet);
}

int GetAbilityCheckBonus(object oPC, int nAbility)
{
        int nBonus = 0;
        if (nAbility == ABILITY_STRENGTH)
        {
                if (GetHasSpellEffect(MOVE_SD_STONEFOOT_STANCE, oPC)) nBonus += 2;
                if (GetHasSpellEffect(MOVE_SS_STEP_WIND,        oPC)) nBonus += 4;
                if (GetHasSpellEffect(MOVE_SD_ROOT_MOUNTAIN,    oPC)) nBonus += 10;
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
        // Somewhat silly and ineffecient hardcoding, but I'm feeling lazy.
        // Checks three times since each has unique maneuvers.
        string sManeuverFile = GetAMSDefinitionFileName(CLASS_TYPE_CRUSADER);
        if (StringToInt(Get2DACache(sManeuverFile, "Stance", nMoveId)) == 1) return TRUE;
        sManeuverFile = GetAMSDefinitionFileName(CLASS_TYPE_SWORDSAGE);
        if (StringToInt(Get2DACache(sManeuverFile, "Stance", nMoveId)) == 1) return TRUE;
        sManeuverFile = GetAMSDefinitionFileName(CLASS_TYPE_WARBLADE);
        if (StringToInt(Get2DACache(sManeuverFile, "Stance", nMoveId)) == 1) return TRUE;
        
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
        SetLocalInt(oPC, "DesertWindBoost", PRCGetSpellId());
        DelayCommand(6.0, DeleteLocalInt(oPC, "DesertWindBoost"));
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

int DoCharge(object oPC, object oTarget, int nDoAttack = TRUE, int nGenerateAoO = TRUE, int nDamage = 0, int nDamageType = -1, int nBullRush = FALSE, int nExtraBonus = 0, int nBullAoO = TRUE, int nMustFollow = TRUE, int nAttack = 0, int nPounce = FALSE)
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
                        int nDamage = 0;
                        // Checks for a White Raven Stance
                        // If it exists, +1 damage/initiator level
                        if (GetIsObjectValid(GetLocalObject(oPC, "LeadingTheCharge")))
                        {
                                nDamage += GetInitiatorLevel(GetLocalObject(oPC, "LeadingTheCharge"));
                        }
                        if (nDamageType == -1) // If the damage type isn't set
                        {
                                object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
                                nDamageType = GetWeaponDamageType(oWeap);
                        }
                        if (nPounce) // Uses instant attack in order to make sure they all go off in the alloted period of time.
                        	PerformAttackRound(oPC, oTarget, eNone, 0.0, nAttack, nDamage, nDamageType, FALSE, "Charge Hit", "Charge Miss", FALSE, FALSE, TRUE);
                        else
                        	PerformAttack(oPC, oTarget, eNone, 0.0, nAttack, nDamage, nDamageType, "Charge Hit", "Charge Miss");
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
        return nSucceed;
}

int DoBullRush(object oPC, object oTarget, int nExtraBonus, int nGenerateAoO = TRUE, int nMustFollow = TRUE)
{
        // The basic modifiers
        int nSucceed = FALSE;
        int nPCStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        int nTargetStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
        int nPCBonus = GetSizeModifier(oPC);
        int nTargetBonus = GetSizeModifier(oTarget);
        effect eNone;
        // Get a +2 bonus for charging during a bullrush
        if (GetIsCharging(oPC)) nPCBonus += 2;
        // Other ability bonuses
        nPCBonus += GetAbilityCheckBonus(oPC, ABILITY_STRENGTH);
        // Extra bonus
        nPCBonus += nExtraBonus;
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
                        PerformAttack(oPC, oAreaTarget, eNone, 0.0, 0, 0, 0, "Attack of Opportunity Hit", "Attack of Opportunity Miss");
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
                FloatingTextStringOnCreature("You have failed your Bull Rush Attempt",oPC, FALSE);
        
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
                PerformAttack(oPC, oTarget, eNone, 0.0, 0, 0, 0, "Attack of Opportunity Hit", "Attack of Opportunity Miss");     
        }
        int nPCCheck = nPCStat + nPCBonus + nExtraBonus + d20();
        int nTargetCheck = nTargetStat + nTargetBonus + d20();
        // Now roll the ability check
        if (nPCCheck >= nTargetCheck)
        {
                FloatingTextStringOnCreature("You have succeeded on your Trip attempt",oPC, FALSE);
                // Knock em down
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
                nSucceed = TRUE;
                SetLocalInt(oPC, "TripDifference", nPCCheck - nTargetCheck);
                DelayCommand(2.0, DeleteLocalInt(oPC, "TripDifference"));
        }
        else // If you fail, enemy gets a counter trip attempt, using Strength
        {
                nTargetStat = GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetAbilityCheckBonus(oTarget, ABILITY_STRENGTH);
                FloatingTextStringOnCreature("You have failed on your Trip attempt",oPC, FALSE);
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
                SetLocalInt(oPC, "TripDifference", nTargetCheck - nPCCheck);
                DelayCommand(2.0, DeleteLocalInt(oPC, "TripDifference"));
        }
        
        // Let people know if we made the hit or not
        return nSucceed;
}

int GetIntToDamage(int nCheck)
{
    int IntToDam = -1;

    if (nCheck == 1)
    {
        IntToDam = DAMAGE_BONUS_1;
    }
    else if (nCheck == 2)
    {
        IntToDam = DAMAGE_BONUS_2;
    }
    else if (nCheck == 3)
    {
        IntToDam = DAMAGE_BONUS_3;
    }
    else if (nCheck == 4)
    {
        IntToDam = DAMAGE_BONUS_4;
    }
    else if (nCheck == 5)
    {
        IntToDam = DAMAGE_BONUS_5;
    }
    else if (nCheck == 6)
    {
        IntToDam = DAMAGE_BONUS_6;
    }
    else if (nCheck == 7)
    {
        IntToDam = DAMAGE_BONUS_7;
    }
    else if (nCheck == 8)
    {
        IntToDam = DAMAGE_BONUS_8;
    }
    else if (nCheck == 9)
    {
        IntToDam = DAMAGE_BONUS_9;
    }
    else if (nCheck == 10)
    {
        IntToDam = DAMAGE_BONUS_10;
    }
    else if (nCheck == 11)
    {
        IntToDam = DAMAGE_BONUS_11;
    }
    else if (nCheck == 12)
    {
        IntToDam = DAMAGE_BONUS_12;
    }
    else if (nCheck == 13)
    {
        IntToDam = DAMAGE_BONUS_13;
    }
    else if (nCheck == 14)
    {
        IntToDam = DAMAGE_BONUS_14;
    }
    else if (nCheck == 15)
    {
        IntToDam = DAMAGE_BONUS_15;
    }
    else if (nCheck == 16)
    {
        IntToDam = DAMAGE_BONUS_16;
    }
    else if (nCheck == 17)
    {
        IntToDam = DAMAGE_BONUS_17;
    }
    else if (nCheck == 18)
    {
        IntToDam = DAMAGE_BONUS_18;
    }
    else if (nCheck == 19)
    {
        IntToDam = DAMAGE_BONUS_19;
    }
    else if (nCheck >= 20)
    {
        IntToDam = DAMAGE_BONUS_20;
    }

    return IntToDam;
}

int GetHasInsightfulStrike(object oInitiator)
{
        // Always the swordsage
        int nDiscToCheck = GetDisciplineByManeuver(PRCGetSpellId(), CLASS_TYPE_SWORDSAGE);
        if      (GetHasFeat(FEAT_SS_DF_IS_DW, oInitiator) && nDiscToCheck == DISCIPLINE_DESERT_WIND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_DM, oInitiator) && nDiscToCheck == DISCIPLINE_DIAMOND_MIND) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_SS, oInitiator) && nDiscToCheck == DISCIPLINE_SETTING_SUN)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_SH, oInitiator) && nDiscToCheck == DISCIPLINE_SHADOW_HAND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_SD, oInitiator) && nDiscToCheck == DISCIPLINE_STONE_DRAGON) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_TC, oInitiator) && nDiscToCheck == DISCIPLINE_TIGER_CLAW)   return TRUE;
        
        return FALSE;
}

int GetHasDefensiveStance(object oInitiator, int nDiscipline)
{
        // Because this is only called from inside the proper stances
        // Its just a check to see if they should link in the save boost.
        if      (GetHasFeat(FEAT_SS_DF_DS_DW, oInitiator) && nDiscipline == DISCIPLINE_DESERT_WIND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_DM, oInitiator) && nDiscipline == DISCIPLINE_DIAMOND_MIND) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_SS, oInitiator) && nDiscipline == DISCIPLINE_SETTING_SUN)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_SH, oInitiator) && nDiscipline == DISCIPLINE_SHADOW_HAND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_SD, oInitiator) && nDiscipline == DISCIPLINE_STONE_DRAGON) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_TC, oInitiator) && nDiscipline == DISCIPLINE_TIGER_CLAW)   return TRUE;
        
        return FALSE;
}


int DoGrapple(object oPC, object oTarget, int nExtraBonus, int nGenerateAoO = TRUE)
{        
        int nSucceed = FALSE;
        effect eNone;
        // Do the AoO for trying a grapple
        if (nGenerateAoO)
        {
                // Perform the Attack
                PerformAttack(oPC, oTarget, eNone, 0.0, 0, 0, 0, "Attack of Opportunity Hit", "Attack of Opportunity Miss");     
        
                if (GetLocalInt(oPC, "PRCCombat_StruckByAttack"))
                {
                        FloatingTextStringOnCreature("You have failed at your Grapple Attempt.",oPC, FALSE);
                        return FALSE;
                }
        }

        // Now roll the ability check
        if (_DoGrappleCheck(oPC, oTarget, nExtraBonus))
        {
                FloatingTextStringOnCreature("You have successfully grappled " + GetName(oTarget), oPC, FALSE);
                SetGrapple(oTarget);
                effect eHold = EffectCutsceneImmobilize();
                effect eEntangle = EffectVisualEffect(VFX_DUR_SPELLTURNING_R);
                effect eLink = EffectLinkEffects(eHold, eEntangle);
                //apply the effect
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 9999.0);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 9999.0);
                nSucceed = TRUE;
        }
        else
                FloatingTextStringOnCreature("You have failed your Grapple Attempt",oPC, FALSE);
        
        // Let people know if we made the hit or not
        return nSucceed;
}

void SetGrapple(object oTarget)
{
        SetLocalInt(oTarget, "IsGrappled", TRUE);
}

int GetGrapple(object oTarget)
{
        return GetLocalInt(oTarget, "IsGrappled");
}

void EndGrapple(object oPC, object oTarget)
{
        DeleteLocalInt(oPC, "IsGrappled");
        DeleteLocalInt(oTarget, "IsGrappled");
        effect eBad = GetFirstEffect(oTarget);
        //Search for negative effects
        while(GetIsEffectValid(eBad))
        {
                int nInt = GetEffectSpellId(eBad);
                if (GetEffectType(eBad) == EFFECT_TYPE_CUTSCENEIMMOBILIZE)
                {
                        RemoveEffect(oTarget, eBad);
                }
                eBad = GetNextEffect(oTarget);
        }
        eBad = GetFirstEffect(oPC);
        //Search for negative effects
        while(GetIsEffectValid(eBad))
        {
                int nInt = GetEffectSpellId(eBad);
                if (GetEffectType(eBad) == EFFECT_TYPE_CUTSCENEIMMOBILIZE)
                {
                        RemoveEffect(oPC, eBad);
                }
                eBad = GetNextEffect(oPC);
        }       
}

void DoGrappleOptions(object oPC, object oTarget, int nExtraBonus, int nSwitch = -1)
{
        effect eNone;
                
        if (nSwitch == -1 || GetGrapple(oPC) || GetGrapple(oTarget))
        {
                FloatingTextStringOnCreature("DoGrappleOptions: Error, invalid option passed to function",oPC, FALSE);
                return;
        }
        else if (nSwitch == GRAPPLE_ATTACK)
        {
                // Must be a light weapon, and succeed at the grapple check
                if (_DoGrappleCheck(oPC, oTarget, nExtraBonus) && GetIsLightWeapon(oPC))
                {
                        // Bonuses to attack in a grapple from stance
                        if (GetHasSpellEffect(MOVE_TC_WOLVERINE_STANCE, oPC))
                        {
                                int nDam = 0;
                                if (PRCGetCreatureSize(oTarget) > PRCGetCreatureSize(oPC)) nDam = 4;
                                PerformAttack(oPC, oTarget, eNone, 0.0, 0, nDam, 0, "Wolverine Stance Hit", "Wolverine Stance Miss");    
                        }
                        else
                        {
                                // Attack with a -4 penalty
                                PerformAttack(oPC, oTarget, eNone, 0.0, -4, 0, 0, "Grapple Attack Hit", "Grapple Attack Miss");  
                        }
                }
                else
                        FloatingTextStringOnCreature("You have failed your Grapple Attempt",oPC, FALSE);        
        }
        else if (nSwitch == GRAPPLE_OPPONENT_WEAPON)
        {
                // Must be a light weapon, and succeed at the grapple check
                if (_DoGrappleCheck(oPC, oTarget, nExtraBonus) && GetIsLightWeapon(oTarget))
                {
                        // Attack with a -4 penalty
                        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
                        PerformAttack(oPC, oTarget, eNone, 0.0, -4, 0, 0, "Grapple Attack Hit", "Grapple Attack Miss", FALSE, oWeapon);  
                }
                else
                        FloatingTextStringOnCreature("You have failed your Grapple Attempt",oPC, FALSE);        
        }
        else if (nSwitch == GRAPPLE_ESCAPE)
        {
                // Must be a light weapon, and succeed at the grapple check
                if (_DoGrappleCheck(oPC, oTarget, nExtraBonus))
                {
                        EndGrapple(oPC, oTarget);
                }
                else
                        FloatingTextStringOnCreature("You have failed your Grapple Attempt",oPC, FALSE);        
        }
        else if (nSwitch == GRAPPLE_TOB_CRUSHING && GetHasSpellEffect(MOVE_SD_CRUSHING_WEIGHT, oPC))
        {
                // Constrict for 2d6 + 1.5 Strength
                if (_DoGrappleCheck(oPC, oTarget, nExtraBonus))
                {
                        int nDam = FloatToInt(d6(2) + (GetAbilityModifier(ABILITY_STRENGTH, oPC) * 1.5));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam), oTarget);
                }
                else
                        FloatingTextStringOnCreature("You have failed your Grapple Attempt",oPC, FALSE);        
        }               
}

int GetIsLightWeapon(object oPC)
{
        // You may use any weapon in a grapple with this stance.
        if (GetHasSpellEffect(MOVE_TC_WOLVERINE_STANCE, oPC)) return TRUE;
        int nSize   = PRCGetCreatureSize(oPC);
        int nType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
        int nWeaponSize = StringToInt(Get2DACache("baseitems", "WeaponSize", nType));
        // is the size appropriate for a light weapon?
        return (nWeaponSize < nSize);  
}

int DoOverrun(object oPC, object oTarget, int nGenerateAoO = TRUE, int nExtraBonus = 0, int nAvoid = TRUE, int nCounter = TRUE)
{
        if (!nGenerateAoO)
        {
                // Huge bonus to tumble to prevent AoOs from movement
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_TUMBLE, 50), oPC, 6.0);
        }
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
                PerformAttack(oPC, oTarget, eNone, 0.0, 0, 0, 0, "Attack of Opportunity Hit", "Attack of Opportunity Miss");     
        }
        int nPCCheck = nPCStat + nPCBonus + nExtraBonus + d20();
        int nTargetCheck = nTargetStat + nTargetBonus + d20();
        
        // The target has the option to avoid. Smaller targets will avoid if allowed.
        if (nPCBonus > nTargetBonus && nAvoid)
        {
                FloatingTextStringOnCreature(GetName(oTarget) + " has successfully avoided you", oPC, FALSE);
                // You didn't knock down the target, but neither did it stop you. Keep on chugging.
                return TRUE;
        }       
        // Now roll the ability check
        if (nPCCheck >= nTargetCheck)
        {
                FloatingTextStringOnCreature("You have succeeded on your Overrun attempt",oPC, FALSE);
                // Knock em down
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oTarget, 6.0);
                nSucceed = TRUE;
                SetLocalInt(oPC, "OverrunDifference", nPCCheck - nTargetCheck);
                DeleteLocalInt(oPC, "OverrunDifference");
        }
        else // If you fail, enemy gets a counter Overrun attempt, using Strength
        {
                nTargetStat = GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetAbilityCheckBonus(oTarget, ABILITY_STRENGTH);
                FloatingTextStringOnCreature("You have failed on your Overrun attempt",oPC, FALSE);
                // Roll counter Overrun attempt
                nTargetCheck = nTargetStat + nTargetBonus + d20();
                nPCCheck = nPCStat + nPCBonus + d20();
                // If counters aren't allowed, don't knock em down
                // Its down here to allow the text message to go through
                if (nTargetCheck >= nPCCheck && nCounter)
                {
                        // Knock em down
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oPC, 6.0);
                }
                SetLocalInt(oPC, "OverrunDifference", nTargetCheck - nPCCheck);
                DelayCommand(2.0, DeleteLocalInt(oPC, "OverrunDifference"));
        }       
        
        return nSucceed;
}
// Test main
//void main(){}