//::///////////////////////////////////////////////
//:: Name      Healing Touch
//:: FileName  sp_healng_tch.nss
//:://////////////////////////////////////////////
/**@file Healing Touch
Necromancy[Good]
Level: Sorcerer/wizard 3
Components: V,S
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You transfer some of your life essence to another
creature, healing it.  You may heal up to 1d6
hit points per two caster levels (maximum 10d6),
and must decide how many dice to roll when you
cast the spell.  You take damage equal to the 
amount the target is healed.  This spell cannot
restore more hit points to a target than your
current hit points +10, which is enough to kill 
you.

Author:    Tenjac
Created:   7/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "inc_dynconv"

void main()
{
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//Spellhook
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);	
	
	StartDynamicConversation("healing_touch", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);