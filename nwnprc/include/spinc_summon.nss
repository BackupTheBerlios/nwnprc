#include "prc_inc_switch"
void sp_summon(string creature, int impactVfx)
{
    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    // Check to see if the spell hook cancels the spell.
    if (!X2PreSpellCastCode()) return;

    // Get the duration, base of 24 hours, modified by metamagic
    float fDuration = SPGetMetaMagicDuration(HoursToSeconds(24));

    // Apply impact VFX and summon effects.
    MultisummonPreSummon();
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = SPGetMetaMagicDuration(RoundsToSeconds(PRCGetCasterLevel()*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL)));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(impactVfx),
                          GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(creature),
                          GetSpellTargetLocation(), fDuration);

    SPSetSchool();
}
