/**
 * Master of Shrouds: Summon Undead (1-4)
 * 2004/02/15
 * Brian Greinke
 * edited to include epic wraith summons 2004/03/04; also removed unnecessary scripting.
 * Lockindal Linantal
 */

#include "prc_class_const"
#include "prc_feat_const"

void main()
{
    string sSummon;
    effect eSummonB;
    object oCreature;
    int nClass = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, OBJECT_SELF);


            switch (nClass)
            {
                case 3:
                    sSummon = "prc_mos_allip";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 5:
                    sSummon = "prc_mos_wraith";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 7:
                    sSummon = "prc_mos_spectre1";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 9:
                    sSummon = "prc_mos_spectre2";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 11:
                    sSummon = "prc_mos_21";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 14:
                    sSummon = "prc_mos_24";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 17:
                    sSummon = "prc_mos_27";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 20:
                    sSummon = "prc_mos_30";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 23:
                    sSummon = "prc_mos_33";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 26:
                    sSummon = "prc_mos_36";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 29:
                    sSummon = "prc_mos_39";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 180:  //max level for npc
                    sSummon = "prc_mos_39";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
            }

   effect eSum = EffectSummonCreature(sSummon, VFX_NONE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummonB, GetSpellTargetLocation());
   ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSum, GetSpellTargetLocation());
}
