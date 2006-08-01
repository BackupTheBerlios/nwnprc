/*
   ----------------
   Word of Nurturing, Potent
   true_utr_wrdntpo
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

    Word of Nurturing, Potent

    Level: Evolving Mind 4
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds or 1 round
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend, Empower

    Normal:  Your powerful utterance grants an ally increased ability to knit her own wounds.
             Your ally gains regeneration +10.
    Reverse: You tear at the fabric of your enemy's connection to its body, causing great wounds.
             Your foe takes a 6d6 damage, and 6d6 damage the next round if you concentrate. Concentration involves doing nothing more strenous than moving.
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
        int nSRCheck     = MyPRCResistSpell(oTrueSpeaker, oTarget, utter.nPen);
        
        
        // The NORMAL effect of the Utterance goes here
        if (PRCGetSpellId() == UTTER_WORD_NURTURING_POTENT)
        {
        	// Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        	utter.bIgnoreSR = TRUE;
        	utter.fDur       = RoundsToSeconds(5);
        	// Regeneration
        	utter.eLink = EffectRegenerate(10, 6.0);
        	// Impact VFX 
        	utter.eLink2 = EffectVisualEffect(VFX_IMP_HEALING_G_CYA);
        }
        // The REVERSE effect of the Utterance goes here
        else // UTTER_WORD_NURTURING_POTENT_R
        {
        	utter.fDur       = RoundsToSeconds(1);
        	
        	// If the Spell Penetration fails, don't apply any effects
        	if (!nSRCheck)
        	{
       			// Skill Penalty
       			utter.eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
       			int nDamage = d6(6);
			// Empower it
			if(utter.bEmpower) nDamage += (nDamage/2);
       			// Impact VFX 
        		utter.eLink2 = EffecLinkEffects(EffectVisualEffect(VFX_IMP_MAGBLU), EffectDamage(nDamage));
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
