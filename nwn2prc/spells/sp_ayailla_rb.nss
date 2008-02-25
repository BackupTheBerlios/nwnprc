//::///////////////////////////////////////////////
//:: Name      Ayailla's Radiant Burst
//:: FileName  sp_ayaiila_rb.nss
//:://////////////////////////////////////////////
/**@file Ayailla's Radiant Burst 
Evocation [Good] 
Level: Sanctified 2 
Components: V, S, Sacrifice 
Casting Time: 1 standard action 
Range: 60 ft.
Area: Cone-shaped burst 
Duration: Instantaneous 
Saving Throw: Fortitude negates (blindness) and 
Reflex half (shards) 
Spell Resistance: Yes

Shards of heavenly light spray from your fingertips,
blinding evil creatures in their path for 1 round. 
A successful Fortitude save negates the blindness. 
The luminous shards also sear the flesh of evil 
creatures, dealing 1d6 points of damage per two 
caster levels (maximum 5d6). A successful Reflex 
save halves the damage, which is of divine origin.

Sacrifice: 1d2 points of Strength damage.

Author:    Tenjac
Created:   6/1/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC;
	int nDam;
	int nMetaMagic = PRCGetMetaMagicFeat();
	location lLoc = GetSpellTargetLocation();	
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	float fDur = 6.0f;
	//effect eVis = EffectVisualEffect(?????); 
	
	//make sure it's not the PC
	if(oTarget == oPC)
	{
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	//Metamagic extend
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur = fDur * 2;
	}
	
	//VFX
	//SPApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);
	
	while(GetIsObjectValid(oTarget))
	{				
		if(!PRCMyResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			nDC = SPGetSpellSaveDC(oTarget, oPC);
			
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, fDur);
			}
			
			//evil take damage, separate saving throw			
			if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			{
				if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC))
				{
					nDam = d6(min(5, nCasterLvl/2));
					
					//maximize
					if(nMetaMagic == METAMAGIC_MAXIMIZE)
					{
						nDam = 6 * (min(5, nCasterLvl/2));
					}
					//empower
					if(nMetaMagic == METAMAGIC_EMPOWER)
					{
						nDam += (nDam/2);
					}
					//Apply damage														
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.28f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	//Bwahah... yes, it's secretly Corruption cost and not Sacrifice :P
	DoCorruptionCost(oPC, ABILITY_STRENGTH, d2(), 0);
	SPSetSchool();
}
	