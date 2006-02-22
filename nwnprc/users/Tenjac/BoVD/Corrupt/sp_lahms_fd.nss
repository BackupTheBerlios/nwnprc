//::///////////////////////////////////////////////
//:: Name:     Lahm's Finger Darts
//:: Filename: sp_lahms_fd.nss
//::///////////////////////////////////////////////
/**Lahm's Finger Darts
Transmutation [Evil] 
Level: Corrupt 2 
Components: V S, Corrupt 
Casting Time: 1 action 
Range: Medium (100 ft. + 10 ft./level)
Targets: Up to five creatures, no two of which can 
be more than 15 ft. apart
Duration: Instantaneous 
Saving Throw: None 
Spell Resistance: Yes

The caster's finger becomes a dangerous projectile
that flies from her hand and unerringly strikes its
target. The dart deals 1d4 points of Dexterity
damage. Creatures without fingers cannot cast this
spell.

The dart strikes unerringly, even if the target is
in melee or has partial cover or concealment. 
Inanimate objects (locks, doors, and so forth) 
cannot be damaged by the spell.

For every three caster levels beyond 1st, the caster
gains an additional dart by losing an additional 
finger: two at 4th level, three at 7th level, four 
at 10th level, and the maximum of five darts at 13th
level or higher. If the caster shoots multiple darts,
she can have them strike a single creature or several
creatures. A single dart can strike only one creature.
The caster must designate targets before checking for
spell resistance or damage.

Fingers lost to this spell grow back when the 
corruption cost is healed, at the rate of one finger
per point of Strength damage healed.

Corruption Cost: 1 point of Strength damage per dart,
plus the loss of one finger per dart. A hand with one
or no fingers is useless.

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"

void main()
{
	SPSetSchool(SPELL_SHOOL_TRANSMUTATION);
	
	