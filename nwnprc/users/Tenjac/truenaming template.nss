/*
[13:42] <Annihilator-X17> There's a function called EvaluateManifestation/Utterance
[13:43] <Annihilator-X17> and you put into it all the things it needs to know, then it calculates and spits out whether you can manifest, and a whole bunch of other things ;P
[13:43] <Annihilator-X17> basically, what this tells it is the power/utterance can have Empower and Extend
[13:43] <Annihilator-X17> and so it checks for both of em
[13:43] <Annihilator-X17> if they arent put in, it assumes the utterance cant have em and never even checks
[13:43] <Annihilator-X17> Quicken is done seperately and is always assumed to be on
[13:44] <Annihilator-X17> because you can quicken anything
[13:44] <Annihilator-X17> since there are only 3 metautters
[13:44] <Tenjac> right
[13:44] <Annihilator-X17> the only time you'll ever use it is if there is an extend/empower utter
[13:44] <Annihilator-X17> and that would look like (METAUTTERANCE_EXTEND | METAUTTERANCE_EMPOWER)
[13:45] <Annihilator-X17> as for type, that just tells it which of the three lexicons its looking at
[13:45] <Annihilator-X17> TYPE_EVOLVING_MIND, TYPE_CRAFTED_TOOL, TYPE_PERFECTED_MAP
[13:45] <Annihilator-X17> DC and targetting is different for the different powers
[13:45] <Annihilator-X17> utterances even
[13:47] <Tenjac> hehe
[13:48] <Annihilator-X17> easiest to use will end up being Perfected Map
[13:48] <Annihilator-X17> the DC is static at 25
[13:48] <Annihilator-X17> (there is erratta that makes the DC for it a formula, but who needs errata?)

*/

	

/*
   ----------------
   Defensive Edge

   true_utr_defedge
   ----------------

   19/7/06 by Stratovarius
*/ /** @file

    Defensive Edge

    Level: Evolving Mind 1
    Range: 60 feet
    Target: One Creature
    Duration: 5 Rounds
    Metautterances: Extend

    Normal:  You grant a greater awareness of foes in the area, increasing an ally's ability to protect herself. 
             Your ally gains +1 Armour Class.
    Reverse: Your dire whispers seep into your foe's mind, disrupting its ability to defend itself.
             Your foe takes a -1 to Armour Class.            
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
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, TYPE_EVOLVING_MIND);

    if(utter.bCanUtter)
    {
        float fDuration = RoundsToSeconds(5);
        if(utter.bExtend) fDuration *= 2;
        effect eLink;
        
        // Normal
        if (PRCGetSpellId() == UTTER_DEFENSIVE_EDGE)
        {
        	eLink = EffectLinkEffects(EffectACIncrease(1, AC_DODGE_BONUS), EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
        }
        else // Its either one or the other, so use this as the default
        {
        	eLink = EffectLinkEffects(EffectACDecrease(1), EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR));
        	// A return of true from this function means the target made its SR roll
        	// If this is the case, the utterance has failed, so we exit
        	if (MyPRCResistSpell(oTrueSpeaker, oTarget, GetTrueSpeakPenetration(oTrueSpeaker))) return;
        }
        
        // Apply effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, utter.nSpellID, utter.nTruespeakerLevel);
    }// end if - Successfull manifestation
}