//::///////////////////////////////////////////////
//:: Tome of Battle include: Misceallenous
//:: tob_inc_tobfunc
//::///////////////////////////////////////////////
/** @file
    Defines various functions and other stuff that
    do something related to Invocation implementation.

    Also acts as inclusion nexus for the general
    invocation includes. In other words, don't include
    them directly in your scripts, instead include this.

    @author Fox
    @date   Created - 2008.1.25
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const int    INVOCATION_DRACONIC    = 1;
const int    INVOCATION_WARLOCK     = 2;

const int    INVOCATION_LEAST       = 2;
const int    INVOCATION_LESSER      = 4;
const int    INVOCATION_GREATER     = 6;
const int    INVOCATION_DARK        = 8;

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Determines from what class's invocation list the currently casted
 * invocation is cast from.
 *
 * @param oInvoker  A creature invoking at this moment
 * @return            CLASS_TYPE_* constant of the class
 */
int GetInvokingClass(object oInvoker = OBJECT_SELF);

/**
 * Determines the given creature's Invoker level. If a class is specified,
 * then returns the Invoker level for that class. Otherwise, returns
 * the Invoker level for the currently active invocation.
 *
 * @param oInvoker       The creature whose Invoker level to determine
 * @param nSpecificClass The class to determine the creature's Invoker
 *                       level in.
 * @param nUseHD         If this is set, it returns the Character Level of the calling creature.
 *                       DEFAULT: CLASS_TYPE_INVALID, which means the creature's
 *                       Invoker level in regards to an ongoing invocation
 *                       is determined instead.
 * @return               The Invoker level
 */
int GetInvokerLevel(object oInvoker, int nSpecificClass = CLASS_TYPE_INVALID, int nUseHD = FALSE);

/**
 * Determines whether a given creature uses Invocations.
 * Requires either levels in an invocation-related class or
 * natural Invocation ability based on race.
 *
 * @param oCreature Creature to test
 * @return          TRUE if the creature can use Invocations, FALSE otherwise.
 */
int GetIsInvocationUser(object oCreature);

/**
 * Determines the given creature's highest undmodified Invoker level among it's
 * invoking classes.
 *
 * @param oCreature Creature whose highest Invoker level to determine
 * @return          The highest unmodified Invoker level the creature can have
 */
int GetHighestInvokerLevel(object oCreature);

/**
 * Determines whether a given class is an invocation-related class or not.
 *
 * @param nClass CLASS_TYPE_* of the class to test
 * @return       TRUE if the class is an invocation-related class, FALSE otherwise
 */
int GetIsInvocationClass(int nClass);

/**
 * Gets the level of the invocation being currently cast.
 * WARNING: Return value is not defined when an invocation is not being cast.
 *
 * @param oInvoker    The creature currently casting an invocation
 * @return            The level of the invocation being cast
 */
int GetInvocationLevel(object oInvoker);

/**
 * Returns the name of the invocation
 *
 * @param nSpellId        SpellId of the invocation
 */
string GetInvocationName(int nSpellId);

/**
 * Calculates how many invoker levels are gained by a given creature from
 * it's levels in prestige classes.
 *
 * @param oCreature Creature to calculate added invoker levels for
 * @return          The number of invoker levels gained
 */
int GetInvocationPRCLevels(object oCreature);

/**
 * Determines whether a given class is an invocation class or not. An invocation
 * class is defined as one that gives base invocation casting.
 *
 * @param nClass CLASS_TYPE_* of the class to test
 * @return       TRUE if the class is an invocation class, FALSE otherwise
 */
int GetIsInvocationClass(int nClass);

/**
 * Determines which of the character's classes is their first invocation casting
 * class, if any. This is the one which gains invoker level raise benefits from
 * prestige classes.
 *
 * @param oCreature Creature whose classes to test
 * @return          CLASS_TYPE_* of the first invocation casting class,
 *                  CLASS_TYPE_INVALID if the creature does not possess any.
 */
int GetFirstInvocationClass(object oCreature = OBJECT_SELF);

/**
 * Determines the position of a creature's first invocation casting class, if any.
 *
 * @param oCreature Creature whose classes to test
 * @return          The position of the first invocation class {1, 2, 3} or 0 if
 *                  the creature possesses no levels in invocation classes.
 */
int GetFirstInvocationClassPosition(object oCreature = OBJECT_SELF);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "inv_invoc_const"
#include "prc_alterations"
#include "inv_inc_invknown"
#include "inv_inc_invoke"

//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetInvokingClass(object oInvoker = OBJECT_SELF)
{
    return GetLocalInt(oInvoker, PRC_INVOKING_CLASS) - 1;
}

