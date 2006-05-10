//::///////////////////////////////////////////////
//:: Name      Spores of the Vrock
//:: FileName  sp_spore_vrock.nss
//:://////////////////////////////////////////////
/**@file Spores of the Vrock 
Conjuration (Creation) [Evil]
Level: Clr 2, Demonologist 1 
Components: V S, M/DF 
Casting Time: 1 full round 
Area: 5-ft. radius, centered on caster
Duration: Instantaneous 
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster summons a mass of spores that fill the 
area around him.

The spores deal 1d8 points of damage to all 
creatures within 5 feet other than the caster. Then
they penetrate the skin and grow, dealing an 
additional 1d2 points of damage each round for 10 
rounds. At the end of this time, a tangle of viny 
growths covers each subject. A delay poison spell 
stops the spores' growth for its duration. Bless, 
neutralize poison, or remove disease kills the 
spores, as does sprinkling the victim with a vial
of holy water.

Arcane Material Component: The feathers of an 
avian creature with an intelligence score of at 
least 3 (a harpy, achaierai, or similar creature). 

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = 