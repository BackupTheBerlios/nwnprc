//::///////////////////////////////////////////////
//:: Name      Exalted Fury
//:: FileName  sp_exalt_fury.nss
//:://////////////////////////////////////////////
/**@file Exalted Fury 
Evocation [Good] 
Level: Sanctified 9 
Components: V, Sacrifice 
Casting Time: 1 standard action 
Range: 40 ft.
Area: 40-ft. radius burst, centered on you 
Duration: Instantaneous
Saving Throw: None 
Spell Resistance: Yes

Uttering a single, awesomely powerful syllable of 
the Words of Creation, your body erupts in the same 
holy power that shaped the universe at its birth. 
All evil creatures within the area take damage equal
to your current hit points +50.

Sacrifice: You die. You can be raised or resurrected
normally.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC;
	int nMetaMagic = PRCGetMetaMagicFeat();
	location lLoc = GetSpellTargetLocation();	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	effect eVis = EffectVisualEffect(?????); 