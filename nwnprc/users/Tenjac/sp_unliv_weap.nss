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

void Asplode(object oTarget);
void BombTimer(object oTarget, int nCounter);
void Fragile(object oTarget, nHP);

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
	int nCounter = (FloatToInt(fDur))/6;
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nMin = min(nCasterLvl, 10);
	int nDam = d6(nMin);
	int nType = MyPRCGetRacialType(oTarget);
	int nHP = GetCurrentHitPoints(oTarget);
	
	if(nType == RACIAL_TYPE_UNDEAD)
	{		
		//Spell Resistance
		if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Saving Throw
			if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
			{               
				if(nMetaMagic == METAMAGIC_EXTEND)
				{
					fDur += fDur;
				}
				
				if(nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDam = 6 * nMin;
				}
				
				if(nMetaMagic == METAMAGIC_EMPOWER)
				{
					nDam += (nDam/2);
				}
												
				//Duration VFX
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR), oTarget, fDuration);
				
				BombTimer(oTarget, nCounter);
				Fragile(oTarget, nHP);
			}
		}
	}
	SPEvilShift(oPC);
	SPSetSchool();
}
	

void BombTimer(object oTarget, int nCounter)
{
	if(nCounter < 1)
	{
		Asplode(oTarget);
		return;
	}
	
	nCounter--;
	
	DelayCommand(6.0f, BombTimer(oTarget, nCounter));
}

void Asplode(object oTarget)
{
	location lLoc = GetLocation(oTarget);
	effect eSplode = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSplode, oTarget);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);
	
	object oOuch = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	
	while(GetIsObjectValid(oOuch))
	{
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oOuch);
		oOuch = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}

void Fragile(object oTarget, int nHP)
{
	if(GetCurrentHitPoints(oTarget) < nHP)
	{
		Asplode(oTarget);
		return;
	}
	
	nHP = GetCurrentHitPoints(oTarget);
	DelayCommand(2.0f, Fragile(oTarget, nHP));	
}

	
	
           
        
    