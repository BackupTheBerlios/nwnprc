//::///////////////////////////////////////////////
//:: Name      Energy Aegis
//:: FileName  sp_enrgy_aegis.nss
//:://////////////////////////////////////////////
/**@file Energy Aegis
Abjuration
Level: Cleric 3, duskblade 3, sorcerer/wizard 3
Components: V, DF
Casting time: 1 immediate action
Range: Close
Target: One creature
Duration: 1 round
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

When you cast energy aegis, speify an energy type 
(acid, cold, electricity, fire, or sonic). Against
the next attack using this energy type that targets
the subject, it gains resistance 20.

**/

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nSpell = PRCGetSpellId();
	int nDamType;
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = RoundsToSeconds(1);
	
	SPRaiseSpellCastAt(oTarget,FALSE, SPELL_ENERGY_AEGIS, oPC);
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}	
	
	if(nSpell == SPELL_ENERGY_AEGIS_ACID)
	{
		nDamType = DAMAGE_TYPE_ACID;
	}
	
	else if(nSpell == SPELL_ENERGY_AEGIS_COLD)
	{
		nDamType = DAMAGE_TYPE_COLD;
	}
	
	else if(nSpell == SPELL_ENERGY_AEGIS_ELEC)
	{
		nDamType = DAMAGE_TYPE_ELECTRICAL;
	}
	
	else if(nSpell == SPELL_ENERGY_AEGIS_FIRE)
	{
		nDamType = DAMAGE_TYPE_FIRE;
	}
	
	else if(nSpell == SPELL_ENERGY_AEGIS_SONIC)
	{
		nDamType = DAMAGE_TYPE_SONIC;
	}
	
	else
	{
		SPSetSchool();
		return;
	}
	
	effect eBuff = EffectDamageResistance(nDamType, 20, 0);
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDur);
	
	SPSetSchool();
}
	
	
	
	
	
	