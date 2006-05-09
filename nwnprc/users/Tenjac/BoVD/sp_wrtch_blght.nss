//::///////////////////////////////////////////////
//:: Name      Wretched Blight
//:: FileName  sp_wrtch_blght.nss
//:://////////////////////////////////////////////
/**@file Wretched Blight 
Evocation [Evil]
Level: Clr 7
Components: V, S 
Casting Time: 1 action 
Range: Medium (100 ft. + 10 ft./level)
Area: 20-ft.-radius spread
Duration: Instantaneous
Saving Throw: Fortitude partial (see text)
Spell Resistance: Yes 

The caster calls up unholy power to smite his enemies.
The power takes the form of a soul chilling mass of 
clawing darkness. Only good and neutral (not evil)
creatures are harmed by the spell.

The spell deals 1d8 pts of damage per caster level 
(maximum 15d8) to good creatures and renders them 
stunned for 1d4 rounds. A successful Fortitude save
reduces damage to half and negates the stunning effect.

The spell deals only half damage to creatures that
are neither evil nor good, and they are not stunned.
Such creatures can reduce the damage in half again 
(down to one­quarter of the roll) with a successful
Reflex save.

Author:    Tenjac
Created:   5/9/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nDam;
	int nMetaMagic = PRCGetMetaMagicFeat();
	location lLoc = GetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_DUR_DARKNESS);
	effect eDam; 
	int nAlign;
	
	//spellhook
	if(!X2PreSpellCastCode()) return;
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	
	//VFX
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lLoc, 3.0f);
	
	while(GetIsObjectValid(oTarget))
	{
		nDam = d8(min(nCasterLvl, 15));
		nAlign = GetAlignmentGoodEvil(oTarget);
		
		//Metmagic: Maximize
		if (nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDam = 8 * min(nCasterLvl, 15);
		}
		
		//Metmagic: Empower
		if (nMetaMagic == METAMAGIC_EMPOWER)
		{
			nDam += (nDam/2);
		}
		
		//SR
		if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			if(nAlign == ALIGNMENT_GOOD)
			{
				//Save for 1/2 dam
				if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					nDam = nDam/2;
				}
				else
				{
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(d4(1)));
				}
				
			}
			else if(nAlign == ALIGNMENT_NEUTRAL)
			{
				//Start at 1/2 dam
				nDam = nDam/2;
				
				//Save for furter 1/2
				if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					nDam = nDam/2;
				}
			}
			
			else
			{
				//Yay, you're evil, have a VFX.
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, 1.0f);
			}
									
			//Apply Damage
			eDam = EffectDamage(DAMAGE_TYPE_MAGICAL, nDam);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	SPEvilShift(oPC);
	SPSetSchool();
}
			
			
			
				
	
			
		
		
	