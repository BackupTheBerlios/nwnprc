//::///////////////////////////////////////////////
//:: Name      Eternity of Torture
//:: FileName  sp_etern_tortr.nss
//:://////////////////////////////////////////////
/**@file Eternity of Torture 
Necromancy [Evil]
Level: Pain 9
Components: V, S, DF 
Casting Time: 1 action 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One creature
Duration: Permanent
Saving Throw: Fortitude partial 
Spell Resistance: Yes

The subject's body is twisted and warped, wracked 
forever with excruciating pain. The subject is 
rendered helpless, but-as long as the spell continues
-it is sustained and has no need for food, drink, or 
air. The subject does not age-all the better to ensure
a true eternity of unimaginable torture. The subject 
takes 1 point of drain to each ability score each day
until all scores are reduced to 0 (except Constitution,
which stays at 1). The subject cannot heal or regenerate.
Lastly, the subject is completely unaware of its 
surroundings, insensate to anything but the excruciating
pain.

A single Fortitude saving throw is all that stands 
between a target and this horrible spell. However, 
even if the saving throw is successful, the target 
still feels terrible (but temporary) pain. The target 
takes 5d6 points of damage immediately and takes a -4
circumstance penalty on attack rolls, saving throws, 
skill checks, and ability checks for 1 round per level 
of the caster.

Author:    Tenjac
Created:   3/25/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = 15000.0f;	
	effect eImp = EffectVisualEffect(VFX_FNF_PWKILL);
	
	//spellhook
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//Spell resist
	if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//VFX
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
		
		//Fort save
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, fDur)); 
			AssignCommand(oTarget, SetCommandable(FALSE));
			
			//Should this be done by dispell spells instead?
			DelayCommand(fDur, AssignCommand(oTarget, SetCommandable(TRUE)));
		}
		
		else
		{
			//5d6 damage, -4 to attack, save, skills, attribute checks
			int nDam = d6(5);
			effect eLink = EffectAttackDecrease(4, ATTACK_BONUS_MISC);
			eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
			eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL, 4);
			
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (6.0f * nCasterLvl));
		}
	}
	
	SPEvilShift(oPC);
	SPSetSchool();
}

void AbilityScrewed (object oTarget)
{
	if(GetAbilityScore(oTarget, ABILITY_STRENGTH) > 3) 
	{
		ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, 1, DURATION_TYPE_PERMANENT, TRUE, -1.0f);
	}
		
	if(GetAbilityScore(oTarget, ABILITY_DEXTERITY) > 3)
	{
		ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, 1, DURATION_TYPE_PERMANENT, TRUE, -1.0f);
	}
	
	if(GetAbilityScore(oTarget, ABILITY_CONSTITUTION) > 3)
	{
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, 1, DURATION_TYPE_PERMANENT, TRUE, -1.0f);
	}
	if(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) > 3)
	{
		ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, 1, DURATION_TYPE_PERMANENT, TRUE, -1.0f);
	}
	
	if(GetAbilityScore(oTarget, ABILITY_WISDOM) > 3)
	{
		ApplyAbilityDamage(oTarget, ABILITY_WISDOM, 1, DURATION_TYPE_PERMANENT, TRUE, -1.0f);
	}
	
	if(GetAbilityScore(oTarget, ABILITY_CHARISMA) > 3)
	{
		ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, 1, DURATION_TYPE_PERMANENT, TRUE, -1.0f);
	}
	
	
	
	
	
			