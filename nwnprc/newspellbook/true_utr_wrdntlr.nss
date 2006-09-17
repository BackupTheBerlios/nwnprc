/*
   ----------------
   Word of Nurturing, Lesser
   true_utr_wrdntlr
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

    Word of Nurturing, Lesser

    Level: Evolving Mind 2
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds or 1 round
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend, Empower

    Normal:  You speak a more complex utterance of health, providing an ally with the soothing balm of healing
             Your ally gains regeneration +3.
    Reverse: You speak a word that tears at an enemy's flesh, causing it to bleed from several wounds.
             Your foe takes a 2d6 damage, and 2d6 damage the next round if you concentrate. Concentration involves doing nothing more strenous than moving.
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, (METAUTTERANCE_EXTEND | METAUTTERANCE_EMPOWER), LEXICON_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
        // This is done so Speak Unto the Masses can read it out of the structure
        utter.nPen       = GetTrueSpeakPenetration(oTrueSpeaker);
        int nSRCheck;
        
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_WORD_NURTURING_LESSER)
        {
        	// This utterance applies only to friends
		utter.bFriend = TRUE;
		// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	utter.fDur       = RoundsToSeconds(5);
        	// Regeneration
        	utter.eLink = EffectRegenerate(3, 6.0);
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_HEALING_M_MAG);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_WORD_NURTURING_LESSER_R
        {
        	utter.fDur       = RoundsToSeconds(1);
        	
        	// If the Spell Penetration fails, don't apply any effects
        	nSRCheck = MyPRCResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        	if (!nSRCheck)
        	{
       			// Skill Penalty
       			utter.eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
			int nDamage = d6(2);
			// Empower it
			if(utter.bEmpower) nDamage += (nDamage/2);       			
       			// Impact VFX 
        		utter.eLink2 = EffectLinkEffects(EffectVisualEffect(VFX_IMP_MAGPUR), EffectDamage(nDamage));
        		// This takes care of the concentration bit of the utterance
        		DelayCommand(6.0, DoWordOfNurturingReverse(oTrueSpeaker, oTarget, utter));
        	}
        }
        if(utter.bExtend) utter.fDur *= 2;
        // Duration Effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, utter.eLink, oTarget, utter.fDur, TRUE, utter.nSpellId, utter.nTruespeakerLevel);
        // Impact Effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, utter.eLink2, oTarget);
        
        // Speak Unto the Masses. Swats an area with the effects of this utterance
        DoSpeakUntoTheMasses(oTrueSpeaker, oTarget, utter);
        // Mark for the Law of Sequence. This only happens if the utterance succeeds, which is why its down here.
        // The utterance isn't active if SR stops it
        if (!nSRCheck) DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance    
}
