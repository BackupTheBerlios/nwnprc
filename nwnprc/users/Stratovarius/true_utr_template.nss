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
                                               TYPE_* /* Pick One: LEXICON_EVOLVING_MIND, LEXICON_CRAFTED_TOOL, LEXICON_PERFECTED_MAP*/);

    if(utter.bCanUtter)
    {
        float fDuration = RoundsToSeconds(5);
        if(utter.bExtend) fDuration *= 2;
        effect eLink;
        
        // The NORMAL effect of the Utterance goes here
        if (PRCGetSpellId() == UTTER_NORMAL)
        {
        	eLink = EffectLinkEffects();
        }
        // The REVERSE effect of the Utterance goes here
        else 
        {
        	eLink = EffectLinkEffects();
        	
        	// A return of true from this function means the target made its SR roll
        	// If this is the case, the utterance has failed, so we exit
        	if (MyPRCResistSpell(oTrueSpeaker, oTarget, GetTrueSpeakPenetration(oTrueSpeaker))) return;
        }
        // If either of these ApplyEffect isn't needed, delete it.
        // Apply Utterance effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, utter.nSpellID, utter.nTruespeakerLevel);
        // Visual Impact Effect or Instant Effect Utterance
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
        // Mark for the Law of Sequence. This only happens if the power succeeds, which is why its down here.
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, fDuration)
    }// end if - Successful utterance
}
