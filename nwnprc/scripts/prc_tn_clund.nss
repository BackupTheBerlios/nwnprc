/**
 * True Necromancer: Create Lesser Undead
 * 2004/04/14
 * Stratovarius
 */

#include "prc_class_const"
#include "prc_feat_const"

void main()
{
    string sSummon;
    effect eSummonB;
    object oCreature;
    int nClass = GetLevelByClass(CLASS_TYPE_TRUENECRO, OBJECT_SELF);

            switch (nClass)
            {
                case 4:
                    sSummon = "doomkght001";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 7:
                    sSummon = "mohrg001";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 10:
                    sSummon = "doomkghtboss001";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
            }


   float fDelay = 0.0;
   effect eSum = EffectSummonCreature(sSummon, VFX_IMP_NEGATIVE_ENERGY, fDelay);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSum, OBJECT_SELF, fDelay);
}
