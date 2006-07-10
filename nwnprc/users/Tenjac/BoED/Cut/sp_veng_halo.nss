//::///////////////////////////////////////////////
//:: Name      Vengeance Halo
//:: FileName  sp_veng_halo.nss
//:://////////////////////////////////////////////
/**@file Vengeance Halo 
Abjuration [Good] 
Level: Cleric 6, Wrath 6 
Components: V, S, DF, Abstinence 
Casting Time: 1 standard action 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One good aligned creature; see text
Duration: 1 minute/level
Saving Throw: None or Reflex half; see text
Spell Resistance: No

A luminous ring of holy power appears above the 
head of a good creature and remains in place until
the spell expires or the creature is slain 
(reduced to -10 hp). If the latter event occurs, 
the halo discharges an arc of divine energy that 
deals 1d6 points of damage per caster level 
(maximum 20d6) to the target's slayer. The creature
subject to the attack can make a Reflex save to 
reduce the damage by half. Once the vengeance halo
unleashes its energy, it disappears and the spell 
ends.

Abstinence Component: You must abstain from alcohol 
for 1 week prior to casting this spell.

Author:    Tenjac
Created:   7/7/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLvl);
		
	//VFX
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE), oTarget, fDur);
	
	DamageMonitor(oTarget);
	
	SPGoodShift(oPC);
	SPSetSchool();
}

void DamageMonitor(object oTarget)
{
	if(GetIsDead(oTarget))
	{
		object oKiller = GetLastDamager() //Calling this will return the damager
		                                  //of oPC, not oTarget

	
	
	
	
	
	