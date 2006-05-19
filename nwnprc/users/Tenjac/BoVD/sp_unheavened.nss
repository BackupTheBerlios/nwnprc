//::///////////////////////////////////////////////
//:: Name      Unheavened
//:: FileName  sp_unheavened.nss
//:://////////////////////////////////////////////
/**@fileUnheavened 
Abjuration [Evil] 
Level: Sor/Wiz 2 
Components: V, S, Drug 
Casting Time: 1 action 
Range: Touch
Target: One creature 
Duration: 10 minutes/level 
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

The caster grants one creature a +4 profane bonus on
saving throws made against any spell or spell-like
effect from a good outsider. This protection 
manifests as a black and red nimbus of energy
visible around the subject. All celestial beings can
identify an unheavened nimbus on sight.

Drug Component: Vodare. 

Author:    Tenjac
Created:   5/18/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	//spellhook
	if(!X2PreSpellCastCode()) return;
	SPSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	
	//check for Vodare
	if(GetHasSpellEffect(SPELL_VODARE, oPC))
	{
		//only aginast
	