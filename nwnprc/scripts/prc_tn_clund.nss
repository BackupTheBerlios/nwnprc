/**
 * True Necromancer: Create Lesser Undead
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
                case 4:
                    sSummon = "prc_sum_mohrg";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 7:
                    sSummon = "prc_sum_zlord";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
                case 10:
                    sSummon = "prc_sum_sklch";
                    eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
                    break;
            }
	    if (nClass > 10)
		{
		sSummon = "prc_sum_sklch";
		}


   oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
   AddHenchman(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}