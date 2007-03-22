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
// Test main
//void main(){}