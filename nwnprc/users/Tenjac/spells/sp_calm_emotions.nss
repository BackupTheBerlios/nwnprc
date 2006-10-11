//::///////////////////////////////////////////////
//:: Name      Calm Emotions
//:: FileName  sp_calm_emotions.nss
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
	if(!X2PreSpellCastCode*()) return;
	
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	effect eAoE = EffectAreaOfEffect(AOE_PER_CALM_EMOTIONS);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oPC, fDur);
	
	SPSetSchool();
}
	
	
	