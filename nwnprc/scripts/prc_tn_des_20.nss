//::///////////////////////////////////////////////
//:: Desecrate
//:: PRC_TN_desecrate
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/

#include "prc_feat_const"

void main()
{
    effect eAOE = EffectAreaOfEffect(AOE_MOB_DES_20, "prc_tn_des_a", "", "prc_tn_des_b");
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}

