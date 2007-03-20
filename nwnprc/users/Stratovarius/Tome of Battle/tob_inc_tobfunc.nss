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
 * Determines a creature's ability score in the initiating ability of a given
 * class.
 *
 * @param oInitiator Creature whose ability score to get
 * @param nClass      CLASS_TYPE_* constant of a initiating class
 */
int GetBladeMagicAbilityScoreOfClass(object oInitiator, int nClass);

/**
 * Determines the initiating ability of a class.
 *
 * @param nClass CLASS_TYPE_* constant of the class to determine the initiating stat of
 * @return       ABILITY_* of the initiating stat. ABILITY_CHARISMA for non-Initiator
 *               classes.
 */
int GetBladeMagicAbilityOfClass(int nClass);

/**
 * Calculates the DC of the maneuver being currently initiated.
 * Base value is 10 + maneuver level + ability modifier in initiating stat
 *
 * WARNING: Return value is not defined when a maneuver is not being initiated.
 *
 */
int GetInitiatorDC(object oInitiator = OBJECT_SELF);

/**
 * Determines the Initiator's level in regards to Initiator checks to overcome
 * spell resistance.
 *
 * WARNING: Return value is not defined when a maneuver is not being initiated.
 *
 * @param oInitiator A creature initiating a maneuver at the moment
 * @return            The creature's Initiator level, adjusted to account for
 *                    modifiers that affect spell resistance checks.
 */
int GetBladeMagicPenetration(object oInitiator = OBJECT_SELF);

/**
 * Marks an maneuver as active for the Law of Sequence.
 * Called from the maneuver
 *
 * @param oInitiator    Caster of the maneuver
 * @param nSpellId        SpellId of the maneuver
 * @param fDur            Duration of the maneuver
 */
void DoLawOfSequence(object oInitiator, int nSpellId, float fDur);

/**
 * Checks to see whether the law of sequence is active
 * maneuver fails if it is.
 *
 * @param oInitiator    Caster of the maneuver
 * @param nSpellId        SpellId of the maneuver
 *
 * @return True if the maneuver is active, False if it is not.
 */
int CheckLawOfSequence(object oInitiator, int nSpellId);

/**
 * Returns the name of the maneuver
 *
 * @param nSpellId        SpellId of the maneuver
 */
string GetManeuverName(int nSpellId);

/**
 * Returns the name of the Disciple
 *
 * @param nDisciple        DISCIPLINE_* to name
 */
string GetDiscipleName(int nDisciple);

/**
 * Returns the Disciple the maneuver is in
 * @param nSpellId   maneuver to check
 *
 * @return           DISCIPLINE_*
 */
int GetDiscipleByManeuver(int nSpellId);

/**
 * Returns true or false if the initiator has the Discipline
 * @param oInitiator    Person to check
 * @param nDiscipline   Discipline to check
 *
 * @return           TRUE or FALSE
 */
int TOBGetHasDisciple(object oInitiator, int nDiscipline);

/**
 * Returns true or false if the swordsage has Discipline
 * focus in the chosen discipline
 * @param oInitiator    Person to check
 * @param nDiscipline   Discipline to check
 *
 * @return           TRUE or FALSE
 */
int TOBGetHasDiscipleFocus(object oInitiator, int nDiscipline);

*/
//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "prc_move_const"
#include "prc_alterations"
#include "tob_inc_move"
#include "tob_inc_moveknwn"

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetInitiatingClass(object oInitiator = OBJECT_SELF)
{
    return GetLocalInt(oInitiator, PRC_Initiating_CLASS) - 1;
}

