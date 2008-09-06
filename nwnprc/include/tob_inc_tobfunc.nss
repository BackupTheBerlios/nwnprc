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
int GetBladeMagicPRCLevels(object oInitiator);

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
 * Checks whether the PC has the prereqs for the maneuver
 *
 * @param nClass The class that is trying to learn the feat
 * @param nFeat The maneuver's FeatId
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


int _CheckPrereqsByDiscipline(object oPC, int nDiscipline, int nCount, int nClass, int nType = MANEUVER_TYPE_MANEUVER)
{
     // Place to finish, place to start in feat.2da
     int nCheckTo, nCheck, nCheckTo2, nCheck2, nCheckTo3, nCheck3;
     int bUse2 = FALSE;
     int bUse3 = FALSE;
     int nPrereqCount = 0;
     // The range to check for prereqs
     // Some disciplines (5 of the 9) only have one range to check (single class disciplines)
     if (nDiscipline == DISCIPLINE_DESERT_WIND)    	{ nCheck = 23672; nCheckTo = 23698; }
     else if (nDiscipline == DISCIPLINE_DEVOTED_SPIRIT) { nCheck = 23602; nCheckTo = 23627; }
     else if (nDiscipline == DISCIPLINE_IRON_HEART)     { nCheck = 23835; nCheckTo = 23855; }
     else if (nDiscipline == DISCIPLINE_SETTING_SUN)    { nCheck = 23721; nCheckTo = 23740; }
     else if (nDiscipline == DISCIPLINE_SHADOW_HAND)    { nCheck = 23741; nCheckTo = 23765; }
     
     // These disciplines require looping over two or three areas in feat.2da
     else if (nDiscipline == DISCIPLINE_DIAMOND_MIND && nClass == CLASS_TYPE_SWORDSAGE)    { nCheck = 23699; nCheckTo = 23720; }
     else if (nDiscipline == DISCIPLINE_DIAMOND_MIND && nClass == CLASS_TYPE_WARBLADE)     { nCheck2 = 23813; nCheckTo2 = 23834; bUse2 = TRUE; }
     else if (nDiscipline == DISCIPLINE_STONE_DRAGON && nClass == CLASS_TYPE_CRUSADER)     { nCheck = 23628; nCheckTo = 23651; }
     else if (nDiscipline == DISCIPLINE_STONE_DRAGON && nClass == CLASS_TYPE_SWORDSAGE)    { nCheck2 = 23766; nCheckTo2 = 23789; bUse2 = TRUE; }     
     else if (nDiscipline == DISCIPLINE_STONE_DRAGON && nClass == CLASS_TYPE_WARBLADE)     { nCheck3 = 23856; nCheckTo3 = 23879; bUse3 = TRUE; }     
     else if (nDiscipline == DISCIPLINE_TIGER_CLAW   && nClass == CLASS_TYPE_SWORDSAGE)    { nCheck = 23790; nCheckTo = 23812; }
     else if (nDiscipline == DISCIPLINE_TIGER_CLAW   && nClass == CLASS_TYPE_WARBLADE)     { nCheck2 = 23880; nCheckTo2 = 23902; bUse2 = TRUE; }     
     else if (nDiscipline == DISCIPLINE_WHITE_RAVEN  && nClass == CLASS_TYPE_CRUSADER)     { nCheck = 23652; nCheckTo = 23671; }
     else if (nDiscipline == DISCIPLINE_WHITE_RAVEN  && nClass == CLASS_TYPE_WARBLADE)     { nCheck2 = 23903; nCheckTo2 = 23922; bUse2 = TRUE; }  
     
     // While it hasn't reached the end of the check, keep going
     while (nCheckTo >= nCheck) 
     {
        // If the PC has a prereq feat, mark it down
        if(GetHasFeat(nCheck, oPC)) 
        {
        	if (nType == MANEUVER_TYPE_MANEUVER)
       			nPrereqCount += 1;
        	// If stances are being looked for, special check
        	else if ((nType == MANEUVER_TYPE_STANCE && Get2DACache("feat", "Constant", nCheck) == "MANEUVER_STANCE"))
        	      	nPrereqCount += 1;
        }
        // If the number of prereq feats is at least equal to requirement, return true.
        if (nPrereqCount >= nCount) return TRUE;        
        
        nCheck += 1;
     }
     // Diamond Mind, Stone Dragon, Tiger Claw. White Raven 2nd class check
     while (nCheckTo2 >= nCheck2 && bUse2)      
     {
        // If the PC has a prereq feat, mark it down
        if(GetHasFeat(nCheck, oPC)) 
        {
        	if (nType == MANEUVER_TYPE_MANEUVER)
       			nPrereqCount += 1;
        	// If stances are being looked for, special check
        	else if ((nType == MANEUVER_TYPE_STANCE && Get2DACache("feat", "Constant", nCheck) == "MANEUVER_STANCE"))
        	      	nPrereqCount += 1;
        }
        // If the number of prereq feats is at least equal to requirement, return true.
        if (nPrereqCount >= nCount) return TRUE;        
        
        nCheck2 += 1;
     }
     // Stone Dragon 3rd class check
     while (nCheckTo3 >= nCheck3 && bUse3)      
     {
        // If the PC has a prereq feat, mark it down
        if(GetHasFeat(nCheck, oPC)) 
        {
        	if (nType == MANEUVER_TYPE_MANEUVER)
       			nPrereqCount += 1;
        	// If stances are being looked for, special check
        	else if ((nType == MANEUVER_TYPE_STANCE && Get2DACache("feat", "Constant", nCheck) == "MANEUVER_STANCE"))
        	      	nPrereqCount += 1;
        }
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
    string sWPTag = "PRC_BMWP_" + GetName(oPC) + IntToString(nMoveId);
    oTestWP = GetWaypointByTag(sWPTag);
    // Distance moved in the last round
    float fDist = FeetToMeters(GetDistanceBetween(oPC, oTestWP));
    // Giving them a little extra distance because of NWN's dance of death
    float fCheck = FeetToMeters(fFeet);
    if(DEBUG) DoDebug("_RecursiveStanceCheck: fDist: " + FloatToString(fDist));
    if(DEBUG) DoDebug("_RecursiveStanceCheck: fCheck: " + FloatToString(fCheck));
    if(DEBUG) DoDebug("_RecursiveStanceCheck: nMoveId: " + IntToString(nMoveId));
    

    // Moved the distance
    if (fDist >= fCheck)
    {
    	if(DEBUG) DoDebug("_RecursiveStanceCheck: fDist > fCheck");
        // Stances that clean up
        if (nMoveId == MOVE_SD_STONEFOOT_STANCE) 
        {
                RemoveEffectsFromSpell(oPC, nMoveId);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Moved too far, cancelling stances.");
                // Clean up the test WP as well
                DestroyObject(oTestWP);
        }
        // Stances that clean up
        else if (nMoveId == MOVE_MOUNTAIN_FORTRESS) 
        {
                RemoveEffectsFromSpell(oPC, nMoveId);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Moved too far, cancelling stances.");
                // Clean up the test WP as well
                DestroyObject(oTestWP);
        }        
        // Stances that clean up
        else if (nMoveId == MOVE_SD_ROOT_MOUNTAIN) 
        {
                RemoveEffectsFromSpell(oPC, nMoveId);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Moved too far, cancelling stances.");
                // Clean up the test WP as well
                DestroyObject(oTestWP);
        }        
        else if (nMoveId == MOVE_SH_CHILD_SHADOW)
        {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectConcealment(20)), oPC, 6.0);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Applying bonuses.");
                // Clean up the test WP 
                DestroyObject(oTestWP);
                // Create waypoint for the movement for next round
                CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);          
        }
        else if (nMoveId == MOVE_IH_ABSOLUTE_STEEL)
        {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectACIncrease(2)), oPC, 6.0);
                if(DEBUG) DoDebug("_RecursiveStanceCheck: Applying bonuses.");
                // Clean up the test WP 
                DestroyObject(oTestWP);
                // Create waypoint for the movement for next round
                CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);          
        }
        
        else if (nMoveId == MOVE_SD_GIANTS_STANCE)
        {
                DeleteLocalInt(oPC, "DWGiantsStance");
                DeleteLocalInt(oPC, "PRC_Power_Expansion_SizeIncrease");
                RemoveEffectsFromSpell(oPC, nMoveId);
                DestroyObject(oTestWP);        
        }
        
        else if (nMoveId == MOVE_IH_DANCING_BLADE_FORM)
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
    
    if(DEBUG) DoDebug("_RecursiveStanceCheck: Exiting");
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
                // Prestige classes are stuck in here 
                nClassLevel += GetBladeMagicPRCLevels(oInitiator);
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

