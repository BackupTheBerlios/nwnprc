#include "prc_class_const"
#include "nw_i0_spells"

void main()
{
    object oPC = GetSpellTargetObject();

    RemoveEffectsFromSpell(oPC, GetSpellId());

    int nLevel = GetLevelByClass(CLASS_TYPE_SACREDFIST,oPC);
    int iSpeed = (nLevel > 2) ? 10 : 0;
        iSpeed = (nLevel > 5) ? 20 : iSpeed;
        iSpeed = (nLevel > 7) ? 30 : iSpeed;

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectMovementSpeedIncrease(iSpeed)),oPC);
}
