//::///////////////////////////////////////////////
//:: Name      Crushing Fist of Spite  
//:: FileName  sp_crush_fs.nss  
//:://////////////////////////////////////////////
/**@Crushing Fist of Spite
Evocation [Evil, Force] 
Level: Sor/Wiz 9 
Components: V, S, M, Disease 
Casting Time: 1 action 
Range: Medium (100 ft. + 10 ft./level)
Area: 5-ft.-radius cylinder, 30 ft. high 
Duration: 1 round/level
Saving Throw: Reflex half or Reflex negates (see text)
Spell Resistance: Yes

A fist of darkness appears 30 feet above the ground 
and begins smashing down with incredible power. 
All creatures and objects within the area take 1d6 
points of damage per caster level (maximum 20d6). 
A successful Reflex saving throw reduces damage by 
half. Each round, as a free action, the caster can 
direct the fist to another area within range, where
it smashes downward again. It continues to attack
the same area unless otherwise directed.

The fist does not need to strike the ground. It can
attack airborne targets as well. Airborne targets
that succeed at a Reflex save take no damage and
are forcibly ejected from the spell's area.

Material Component: A severed hand from a 
good-aligned humanoid cleric. 

Disease Component: Festering anger. 

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	location lLoc = GetSpellTargetLocation();
	int nCasterLvl = PRCGetCasterLevel();
        float fDuration = RoundsToSeconds(nCasterLvl);
        
	if (!X2PreSpellCastCode()) return;
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
			
	// Apply summon and vfx at target location. 
	MultisummonPreSummon();	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lLoc);	
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature("sp_crush_fist"), lLoc, fDuration);
	
	SPEvilShift(oPC);
	SPSetSchool();	
}