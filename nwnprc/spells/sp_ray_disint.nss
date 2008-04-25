//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Disintegrate
//:: FileName  sp_ray_disint.nss
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
			
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	//Beam VFX.  Ornedan is my hero.
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_DISINTEGRATE, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
	
	if (nTouch)
	{
		ActionDoCommand(SetLocalInt(OBJECT_SELF, "AttackHasHit", nTouch)); //preserve crits
		DoRacialSLA(SPELL_DISINTEGRATE, 13, 18);
		ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "AttackHasHit"));
	}
}