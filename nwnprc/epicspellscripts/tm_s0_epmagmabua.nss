/////////////////////////////////////////////////
// Magma Burst: On Enter
// tm_s0_epMagmaBu.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: Initial explosion (20d8) reflex save, then AoE of lava (10d8),
// fort save.  If more then 5 rnds in the cloud cumulative, you turn to stone
// as the lava hardens (fort save).
/////////////////////////////////////////////////
// Last Updated: 03/15/2004, Nron Ksr
/////////////////////////////////////////////////

//#include "X0_I0_SPELLS"
// Boneshank - Added below include files for needed functions.
#include "nw_i0_spells"
#include "inc_epicspells"
//#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    object oCaster = GetAreaOfEffectCreator();

    //Declare major variables
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect( VFX_IMP_FLAME_S );
    float fDelay;
    // Boneshank - Added in the nDC formula.
    oTarget = GetEnteringObject();

    

    //Declare the spell shape, size and the location.
    if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
    {
        //Fire cast spell at event for the specified target
        SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD) );
        //Make SR check, and appropriate saving throw(s).
        if( !MyPRCResistSpell(oCaster, oTarget, GetTotalCastingLevel(oCaster)+SPGetPenetr(oCaster), fDelay) )
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Roll damage.
            nDamage = d8(10);

            //Adjust damage for Fort Save:  How does one avoid lava and not leave the area?
            // Flying, I guess:  To bad NWN doesn't have a "Z" Axis. :D
            if( !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(GetAreaOfEffectCreator(), oTarget),
                SAVING_THROW_TYPE_FIRE, oCaster) )
            {
                // Apply effects to the currently selected target.
                eDam = EffectDamage( nDamage, DAMAGE_TYPE_FIRE );
                DelayCommand( fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );
                DelayCommand( fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
            }
            else
            {
                nDamage = nDamage / 2;
                eDam = EffectDamage( nDamage, DAMAGE_TYPE_FIRE );
                DelayCommand( fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );
                DelayCommand( fDelay,
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
            }
            SetLocalInt( oTarget, "MagmaBurst", 1 );
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