int GetBladeMagicPRCLevels(object oInitiator)
{
    	int nLevel = 0;
	
	nLevel += GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL, oInitiator);
	
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
        else if (nMoveId == MOVE_DW_BURNING_BLADE) return TRUE;
        else if (nMoveId == MOVE_DW_DISTRACTING_EMBER) return TRUE;
        else if (nMoveId == MOVE_DW_FLAMES_BLESSING) return TRUE;
        else if (nMoveId == MOVE_DW_BURNING_BRAND) return TRUE;
        else if (nMoveId == MOVE_DW_FIRE_RIPOSTE    ) return TRUE;
        else if (nMoveId == MOVE_DW_HATCHLINGS_FLAME) return TRUE;
        else if (nMoveId == MOVE_DW_DEATH_MARK	 ) return TRUE;
        else if (nMoveId == MOVE_DW_FAN_FLAMES     ) return TRUE;
        else if (nMoveId == MOVE_DW_HOLOCAUST_CLOAK) return TRUE;
        else if (nMoveId == MOVE_DW_FIRESNAKE	) return TRUE;
        else if (nMoveId == MOVE_DW_SEARING_BLADE ) return TRUE;
        else if (nMoveId == MOVE_DW_SEARING_CHARGE) return TRUE;
        else if (nMoveId == MOVE_DW_DRAGONS_FLAME ) return TRUE;
        else if (nMoveId == MOVE_DW_LEAPING_FLAME    ) return TRUE;
        else if (nMoveId == MOVE_DW_LINGERING_INFERNO) return TRUE;
        else if (nMoveId == MOVE_DW_FIERY_ASSAULT ) return TRUE;
        else if (nMoveId == MOVE_DW_RING_FIRE	) return TRUE;
        else if (nMoveId == MOVE_DW_INFERNO_BLADE ) return TRUE;
        else if (nMoveId == MOVE_DW_SALAMANDER_CHARGE) return TRUE;
        else if (nMoveId == MOVE_DW_RISING_PHOENIX) return TRUE;
        else if (nMoveId == MOVE_DW_WYRMS_FLAME   ) return TRUE;
	else if (nMoveId == MOVE_DW_INFERNO_BLAST) return TRUE;
        else if (nMoveId == MOVE_SH_BALANCE_SKY) return TRUE;
        else if (nMoveId == MOVE_SH_CHILD_SHADOW ) return TRUE;
        else if (nMoveId == MOVE_SH_CLINGING_SHADOW    ) return TRUE;
        else if (nMoveId == MOVE_SH_CLOAK_DECEPTION) return TRUE;
        else if (nMoveId == MOVE_SH_ENERVATING_SHADOW ) return TRUE;
        else if (nMoveId == MOVE_SH_FIVE_SHADOW_CREEPING	) return TRUE;
        else if (nMoveId == MOVE_SH_GHOST_BLADE ) return TRUE;
        else if (nMoveId == MOVE_SH_OBSCURING_SHADOW_VEIL) return TRUE;
        else if (nMoveId == MOVE_SH_SHADOW_BLADE_TECH) return TRUE;
        else if (nMoveId == MOVE_SH_SHADOW_GARROTTE   ) return TRUE;
	else if (nMoveId == MOVE_SH_SHADOW_NOOSE) return TRUE;	
	else if (nMoveId == MOVE_SH_STRENGTH_DRAINING) return TRUE;	
        
        // If nothing returns TRUE, fail
        return FALSE;
}

