//::///////////////////////////////////////////////
//:: Name      Dolorous Motes
//:: FileName  sp_dolorous_mts.nss
//:://////////////////////////////////////////////
/**@file Dolorous Motes
Enchantment (Compulsion) [Mind-Affecting]
Level: Bard 4, sorcerer/wizard 3
Components:  V,S, Sacrifice
Casting Time: 1 standard action
Range: Long
Effect: 1 10-ft cube/level
Duration: 1 round/level
Saving Throw: Will negates; see text
Spell Resistance: Yes
 
This spell creates flickering motes of light that 
cause intense mental anguish.  Creatures inside or
passing through a cloud of dolorous motes must succeed
on a Will save or be daved for 1 round.  A new save
may be made each round.  Leaving and re-entering a 
cloud of motes forces a new save.

Sacrifice: 1d3 points of Wisdom damage

Author:    Tenjac
Created:   6/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	