/////////////////////////////////////////////////
// Tolodine's Killing Wind: On Heartbeat
// tm_s0_epkillwndb.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/07/2004
// Description: This script causes an AOE Death Spell for 10 rnds.
// Fort. save -4 to resist
/////////////////////////////////////////////////
// Last Updated: 03/15/2004, Nron Ksr
/////////////////////////////////////////////////
#include "nw_i0_spells"
#include "x2_inc_spellhook"
//#include "X0_I0_SPELLS"
#include "inc_epicspells"
//#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    //Declare variables
    effect eVis = EffectVisualEffect( VFX_IMP_DEATH );
//    effect eVis = EffectVisualEffect( VFX_COM_CHUNK_RED_MEDIUM ); // Alternative Death VFX
    float fDelay;
    int nDC = GetEpicSpellSaveDC(GetAreaOfEffectCreator()) + // Boneshank - added.
		GetDCSchoolFocusAdjustment(GetAreaOfEffectCreator(), TOLO_KW_S);        
        //Get the first object in the persistent area
    object oTarget = GetFirstInPersistentObject();

 



    while( GetIsObjectValid(oTarget) )
    {
        if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,
            GetAreaOfEffectCreator()) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent( oTarget,
                EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE) );
            //Make a SR check
            if( !MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget, 0) )
            {

                //Make a fortitude save (-4) to avoid death
                if( !MySavingThrow(SAVING_THROW_FORT, oTarget, nDC+4+GetChangesToSaveDC(oTarget,GetAreaOfEffectCreator()),
                    SAVING_THROW_TYPE_DEATH, GetAreaOfEffectCreator()) )
                {
                    //Apply the delay VFX impact and death effect
                    DelayCommand( fDelay,
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
                    effect eDeath = EffectDeath();
                    DelayCommand( fDelay,
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget) );
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