int GetHasActiveStance(object oInitiator)
{
	if (GetHasSpellEffect(MOVE_DW_FLAMES_BLESSING, oInitiator)) return MOVE_DW_FLAMES_BLESSING;
	else if (GetHasSpellEffect(MOVE_DS_IRON_GUARDS_GLARE, oInitiator)) return MOVE_DS_IRON_GUARDS_GLARE;
	else if (GetHasSpellEffect(MOVE_DS_MARTIAL_SPIRIT, oInitiator)) return MOVE_DS_MARTIAL_SPIRIT;
	else if (GetHasSpellEffect(MOVE_DM_STANCE_OF_CLARITY, oInitiator)) return MOVE_DM_STANCE_OF_CLARITY;
	else if (GetHasSpellEffect(MOVE_IH_PUNISHING_STANCE, oInitiator)) return MOVE_IH_PUNISHING_STANCE;
	else if (GetHasSpellEffect(MOVE_SS_STEP_WIND, oInitiator)) return MOVE_SS_STEP_WIND;
	else if (GetHasSpellEffect(MOVE_SH_CHILD_SHADOW, oInitiator)) return MOVE_SH_CHILD_SHADOW;
	else if (GetHasSpellEffect(MOVE_SH_ISLAND_BLADES, oInitiator)) return MOVE_SH_ISLAND_BLADES;
	else if (GetHasSpellEffect(MOVE_SD_STONEFOOT_STANCE, oInitiator)) return MOVE_SD_STONEFOOT_STANCE;
	else if (GetHasSpellEffect(MOVE_TC_BLOOD_WATER, oInitiator)) return MOVE_TC_BLOOD_WATER;
	else if (GetHasSpellEffect(MOVE_TC_HUNTERS_SENSE, oInitiator)) return MOVE_TC_HUNTERS_SENSE;
	else if (GetHasSpellEffect(MOVE_WR_BOLSTERING_VOICE, oInitiator)) return MOVE_WR_BOLSTERING_VOICE;
	else if (GetHasSpellEffect(MOVE_WR_LEADING_CHARGE, oInitiator)) return MOVE_WR_LEADING_CHARGE;
	else if (GetHasSpellEffect(MOVE_DW_HOLOCAUST_CLOAK, oInitiator)) return MOVE_DW_HOLOCAUST_CLOAK;
        else if (GetHasSpellEffect(MOVE_DS_THICKET_BLADES, oInitiator)) return MOVE_DS_THICKET_BLADES;
	else if (GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oInitiator)) return MOVE_DM_PEARL_BLACK_DOUBT;
	else if (GetHasSpellEffect(MOVE_IH_ABSOLUTE_STEEL, oInitiator)) return MOVE_IH_ABSOLUTE_STEEL;
	else if (GetHasSpellEffect(MOVE_SS_GIANT_KILLING_STYLE, oInitiator)) return MOVE_SS_GIANT_KILLING_STYLE;
	else if (GetHasSpellEffect(MOVE_SH_ASSASSINS_STANCE, oInitiator)) return MOVE_SH_ASSASSINS_STANCE;
	else if (GetHasSpellEffect(MOVE_SH_DANCE_SPIDER, oInitiator)) return MOVE_SH_DANCE_SPIDER;
	else if (GetHasSpellEffect(MOVE_SD_CRUSHING_WEIGHT, oInitiator)) return MOVE_SD_CRUSHING_WEIGHT;
	else if (GetHasSpellEffect(MOVE_SD_ROOT_MOUNTAIN, oInitiator)) return MOVE_SD_ROOT_MOUNTAIN;
	else if (GetHasSpellEffect(MOVE_TC_LEAPING_DRAGON, oInitiator)) return MOVE_TC_LEAPING_DRAGON;
	else if (GetHasSpellEffect(MOVE_TC_WOLVERINE_STANCE, oInitiator)) return MOVE_TC_WOLVERINE_STANCE;
	else if (GetHasSpellEffect(MOVE_WR_TACTICS_WOLF, oInitiator)) return MOVE_WR_TACTICS_WOLF;
	else if (GetHasSpellEffect(MOVE_DM_HEARING_AIR, oInitiator)) return MOVE_DM_HEARING_AIR;
	else if (GetHasSpellEffect(MOVE_IH_DANCING_BLADE_FORM, oInitiator)) return MOVE_IH_DANCING_BLADE_FORM;
	else if (GetHasSpellEffect(MOVE_SS_SHIFTING_DEFENSE, oInitiator)) return MOVE_SS_SHIFTING_DEFENSE;
        else if (GetHasSpellEffect(MOVE_SH_STEP_DANCING_MOTH, oInitiator)) return MOVE_SH_STEP_DANCING_MOTH;
	else if (GetHasSpellEffect(MOVE_SD_GIANTS_STANCE, oInitiator)) return MOVE_SD_GIANTS_STANCE;
	else if (GetHasSpellEffect(MOVE_WR_PRESS_ADVANTAGE, oInitiator)) return MOVE_WR_PRESS_ADVANTAGE;
	else if (GetHasSpellEffect(MOVE_DW_FIERY_ASSAULT, oInitiator)) return MOVE_DW_FIERY_ASSAULT;
	else if (GetHasSpellEffect(MOVE_DS_AURA_CHAOS, oInitiator)) return MOVE_DS_AURA_CHAOS;
	else if (GetHasSpellEffect(MOVE_DS_PERFECT_ORDER, oInitiator)) return MOVE_DS_PERFECT_ORDER;
	else if (GetHasSpellEffect(MOVE_DS_AURA_TRIUMPH, oInitiator)) return MOVE_DS_AURA_TRIUMPH;
	else if (GetHasSpellEffect(MOVE_DS_AURA_TYRANNY, oInitiator)) return MOVE_DS_AURA_TYRANNY;
	else if (GetHasSpellEffect(MOVE_TC_PREY_ON_THE_WEAK, oInitiator)) return MOVE_TC_PREY_ON_THE_WEAK;
	else if (GetHasSpellEffect(MOVE_DW_RISING_PHOENIX, oInitiator)) return MOVE_DW_RISING_PHOENIX;
	else if (GetHasSpellEffect(MOVE_DS_IMMORTAL_FORTITUDE, oInitiator)) return MOVE_DS_IMMORTAL_FORTITUDE;
	else if (GetHasSpellEffect(MOVE_DM_STANCE_ALACRITY, oInitiator)) return MOVE_DM_STANCE_ALACRITY;
	else if (GetHasSpellEffect(MOVE_IH_SUPREME_BLADE_PARRY, oInitiator)) return MOVE_IH_SUPREME_BLADE_PARRY;
	else if (GetHasSpellEffect(MOVE_SS_GHOSTLY_DEFENSE, oInitiator)) return MOVE_SS_GHOSTLY_DEFENSE;
        else if (GetHasSpellEffect(MOVE_SH_BALANCE_SKY, oInitiator)) return MOVE_SH_BALANCE_SKY;  
	else if (GetHasSpellEffect(MOVE_SD_STRENGTH_STONE, oInitiator)) return MOVE_SD_STRENGTH_STONE;
	else if (GetHasSpellEffect(MOVE_TC_WOLF_PACK_TACTICS, oInitiator)) return MOVE_TC_WOLF_PACK_TACTICS;
	else if (GetHasSpellEffect(MOVE_WR_SWARM_TACTICS, oInitiator)) return MOVE_WR_SWARM_TACTICS;

        // If nothing returns TRUE, fail
        return FALSE;
}

