//::///////////////////////////////////////////////
//:: Name      Absorb Strength
//:: FileName  sp_absorb_str.nss
//:://////////////////////////////////////////////
/** @file Absorb Strength
Necromancy [Evil]
Level: Corrupt 4
Components: V, S, F, Corrupt
Casting Time: 1 action
Range: Personal
Target: Caster
Duration: 10 minutes/level

The caster eats at least a portion of the flesh of 
another creature's corpse, thereby gaining one-quarter
of the creature's Strength score as an enhancement 
bonus to the caster's Strength score, and one-quarter 
of the creature's Constitution score as an enhancement
bonus to the caster's Constitution.
 
Focus: A fresh or preserved (still bloody) 1-ounce 
portion of another creature's flesh.

Corruption Cost: 2d6 points of Wisdom damage.

Author:    Tenjac
Created:   1/25/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"
#include "inc_abil_damage"


void DiseaseCheck(object oTarget, object oPC)
{
	effect eDisease;
	
	//Soul rot	
	if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER && GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL))
	{
		eDisease = EffectDisease(DISEASE_SOUL_ROT);
	}
	
	if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD     ||
	   MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OOZE       ||
	   MyPRCGetRacialType(oTarget) == RACIAL_TYPE_ABERRATION ||
	   MyPRCGetRacialType(oTarget) == RACIAL_TYPE_VERMIN
	 {
		 eDisease = EffectDisease(DISEASE_BLUE_GUTS);
	 }
	 
	 SPApplyEffectToObject(DUATION_TYPE_PERMANENT, eDisease, oPC);
}

void main()
{	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	location lLoc = GetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_CUBE, RADIUS_SIZE_SMALL, lLoc, FALSE, OBJECT_TYPE_CREATURE);
		
        while(!GetIsDead(oTarget) && GetIsObjectValid(oTarget))
        {
		oTarget = GetNextObjectInShape(SHAPE_CUBE, RADIUS_SIZE_SMALL, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	//must be dead creature so check again for GetSpellTargetObject
	if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE || !GetIsDead(oTarget))			
	{
		return;
	}
			
	//Get ability scores
	int nStr = GetAbilityScore(oTarget, ABILITY_STRENGTH);
	int nCon = GetAbilityScore(oTarget, ABILITY_CONSTITUTION);
	
	//Bonus of 1/4 
	nStr = nStr/4;
	nCon = nCon/4;
	
	//Construct effects
	effect eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
	effect eConBonus = EffectAbilityIncrease(ABILITY_CONSTITUTION, nCon);
	effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	
	//Link
	effect eBonus = EffectLinkEffects(eStrBonus, eConBonus);
	       eBonus = EffectLinkEffects(eBonus, eVis);
	
	//Duration 10 min/level
	float fDuration = IntToFloat(nCasterLvl * 600);
	
	//Check for Extend
	if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
	{
		fDuration = (fDuration * 2);
	}
	
	//Apply
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, fDuration);
	
	//If appropriate, expose player to disease
	DiseaseCheck(oTarget, oPC);
	
	//Corruption Cost
	{
		int nCost = d6(2);
		DelayCommand(fDuration, DoCorruptionCost(oPC, oTarget, ABILITY_WISDOM, nCost, 0));
	}	
	
	
	SPEvilShift(oPC);
	
	SPSetSchool();
}

	
	