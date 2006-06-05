//::///////////////////////////////////////////////
//:: Name      Imprison Soul
//:: FileName  sp_impris_soul.nss
//:://////////////////////////////////////////////
/**@file Imprison Soul 
Necromancy [Evil] 
Level: Clr 7 
Components: V, S, M, F 
Casting Time: 1 action (see text) 
Range: Medium (100 ft. + 10 ft./level)
Target: One creature 
Duration: Instantaneous 
Saving Throw: Will negates 
Spell Resistance: No

By casting imprison soul, the caster places the 
subject's soul in a receptacle, such as a gem, 
ring, or some other minuscule object, leaving the
subject's body lifeless. While trapped, the 
subject takes 1d4 points of Constitution damage per
day until dead or freed. The rituals to prepare the 
receptacle require three days. Destroying or opening 
the receptacle ends the spell, releasing the soul.

To cast the spell, the receptacle must be within 
spell range and the caster must know where it is.
The caster must also know the name of the target.

Material Component: A portion of the target's body 
a fingernail, a strand of hair, or some other small
part).

Focus: A Tiny or smaller object to be the receptacle 
for the subject's soul. 

Author:    Tenjac
Created:   6/5/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
void DamageLoop(object oTarget);

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nHP = GetCurrentHitPoints(oTarget);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	SPRaiseSpellCastAt(oTarget,TRUE, SPELL_IMPRISON_SOUL, oPC);
	
	if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
	{
		DamageLoop(oTarget, oPC, nMetaMagic);		
	}
	SPEvilShift(oPC);
}

void DamageLoop(object oTarget, object oPC, int nMetaMagic)
{
	int nDam = d4();
	
	if(nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nDam = 4;
	}
	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nDam += (nDam/2);
	}
	
	//1d4 CON
	ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_PERMANENT, 0.0f, FALSE, SPELL_IMPRISON_SOUL, PRCGetCasterLevel(oPC), oPC);
	
	DelayCommand(HoursToSeconds(24), DamageLoop(oTarget, oPC, nMetaMagic);
}
	
	