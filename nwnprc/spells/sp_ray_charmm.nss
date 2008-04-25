//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Charm Monster
//:: FileName  sp_ray_charmm.nss
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{

    //Declare major variables
   object oPC = OBJECT_SELF;
   object oTarget = GetSpellTargetObject();
        
    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);
    
    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
    
    if (nTouch)
    {
	    ActionDoCommand(SetLocalInt(OBJECT_SELF, "AttackHasHit", nTouch)); //preserve crits
	    DoRacialSLA(SPELL_CHARM_MONSTER, 13, 18);
	    ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "AttackHasHit"));
    }
}
    