//::///////////////////////////////////////////////
//:: Name      Unliving Weapon
//:: FileName  sp_unliv_weap.nss
//:://////////////////////////////////////////////
/**@file Unliving Weapon 
Necromancy [Evil] 
Level: Clr 3
Components: V, S, M 
Casting Time: 1 full round 
Range: Touch
Targets: One undead creature 
Duration: 1 hour/level 
Saving Throw: Will negates 
Spell Resistance: Yes

This spell causes an undead creature to explode in a
burst of powerful energy when struck for at least 1
point of damage, or at a set time no longer than the
duration of the spell, whichever comes first. The 
explosion is a 10-foot radius burst that deals 1d6 
points of damage for every two caster levels 
(maximum 10d6).

While this spell can be an effective form of attack 
against an undead creature, necromancers often use 
unliving weapon to create undead capable of suicide 
attacks (if such a term can be applied to something 
that is already dead). Skeletons or zombies with this
spell cast upon them can be very dangerous to foes 
that would normally disregard them.

Material Component: A drop of bile and a bit of sulfur.

Author:    Tenjac
Created:   5/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void HiImABomb(object oTarget, int nCounter, int nHP, int nCasterLvl);

#include "spinc_common"

void main()
{
	// Set the spellschool
	SPSetSchool(SPELL_SCHOOL_NECROMANCY); 
		
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = HoursToSeconds(nCasterLvl);
	int nCounter = (FloatToInt(fDur))/3;
			
	//Spell Resistance
	if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//Saving Throw
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{				
			if(PRCGetMetaMagicFeat() == METAMAGIC_EXTEND)
			{
				fDur += fDur;
			}
			
			int nHP = GetCurrentHitPoints(oTarget);
			
			HiImABomb(oTarget, nCounter, nHP, nCasterLvl);
		}
	}
	SPEvilShift(oPC);
	SPSetSchool();
}

void HiImABomb(object oTarget, int nCounter, int nHP, int nCasterLvl)
{
	if((nCounter < 1) || GetCurrentHitPoints(oTarget) < nHP)
	{
		effect eSplode = EffectDeath(TRUE, TRUE);
		       eSplode = SupernaturalEffect(eSplode);
		       
		effect eVis = EffectVisualEffect(VFX_FNF_BLINDDEAF);
		location lLoc = GetLocation(oTarget);
		int nMetaMagic = PRCGetMetaMagicFeat();
		
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		
		object oOuch = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		
		while(GetIsObjectValid(oOuch))
		{
			
			int nDam = d6(min((nCasterLvl/2), 10));
			
			if(nMetaMagic == METAMAGIC_MAXIMIZE)
			{
				nDam = 6 * min((nCasterLvl/2), 10);
			}
			
			if(nMetaMagic == METAMAGIC_EMPOWER)
			{
				nDam += (nDam/2);
			}
			
			//Apply damage
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oOuch);
			
			//Get next victim
			oOuch = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		}
	}
	nCounter--;
	
	nHP = GetCurrentHitPoints(oTarget);
	
	DelayCommand(3.0f, HiImABomb(oTarget, nCounter, nHP, nCasterLvl));
}
		
		       
	       
		
	