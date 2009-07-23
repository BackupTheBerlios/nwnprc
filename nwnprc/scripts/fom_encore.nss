#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int nBonusUses = GetLevelByClass(CLASS_TYPE_FAVORED_MILIL, oPC) / 2;
    int nUse = 1;
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    while (nBonusUses >= nUse)
    {
        IncrementRemainingFeatUses(oPC, FEAT_BARD_SONGS);
        nUse += 1;
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
}