/////////////////////////////////////////////////
// Tolodine's Killing Wind
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/07/2004
// Description: This script causes an AOE Death Spell for 10 rnds.
// Fort. save -4 to resist
/////////////////////////////////////////////////
// Last Updated: 03/16/2004, Nron Ksr
/////////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_I0_SPELLS"
#include "inc_epicspells"

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, TOLO_KW_DC, TOLO_KW_S, TOLO_KW_XP))
    {
        //Declare variables
        int nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        int nToAffect = nCasterLevel;
        location lTarget = GetSpellTargetLocation();

        // Visual effect creations
        effect eImpact = EffectVisualEffect( 262 );
        effect eImpact2 = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_MIND );
        effect eImpact3 = EffectVisualEffect( VFX_FNF_HOWL_WAR_CRY );
        effect eImpact4 = EffectVisualEffect( VFX_FNF_SOUND_BURST );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact2, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact3, lTarget );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact4, lTarget );

        effect eAOE = EffectAreaOfEffect
            ( AOE_PER_FOG_OF_BEWILDERMENT, "tm_s0_epkillwnda", "tm_s0_epkillwndb", "****" );

        //Create an instance of the AOE Object
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(10) );
    }
}
