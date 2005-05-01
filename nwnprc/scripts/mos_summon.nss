/**
 * Master of Shrouds: Summon Undead (1-4)
 * 2004/02/15
 * Brian Greinke
 * edited to include epic wraith summons 2004/03/04; also removed unnecessary scripting.
 * Lockindal Linantal
 */

#include "prc_inc_clsfunc"
#include "prc_inc_switch"

void main()
{
    string sSummon;
    effect eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
    object oCreature;
    int nClass = GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, OBJECT_SELF);

    if (nClass > 29)	        sSummon = "prc_mos_39";
    else if (nClass > 26)	sSummon = "prc_mos_36";
    else if (nClass > 23)	sSummon = "prc_mos_33";
    else if (nClass > 20)	sSummon = "prc_mos_30";
    else if (nClass > 17)	sSummon = "prc_mos_27";
    else if (nClass > 14)	sSummon = "prc_mos_24";
    else if (nClass > 11)	sSummon = "prc_mos_21";
    else if (nClass > 9)	sSummon = "prc_mos_spectre2";
    else if (nClass > 7)	sSummon = "prc_mos_spectre1";
    else if (nClass > 5)	sSummon = "prc_mos_wraith";
    else                 	sSummon = "prc_mos_allip";

   MultisummonPreSummon(OBJECT_SELF);
   effect eSum = EffectSummonCreature(sSummon, VFX_NONE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummonB, GetSpellTargetLocation());
   ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSum, GetSpellTargetLocation());
   object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
   CorpseCrafter(OBJECT_SELF, oSummon);   
}
