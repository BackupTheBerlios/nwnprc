//::///////////////////////////////////////////////
//:: Name      Righteous Smite
//:: FileName  sp_right_smt.nss
//:://////////////////////////////////////////////
/**@file Righteous Smite 
Evocation [Good] 
Level: Clr 7, exalted arcanist 7, Wrath 7
Components: V, S
Casting Time: 1 standard action 
Range: Medium (100 ft. + 10 ft./level) 
Area: 20-ft. radius spread
Duration: Instantaneous
Saving Throw: Will partial; see text 
Spell Resistance: Yes

You draw down holy power to smite your enemies. Only
evil and neutral creatures are harmed by the spell;
good creatures are unaffected.

The spell deals 1d6 points of damage per caster 
level (maximum 20d6) to evil creatures (or 1d8 
points of damage per caster level, maximum 20d8, 
to evil outsiders) and blinds them for 1d4 rounds.
A successful Will saving throw reduces damage to 
half and negates the blinding effect.

The spell deals only half damage against creatures
that are neither good nor evil, and they are not
blinded. They can reduce that damage by half (down
to one quarter of the roll) with a successful Will
save.

Author:    Tenjac
Created:   6/22/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.10, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDam;
	int nAlign;
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nDC;
	float fDur = RoundsToSeconds(d4(1));
	
	while(GetIsObjectValid(oTarget))
	{
		if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
		{
			nAlign = GetAlignmentGoodEvil(oTarget);
			nDC = SPGetSpellSaveDC(oTarget, oPC);
			
			if((MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER) && (nAlign == ALIGNMENT_EVIL))
			{
				nDam = d8(min(nCasterLvl, 20));
				
				if(nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDam = 8 * (min(nCasterLvl, 20));
					fDur = 24.0f;
				}
			}
			
			else
			{
				nDam = d6(min(nCasterLvl, 20));
				
				if(nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDam = 6 * (min(nCasterLvl, 20));
					fDur = 24.0f;
				}
			}		
			
			if(nMetaMagic == METAMAGIC_EMPOWER)
			{
				nDam += (nDam/2);
			}
			
			//Save for 1/2
			if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				nDam = (nDam/2);
			}
			
			if(nAlign == ALIGNMENT_EVIL)
			{
				if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{			
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, fDur);
				}				
			}
			
			if(nAlign == ALIGNMENT_NEUTRAL)
			{
				// neutral takes 1/2 damage
				nDam = (nDam/2);
			}
			
			//Deal damage to non-good
			if(nAlign != ALIGNMENT_GOOD)
			{
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget);
			}	
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.10, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	SPGoodShift(oPC);
	SPSetSchool();
}
			
			