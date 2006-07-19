1  
2  
3  
4  
5  
6  
7  
8  
9  
10  
11  
12  
13  
14  
15  
16  
17  
18  
19  
20  
21  
22  
23  
24  
25  
26  
27  
28  
29  
30  
31  
32  
33  
34  
35  
36  
37  
38  
39  
40  
41  
42  
43  
44  
45  
46  
47  
48  
49  
50  
51  
52  
53  
54  
55  
56  
57  
58  
59  
60  
61  
62  
63  
64  
65  
66  
67  
68  
69  
70  
71  
72  
73  
  

	

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