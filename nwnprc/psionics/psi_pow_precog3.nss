/*
   ----------------
   Precognition, Save Boost
   
   prc_pow_precog3
   ----------------

   15/7/05 by Stratovarius

   Class: Psion (Seer)
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
Precognition allows your mind to glimpse fragments of potential future events�what you see will probably happen if no one takes 
action to change it. However, your vision is incomplete, and it makes no real sense until the actual events you glimpsed begin to 
unfold. That�s when everything begins to come together, and you can act, if you act swiftly, on the information you previously 
received when you manifested this power.

In practice, manifesting this power grants you a precognitive edge. Normally, you can have only a single precognitive edge at one 
time. You must use your edge within a period of no more than 10 minutes per level, at which time your preknowledge fades and you 
lose your edge.

You can use your precognitive edge in a variety of ways. Essentially, the edge translates into a +2 insight bonus that you can 
apply at any time to either an attack roll, a damage roll, a saving throw, or a skill check. To apply this bonus for one round, 
press either the Attack, Save, Skill, or Damage option on the radial menu.
*/

#include "X0_I0_SPELLS"

void main()
{
	object oTarget = GetSpellTargetObject();
	int nTest = GetLocalInt(oTarget, "Precognition");
	
	if (nTest)
	{
		effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
		effect eAttack = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oTarget, 6.0);
		DeleteLocalInt(oTarget, "Precognition");
	}
	else
	{
		FloatingTextStringOnCreature("You do not have a precognitive edge", oTarget, FALSE);
	}
}