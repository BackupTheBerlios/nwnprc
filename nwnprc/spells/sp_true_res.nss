//::///////////////////////////////////////////////
//:: Name      True Resurrection
//:: FileName  sp_true_res.nss
//:://////////////////////////////////////////////9
/** @file True Resurrection
Conjuration (Healing)
Level: 	Clr 9, Hlr 9
Casting Time: 	10 minutes

This spell functions like raise dead, except that 
you can resurrect a creature that has been dead for
as long as 10 years per caster level. This spell can
even bring back creatures whose bodies have been 
destroyed, provided that you unambiguously identify 
the deceased in some fashion (reciting the deceased�s 
time and place of birth or death is the most common 
method).

Upon completion of the spell, the creature is 
immediately restored to full hit points, vigor, and 
health, with no loss of level (or Constitution points)
or prepared spells.

You can revive someone killed by a death effect or 
someone who has been turned into an undead creature and
then destroyed. This spell can also resurrect elementals
or outsiders, but it can�t resurrect constructs or undead
creatures.

Even true resurrection can�t restore to life a creature 
who has died of old age.

Material Component: A sprinkle of holy water and diamonds
worth a total of at least 25,000 gp. 

Author:    Stratovarius
Created:   12/10/06
**/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "inc_dynconv"

void main()
{
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//Define vars
	object oPC = OBJECT_SELF;

	StartDynamicConversation("sp_cnv_trures", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

	SPSetSchool();
}
				
				