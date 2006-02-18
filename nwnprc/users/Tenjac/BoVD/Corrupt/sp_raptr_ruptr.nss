//::///////////////////////////////////////////////
//:: Name      Rapture of Rupture
//:: FileName  sp_rapt_rupt.nss
//:://////////////////////////////////////////////
/** @file
Rapture of Rupture
Transmutation [Evil]
Level: Corrupt 7
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: One living creature touched per level
Duration: Instantaneous
Saving Throw: Fortitude half
Spell Resistance: Yes

With this spell, the caster's touch deals grievous 
wounds to multiple targets. After rapture of rupture
is cast, the caster can touch one target per round 
until she has touched a number of targets equal to 
her caster level. The same creature cannot be 
affected twice by the same rapture of rupture. A 
creature with no discernible anatomy is unaffected by
this spell.

When the caster touches a subject, his flesh bursts 
open suddenly in multiple places. Each subject takes 
6d6 points of damage and is stunned for 1 round; a 
successful Fortitude save reduces damage by half and
negates the stun effect. Subjects who fail their 
Fortitude save continue to take 1d6 points of damage
per round until they receive magical healing, succeed
at a Heal check (DC 20), or die. If a subject takes 6
points of damage from rapture of rupture in a single 
round, he is stunned in the following round.

Corruption Cost: 1 point of Strength damage per target 
touched.

*/
//  Author:   Tenjac
//  Created:  1/7/2006
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"

void main()
{
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();