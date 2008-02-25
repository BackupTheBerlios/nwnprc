//::///////////////////////////////////////////////
//:: Name      Calm Emotions: On Enter
//:: FileName  sp_calm_emotionA.nss
//:://////////////////////////////////////////////2
/** @file Calm Emotions
Enchantment (Compulsion) [Mind-Affecting]
Level: 	Brd 2, Clr 2, Law 2
Components: 	V, S, DF
Casting Time: 	1 standard action
Range: 	Medium (100 ft. + 10 ft./level)
Area: 	Creatures in a 20-ft.-radius spread
Duration: 	1 round/level
Saving Throw: 	Will negates
Spell Resistance: 	Yes

This spell calms agitated creatures. You have no 
control over the affected creatures, but calm emotions
can stop raging creatures from fighting or joyous ones
from reveling. Creatures so affected cannot take 
violent actions (although they can defend themselves) 
or do anything destructive. 


**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   8.10.06
//////////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
	object oPC = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);	
	
	//SR
	if(!PRCMyResistSpell(oPC, oTarget, PRCGetCasterLevel(oPC) + SPGetPenetr()))
	{
		//Saving Throw
		if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
			effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
			
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(PRCGetCasterLevel(oPC)));
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDazed(), oTarget);
		}
	}
}