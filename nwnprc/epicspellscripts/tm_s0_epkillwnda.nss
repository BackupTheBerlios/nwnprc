/////////////////////////////////////////////////
// Tolodine's Killing Wind: On Enter
// tm_s0_epkillwnda.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/07/2004
// Description: This script causes an AOE Death Spell for 10 rnds.
// Fort. save -4 to resist
/////////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_I0_SPELLS"
#include "inc_epicspells"
#include "prc_alterations"

void main()
{
    //Declare variables
    effect eVis = EffectVisualEffect( VFX_IMP_DEATH );
//    effect eVis = EffectVisualEffect( VFX_COM_CHUNK_RED_MEDIUM ); // Alternative Death VFX
    float fDelay;
    int nDC = GetEpicSpellSaveDC(GetAreaOfEffectCreator()) + // Boneshank - added.
        GetDCSchoolFocusAdjustment(GetAreaOfEffectCreator(), TOLO_KW_S);

    //Get the first object entering the area
    object oTarget = GetEnteringObject();

    if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,
        GetAreaOfEffectCreator()) )
    {
        //Fire cast spell at event for the specified target
        SignalEvent( oTarget,
            EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE) );
        //Make SR check
        if( !MyPRCResistSpell(OBJECT_SELF, oTarget, 0))
        {
            //Make a fortitude save (-4) to avoid death
            if( !MySavingThrow(SAVING_THROW_FORT, oTarget, nDC+4,
                SAVING_THROW_TYPE_DEATH, GetAreaOfEffectCreator()) )
            {
                //Apply the delay VFX impact and death effect
                DelayCommand( fDelay,
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
                effect eDeath = EffectDeath();
                DelayCommand( fDelay,
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget) );
            }
        }
    }
}
