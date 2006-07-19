//::///////////////////////////////////////////////
//:: Truenaming include: Misceallenous
//:: true_inc_trufunc
//::///////////////////////////////////////////////
/** @file
    Defines various functions and other stuff that
    do something related to the truenaming implementation.

    Also acts as inclusion nexus for the general
    truenaming includes. In other words, don't include
    them directly in your scripts, instead include this.

    @author Stratovarius
    @date   Created - 2006.7.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Determines from what class's Utterance list the currently being truespoken
 * Utterance is truespoken from.
 *
 * @param oTrueSpeaker A creature uttering a Utterance at this moment
 * @return            CLASS_TYPE_* constant of the class
 */
int GetTruespeakingClass(object oTrueSpeaker = OBJECT_SELF);

/**
 * Determines the given creature's truespeaker level. If a class is specified,
 * then returns the truespeaker level for that class. Otherwise, returns
 * the truespeaker level for the currently active utterance.
 *
 * @param oTrueSpeaker   The creature whose truespeaker level to determine
 * @param nSpecificClass The class to determine the creature's truespeaker
 *                       level in.
 * @param nUseHD         If this is set, it returns the Character Level of the calling creature.
 *                       DEFAULT: CLASS_TYPE_INVALID, which means the creature's
 *                       truespeaker level in regards to an ongoing utterance
 *                       is determined instead.
 * @return               The truespeaker level
 */
int GetTruespeakerLevel(object oTrueSpeaker, int nSpecificClass = CLASS_TYPE_INVALID, int nUseHD = FALSE);

/**
 * Determines the given creature's highest undmodified truespeaker level among it's
 * uttering classes.
 *
 * @param oCreature Creature whose highest truespeaker level to determine
 * @return          The highest unmodified truespeaker level the creature can have
 */
int GetHighestTrueSpeakerLevel(object oCreature);

/**
 * Gets the level of the Utterance being currently truespoken.
 * WARNING: Return value is not defined when a Utterance is not being truespoken.
 *
 * @param oTrueSpeaker The creature currently uttering a utterance
 * @return            The level of the Utterance being truespoken
 */
int GetUtteranceLevel(object oTrueSpeaker);

/**
 * Determines a creature's ability score in the uttering ability of a given
 * class.
 *
 * @param oTrueSpeaker Creature whose ability score to get
 * @param nClass      CLASS_TYPE_* constant of a uttering class
 */
int GetAbilityScoreOfClass(object oTrueSpeaker, int nClass);

/**
 * Determines the uttering ability of a class.
 *
 * @param nClass CLASS_TYPE_* constant of the class to determine the uttering stat of
 * @return       ABILITY_* of the uttering stat. ABILITY_CHARISMA for non-TrueSpeaker
 *               classes.
 */
int GetAbilityOfClass(int nClass);

/**
 * Calculates the DC of the Utterance being currently truespoken.
 * Base value is 10 + Utterance level + ability modifier in uttering stat
 *
 * WARNING: Return value is not defined when a Utterance is not being truespoken.
 *
 */
int GetTrueSpeakerDC(object oTrueSpeaker = OBJECT_SELF);

/**
 * Determines the truespeaker's level in regards to truespeaker checks to overcome
 * spell resistance.
 *
 * WARNING: Return value is not defined when a Utterance is not being truespoken.
 *
 * @param oTrueSpeaker A creature uttering a Utterance at the moment
 * @return            The creature's truespeaker level, adjusted to account for
 *                    modifiers that affect spell resistance checks.
 */
int GetTrueSpeakPenetration(object oTrueSpeaker = OBJECT_SELF);

/**
 * Marks an utterance as active for the Law of Sequence.
 * Called from the Utterance
 *
 * @param oTrueSpeaker    Caster of the Utterance
 * @param nSpellId        SpellId of the Utterance
 * @param fDur            Duration of the Utterance
 */
void DoLawOfSequence(object oTrueSpeaker, int nSpellId, int fDur);

/**
 * Checks to see whether the law of sequence is active
 * Utterance fails if it is.
 *
 * @param oTrueSpeaker    Caster of the Utterance
 * @param nSpellId        SpellId of the Utterance
 *
 * @return True if the Utterance is active, False if it is not.
 */
int CheckLawOfSequence(object oTrueSpeaker, int nSpellId);

/**
 * Returns the name of the Utterance
 *
 * @param nSpellId        SpellId of the Utterance
 */
string GetUtteranceName(int nSpellId);

