//::///////////////////////////////////////////////
//:: Name      Angry Ache
//:: FileName  sp_angry_ache.nss
//:://////////////////////////////////////////////
/**@file Angry Ache
Necromancy
Level: Asn 1, Clr 1, Pain 1
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: 1 minute/level
Saving Throw: Fortitude negates
Spell Resistance: Yes 

The caster temporarily strains the subject's muscles
in a very specific way. The subject feels a sharp 
pain whenever she makes an attack. All her attack 
rolls have a -2 circumstance penalty for every four 
caster levels (maximum penalty -10).

Author:    Tenjac
Created:   02/05/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"
#include "x2_inc_spellhook"

void main()
{
	PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//define vars
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nPenalty = 2;
	float fDuration = RoundsToSeconds(nCasterLvl * 10);
	
	PRCSignalSpellEvent(oTarget, TRUE, SPELL_ANGRY_ACHE, oPC);
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDuration += fDuration;
	}
	
	//Calculate DC
	int nDC = PRCGetSaveDC(oTarget, oPC);
	
	//Check Spell Resistance
	if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			
			if(nCasterLvl > 7)
			{
				nPenalty = 4;
			}
			
			if(nCasterLvl > 11)
			{
				nPenalty = 6;
			}
			
			if(nCasterLvl > 15)
			{
				nPenalty = 8;
			}
			
			if(nCasterLvl > 19)
			{
				nPenalty = 10;
			}
		}
		//Construct effect
		effect ePenalty = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
		
		//Apply Effect
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenalty, oTarget, fDuration, TRUE, SPELL_ANGRY_ACHE, nCasterLvl);
	}
	
	PRCSetSchool();		
}
	
	
		