#include "prc_class_const"

void main()
{
    object oPC = GetSpellTargetObject();

    int nLevel = GetLevelByClass(CLASS_TYPE_SACREDFIST,oPC);
    int iSpeed;
    if (nLevel>2)
    {
        iSpeed = 10;
        if (nLevel>7) iSpeed = 30;
        //else if (nLevel>7) iSpeed = 30;

        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(EffectMovementSpeedIncrease(iSpeed)),oPC);
    }

}