void ClearStances(object oInitiator, int nDontClearMove)
{
        // Clears spell effects, will not clear DontClearMove
        // This is used to allow Warblades to have two stances.
	if (GetHasSpellEffect(MOVE_DW_FLAMES_BLESSING, oInitiator) && nDontClearMove != MOVE_DW_FLAMES_BLESSING)
           RemoveEffectsFromSpell(oInitiator, MOVE_DW_FLAMES_BLESSING);	
	if (GetHasSpellEffect(MOVE_DS_IRON_GUARDS_GLARE, oInitiator) && nDontClearMove != MOVE_DS_IRON_GUARDS_GLARE)
           RemoveEffectsFromSpell(oInitiator, MOVE_DS_IRON_GUARDS_GLARE);	
	if (GetHasSpellEffect(MOVE_DS_MARTIAL_SPIRIT, oInitiator) && nDontClearMove != MOVE_DS_MARTIAL_SPIRIT)
           RemoveEffectsFromSpell(oInitiator, MOVE_DS_MARTIAL_SPIRIT);	
	if (GetHasSpellEffect(MOVE_DM_STANCE_OF_CLARITY, oInitiator) && nDontClearMove != MOVE_DM_STANCE_OF_CLARITY)
           RemoveEffectsFromSpell(oInitiator, MOVE_DM_STANCE_OF_CLARITY);	
	if (GetHasSpellEffect(MOVE_IH_PUNISHING_STANCE, oInitiator) && nDontClearMove != MOVE_IH_PUNISHING_STANCE)
           RemoveEffectsFromSpell(oInitiator, MOVE_IH_PUNISHING_STANCE);	
	if (GetHasSpellEffect(MOVE_SS_STEP_WIND, oInitiator) && nDontClearMove != MOVE_SS_STEP_WIND)
           RemoveEffectsFromSpell(oInitiator, MOVE_SS_STEP_WIND);	
	if (GetHasSpellEffect(MOVE_SH_CHILD_SHADOW, oInitiator) && nDontClearMove != MOVE_SH_CHILD_SHADOW)
           RemoveEffectsFromSpell(oInitiator, MOVE_SH_CHILD_SHADOW);	
	if (GetHasSpellEffect(MOVE_SH_ISLAND_BLADES, oInitiator) && nDontClearMove != MOVE_SH_ISLAND_BLADES)
           RemoveEffectsFromSpell(oInitiator, MOVE_SH_ISLAND_BLADES);	
	if (GetHasSpellEffect(MOVE_SD_STONEFOOT_STANCE, oInitiator) && nDontClearMove != MOVE_SD_STONEFOOT_STANCE)
           RemoveEffectsFromSpell(oInitiator, MOVE_SD_STONEFOOT_STANCE);	
	if (GetHasSpellEffect(MOVE_TC_BLOOD_WATER, oInitiator) && nDontClearMove != MOVE_TC_BLOOD_WATER)
           RemoveEffectsFromSpell(oInitiator, MOVE_TC_BLOOD_WATER);	
           
           if(DEBUG) DoDebug("tob_inc_tobfunc: ClearStances Part #1");
           
	if (GetHasSpellEffect(MOVE_TC_HUNTERS_SENSE, oInitiator) && nDontClearMove != MOVE_TC_HUNTERS_SENSE)
           RemoveEffectsFromSpell(oInitiator, MOVE_TC_HUNTERS_SENSE);	
	if (GetHasSpellEffect(MOVE_WR_BOLSTERING_VOICE, oInitiator) && nDontClearMove != MOVE_WR_BOLSTERING_VOICE)
           RemoveEffectsFromSpell(oInitiator, MOVE_WR_BOLSTERING_VOICE);	
	if (GetHasSpellEffect(MOVE_WR_LEADING_CHARGE, oInitiator) && nDontClearMove != MOVE_WR_LEADING_CHARGE)
           RemoveEffectsFromSpell(oInitiator, MOVE_WR_LEADING_CHARGE);	
	if (GetHasSpellEffect(MOVE_DW_HOLOCAUST_CLOAK, oInitiator) && nDontClearMove != MOVE_DW_HOLOCAUST_CLOAK)
           RemoveEffectsFromSpell(oInitiator, MOVE_DW_HOLOCAUST_CLOAK);	
        if (GetHasSpellEffect(MOVE_DS_THICKET_BLADES, oInitiator) && nDontClearMove != MOVE_DS_THICKET_BLADES)
           RemoveEffectsFromSpell(oInitiator, MOVE_DS_THICKET_BLADES);        
	if (GetHasSpellEffect(MOVE_DM_PEARL_BLACK_DOUBT, oInitiator) && nDontClearMove != MOVE_DM_PEARL_BLACK_DOUBT)
           RemoveEffectsFromSpell(oInitiator, MOVE_DM_PEARL_BLACK_DOUBT);	
	if (GetHasSpellEffect(MOVE_IH_ABSOLUTE_STEEL, oInitiator) && nDontClearMove != MOVE_IH_ABSOLUTE_STEEL)
           RemoveEffectsFromSpell(oInitiator, MOVE_IH_ABSOLUTE_STEEL);	
	if (GetHasSpellEffect(MOVE_SS_GIANT_KILLING_STYLE, oInitiator) && nDontClearMove != MOVE_SS_GIANT_KILLING_STYLE)
           RemoveEffectsFromSpell(oInitiator, MOVE_SS_GIANT_KILLING_STYLE);	
	if (GetHasSpellEffect(MOVE_SH_ASSASSINS_STANCE, oInitiator) && nDontClearMove != MOVE_SH_ASSASSINS_STANCE)
           RemoveEffectsFromSpell(oInitiator, MOVE_SH_ASSASSINS_STANCE);	
	if (GetHasSpellEffect(MOVE_SH_DANCE_SPIDER, oInitiator) && nDontClearMove != MOVE_SH_DANCE_SPIDER)
           RemoveEffectsFromSpell(oInitiator, MOVE_SH_DANCE_SPIDER);	
	if (GetHasSpellEffect(MOVE_SD_CRUSHING_WEIGHT, oInitiator) && nDontClearMove != MOVE_SD_CRUSHING_WEIGHT)
           RemoveEffectsFromSpell(oInitiator, MOVE_SD_CRUSHING_WEIGHT);	
           
           if(DEBUG) DoDebug("tob_inc_tobfunc: ClearStances Part #2");
       	
	if (GetHasSpellEffect(MOVE_SD_ROOT_MOUNTAIN, oInitiator) && nDontClearMove != MOVE_SD_ROOT_MOUNTAIN)
           RemoveEffectsFromSpell(oInitiator, MOVE_SD_ROOT_MOUNTAIN);	
	if (GetHasSpellEffect(MOVE_TC_LEAPING_DRAGON, oInitiator) && nDontClearMove != MOVE_TC_LEAPING_DRAGON)
           RemoveEffectsFromSpell(oInitiator, MOVE_TC_LEAPING_DRAGON);	
	if (GetHasSpellEffect(MOVE_TC_WOLVERINE_STANCE, oInitiator) && nDontClearMove != MOVE_TC_WOLVERINE_STANCE)
           RemoveEffectsFromSpell(oInitiator, MOVE_TC_WOLVERINE_STANCE);	
	if (GetHasSpellEffect(MOVE_WR_TACTICS_WOLF, oInitiator) && nDontClearMove != MOVE_WR_TACTICS_WOLF)
           RemoveEffectsFromSpell(oInitiator, MOVE_WR_TACTICS_WOLF);	
	if (GetHasSpellEffect(MOVE_DM_HEARING_AIR, oInitiator) && nDontClearMove != MOVE_DM_HEARING_AIR)
           RemoveEffectsFromSpell(oInitiator, MOVE_DM_HEARING_AIR);	
	if (GetHasSpellEffect(MOVE_IH_DANCING_BLADE_FORM, oInitiator) && nDontClearMove != MOVE_IH_DANCING_BLADE_FORM)
           RemoveEffectsFromSpell(oInitiator, MOVE_IH_DANCING_BLADE_FORM);	
	if (GetHasSpellEffect(MOVE_SS_SHIFTING_DEFENSE, oInitiator) && nDontClearMove != MOVE_SS_SHIFTING_DEFENSE)
           RemoveEffectsFromSpell(oInitiator, MOVE_SS_SHIFTING_DEFENSE);	
        if (GetHasSpellEffect(MOVE_SH_STEP_DANCING_MOTH, oInitiator) && nDontClearMove != MOVE_SH_STEP_DANCING_MOTH)
           RemoveEffectsFromSpell(oInitiator, MOVE_SH_STEP_DANCING_MOTH);        
	if (GetHasSpellEffect(MOVE_SD_GIANTS_STANCE, oInitiator) && nDontClearMove != MOVE_SD_GIANTS_STANCE)
           RemoveEffectsFromSpell(oInitiator, MOVE_SD_GIANTS_STANCE);	
	if (GetHasSpellEffect(MOVE_WR_PRESS_ADVANTAGE, oInitiator) && nDontClearMove != MOVE_WR_PRESS_ADVANTAGE)
           RemoveEffectsFromSpell(oInitiator, MOVE_WR_PRESS_ADVANTAGE);	
	if (GetHasSpellEffect(MOVE_DW_FIERY_ASSAULT, oInitiator) && nDontClearMove != MOVE_DW_FIERY_ASSAULT)
           RemoveEffectsFromSpell(oInitiator, MOVE_DW_FIERY_ASSAULT);	
	if (GetHasSpellEffect(MOVE_DS_AURA_CHAOS, oInitiator) && nDontClearMove != MOVE_DS_AURA_CHAOS)
    	{
           RemoveEffectsFromSpell(oInitiator, MOVE_DS_AURA_CHAOS);	
           DeleteLocalInt(oInitiator, "DSChaos");
    	}
	if (GetHasSpellEffect(MOVE_DS_PERFECT_ORDER, oInitiator) && nDontClearMove != MOVE_DS_PERFECT_ORDER)
	{
           RemoveEffectsFromSpell(oInitiator, MOVE_DS_PERFECT_ORDER);
           DeleteLocalInt(oInitiator, "DSPerfectOrder");	
    	}
    	
    	if(DEBUG) DoDebug("tob_inc_tobfunc: ClearStances Part #3");
    	
	if (GetHasSpellEffect(MOVE_DS_AURA_TRIUMPH, oInitiator) && nDontClearMove != MOVE_DS_AURA_TRIUMPH)
           RemoveEffectsFromSpell(oInitiator, MOVE_DS_AURA_TRIUMPH);	
	if (GetHasSpellEffect(MOVE_DS_AURA_TYRANNY, oInitiator) && nDontClearMove != MOVE_DS_AURA_TYRANNY)
           RemoveEffectsFromSpell(oInitiator, MOVE_DS_AURA_TYRANNY);	
	if (GetHasSpellEffect(MOVE_TC_PREY_ON_THE_WEAK, oInitiator) && nDontClearMove != MOVE_TC_PREY_ON_THE_WEAK)
           RemoveEffectsFromSpell(oInitiator, MOVE_TC_PREY_ON_THE_WEAK);	
	if (GetHasSpellEffect(MOVE_DW_RISING_PHOENIX, oInitiator) && nDontClearMove != MOVE_DW_RISING_PHOENIX)
           RemoveEffectsFromSpell(oInitiator, MOVE_DW_RISING_PHOENIX);	
	if (GetHasSpellEffect(MOVE_DS_IMMORTAL_FORTITUDE, oInitiator) && nDontClearMove != MOVE_DS_IMMORTAL_FORTITUDE)
           RemoveEffectsFromSpell(oInitiator, MOVE_DS_IMMORTAL_FORTITUDE);	
	if (GetHasSpellEffect(MOVE_DM_STANCE_ALACRITY, oInitiator) && nDontClearMove != MOVE_DM_STANCE_ALACRITY)
           RemoveEffectsFromSpell(oInitiator, MOVE_DM_STANCE_ALACRITY);	
	if (GetHasSpellEffect(MOVE_IH_SUPREME_BLADE_PARRY, oInitiator) && nDontClearMove != MOVE_IH_SUPREME_BLADE_PARRY)
           RemoveEffectsFromSpell(oInitiator, MOVE_IH_SUPREME_BLADE_PARRY);	
	if (GetHasSpellEffect(MOVE_SS_GHOSTLY_DEFENSE, oInitiator) && nDontClearMove != MOVE_SS_GHOSTLY_DEFENSE)
           RemoveEffectsFromSpell(oInitiator, MOVE_SS_GHOSTLY_DEFENSE);	
        if (GetHasSpellEffect(MOVE_SH_BALANCE_SKY, oInitiator) && nDontClearMove != MOVE_SH_BALANCE_SKY)  
           RemoveEffectsFromSpell(oInitiator, MOVE_SH_BALANCE_SKY);        
	if (GetHasSpellEffect(MOVE_SD_STRENGTH_STONE, oInitiator) && nDontClearMove != MOVE_SD_STRENGTH_STONE)
           RemoveEffectsFromSpell(oInitiator, MOVE_SD_STRENGTH_STONE);	
	if (GetHasSpellEffect(MOVE_TC_WOLF_PACK_TACTICS, oInitiator) && nDontClearMove != MOVE_TC_WOLF_PACK_TACTICS)
           RemoveEffectsFromSpell(oInitiator, MOVE_TC_WOLF_PACK_TACTICS);	
	if (GetHasSpellEffect(MOVE_WR_SWARM_TACTICS, oInitiator) && nDontClearMove != MOVE_WR_SWARM_TACTICS)  
                RemoveEffectsFromSpell(oInitiator, MOVE_WR_SWARM_TACTICS);
                
        if(DEBUG) DoDebug("tob_inc_tobfunc: ClearStances Part #4");
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
    string sWPTag = "PRC_BMWP_" + GetName(oPC) + IntToString(nMoveId);
    object oTestWP = GetWaypointByTag(sWPTag);
    if (!GetIsObjectValid(oTestWP))
    {
        // Create waypoint for the movement
        CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, sWPTag);
        if(DEBUG) DoDebug("InitiatorMovementCheck: WP for " + DebugObject2Str(oPC) + " didn't exist, creating. Tag: " + sWPTag);
    }
    // Start the recursive HB check for movement
    // Seeing if this solves some of the issues with it
    DelayCommand(2.0, _RecursiveStanceCheck(oPC, oTestWP, nMoveId, fFeet));
}

