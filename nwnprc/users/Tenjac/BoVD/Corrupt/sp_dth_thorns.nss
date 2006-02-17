//::///////////////////////////////////////////////
//:: Name      Death by Thorns
//:: FileName  sp_dth_thorns.nss
//:://////////////////////////////////////////////
/**@file Death by Thorns
Conjuration (Creation) [Evil, Death] 
Level: Corrupt 7
Components: V, S, Corrupt 
Casting Time: 1 action 
Range: Touch
Targets: Up to three creatures, no two of which can
be more than 15 ft. apart
Duration: Instantaneous 
Saving Throw: Fortitude partial 
Spell Resistance: Yes
 
The caster causes thorns to sprout from the insides 
of the subject creatures, which writhe in agony for
1d4 rounds, incapacitated, before dying. A wish or
miracle spell cast on a subject during this time can
eliminate the thorns and save that creature. 
Creatures that succeed at their Fortitude saving 
throws are still incapacitated for 1d4 rounds in 
horrible agony, taking 1d6 points of damage per round.
At the end of the agony, however, the thorns disappear.

Corruption Cost: 1d3 points of Wisdom drain.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"

void main()
{
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nTargetCount;
	location lTarget = GetLocation(oTarget);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nDelay;
	float fDuration;
	effect ePar = EffectCutsceneImmobilize();
	effect eDeath = EffectDeath();
	
	SPRaiseSpellCastAt(oTarget, TRUE, SPELL_DEATH_BY_THORNS, oPC);
			
	//Check Spell Resistance
	if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//loop the thorn giving              max 3 targets
		while(GetIsObjectValid(oTarget) && nTargetCount < 3)
		{
			nDelay = d4(1);
			fDuration = RoundsToSeconds(nDelay);
			
			//Immobilize target
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, fDuration);
			
			//Loop torture animation
			ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, fDuration);
						
			//Give thorns if spell if failed save
			if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))    
			{
				DelayCommand(fDuration, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);				
			}
			
			else
			{
				int nCount = nDelay;
				DamageLoop(oTarget, nCount);
			}			
			
			//Increment targets
			nTargetCount++;				
			
			//Get next creature within 15 ft
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 7.5f, lTarget, FALSE, OBJECT_TYPE_CREATURE);
		}
	}
	
	//Corruption cost
	
	int nCost = d3(1);
	
	DoCorruptionCost(oPC, ABILITY_WISDOM, nCost, 1);
	
	//Alignment Shift
	SPShiftEvil(oPC);
	
	SPSetSchool();
}	

void DamageLoop(object oTarget, int nCount)
{
	effect eDam = EffectDamage(d6(1), DAMAGE_TYPE_MAGICAL);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	nCount--;
	
	if(nCount > 0)
	{
		DelayCommand(6.0f, DamageLoop(oTarget, nCount);
	}
}
	
	
	
	