/**
 * Applies modifications to a utterance's damage that depend on some property
 * of the target.
 * Currently accounts for:
 *  - Mental Resistance
 *  - Greater Utterance Specialization
 *  - Intellect Fortress
 *
 * @param oTarget     A creature being dealt damage by a utterance
 * @param oTrueSpeaker The creature uttering the damaging utterance
 * @param nDamage     The amount of damage the creature would be dealt
 *
 * @param bIsHitPointDamage Is the damage HP damage or something else?
 * @param bIsEnergyDamage   Is the damage caused by energy or something else? Only relevant if the damage is HP damage.
 *
 * @return The amount of damage, modified by oTarget's abilities
 */
int GetTargetSpecificChangesToDamage(object oTarget, object oTrueSpeaker, int nDamage,
                                     int bIsHitPointDamage = TRUE, int bIsEnergyDamage = FALSE);


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "prc_utter_const"
#include "prc_alterations"
#include "true_inc_utter" // Provides psi_inc_augment, psi_inc_focus, psi_inc_metapsi and psi_inc_ppoints
#include "true_inc_truknwn"


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetUtteringClass(object oTrueSpeaker = OBJECT_SELF)
{
    return GetLocalInt(oTrueSpeaker, PRC_TRUESPEAKING_CLASS) - 1;
}

int GetTrueSpeakerLevel(object oTrueSpeaker, int nSpecificClass = CLASS_TYPE_INVALID, int nUseHD = FALSE)
{
    int nLevel;
    int nAdjust = GetLocalInt(oTrueSpeaker, PRC_CASTERLEVEL_ADJUSTMENT);
    
    // If this is set, return the user's HD
    if (nUseHD) return GetHitDice(oTrueSpeaker);

    // The function user needs to know the character's truespeaker level in a specific class
    // instead of whatever the character last truespoken a Utterance as
    if(nSpecificClass != CLASS_TYPE_INVALID)
    {
        int nClassLevel = GetLevelByClass(nSpecificClass, oTrueSpeaker);
        if (nClassLevel > 0)
        {
        	nLevel = nClassLevel;
        }
        // A character's truespeaker level gained from non-uttering classes is always a nice, round zero
        else
            return 0;
    }

    // Item Spells
    if(GetItemPossessor(GetSpellCastItem()) == oTrueSpeaker)
    {
        if(DEBUG) SendMessageToPC(oTrueSpeaker, "Item casting at level " + IntToString(GetCasterLevel(oTrueSpeaker)));

        return GetCasterLevel(oTrueSpeaker) + nAdjust;
    }

    // For when you want to assign the caster level.
    else if(GetLocalInt(oTrueSpeaker, PRC_CASTERLEVEL_OVERRIDE) != 0)
    {
        if(DEBUG) SendMessageToPC(oTrueSpeaker, "Forced-level uttering at level " + IntToString(GetCasterLevel(oTrueSpeaker)));

        DelayCommand(1.0, DeleteLocalInt(oTrueSpeaker, PRC_CASTERLEVEL_OVERRIDE));
        nLevel = GetLocalInt(oTrueSpeaker, PRC_CASTERLEVEL_OVERRIDE);
    }
    else if(GetUtteringClass(oTrueSpeaker) != CLASS_TYPE_INVALID)
    {
        //Gets the level of the uttering class
        int nUtteringClass = GetUtteringClass(oTrueSpeaker);
        nLevel = GetLevelByClass(nUtteringClass, oTrueSpeaker);
    }

    // If everything else fails, use the character's first class position
    if(nLevel == 0)
    {
        if(DEBUG)             DoDebug("Failed to get truespeaker level for creature " + DebugObject2Str(oTrueSpeaker) + ", using first class slot");
        else WriteTimestampedLogEntry("Failed to get truespeaker level for creature " + DebugObject2Str(oTrueSpeaker) + ", using first class slot");

        nLevel = GetLevelByPosition(1, oTrueSpeaker);
    }

    nLevel += nAdjust;

    // This spam is technically no longer necessary once the truespeaker level getting mechanism has been confirmed to work
//    if(DEBUG) FloatingTextStringOnCreature("TrueSpeaker Level: " + IntToString(nLevel), oTrueSpeaker, FALSE);

    return nLevel;
}