int GetIsStance(int nMoveId)
{
        if(DEBUG) DoDebug("GetIsStance running");
        int nClass = GetInitiatingClass(OBJECT_SELF);
        string sManeuverFile = GetAMSDefinitionFileName(nClass);
        int i, nManeuverLevel;
        string sMoveID;
        for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
        {
            // If looking for stances, skip maneuvers, else reverse
            if(StringToInt(Get2DACache(sManeuverFile, "Stance", i)) == 0){
                continue;
            } 
            sMoveID = Get2DACache(sManeuverFile, "RealSpellID", i);
            if(StringToInt(sMoveID) == nMoveId) return TRUE;
        }
        
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
        if(DEBUG) DoDebug("GetCrusaderHealTarget: HP to 0");
        object oReturn;
        //Get the first target in the radius around the caster
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fDistance), GetLocation(oPC));
        if(DEBUG) DoDebug("GetCrusaderHealTarget: First Target");
        while(GetIsObjectValid(oTarget))
        {
        	if(DEBUG) DoDebug("GetCrusaderHealTarget: Valid");
		if (GetIsPC(oTarget) && !GetIsEnemy(oTarget, oPC))
		{
                	if(DEBUG) DoDebug("GetCrusaderHealTarget: oTarget " + GetName(oTarget));
                	nCurrentHP = GetCurrentHitPoints(oTarget);
                	nMaxHP = GetMaxHitPoints(oTarget);
                	// Check HP vs current biggest loss
                	// Set the target
                	if ((nMaxHP - nCurrentHP) > nCurrentMax)
                	{
                		if(DEBUG) DoDebug("GetCrusaderHealTarget: New oReturn");
                	        nCurrentMax = nMaxHP - nCurrentHP;
                	        oReturn = oTarget;
                	}
                }
                if(DEBUG) DoDebug("GetCrusaderHealTarget: Next Target");
                //Get the next target in the specified area around the caster
                oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fDistance), GetLocation(oPC));
        }
        if(DEBUG) DoDebug("GetCrusaderHealTarget: oReturn " + GetName(oReturn));
        return oReturn;
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

