//::///////////////////////////////////////////////
//:: Name      Energize Potion
//:: FileName  sp_energz_ptn.nss
//:://////////////////////////////////////////////
/**@file Energize Potion
Transmutation
Level: Cleric 3, druid 3, sorc/wizard 2, Wrath 2
Components: V,S,M
Casting Time: 1 standard action
Range: Close
Effect: 10ft radius
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

This spell transforms a magic potion into a volatile
substance that can be hurled out to the specified 
range. The spell destroys the potion and realeases
a 10-foot-radius burst of energy at the point of
impact. The caster must specify the energy type
(acid, cold, electricity, fire, or sonic) when the
spell is cast.

The potion deals 1d6 points of damage (of the
appropriate energy type) per spell level of the 
potion (maximum 3d6). For example, a potion of 
displacement transformed by this spell deals 3d6
points of damage. An energized potion set to deal
fire damage ignites combustibles within the burst
radius.

Author:    Tenjac
Created:   7/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	object oPotion = GetSpellTargetObject();
	
	
	