//::///////////////////////////////////////////////
//:: Name      Scorching Ray
//:: FileName  sp_scorch_ray.nss
//:://////////////////////////////////////////////
/**@file Scorching Ray
Evocation [Fire]
Level: 	Sor/Wiz 2, Duskblade 2
Components: 	V, S
Casting Time: 	1 standard action
Range: 	Close (25 ft. + 5 ft./2 levels)
Effect: 	One or more rays
Duration: 	Instantaneous
Saving Throw: 	None
Spell Resistance: 	Yes

You blast your enemies with fiery rays. You may fire
one ray, plus one additional ray for every four levels
beyond 3rd (to a maximum of three rays at 11th level). 
Each ray requires a ranged touch attack to hit and deals 
4d6 points of fire damage.

The rays may be fired at the same or different targets, 
but all bolts must be aimed at targets within 30 feet of 
each other and fired simultaneously. 

**/
//::////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date  : 29.9.06
//::////////////////////////////////////////////////



/*
    <BEGIN NOTES TO SCRIPTER - MAY BE DELETED LATER>
    Modify as necessary
    Most code should be put in DoSpell()

    PRC_SPELL_EVENT_ATTACK is set when a
        touch or ranged attack is used
    <END NOTES TO SCRIPTER>
*/
#include "prc_alterations"
#include "spinc_common"

void main()
{
	if (!X2PreSpellCastCode()) return;
	SPSetSchool(GetSpellSchool(PRCGetSpellId()));
	
	object oCaster = OBJECT_SELF;
	int nCasterLevel = PRCGetCasterLevel(oCaster);
	object oTarget = PRCGetSpellTargetObject();
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
	int nPenetr = nCasterLevel + SPGetPenetr();
	int nRays = 3;
	int nDam;
	int iAttackRoll;
	
	SPRaiseSpellCastAt(oTarget, TRUE);
	
	if(nCasterLevel < 11)
	{
		nRays =2;
	}
	
	if(nCasterLevel < 7)
	{
		nRays = 1;
	}
	
	while(nRays > 0)
	{
		nRays--;
		iAttackRoll = PRCDoRangedTouchAttack(oTarget);
		
		//Beam
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_FIRE, oCaster, BODY_NODE_HAND, !iAttackRoll), oTarget, 1.0f); 
		
		if (iAttackRoll > 0)
		{
			if(!PRCMyResistSpell(oCaster, oTarget, nPenetr))
			{
				nDam = d6(4);
				
				if(nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDam = 24;
				}
				
				if(nMetaMagic == METAMAGIC_EMPOWER)
				{
					nDam += (nDam/2);
				}
				
				ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDam, DAMAGE_TYPE_FIRE);
			}
		}			
			
	}
	
	SPSetSchool();
}