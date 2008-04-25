//::///////////////////////////////////////////////
//:: Name      False Life
//:: FileName  sp_false_life.nss
//:://////////////////////////////////////////////
/**@file False Life
Necromancy
Level: Sor/Wiz 2, Hexblade 2
Components: V, S, M
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour/level or until discharged; see text

You harness the power of unlife to grant yourself a 
limited ability to avoid death. While this spell is i
n effect, you gain temporary hit points equal to 
1d10 +1 per caster level (maximum +10).

Material Component: A small amount of alcohol or 
distilled spirits, which you use to trace certain 
sigils on your body during casting. These sigils 
cannot be seen once the alcohol or spirits evaporate.

**/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
			
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = HoursToSeconds(nCasterLvl);
	
	PRCSignalSpellEvent(oPC,FALSE, SPELL_FALSE_LIFE, oPC);
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	int nBonus = d10(1) + (min(10, nCasterLvl));
	
	if(nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nBonus = 10 + (min(10, nCasterLvl));
	}
	
	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nBonus += (nBonus/2);
	}
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nBonus), oPC, fDur);
	
	PRCSetSchool();
}

	
	
	