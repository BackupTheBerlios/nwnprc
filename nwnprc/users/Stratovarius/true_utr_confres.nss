/*
   ----------------
   Confounding Resistance
   
   true_utr_confres
   ----------------

   3/8/06 by Stratovarius
*/ /** @file

    Confounding Resistance

    Level: Evolving Mind 4
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Spell Resistance: Yes
    Save: None
    Metautterances: Extend

    Normal:  Your target becomes more mobile, able to entirely avoid effects that might otherwise have some dire consequence.
             Your target gains Evasion.
    Reverse: Your utterance strips your target of its ability to evade harm.
             Your target loses Evasion.
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
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_EVOLVING_MIND);
        
    if(DEBUG) DoDebug("true_utr_archeye running, event: " + IntToString(nEvent));

    if(utter.bCanUtter)
    {
        utter.fDur       = RoundsToSeconds(5);
        if(utter.bExtend) utter.fDur *= 2;
        // This utterance applies only to friends
        utter.bFriend = TRUE;
        // Used to Ignore SR in Speak Unto the Masses for friendly utterances.
        utter.bIgnoreSR = TRUE;
        
        // The NORMAL effect of the Utterance goes here
        if (utter.nSpellId == UTTER_CONFOUNDING_RESISTANCE)
        {
       		utter.ipIProp1 = PRCItemPropertyBonusFeat(IP_CONST_FEAT_EVASION);
       		object oSkin = GetPCSkin(oTrueSpeaker);
       		IPSafeAddItemProperty(oSkin, utter.ipIProp1, utter.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
       		// Visuals 
       		utter.eLink = EffectVisualEffect(VFX_DUR_BLUESHIELDPROTECT);
       		utter.eLink2 = EffectVisualEffect(VFX_IMP_HOLY_AID);
        }
        // The REVERSE effect of the Utterance goes here
        else /* Effects of UTTER_CONFOUNDING_RESISTANCE_R */
        {
        	// Concealment
		SetLocalInt(oTarget, "TrueConfoundingResistance", TRUE);
		DelayCommand(fDur, DeleteLocalInt(oTarget, "TrueConfoundingResistance"));
		// Visuals 
		utter.eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
       		utter.eLink2 = EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_GREEN);
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
        DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}