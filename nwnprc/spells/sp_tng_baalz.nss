//::///////////////////////////////////////////////
//:: Name      Tongue of Baalzebul
//:: FileName  sp_tng_baalz.nss
//:://////////////////////////////////////////////
/**@file Tongue of Baalzebul 
Transmutation [Evil] 
Level: Clr 1 
Components: V, S, M, Drug 
Casting Time: 1 full round
Range: Personal 
Target: Caster 
Duration: 1 hour/level

The caster gains the ability to lie, seduce and 
beguile with devil's skill. He gains a +2 competence
bonus on Bluff, Diplomacy, and Gather information 
checks.

Material Component: A tongue from any creature 
capable of speech.

Drug Component: Mushroom powder. 

Author:    Tenjac
Created:   5/8/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	//spellhook
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	//var
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nBonus = 2;
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDur = HoursToSeconds(nCasterLvl);
	
	//if(is using mushroom powder)
	if(GetHasSpellEffect(SPELL_MUSHROOM_POWDER, oPC))
	{
		//eval metamagic
		if (nMetaMagic == METAMAGIC_EMPOWER)
		{
			nBonus += (nBonus/2);
		}
		
		if (nMetaMagic == METAMAGIC_EXTEND)
		{
			fDur = fDur * 2;
		}
		
		effect eLink = EffectSkillIncrease(SKILL_BLUFF, nBonus);
		       eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_PERSUADE, nBonus));
		
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDur);
	}	
	
	SPEvilShift(oPC);
	
	SPSetSchool();
}