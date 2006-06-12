//::///////////////////////////////////////////////
//:: Name      Dragon Cloud
//:: FileName  sp_drgn_cloud.nss
//:://////////////////////////////////////////////
/**@file Dragon Cloud
Conjuration (Calling) [Air] 
Level: Sanctified 8 
Components: V, S, Sacrifice 
Casting Time: 1 round 
Range: Special (see text) 
Effect: One conjured dragon cloud (see text)
Duration: 1 min. + 1 minute/level 
Saving Throw: None
Spell Resistance: No

You must cast this spell outdoors, in a place where
clouds are visible. It calls forth a spirit of 
elemental air, binds it to a nearby cloud (either a
normal cloud or storm cloud), and gives it a 
dragon-like form. Upon forming, the dragon-shaped
cloud swoops toward you, arriving in 1 minute 
regardless of the actual distance from you. 
(The time it takes to reach you counts toward the 
spell's duration.) Once it arrives, you can command
the dragon cloud like a summoned creature. The dragon
cloud speaks Auran.

At the end of the spell's duration, the dragon cloud 
evaporates into nothingness as the bound elemental 
spirit returns to its home plane. The dragon cloud 
cannot pass through liquids or solid objects.

Sacrifice: 1d3 points of Constitution damage.

Author:    Tenjac
Created:   6/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	object oPC = OBJECT_SELF;
	int nCasterLevel = PRCGetCasterLevel(oPC);
	object oArea = GetArea(oPC);
	location lLoc = GetSpellTargetLocation();
	int nAbove = GetIsAreaAboveGround(oArea);
			
	if(nAbove == AREA_ABOVEGROUND)
	{
		Delaycommand(60.0f, SummonDragonCloud(lLoc);
			
		effect eVis = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);
		
	}
	
	DoCorruptionCost(oPC, ABILITY_CONSTITUTION, d3(), 0);
	SPSetSchool();
}

void SummonDragonCloud(location lLoc)
{
	float fDur = 60.0f + (nCasterLevel * 60.0f);
	
	//Get original max henchmen
	int nMax = GetMaxHenchmen();
	
	//Set new max henchmen high
	SetMaxHenchmen(150);
	
	object oDragon = CreateObject(OBJECT_TYPE_CREATURE, "prc_drag_cld", lLoc, TRUE);
	DestroyObject(oDragon, fDur);
	
	//Make henchman
	AddHenchman(oPC, oDragon);
	
	//Restore original max henchmen
	SetMaxHenchmen(nMax);
}
	
	
