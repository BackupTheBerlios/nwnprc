/*
   ----------------
   Utterance Template

   true_utr_template
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

    Utterance Template

    Level: Evolving Mind, Crafted Tool, or Perfected Map
    Range: 60 feet (Range is 60 feet unless mentioned otherwise)
    Target: 
    Duration: 
    Spell Resistance: Yes
    Save: 
    Metautterances: Extend/Empower (All can be quickened)

    Normal:  
    Reverse: 
*/

#include "true_inc_trufunc"
#include "true_utterhook"
#include "prc_alterations"

void main()
{
/*
  Spellcast Hook Code
  Added 2006-7-19 by Stratovarius
  If you want to make changes to all utterances
  check true_utterhook to find out more

*/

    if (!TruePreUtterCastCode())
    {
    // If code within the PreUtterCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, 
                                               oTarget, 
                                               (METAUTTERANCE_EXTEND | METAUTTERANCE_EMPOWER)/* Use METAUTTERANCE_NONE if it has no Metautterance usable*/, 
                                               LEXICON_EVOLVING_MIND /* Pick One: LEXICON_EVOLVING_MIND, LEXICON_CRAFTED_TOOL, LEXICON_PERFECTED_MAP*/);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
 	utter.nSaveType  = SAVING_THROW_TYPE_NONE; // SAVING_THROW_TYPE_*
    	utter.nSaveThrow = SAVING_THROW_FORT; // SAVING_THROW_WILL/_FORT/_REFLEX
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        utter.nSaveDC    = GetTrueSpeakerDC(oTrueSpeaker);
        utter.fDur       = RoundsToSeconds(5);
        int nSRCheck;
        int nSaveCheck;
        if(utter.bExtend) utter.fDur *= 2;
        // This utterance applies only to friends
	utter.bFriend = TRUE;
	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        utter.bIgnoreSR = TRUE;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_DEFENSIVE_EDGE /* Example Utterance */)
        {
        	// eLink is used for Duration Effects (Buff/Penalty to AC)
        	utter.eLink = EffectLinkEffects();
        	// eLink2 is used for Impact Effects (Damage)
        	utter.eLink2 = EffectVisualEffect();
        }
        // The REVERSE effect of the Utterance goes here
        else /* Effects of UTTER_DEFENSIVE_EDGE_R would be here */
        {
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = MyPRCResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
        		// Saving throw
        		nSaveCheck = PRCMySavingThrow(utter.nSaveThrow, oTarget, utter.nSaveDC, utter.nSaveType, OBJECT_SELF);
        		if(!nSaveCheck)
                	{
        			// eLink is used for Duration Effects (Buff/Penalty to AC)
        			utter.eLink = EffectLinkEffects();
        			// eLink2 is used for Impact Effects (Damage)
        			utter.eLink2 = EffectVisualEffect();
        		}
        	}
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR or Saves stop it
        // Make sure to delete one if not needed
        if (!nSRCheck && !nSaveCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}
