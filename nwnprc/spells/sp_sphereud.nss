#include "spinc_common"
#include "prc_inc_switch"

void main()
{
	if (!X2PreSpellCastCode()) return;

	// Calculate spell duration.
	float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(PRCGetCasterLevel()));

	// Apply summon and vfx at target location.	
	location lTarget = GetSpellTargetLocation();
        MultisummonPreSummon();
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, 
		EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), lTarget);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, 
		EffectSummonCreature("sp_sphereofud"), lTarget, fDuration);
	
	// Save the spell DC for the spell so the sphere can use it.
	int nSaveDC = SPGetSpellSaveDC(OBJECT_SELF,OBJECT_SELF);
	SetLocalInt(OBJECT_SELF, "SP_SPHEREOFUD_DC", nSaveDC);
}