int GetHighestTrueSpeakerLevel(object oCreature)
{
    return max(max(PRCGetClassByPosition(1, oCreature) != CLASS_TYPE_INVALID ? GetTrueSpeakerLevel(oCreature, PRCGetClassByPosition(1, oCreature)) : 0,
                   PRCGetClassByPosition(2, oCreature) != CLASS_TYPE_INVALID ? GetTrueSpeakerLevel(oCreature, PRCGetClassByPosition(2, oCreature)) : 0
                   ),
               PRCGetClassByPosition(3, oCreature) != CLASS_TYPE_INVALID ? GetTrueSpeakerLevel(oCreature, PRCGetClassByPosition(3, oCreature)) : 0
               );
}
int GetUtteranceLevel(object oTrueSpeaker)
{
    return GetLocalInt(oTrueSpeaker, PRC_UTTERANCE_LEVEL);
}

int GetAbilityScoreOfClass(object oTrueSpeaker, int nClass)
{
    return GetAbilityScore(oTrueSpeaker, GetAbilityOfClass(nClass));
}

int GetAbilityOfClass(int nClass){
    switch(nClass)
    {
        case CLASS_TYPE_TRUENAMER:
            return ABILITY_CHARISMA;
        default:
            return ABILITY_CHARISMA;
    }

    // Technically, never gets here but the compiler does not realise that
    return -1;
}

int GetTrueSpeakerDC(object oTrueSpeaker = OBJECT_SELF)
{
    // DC is 10 + 1/2 Truenamer level + Ability (Charisma)
    int nClass = GetUtteringClass(oTrueSpeaker);
    int nDC = 10;
    nDC += GetLevelByClass(nClass, oTrueSpeaker)/2;
    nDC += GetAbilityModifier(GetAbilityOfClass(nClass), oTrueSpeaker);

    // This is where the feats will go once they're added
/*
    if (GetLocalInt(oTrueSpeaker, "PsionicEndowmentActive") == TRUE && UsePsionicFocus(oTrueSpeaker))
    {
            nDC += GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT, oTrueSpeaker) ? 4 : 2;
    }
*/
    return nDC;
}

int GetTrueSpeakPenetration(object oTrueSpeaker = OBJECT_SELF)
{
    int nPen = GetTrueSpeakerLevel(oTrueSpeaker);

    // According to Page 232 of Tome of Magic, Spell Pen as a feat counts, so here it is.
    if(GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oTrueSpeaker)) nPen += 6;
    else if(GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oTrueSpeaker)) nPen += 4;
    else if(GetHasFeat(FEAT_SPELL_PENETRATION, oTrueSpeaker)) nPen += 2;
    
    // Blow away SR totally, just add 9000
    if (GetLocalInt(oTrueSpeaker, TRUE_IGNORE_SR)) nPen += 9000;

    return nPen;
}

void DoLawOfSequence(object oTrueSpeaker, int nSpellId, float fDur)
{
	SetLocalInt(oTrueSpeaker, LAW_OF_SEQUENCE_VARNAME + IntToString(nSpellId), TRUE);
	DelayCommand(fDur, DeleteLocalInt(oTrueSpeaker, LAW_OF_SEQUENCE_VARNAME + IntToString(nSpellId)));
}

int CheckLawOfSequence(object oTrueSpeaker, int nSpellId)
{
	return GetLocalInt(oTrueSpeaker, LAW_OF_SEQUENCE_VARNAME + IntToString(nSpellId));
}

string GetUtteranceName(int nSpellId)
{
	return Get2DACache("spells", "Name", nSpellId);
}

int GetTargetSpecificChangesToDamage(object oTarget, object oTrueSpeaker, int nDamage,
                                     int bIsHitPointDamage = TRUE, int bIsEnergyDamage = FALSE)
{
    // Greater Utterance Specialization - +2 damage on all HP-damaging utterances when target is within 30ft
    if(bIsHitPointDamage                                                &&
       GetHasFeat(FEAT_GREATER_Utterance_SPECIALIZATION, oTrueSpeaker)       &&
       GetDistanceBetween(oTarget, oTrueSpeaker) <= FeetToMeters(30.0f)
       )
            nDamage += 2;
    // Intellect Fortress - Halve damage dealt by utterances that allow PR. Goes before DR (-like) reductions
    if(GetLocalInt(oTarget, "PRC_Utterance_IntellectFortress_Active")    &&
       Get2DACache("spells", "ItemImmunity", PRCGetSpellId()) == "1"
       )
        nDamage /= 2;
    // Mental Resistance - 3 damage less for all non-energy damage and ability damage
    if(GetHasFeat(FEAT_MENTAL_RESISTANCE, oTarget) && !bIsEnergyDamage)
        nDamage -= 3;

    // Reasonable return values only
    if(nDamage < 0) nDamage = 0;

    return nDamage;
}

// Test main
//void main(){}
