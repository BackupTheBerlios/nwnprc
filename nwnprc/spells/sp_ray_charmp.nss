//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Charm Person
//:: FileName  sp_ray_charmp.nss
//:://////////////////////////////////////////////


#include "prc_inc_sp_tch"

void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);

    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f);

    if (nTouch)
    {
            ActionDoCommand(SetLocalInt(OBJECT_SELF, "AttackHasHit", nTouch)); //preserve crits
            DoRacialSLA(SPELL_CHARM_PERSON, 13, 18);
            ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "AttackHasHit"));
    }
}