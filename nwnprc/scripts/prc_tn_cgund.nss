/**
 * True Necromancer: Create Greater Undead
 * 2004/04/14
 * Stratovarius
 */

#include "prc_class_const"
#include "prc_feat_const"

void main()
{
    if (GetMaxHenchmen() < 4)
    {
    SetMaxHenchmen(4);
    }
    string sSummon;
    effect eSummonB;
    object oCreature;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    int nClass = GetLevelByClass(CLASS_TYPE_TRUENECRO, OBJECT_SELF);


            switch (nClass)
            {
                case 7:
                    sSummon = "prc_tn_fthug";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 10:
                    sSummon = "prc_sum_grav";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 13:
                    sSummon = "prc_sum_vamp1";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 16:
                    sSummon = "prc_sum_wight";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 19:
                    sSummon = "prc_sum_bonet";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 22:
                    sSummon = "prc_sum_vamp2";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 25:
                    sSummon = "prc_sum_dk";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 28:  
                    sSummon = "prc_sum_dbl";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
            }
	    if (nClass > 28)
		{
		sSummon = "prc_sum_dbl";
		}

   oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
   AddHenchman(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}