int TOBGetHasDiscipline(object oInitiator, int nDiscipline)
{

	int nCru = GetLevelByClass(CLASS_TYPE_CRUSADER, oInitiator);
	int nSwd = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oInitiator);
	int nWar = GetLevelByClass(CLASS_TYPE_WARBLADE, oInitiator);
	
	if (nCru > 0 && (nDiscipline == DISCIPLINE_DEVOTED_SPIRIT || 
	                 nDiscipline == DISCIPLINE_STONE_DRAGON || 
	                 nDiscipline == DISCIPLINE_WHITE_RAVEN)) return TRUE;
	if (nSwd > 0 && (nDiscipline == DISCIPLINE_DIAMOND_MIND || 
	                 nDiscipline == DISCIPLINE_IRON_HEART || 
	                 nDiscipline == DISCIPLINE_STONE_DRAGON || 
	                 nDiscipline == DISCIPLINE_TIGER_CLAW || 
	                 nDiscipline == DISCIPLINE_WHITE_RAVEN)) return TRUE;
	if (nWar > 0 && (nDiscipline == DISCIPLINE_DESERT_WIND || 
	                 nDiscipline == DISCIPLINE_DIAMOND_MIND || 
	                 nDiscipline == DISCIPLINE_SETTING_SUN || 
	                 nDiscipline == DISCIPLINE_SHADOW_HAND || 
	                 nDiscipline == DISCIPLINE_STONE_DRAGON || 
	                 nDiscipline == DISCIPLINE_TIGER_CLAW)) return TRUE;	                 

	// If none of those trigger.	                 
	return FALSE;	                 
}

