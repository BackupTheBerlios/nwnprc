//::///////////////////////////////////////////////
//:: codi_pre_flst
//:://////////////////////////////////////////////
/*
       Ocular Adept: Flesh to Stone
*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    //SendMessageToPC(OBJECT_SELF, "Petrify script online");
    int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetLevelByTypeDivine();
    int bHit = TouchAttackRanged(oTarget,FALSE)>0;

    if(bHit) {
        if (MyResistSpell(OBJECT_SELF,oTarget) <1)
        {
            DoPetrification(nCasterLvl, OBJECT_SELF, oTarget, GetSpellId(), nOcSv);
        }
    } else {
        if(GetIsPC(OBJECT_SELF)) {
            SendMessageToPC(OBJECT_SELF, "The ray missed.");
        }
    }
}
