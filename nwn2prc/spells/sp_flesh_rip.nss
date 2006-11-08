//::///////////////////////////////////////////////
//:: Name      Flesh Ripper
//:: FileName  sp_flesh_rip
//:://////////////////////////////////////////////
/**@file Flesh Ripper 
Evocation [Evil] 
Level: Clr 3, Mortal Hunter 3 
Components: V, S, Undead, Fiend 
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One living creature 
Duration: Instantaneous
Saving Throw: None 
Spell Resistance: Yes 
                
The caster evokes pure evil power in the form of a
black claw that flies at the target. If a ranged 
touch attack roll succeeds, the claw deals 1d8 
points of damage per caster level (maximum 10d8). 
On a critical hit, in addition to dealing double 
damage, the wound bleeds for 1 point of damage per
round until it is magically healed. 

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	//Spellhook
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nType = MyPRCGetRacialType(oPC);
	
	SPRaiseSpellCastAt(oTarget,TRUE, SPELL_FLESH_RIPPER, oPC);
	
	//Caster must be undead.  If not, hit 'em with alignment change anyway.
	//Try reading the description of the spell moron. =P
	
	if(nType == RACIAL_TYPE_UNDEAD)
	{
		//Check spell resistance
		if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			int nDam = d8(nCasterLvl);
			
			if(nMetaMagic == METAMAGIC_MAXIMIZE)
			{
				nDam = (8 * nCasterLvl);
			}
			
			if(nMetaMagic == METAMAGIC_EMPOWER)
			{
				nDam += (nDam/2);
			}
			
			//Non-descript
			effect eDam = EffectDamage(DAMAGE_TYPE_MAGICAL, nDam);
			
			//VFX
			effect eVis = EffectBeam(VFX_BEAM_BLACK, oPC, BODY_NODE_HAND);
			
			//Make touch attack
			int nTouch = PRCDoRangedTouchAttack(oTarget);
			
			if(nTouch > 0)
			{
				//Apply VFX
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				
				//Apply damage
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
			
			if(nTouch = 2)
			{
				//Wounding
				effect eWound = EffectHitPointChangeWhenDying(1.0f);
				
				SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eWound, oTarget);				
			}
		}
	}
	SPEvilShift(oPC);
	
	SPSetSchool();
}
				
			
	
	
	
	