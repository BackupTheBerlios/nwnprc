//::///////////////////////////////////////////////
//:: Name      Calm Emotions
//:: FileName  sp_calm_emotions.nss
//:://////////////////////////////////////////////2
/** @file Calm Emotions
Enchantment (Compulsion) [Mind-Affecting]
Level: 	Brd 2, Clr 2, Law 2
Components: 	V, S, DF
Casting Time: 	1 standard action
Range: 	Medium (100 ft. + 10 ft./level)
Area: 	Creatures in a 20-ft.-radius spread
Duration: 	Concentration, up to 1 round/level (D)
Saving Throw: 	Will negates
Spell Resistance: 	Yes

This spell calms agitated creatures. You have no 
control over the affected creatures, but calm emotions
can stop raging creatures from fighting or joyous ones
from reveling. Creatures so affected cannot take 
violent actions (although they can defend themselves) 
or do anything destructive. Any aggressive action 
against or damage dealt to a calmed creature immediately
breaks the spell on all calmed creatures.

This spell automatically suppresses (but does not dispel)
any morale bonuses granted by spells such as bless, good
hope, and rage, as well as negating a bardís ability to 
inspire courage or a barbarianís rage ability. It also 
suppresses any fear effects and removes the confused 
condition from all targets. While the spell lasts, a 
suppressed spell or effect has no effect. When the calm 
emotions spell ends, the original spell or effect takes 
hold of the creature again, provided that its duration 
has not expired in the meantime. 
**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   8.10.06
//////////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode*()) return;
	
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	
	