//::///////////////////////////////////////////////
//:: Name      Gutwrench
//:: FileName  sp_gutwrench.nss
//:://////////////////////////////////////////////
/**@file Gutwrench
Necromancy [Evil, Death] 
Level: Sor/Wiz 8 
Components: V, S, Undead 
Casting Time: 1 action 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One living creature 
Duration: Instantaneous
Saving Throw: Fortitude partial 
Spell Resistance: Yes

The innards of the target creature roil. If the 
target fails its saving throw, its intestines burst
forth, killing it. The intestines fly toward the 
caster and are absorbed into her form, granting her
4d6 temporary hit points and a +4 enhancement bonus
to Strength. If the target's save is successful, it
takes 10d6 points of damage instead.

A creature with no discernible anatomy is unaffected
by this spell. 

Author:    Tenjac
Created:   16.3.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//Spellhook
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nType = MyPRCGetRacialType(oPC);
	int nTargetType = MyPRCGetRacialType(oTarget);
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	
	SPRaiseSpellCastAt(oTarget,TRUE, SPELL_GUTWRENCH, oPC);
	
	//Caster must be undead.  If not, hit 'em with alignment change anyway.
	//Try reading the description of the spell moron. =P
	
	if(nType == RACIAL_TYPE_UNDEAD)
	{
		if(nTargetType != RACIAL_TYPE_OOZE &&
		   nTargetType != RACIAL_TYPE_CONSTRUCT &&
		   nTargetType != RACIAL_TYPE_UNDEAD &&
		   nTargetType != RACIAL_TYPE_ELEMENTAL)
		   
		 {
			 if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
			 {
				 if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
				 {
					 //define effects
					 effect eDeath = EffectDeath();
					 effect eGut = EffectBeam(VFX_BEAM_SILENT_EVIL, oTarget, BODY_NODE_CHEST);
					 effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
					 effect eBonus = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
					 effect eLink = EffectLinkEffects(eDeath, eGut);			
					 
					 //Apply to target
					 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
					 
					 //PC
					 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
					 SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, HoursToSeconds(24));			
				 }
				 
				 //Otherwise, take 10d6 damage, be thankful, and RUN.
				 else
				 {
					 int nDam = d6(10);
					 
					 //evaluate metamagic
					 if(nMetaMagic == METAMAGIC_MAXIMIZE)
					 {
						 nDam = (8 * nCasterLvl);
					 }
					 
					 if(nMetaMagic == METAMAGIC_EMPOWER)
					 {
						 nDam += (nDam/2);
					 }
					 
					 //define damage
					 effect eDam = EffectDamage(DAMAGE_TYPE_MAGICAL, nDam);
					 
					 
					 //Apply damage
					 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				 }
			 }
		 }
	 }
	 
	 SPEvilShift(oPC);
	 
	 SPSetSchool();
}
	 
	 