int GetInitiatorLevel(object oInitiator, int nSpecificClass = CLASS_TYPE_INVALID, int nUseHD = FALSE)
{
    int nLevel;
    int nAdjust = GetLocalInt(oInitiator, PRC_CASTERLEVEL_ADJUSTMENT);
    // Bereft's speak syllables and use their character level.
    if (GetIsSyllable(PRCGetSpellId())) nUseHD = TRUE;

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
            	nLevel = nClassLevel;
            }
        }
        // A character's Initiator level gained from non-initiating classes is always a nice, round zero
        else
            return 0;
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
    else if(GetInitiatingClass(oInitiator) != CLASS_TYPE_INVALID)
    {
        //Gets the level of the initiating class
        int ninitiatingClass = GetInitiatingClass(oInitiator);
        nLevel = GetLevelByClass(ninitiatingClass, oInitiator);
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
    return !!(GetLevelByClass(CLASS_TYPE_BladeMagicR, oCreature) ||
              GetLevelByClass(CLASS_TYPE_BEREFT,    oCreature)
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
    return (nClass == CLASS_TYPE_BladeMagicR ||
            nClass == CLASS_TYPE_BEREFT
            );
}

int GetManeuverLevel(object oInitiator)
{
    return GetLocalInt(oInitiator, PRC_MANEUVER_LEVEL);
}

int GetBladeMagicAbilityScoreOfClass(object oInitiator, int nClass)
{
    return GetAbilityScore(oInitiator, GetBladeMagicAbilityOfClass(nClass));
}

int GetBladeMagicAbilityOfClass(int nClass){
    switch(nClass)
    {
        case CLASS_TYPE_BladeMagicR:
            return ABILITY_CHARISMA;
        default:
            return ABILITY_CHARISMA;
    }

    // Technically, never gets here but the compiler does not realise that
    return -1;
}

int GetInitiatorDC(object oInitiator = OBJECT_SELF)
{
    // Things we need for DC Checks
    int nSpellId = PRCGetSpellId();
    object oTarget = PRCGetSpellTargetObject();
    int nRace = MyPRCGetRacialType(oTarget);
    // DC is 10 + 1/2 BladeMagicr level + Ability (Charisma)
    int nClass = GetInitiatingClass(oInitiator);
    int nDC = 10;
    nDC += GetLevelByClass(nClass, oInitiator) / 2;
    nDC += GetAbilityModifier(GetBladeMagicAbilityOfClass(nClass), oInitiator);

    // Focused Disciple. Bonus vs chosen racial type
    if      (nRace == RACIAL_TYPE_ABERRATION         && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_ABERRATION,   oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_ANIMAL             && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_ANIMAL,       oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_BEAST              && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_BEAST,        oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_CONSTRUCT          && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_CONSTRUCT,    oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_DRAGON             && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_DRAGON,       oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_DWARF              && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_DWARF,        oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_ELEMENTAL          && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_ELEMENTAL,    oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_ELF                && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_ELF,          oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_FEY                && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_FEY,          oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_GIANT              && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_GIANT,        oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_GNOME              && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_GNOME,        oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_HALFELF            && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_HALFELF,      oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_HALFLING           && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_HALFLING,     oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_HALFORC            && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_HALFORC,      oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_HUMAN              && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_HUMAN,        oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_HUMANOID_GOBLINOID && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_GOBLINOID,    oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_HUMANOID_MONSTROUS && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_MONSTROUS,    oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_HUMANOID_ORC       && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_ORC,          oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_HUMANOID_REPTILIAN && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_REPTILIAN,    oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_MAGICAL_BEAST      && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_MAGICALBEAST, oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_OOZE               && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_OOZE,         oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_OUTSIDER           && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_OUTSIDER,     oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_SHAPECHANGER       && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_SHAPECHANGER, oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_UNDEAD             && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_UNDEAD,       oInitiator)) nDC += 1;
    else if (nRace == RACIAL_TYPE_VERMIN             && GetHasFeat(FEAT_FOCUSED_DISCIPLINE_VERMIN,       oInitiator)) nDC += 1;

    // maneuver Focus. DC Bonus for a chosen maneuver
    if      (nSpellId == UTTER_BREATH_CLEANSING_R      && GetHasFeat(FEAT_MANEUVER_FOCUS_BREATH_CLEANSING,      oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_BREATH_RECOVERY_R       && GetHasFeat(FEAT_MANEUVER_FOCUS_BREATH_RECOVERY,       oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_ELDRITCH_ATTRACTION     && GetHasFeat(FEAT_MANEUVER_FOCUS_ELDRITCH_ATTRACTION,   oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_ELDRITCH_ATTRACTION_R   && GetHasFeat(FEAT_MANEUVER_FOCUS_ELDRITCH_ATTRACTION,   oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_MORALE_BOOST_R          && GetHasFeat(FEAT_MANEUVER_FOCUS_MORALE_BOOST,          oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_PRETERNATURAL_CLARITY_R && GetHasFeat(FEAT_MANEUVER_FOCUS_PRETERNATURAL_CLARITY, oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_SENSORY_FOCUS_R         && GetHasFeat(FEAT_MANEUVER_FOCUS_SENSORY_FOCUS,         oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_SILENT_CASTER_R         && GetHasFeat(FEAT_MANEUVER_FOCUS_SILENT_CASTER,         oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_SINGULAR_MIND_R         && GetHasFeat(FEAT_MANEUVER_FOCUS_SINGULAR_MIND,         oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_TEMPORAL_SPIRAL_R       && GetHasFeat(FEAT_MANEUVER_FOCUS_TEMPORAL_SPIRAL,       oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_TEMPORAL_TWIST_R        && GetHasFeat(FEAT_MANEUVER_FOCUS_TEMPORAL_TWIST,        oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_WARD_PEACE_R            && GetHasFeat(FEAT_MANEUVER_FOCUS_WARD_PEACE,            oInitiator)) nDC += 1;
    else if (nSpellId == UTTER_SHOCKWAVE               && GetHasFeat(FEAT_MANEUVER_FOCUS_SHOCKWAVE,             oInitiator)) nDC += 1;

    return nDC;
}

int GetBladeMagicPenetration(object oInitiator = OBJECT_SELF)
{
    int nPen = GetInitiatorLevel(oInitiator);

    // According to Page 232 of Tome of Magic, Spell Pen as a feat counts, so here it is.
    if(GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oInitiator)) nPen += 6;
    else if(GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oInitiator)) nPen += 4;
    else if(GetHasFeat(FEAT_SPELL_PENETRATION, oInitiator)) nPen += 2;

    // Blow away SR totally, just add 9000
    // Does not work on Syllables, only maneuvers
    if (GetLocalInt(oInitiator, TRUE_IGNORE_SR) && !GetIsSyllable(PRCGetSpellId())) nPen += 9000;

    if(DEBUG) DoDebug("GetBladeMagicPenetration(" + GetName(oInitiator) + "): " + IntToString(nPen));

    return nPen;
}

void DoLawOfSequence(object oInitiator, int nSpellId, float fDur)
{
	// This makes sure everything is stored using the Normal, and not the reverse
	nSpellId = GetNormalUtterSpellId(nSpellId);
	SetLocalInt(oInitiator, LAW_OF_SEQUENCE_VARNAME + IntToString(nSpellId), TRUE);
	DelayCommand(fDur, DeleteLocalInt(oInitiator, LAW_OF_SEQUENCE_VARNAME + IntToString(nSpellId)));
}

int CheckLawOfSequence(object oInitiator, int nSpellId)
{
	// This makes sure everything is stored using the Normal, and not the reverse
	nSpellId = GetNormalUtterSpellId(nSpellId);
	return GetLocalInt(oInitiator, LAW_OF_SEQUENCE_VARNAME + IntToString(nSpellId));
}

string GetManeuverName(int nSpellId)
{
	return GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId)));
}

string GetDiscipleName(int nDisciple)
{
	string sName;
	if (nDisciple == DISCIPLINE_EVOLVING_MIND)      sName = GetStringByStrRef(16828478);
	else if (nDisciple == DISCIPLINE_CRAFTED_TOOL)  sName = GetStringByStrRef(16828479);
	else if (nDisciple == DISCIPLINE_PERFECTED_MAP) sName = GetStringByStrRef(16828480);

	return sName;
}

int GetDiscipleByManeuver(int nSpellId)
{
     int i, nUtter;
     for(i = 0; i < GetPRCSwitch(FILE_END_CLASS_POWER) ; i++)
     {
         nUtter = StringToInt(Get2DACache("cls_true_utter", "SpellID", i));
         if(nUtter == nSpellId)
         {
             return StringToInt(Get2DACache("cls_true_utter", "Disciple", i));
         }
     }
     // This should never happen
     return -1;
}
// Test main
//void main(){}