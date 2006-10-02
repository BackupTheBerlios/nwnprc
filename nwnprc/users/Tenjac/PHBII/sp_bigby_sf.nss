//::///////////////////////////////////////////////
//:: Name      Bigby's Striking Fist
//:: FileName  sp_bigby_sf.nss
//:://////////////////////////////////////////////
/**@file Bigby's Striking Fist
Evocation [Force]
Level: Duskblade 2, sorcerer/wizard 2
Components: V,S,M
Casting Time: 1 standard action
Range: Medium
Target: One creature
Duration: Instantaneous
Saving Throw: Reflex partial
Spell Resistance: Yes

The attack bonus of this striking fist equals your
caster level + your key ability modifier + 2 for the
hand's Strength score (14). The fist deals 1d6 points
of nonlethal damage per two caster levels (maximum 5d6)
and attempts a bull rush.  The fist has a bonus of +4
plus +1 per two caster levels on the bull rush attempt,
and if successful it knocks the subject back in a 
direction of your choice. This movement does not 
provoke attacks of opportunity.  A subject that 
succeeds on its Reflex save takes half damage and is
not subject to the bull rush attempt.

Material Components: Three glass beads.
**/
///////////////////////////////////////////////////////
// Author: Tenjac
// Date:   27.9.06
///////////////////////////////////////////////////////

int BigbyStrikeDoMeleeTouchAttack(object oTarget, int nAttackBonus, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF);

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLevel = PRCGetCasterLevel(oPC);
	
	int nSorcLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
	int nDuskLevel = GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC);
	int nClassType;
	
	if((nSorcLevel + nDuskLevel) < 1)
	{
		return;
	}
	
	if(nSorcLevel > nDuskLevel)
	{
		nClassType = CLASS_TYPE_SORCERER;
	}
	
	else
	{
		nClassType = CLASS_TYPE_DUSKBLADE;
	}	
	
	int nAbility = GetAbilityForClass(nClassType, oPC);
	int nAttackBonus = (2 + nCasterLvl +  GetAbilityModifier(nAbility, oPC));
	
	int iAttackRoll = BigbyStrikeDoMeleeTouchAttack(oTarget, nAttackBonus);
	
	if (iAttackRoll > 0)
	{	
		int nDam = d6(min(5, (nCasterLevel/2)));
		
		if(nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDam = 6 * (min(5, (nCasterLevel/2)));
		}
		
		if(nMetaMagic == METAMAGIC_EMPOWER)
		{
			nDam += (nDam/2);
		}
		
		//save
		if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, SPGetSpellSaveDC(oTarget, oPC), SAVING_THROW_TYPE_SPELL))
		{
			//Bull Rush
			
		}
		
		else
		{
			nDam = (nDam / 2);
		}
		
	
}

int BigbyStrikeDoMeleeTouchAttack(object oTarget, int nAttackBonus, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF)
{
    if(GetLocalInt(oCaster, "AttackHasHit"))
        return GetLocalInt(oCaster, "AttackHasHit");
    string sCacheName = "AttackHasHit_"+ObjectToString(oTarget);
    if(GetLocalInt(oCaster, sCacheName))
        return GetLocalInt(oCaster, sCacheName);
    int nResult = GetAttackRoll(oTarget, oCaster, OBJECT_INVALID, 0, nAttackBonus,0,nDisplayFeedback, 0.0, TOUCH_ATTACK_MELEE_SPELL);
    SetLocalInt(oCaster, sCacheName, nResult);
    DelayCommand(1.0, DeleteLocalInt(oCaster, sCacheName));
    return nResult;
}
		
int DoBullRushAttack(object oTarget, int nAttackBonus)
{
	
	
}

int EvalSizeBonus(object oSubject)
{
	int nSize = PRCGetCreatureSize(oSubject);
	int nBonus;
	
	//Eval size
		
	if(nSize == CREATURE_SIZE_LARGE)
	{
		nBonus = 4;
	}
	else if(nSize == CREATURE_SIZE_HUGE)
	{
		nBonus = 8;
	}
	else if(nSize == CREATURE_SIZE_GARGANTUAN)
	{
		nBonus = 12;
	}
	else if(nSize == CREATURE_SIZE_COLOSSAL)
	{
		nBonus = 16;
	}
	else if(nSize == CREATURE_SIZE_SMALL)
	{
		nBonus = -4;
	}
	else if(nSize == CREATURE_SIZE_TINY)
	{
		nBonus = -8;
	}
	else if(nSize == CREATURE_SIZE_DIMINUTIVE)
	{
		nBonus = -12;
	}
	else if (nSize == CREATURE_SIZE_FINE)
	{
		nBonus = -16;
	}
	else
	{
		nBonus = 0;
	}
	
	return nBonus;
}
	
	
	