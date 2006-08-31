//::///////////////////////////////////////////////
//:: Name      Rain of Black Tulips
//:: FileName  sp_rain_btul.nss
//:://////////////////////////////////////////////
/**@file Rain of Black Tulips 
Evocation [Good] 
Level: Drd 9 
Components: V, S, M 
Casting Time: 1 standard action 
Range: Long (400 ft. + 40 ft./level) 
Area: Cylinder (80-ft. radius, 80 ft. high)
Duration: 1 round/level (D) 
Saving Throw: None (damage), Fortitude negates (nausea) 
Spell Resistance: Yes

Tulips as black as midnight fall from the sky. The 
tulips explode with divine energy upon striking evil
creatures, each of which takes 5d6 points of damage. 
In addition, evil creatures that fail a Fortitude 
save are nauseated (unable to attack, cast spells, 
concentrate on spells, perform any task requiring 
concentration, or take anything other than a single
move action per turn) until they leave the spell's 
area. A successful Fortitude save renders a creature
immune to the nauseating effect of the tulips, but 
not the damage.

Material Component: A black tulip. 

Author:    Tenjac
Created:   7/14/06
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
	effect eAOE = EffectAreaOfEffect(VFX_AOE_RAIN_OF_BLACK_TULIPS);
	location lLoc = GetSpellTargetLocation(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nDam;
	int nAlign;
	float fDur = RoundsToSeconds(nCasterLvl);
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	//Create AoE
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDur);
	
	//Loop through and damage creatures
	while(GetIsObjectValid(oTarget))
	{
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			//SR
			if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
			{
				nDam = d6(5);
				
				if(nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDam = 30;
				}
				
				if(nMetaMagic == METAMAGIC_EMPOWER)
				{
					nDam += (nDam/2);
				}
				
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	SPGoodShift(oPC);
	SPSetSchool();
}
				
		


