#include "prc_alterations"
#include "prc_class_const"

void main()
{

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eBolt;

    int iDice = GetHitDice(GetMaster())/5+GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,GetMaster());

      //Make a saving throw check
    if (GetAttackRoll(oTarget, OBJECT_SELF, OBJECT_INVALID, 0, 0,0,TRUE, 0.0, TOUCH_ATTACK_RANGED_SPELL))
    {
        eBolt = EffectDamage(d8(1),DAMAGE_TYPE_POSITIVE);
        eBolt = SupernaturalEffect(eBolt);
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSun, oTarget);
    }

}
