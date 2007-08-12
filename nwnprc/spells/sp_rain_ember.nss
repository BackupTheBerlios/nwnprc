//::///////////////////////////////////////////////
//:: Name      Rain of Embers
//:: FileName  sp_rain_ember.nss
//:://////////////////////////////////////////////
/**@file Rain of Embers
Evocation [Fire, Good] 
Level: Sanctified 7 
Components: V, S, Sacrifice 
Casting Time: 1 standard action 
Range: Medium (100 ft. + 10 ft./level) 
Area: Cylinder (40-ft. radius, 120 ft. high)
Duration: 1 round/level (D) 
Saving Throw: Reflex half; see text 
Spell Resistance: Yes

This spell causes orange, star-like embers to rain 
steadily from above. Each round, the falling embers
deal 10d6 points of damage to evil creatures within
the spell's area. Half of the damage is fire damage,
but the other half results directly from divine 
power and is therefore not subject to being reduced
by resistance to fire-based attacks, such as that 
granted by protection from energy (fire), 
fire shield (chill shield), and similar magic. 
Creatures may leave the area to avoid taking 
additional damage, but a new saving throw is required
each round a creature is caught in the Fiery downpour.

A shield provides a cover bonus on the Reflex save,
depending on its size small +2, large +4, tower +7.
A shield spell oriented upward provides a +4 cover 
bonus on the Reflex save. A creature using its 
shield (or shield spell) to block the rain of embers
cannot use it for defense in combat.

Sacrifice: 1d2 points of Strength drain.

Author:    Tenjac
Created:   6/21/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void EmberLoop(int nCounter, int nCasterLvl, int nMetaMagic, object oPC, location lLoc);

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetSpellTargetLocation();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = RoundsToSeconds(nCasterLvl);
	int nCounter = FloatToInt(fDur/6);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	//VFX
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_FIRESTORM), lLoc, fDur);
	
	EmberLoop(nCounter, nCasterLvl, nMetaMagic, oPC, lLoc);
	
	DoCorruptionCost(oPC, ABILITY_STRENGTH, d2(), 1);
	
	//Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
	AdjustAlignment(oPC, ALIGNMENT_GOOD, 10);
	
	SPSetSchool();
	SPGoodShift(oPC);
}
	
void EmberLoop(int nCounter, int nCasterLvl, int nMetaMagic, object oPC, location lLoc)
{
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nDam;
	int nDam2;
		
	while(GetIsObjectValid(oTarget))
	{
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			//Spell Resist
			if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
			{
				int nDC = SPGetSpellSaveDC(oTarget, oPC);
				//Save
				
				nDam = d6(10);
				
				if(nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDam = 60;
				}
				
				if(nMetaMagic == METAMAGIC_EMPOWER)
				{
					nDam += (nDam/2);
				}
				
				if (PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					nDam = (nDam/2);
				}
				
				nDam2 = (nDam/2);
				nDam = (nDam - nDam2);
				
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_FIRE), oTarget);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam2, DAMAGE_TYPE_DIVINE), oTarget);
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}	
	nCounter--;
	
	if(nCounter > 0)
	{
		DelayCommand(6.0f, EmberLoop(nCounter, nCasterLvl, nMetaMagic, oPC, lLoc));
	}
}
		
		
		
		
		
	
	