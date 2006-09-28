//::///////////////////////////////////////////////
//:: Name      Bibgy's Tripping Hand
//:: FileName  sp_bigby_trip.nss
//:://////////////////////////////////////////////
/**@file Bigby's Tripping Hand
Evocation[Force]
Level: Duskblade 1, sorcerer/wizard 1
Components: V,S,M
Casting Time: 1 standard action
Range: Medium
Target: One creature
Duration: Intantaneous
Saving Throw: Reflex negates
Spell Resistance: Yes

The large hand sweeps at the target creature's legs in
a tripping maneuver.  This trip attempt does not provoke
attacks of opportunity.  Its attack bonus equals your
caster level + your key ability modifier + 2 for the 
hand's Strength score (14).  The hand has a bonus of +1
on the trip attempt for every three caster levels, to a
maximum of +5 at 15th level.

Material component: Three glass beads
**/

int BigbyTripDoMeleeTouchAttack(object oTarget, int nAttackBonus, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF);
int EvalSizeBonus(object oSubject);

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);	
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
	
	/*If your attack succeeds, make a Strength check opposed by the
	defender’s Dexterity or Strength check (whichever ability score
	has the higher modifier). A combatant gets a +4 bonus for every
	size category he is larger than Medium or a -4 penalty for every
	size category he is smaller than Medium. The defender gets a +4
	bonus on his check if he has more than two legs or is otherwise 
	more stable than a normal humanoid. If you win, you trip the 
	defender.
	*/
	int nAbility = GetAbilityForClass(nClassType, oPC);
	
	int nAttackBonus = (2 + nCasterLvl +  GetAbilityModifier(nAbility, oPC));
	int nTripBonus = min(5,(nCasterLvl/3));
	
	int iAttackRoll = BigbyTripDoMeleeTouchAttack(oTarget, nAttackBonus);
	if (iAttackRoll > 0)
	{
		//SR
		if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//save
			if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, SPGetSpellSaveDC(oTarget, oPC), SAVING_THROW_TYPE_SPELL))
			{
				
				int nOpposing = (max(GetAbilityModifier(ABILITY_STRENGTH, oTarget), GetAbilityModifier(ABILITY_DEXTERITY, oTarget))) + EvalSizeBonus(oTarget);
				int nCheck    = GetAbilityModifier(ABILITY_STRENGTH, oPC) + EvalSizeBonus(oPC);
				
				if(nCheck > nOpposing)
				{
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 6.0f);
				}
			}
		}
	}
	SPSetSchool();
}

	
int BigbyTripDoMeleeTouchAttack(object oTarget, int nAttackBonus, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF)
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
	