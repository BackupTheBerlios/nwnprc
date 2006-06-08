//::///////////////////////////////////////////////
//:: Name      Brilliant Emanation
//:: FileName  sp_brill_eman.nss
//:://////////////////////////////////////////////
/**@file Brilliant Emanation
Evocation [Good] 
Level: Sanctified 3 
Components: Sacrifice 
Casting Time: 1 standard action 
Range: 100 ft. + 10 ft./level
Area: 100-ft.-radius emanation + 10-ft. radius per level
Duration: 1d4 rounds
Saving Throw: Fortitude partial 
Spell Resistance: Yes

This spell causes a divine glow to radiate from 
any reflective objects worn or carried by the 
caster, including metal armor. Evil creatures 
within the spell's area are blinded unless they 
succeed on a Fortitude saving throw. Non-evil 
characters perceive the brilliant light emanating 
from the caster, but are not blinded by it and do 
not suffer any negative effects from it. Evil 
characters that make their saving throw are not 
blinded, but are distracted, taking a -1 penalty 
on any attacks made within the spell's area for 
the duration of the spell. Creatures must be able 
to see visible light to be affected by this spell.

Sacrifice: 1d3 points of Strength damage. 

Author:    Tenjac
Created:   6/8/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	//spellhook
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	location lLoc = GetLocation(oPC);
	float fDur = RoundsToSeconds(d4());
		
	//VFX on caster
	effect eVis = EffectVisualEffect(VFX_DUR_ );
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, fDur);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 30.48f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	
}