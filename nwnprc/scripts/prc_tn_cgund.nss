/**
 * True Necromancer: Create Greater Undead
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


        if(GetLevelByClass(CLASS_TYPE_TRUENECRO, OBJECT_SELF) >= 11)
        {
            switch (nClass)
            {
                case 10:
                    sSummon = "prc_tn_nightshad";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 13:
                    sSummon = "prc_tn_nightsh02";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 16:
                    sSummon = "prc_tn_grshade";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 19:
                    sSummon = "prc_tn_grshad02";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 22:
                    sSummon = "prc_tn_ep_shade";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 25:
                    sSummon = "prc_tn_gep_shade";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                /*case 27:
                    sSummon = "summonedgreat006";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 30:  //max level for npc
                    sSummon = "summonedgreat006";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;*/
            }
        }
        else
        {
                    sSummon = "summonedgreat006";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);

        }


   float fDelay = 0.0;
   effect eSum = EffectSummonCreature(sSummon, VFX_IMP_NEGATIVE_ENERGY, fDelay);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSum, OBJECT_SELF, fDelay);
}
