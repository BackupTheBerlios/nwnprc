//::///////////////////////////////////////////////
//:: Name      Evil Weather
//:: FileName  sp_evil_wthr.nss
//:://////////////////////////////////////////////
/**@file Evil Weather
Conjuration (Creation) [Evil] 
Level: Corrupt 8
Components: V, S, M, XP, Corrupt (see below)
Casting Time: 1 hour Range: Personal
Area: 1-mile/level radius, centered on caster
Duration: 3d6 minutes 
Saving Throw: None 
Spell Resistance: No
 
The caster conjures a type of evil weather. It 
functions as described in Chapter 2 of this book, 
except that area and duration are as given for this
spell. To conjure violet rain, the caster must 
sacrifice 10,000 gp worth of amethysts and spend 
200 XP. Other forms of evil weather have no material
component or experience point cost.

Corruption Cost: 3d6 points of Constitution damage.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"

void main()
{
	SPSetSchool(SPELL_SHOOL_TRANSMUTATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nSpell = GetSpellID();
	
	//Rain of Blood
	if (nSpell == SPELL_RAIN_OF_BLOOD)
	
	//Violet Rain
	if (nSpell == SPELL_VIOLET_RAIN)
	
	//Green Fog
	if (nSpell == SPELL_GREEN_FOG)
	
	//Rain of Frogs or Fish
	if (nSpell == SPELL_RAIN_OF_FISH)
	
	//Corruption cost
	int nCost = d6(3);
	
	DoCorruptionCost(oPC, oTarget, ABILITY_CONSTITUTION, nCost 0);
	
	SPSetSchool();
}