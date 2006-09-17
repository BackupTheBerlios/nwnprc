//::///////////////////////////////////////////////
//:: Name      Protection from Arrows
//:: FileName  sp_prot_arrows.nss
//:://////////////////////////////////////////////
/**@file Protection from Arrows
Abjuration
Level: Sor/Wiz 2, Hexblade 2
Components: V, S, F
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: 1 hour/level or until discharged
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

The warded creature gains resistance to ranged weapons.
The subject gains damage reduction 10/magic against 
ranged weapons. (This spell doesn�t grant you the 
ability to damage creatures with similar damage 
reduction.) Once the spell has prevented a total of 
10 points of damage per caster level (maximum 100 
points), it is discharged.

Focus: A piece of shell from a tortoise or a turtle.

**/

//////////////////////////////////////////////////
//  Author: Tenjac
//  Date:   16.9.2006
/////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = HoursToSeconds(nCasterLvl);
		
	// Damage Resistance 10 piercing, max of 100 total
	effect eBuff = = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10, min((10 * nCasterLvl), 100), EffectVisualEffect(VFX_DUR_PROTECTION_ARROWS));
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur);
	
	SPSetSchool();
}