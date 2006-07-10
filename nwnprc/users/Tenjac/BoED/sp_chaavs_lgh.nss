//::///////////////////////////////////////////////
//:: Name      Chaav's Laugh
//:: FileName  sp_chaavs_lgh.nss
//:://////////////////////////////////////////////
/**@file Chaav's Laugh
Enchantment (Compulsion)[Good, Mind-Affecting]
Level: Cleric 5, Joy 5
Components: V
Casting Time: 1 standard action
Range: 40ft
Area: 40-ft-radius spread centered on you
Duration: 1 minute/level
Saving Throw: Will negates
Spell Resistance: Yes

You release a joyous, boistrous laugh that 
strengthens the resolve of good creatures and
weakens the resolve of evil creatures.

Good creatures within the soell's area gain the
following benefits for the duration of the spell:
a +2 morale bonus on attack rolls an saves against
fear effects. plus temporary hit points equal to
1d8 + caster level(to a maximum of 1d8 +20 at level
20).  

Evil creatures within the spell's are that fail a 
Will save take a -2 morale penalty on attack rolls
and saves against fear effects for the duration of
the spell.  

Creatures must beable to hear the laugh to be
affected by the spell. Creatures that are neither 
good nor evil are anaffected by Chaav's Laugh.

Author:    Tenjac
Created:   7/10/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetLocation(oPC);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE); 
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC;
	int nAlign;
	
	while(GetIsObjectValid(oTarget))
	{
		nAlign = GetAlignmentGoodEvil(oTarget);
	
	