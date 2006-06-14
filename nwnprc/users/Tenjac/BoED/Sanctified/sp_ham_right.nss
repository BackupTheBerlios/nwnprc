//::///////////////////////////////////////////////
//:: Name      Hammer of Righteousness
//:: FileName  sp_ham_right.nss
//:://////////////////////////////////////////////
/**@file Hammer of Righteousness 
Evocation [Force, Good] 
Level: Sanctified 3 
Components: V, S, Sacrifice 
Casting Time: 1 standard action 
Range: Medium (100 ft. + 10 ft./level) 
Effect: Magic warhammer of force 
Duration: Instantaneous
Saving Throw: Fortitude half 
Spell Resistance: Yes

A great warhammer of positive energy springs into
existence, launches toward a target that you can 
see within the range of the spell, and strikes
unerringly.

The hammer of righteousness deals 1d6 points of 
damage per caster level to the target, or 1d8 
points of damage per caster level if the target is
evil. The caster can decide to deal non-lethal 
damage instead of lethal damage with the hammer, 
or can split the damage evenly between the two 
types. How the damage is split must be decided 
before damage is rolled. The hammer is considered 
a force effect and has no miss chance when striking
an incorporeal target. A successful Fortitude save 
halves the damage.

Sacrifice: 1d3 points of Strength damage.

Author:    Tenjac
Created:   6/14/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLevel = PRCGetCasterLevel(oPC);
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	
	SPRaiseSpellCastAt(oTarget,TRUE, SPELL_HAMMER_OF_RIGHTEOUSNESS, oPC);
	
	if
	