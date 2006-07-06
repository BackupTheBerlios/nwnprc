//::///////////////////////////////////////////////
//:: Name      Last Judgment
//:: FileName  sp_lst_jdgmnt.nss
//:://////////////////////////////////////////////
/**@file Last Judgment
Necromancy [Death, Good] 
Level: Clr 8, Sor/Wiz 8, Wrath 8
Components: V, Celestial 
Casting Time: 1 round 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One evil humanoid, monstrous humanoid, or
giant/2 levels 
Duration: Instantaneous
Saving Throw: Will partial 
Spell Resistance: Yes

Reciting a list of the targets' evil deeds, you call
down the judgment of the heavens upon their heads. 
Creatures that fail their saving throw are struck 
dead and bodily transported to the appropriate Lower
Plane to suffer their eternal punishment. Creatures 
that succeed nevertheless take 3d6 points of 
temporary Wisdom damage as guilt for their misdeeds
overwhelms their minds.

This spell affects only humanoids, monstrous 
humanoids, and giants of evil alignment.

A true resurrection or miracle spell can restore life 
to a creature slain by this spell normally. A 
resurrection spell works only if the creature's body 
can be recovered from the Lower Planes before the 
resurrection is cast.

Author:    Tenjac
Created:   7/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	
	
	