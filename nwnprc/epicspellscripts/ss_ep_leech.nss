/////////////////////////////////////////////////
// Leech Field
// tm_s0_epleech.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: An AoE that saps the life of those in the
// field and transfers it to the caster.
/////////////////////////////////////////////////
// Last Updated: 03/16/2004, Nron Ksr
/////////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, LEECH_F_DC, LEECH_F_S, LEECH_F_XP))
    {

        //Declare variables
        int nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        int nToAffect = nCasterLevel;
        location lTarget = GetSpellTargetLocation();

        // Visual effect creations
        effect eImpact = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_EVIL );
        effect eImpact2 = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
        effect eImpact3 = EffectVisualEffect( VFX_FNF_SUMMON_UNDEAD );

        // Linking visuals
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact2, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact3, lTarget );

        effect eAOE = EffectAreaOfEffect
            ( AOE_PER_EVARDS_BLACK_TENTACLES,
                "tm_s0_epleecha", "tm_s0_epleechb", "****" );

        //Create an instance of the AOE Object
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE,
            lTarget, RoundsToSeconds(nCasterLevel) );
    }

}
