//::///////////////////////////////////////////////
//:: Name      Detect Scrying
//:: FileName  sp_detect_scry.nss
//:://////////////////////////////////////////////
/**@file Detect Scrying
Divination
Level: Brd 4, Sor/Wiz 4, Hexblade 4
Components: V, S, M
Casting Time: 1 standard action
Range: 40 ft.
Area: 40-ft.-radius emanation centered on you
Duration: 24 hours
Saving Throw: None
Spell Resistance: No

You immediately become aware of any attempt to 
observe you by means of a divination (scrying) spell
or effect. The spell’s area radiates from you and 
moves as you move. You know the location of every 
magical sensor within the spell’s area.

If the scrying attempt originates within the area, 
you also know its location; otherwise, you and the 
scrier immediately make opposed caster level checks 
(1d20 + caster level). If you at least match the 
scrier’s result, you get a visual image of the scrier
and an accurate sense of his or her direction and 
distance from you.

Material Component: A small piece of mirror and a 
                    miniature brass hearing trumpet.

**/

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_DIVINATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 12.19f, GetLocation(oPC), FALSE, OBJECT_TYPE_CREATURE);
	
	