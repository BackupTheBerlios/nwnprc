//::///////////////////////////////////////////////
//:: Truenaming include: Truespeaking
//:: true_inc_truespk
//::///////////////////////////////////////////////
/** @file
    Defines functions for handling truespeaking.

    @author Stratovarius
    @date   Created - 2006.18.07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const string LAW_OF_RESIST_VARNAME   = "PRC_LawOfResistance";
const string LAW_OF_SEQUENCE_VARNAME = "PRC_LawOfSequence";
const string TRUE_IGNORE_SR          = "PRC_True_IgnoreSR";
const int    LEXICON_EVOLVING_MIND   = 1;
const int    LEXICON_CRAFTED_TOOL    = 2;
const int    LEXICON_PERFECTED_MAP   = 3;


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Returns the base DC of an Utterance. 
 * This is where the various formulas can be chosen by switch
 *
 * @param oTarget         Target of the Utterance
 * @param oTrueSpeaker    Caster of the Utterance
 * @param nLexicon        Type of the Utterance: Evolving Mind, Crafted Tool, or Perfected Map
 * @return                The base DC via formula to hit the target
 *                        This does not include MetaUtterances, increased DC to ignore SR, or the Laws.
 */
int GetBaseUtteranceDC(object oTarget, object oTrueSpeaker, int nLexicon);

/**
 * Returns the Law of Resistance DC increase
 *
 * @param oTrueSpeaker    Caster of the Utterance
 * @param nSpellId        SpellId of the Utterance
 * @return                The DC boost for this particular power from the Law of Resistance
 */
int GetLawOfResistanceDCIncrease(object oTrueSpeaker, int nSpellID);

/**
 * Stores the Law Of Resistance DC increase
 *
 * @param oTrueSpeaker    Caster of the Utterance
 * @param nSpellId        SpellId of the Utterance
 */
void DoLawOfResistanceDCIncrease(object oTrueSpeaker, int nSpellID);

/**
 * Deletes all of the Local Ints stored by the laws.
 * Called OnRest and OnEnter
 *
 * @param oTrueSpeaker    Caster of the Utterance
 */
void ClearLawLocalVars(object oTrueSpeaker);

/**
 * Returns the Personal Truename DC increase
 * Right now this only accounts for targetting self
 *
 * @param oTrueSpeaker    Caster of the Utterance
 * @param oTarget         Target of the Utterance
 * @return                The DC boost for using a personal truename
 */
int AddPersonalTruenameDC(object oTrueSpeaker, object oTarget);

/**
 * Returns the DC increase if the TrueSpeaker ignores SR.
 *
 * @param oTrueSpeaker    Caster of the Utterance
 * @return                The DC boost for using this ability
 */
int AddIgnoreSpellResistDC(object oTrueSpeaker);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////



//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

int GetBaseUtteranceDC(object oTarget, object oTrueSpeaker, int nLexicon)
{
	int nDC;
	
	// We're targetting a creature
	if (nLexicon == TYPE_EVOLVING_MIND)
	{
		// CR does not take into account floats, so this is converted.
		int nCR = FloatToInt(GetChallengeRating(oTarget));
		// For PCs, use their HitDice
		if (GetIsPC(oTarget)) nCR = GetHitDice(oTarget);
		// Basic formula for the DC
		nDC = 15 + (2 * nCR);
	}
	// Targetting an Item here
	else if (nLexicon == TYPE_CRAFTED_TOOL)
	{
		// The formula isn't finished, because there isn't caster level on NWN items.
		int nCasterLvl = 0;
		nDC = 15 + (2 * nCasterLvl);
	}
	// Targetting the land
	else if (nLexicon == TYPE_PERFECTED_MAP)
	{
		// Yup, thats it.
		nDC = 25;
	}	
	// Later on there will be switches in here to change the DC to different formulas.
	// Thats why the PC is passed in
	
	return nDC;
}

int GetLawOfResistanceDCIncrease(object oTrueSpeaker, int nSpellID)
{
	// Law of resistance is stored for each utterance by SpellId
	int nDC = GetLocalInt(oTrueSpeaker, LAW_OF_RESIST_VARNAME + IntToString(nSpellId));
	// Its stored by the number of succesful attempts, so we double it to get the DC boost
	nDC = nDC * 2;
	return nDC;
}

void DoLawOfResistanceDCIncrease(object oTrueSpeaker, int nSpellID)
{
	// Law of resistance is stored for each utterance by SpellId
	int nNum = GetLocalInt(oTrueSpeaker, LAW_OF_RESIST_VARNAME + IntToString(nSpellId));
	// Store the number of times per day its been cast succesfully
	SetLocalInt(oTrueSpeaker, LAW_OF_RESIST_VARNAME + IntToString(nSpellId), (nNum + 1));
}

void ClearLawLocalVars(object oTrueSpeaker)
{
	// As long as the PC isn't a truenamer, don't run this.
	if (!GetLevelByClass(CLASS_TYPE_TRUENAMER, oTrueSpeaker)) return;
	// Law of resistance is stored for each utterance by SpellId
	// So we loop em all and blow em away
	// Because there are only about 60, this should not TMI
	// i is the SpellId
	// Replace numbers when done
	for(i = 17500; i < 18000; i++)
	{
		DeleteLocalInt(oTrueSpeaker, LAW_OF_RESIST_VARNAME + IntToString(i));
		DeleteLocalInt(oTrueSpeaker, LAW_OF_SEQUENCE_VARNAME + IntToString(i));
	}
}

int AddPersonalTruenameDC(object oTrueSpeaker, object oTarget)
{
	// Targetting yourself increases the DC by 2
	// But you get a +4 Bonus to speak your own truename
	// Total Adjustment: -2
	int nDC = 0;
	
	// Only works when the Truespeaker targets himself at the moment.
	if (oTrueSpeaker == oTarget) nDC = -2;
	
	return nDC;
}

int AddIgnoreSpellResistDC(object oTrueSpeaker)
{
	int nDC = 0;
	if (GetLocalInt(oTrueSpeaker, TRUE_IGNORE_SR)) nDC += 5;
	
	return nDC;
}
// Test main
//void main(){}