int TOBGetHasDisciplineFocus(object oInitiator, int nDiscipline)
{
	// Set one of the Discipline Focus feats
        if      (GetHasFeat(FEAT_SS_DF_DS_DW, oInitiator) && nDiscipline == DISCIPLINE_DESERT_WIND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_DM, oInitiator) && nDiscipline == DISCIPLINE_DIAMOND_MIND) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_SS, oInitiator) && nDiscipline == DISCIPLINE_SETTING_SUN)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_SH, oInitiator) && nDiscipline == DISCIPLINE_SHADOW_HAND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_SD, oInitiator) && nDiscipline == DISCIPLINE_STONE_DRAGON) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_DS_TC, oInitiator) && nDiscipline == DISCIPLINE_TIGER_CLAW)   return TRUE;
        // Set two of the Discipline Focus feats
        if      (GetHasFeat(FEAT_SS_DF_IS_DW, oInitiator) && nDiscipline == DISCIPLINE_DESERT_WIND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_DM, oInitiator) && nDiscipline == DISCIPLINE_DIAMOND_MIND) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_SS, oInitiator) && nDiscipline == DISCIPLINE_SETTING_SUN)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_SH, oInitiator) && nDiscipline == DISCIPLINE_SHADOW_HAND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_SD, oInitiator) && nDiscipline == DISCIPLINE_STONE_DRAGON) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_IS_TC, oInitiator) && nDiscipline == DISCIPLINE_TIGER_CLAW)   return TRUE;        
        // Set three of the Discipline Focus feats
        if      (GetHasFeat(FEAT_SS_DF_WF_DW, oInitiator) && nDiscipline == DISCIPLINE_DESERT_WIND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_WF_DM, oInitiator) && nDiscipline == DISCIPLINE_DIAMOND_MIND) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_WF_SS, oInitiator) && nDiscipline == DISCIPLINE_SETTING_SUN)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_WF_SH, oInitiator) && nDiscipline == DISCIPLINE_SHADOW_HAND)  return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_WF_SD, oInitiator) && nDiscipline == DISCIPLINE_STONE_DRAGON) return TRUE;
        else if (GetHasFeat(FEAT_SS_DF_WF_TC, oInitiator) && nDiscipline == DISCIPLINE_TIGER_CLAW)   return TRUE;        

	// If none of those trigger.	                 
	return FALSE;	
}
// Test main
//void main(){}