int GetInvokerLevel(object oInvoker, int nSpecificClass = CLASS_TYPE_INVALID, int nUseHD = FALSE)
{
    int nLevel;
    int nTotalHD = GetHitDice(oInvoker);
    int nAdjust = GetLocalInt(oInvoker, PRC_CASTERLEVEL_ADJUSTMENT);

    // If this is set, return the user's HD
    if (nUseHD) return GetHitDice(oInvoker);

    // The function user needs to know the character's Invoker level in a specific class
    // instead of whatever the character last cast an invocation as
    if(nSpecificClass != CLASS_TYPE_INVALID)
    {
        if(GetIsInvocationClass(nSpecificClass))
        {
            int nClassLevel = GetLevelByClass(nSpecificClass, oInvoker);
            if (nClassLevel > 0)
            {
                // Invoker level is class level + any arcane spellcasting or invoking levels in any PRCs
                nLevel = nClassLevel + GetInvocationPRCLevels(oInvoker);
            }
        }
        // A character with no Invoker levels can't use Invocations
        else
            return 0;
    }

    // Item Spells
    if(GetItemPossessor(GetSpellCastItem()) == oInvoker)
    {
        if(DEBUG) SendMessageToPC(oInvoker, "Item casting at level " + IntToString(GetCasterLevel(oInvoker)));

        return GetCasterLevel(oInvoker) + nAdjust;
    }

    // For when you want to assign the caster level.
    else if(GetLocalInt(oInvoker, PRC_CASTERLEVEL_OVERRIDE) != 0)
    {
        if(DEBUG) SendMessageToPC(oInvoker, "Forced-level Invoking at level " + IntToString(GetCasterLevel(oInvoker)));

        DelayCommand(1.0, DeleteLocalInt(oInvoker, PRC_CASTERLEVEL_OVERRIDE));
        nLevel = GetLocalInt(oInvoker, PRC_CASTERLEVEL_OVERRIDE);
    }

    // If everything else fails, use the character's first class position
    if(nLevel == 0)
    {
        if(DEBUG)             DoDebug("Failed to get Invoker level for creature " + DebugObject2Str(oInvoker) + ", using first class slot");
        else WriteTimestampedLogEntry("Failed to get Invoker level for creature " + DebugObject2Str(oInvoker) + ", using first class slot");

        nLevel = GetLevelByPosition(1, oInvoker);
    }

    nLevel += nAdjust;

    // This spam is technically no longer necessary once the Invoker level getting mechanism has been confirmed to work
    if(DEBUG) FloatingTextStringOnCreature("Invoker Level: " + IntToString(nLevel), oInvoker, FALSE);

    return nLevel;
}

//add Warlock here later
int GetIsInvocationUser(object oCreature)
{
    return !!(GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oCreature)
             );
}

int GetHighestInvokerLevel(object oCreature)
{
    return max(max(PRCGetClassByPosition(1, oCreature) != CLASS_TYPE_INVALID ? GetInvokerLevel(oCreature, PRCGetClassByPosition(1, oCreature)) : 0,
                   PRCGetClassByPosition(2, oCreature) != CLASS_TYPE_INVALID ? GetInvokerLevel(oCreature, PRCGetClassByPosition(2, oCreature)) : 0
                   ),
               PRCGetClassByPosition(3, oCreature) != CLASS_TYPE_INVALID ? GetInvokerLevel(oCreature, PRCGetClassByPosition(3, oCreature)) : 0
               );
}

//add Warlock here later
int GetIsInvocationClass(int nClass)
{
    return (nClass==CLASS_TYPE_DRAGONFIRE_ADEPT 
            );
}

int GetInvocationLevel(object oInvoker)
{
    return GetLocalInt(oInvoker, PRC_INVOCATION_LEVEL);
}

string GetInvocationName(int nSpellId)
{
        return GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId)));
}

int GetInvocationPRCLevels(object oCreature)
{
    int nLevel = 0;
    
    //arcane spellcasting levels boost invocations
    nLevel += GetArcanePRCLevels(oCreature);


    return nLevel;
}

int GetFirstInvocationClass(object oCreature = OBJECT_SELF)
{
    int nInvocationPos = GetFirstInvocationClassPosition(oCreature);
    if (!nInvocationPos) return CLASS_TYPE_INVALID; // no invoking class

    return PRCGetClassByPosition(nInvocationPos, oCreature);
}

int GetFirstInvocationClassPosition(object oCreature = OBJECT_SELF)
{
    if (GetIsInvocationClass(PRCGetClassByPosition(1, oCreature)))
        return 1;
    if (GetIsInvocationClass(PRCGetClassByPosition(2, oCreature)))
        return 2;
    if (GetIsInvocationClass(PRCGetClassByPosition(3, oCreature)))
        return 3;

    return 0;
}
// Test main
//void main(){}
