//::///////////////////////////////////////////////
//:: Name      Sadism
//:: FileName  sp_sadism.nss
//:://////////////////////////////////////////////
/**@file Sadism
Enchantment [Evil]
Level: Asn 3, Blk 3, Clr 3, Pain 2, Sor/Wiz 2
Components: V, S, M 
Casting Time: 1 action 
Range: Personal 
Target: Caster 
Duration: 1 round/level

For every 10 points of damage the caster deals in a
given round while under the effect of this spell, 
she gains a +1 luck bonus on attack rolls, saving t
hrows, and skill checks in the next round. The more 
damage the caster deals, the greater the luck bonus.
It's possible to get a luck bonus for multiple 
rounds if she deals damage in more than one round 
during the spell's duration.

Material Component: A leather strap that has been 
soaked in human blood. 

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void SadisticLoop(object oPC, int nCounter, int nDamage);

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	int nDam = 0;
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCounter = PRCGetCasterLevel(oPC);
	int nDamage;
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		nCounter = (nCounter * 2);
	}
		
	//Start the loop
	SadisticLoop(oPC, nCounter, nDamage);
	
	SPEvilShift(oPC)
	SPSetSchool();
}

void SadisticLoop(object oPC, int nCounter, int nDamage)
{
	if(nCounter > 0)
	{
		if(nDamage > 0)
		{
			int nBonus = nDamage/10;
			
			effect eLink = EffectAttackIncrease(nBonus, ATTACK_BONUS_MISC);
			eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL));
			eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus));
						
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 6.0f);			
		}
		
		//Decrement counter
		nCounter--;
		
		//Schedule next go-round
		DelayCommand(6.0f, SadisticLoop(oPC, nCounter, nDamage));
	}
}
	

	
	