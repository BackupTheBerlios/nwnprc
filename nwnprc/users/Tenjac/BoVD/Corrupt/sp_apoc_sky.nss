//::///////////////////////////////////////////////
//:: Name      Apocalypse from the Sky
//:: FileName  sp_apoc_sky.nss
//:://////////////////////////////////////////////
/**@file Apocalypse from the Sky
Conjuration (Creation) [Evil]
Level: Corrupt 9
Components: V, S, M, Corrupt
Casting Time: 1 day
Range: Personal
Area: 10-mile radius/level, centered on caster
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes 

The caster calls upon the darkest forces in all 
existence to rain de­struction down upon the land. 
All creatures and objects in the spell's area take
10d6 points of fire, acid, or sonic damage 
(caster's choice). This damage typically levels 
forests, sends moun­tains tumbling, and wipes out 
entire populations of living creatures. The caster 
is subject to the damage as well as the corruption 
cost.

Material Component: An artifact, usually one of good 
perverted to this corrupt use.

Corruption Cost: 3d6 points of Constitution damage 
and 4d6 points of Wisdom drain. Just preparing this 
spell deals 1d3 points of wisdom damage, with another
1d3 points of Wisdom damage for each day it remains 
among the caster's prepared spells.

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
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//define vars
	object oPC = OBJECT_SELF;
	
