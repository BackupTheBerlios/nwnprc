/////////////////////////////////////////////////
// Leech Field: On Heartbeat
// tm_s0_epleech.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/15/2004
// Description: An AoE that saps the life of those in the
// field and transfers it to the caster.
/////////////////////////////////////////////////
// Last Updated: 03/15/2004, Nron Ksr
/////////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_epicspells"
#include "x2_I0_SPELLS"
#include "prc_alterations"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget;
    int nDamage;
    float fDelay;
    int nDC = GetEpicSpellSaveDC(oCaster) + // Boneshank - added.
		GetChangesToSaveDC() +
        GetDCSchoolFocusAdjustment(oCaster, LEECH_F_S);

    // If oCaster is not valid
    if( !GetIsObjectValid(oCaster) )
    {
		DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        DestroyObject( OBJECT_SELF );
        return;
    }

    //Declare and assign personal impact visual effect.
    effect eVisHeal = EffectVisualEffect( VFX_IMP_HEALING_M );
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eBad = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );
    effect eDam, eHeal;


    //Capture the first target object in the shape.
    oTarget = GetFirstInPersistentObject();

    while( GetIsObjectValid(oTarget) )
    {
        //Declare the spell shape, size and the location.
        if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,
            GetAreaOfEffectCreator()) )
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Roll damage.
            // Apply effects to the currently selected target.

            // * any undead should be healed, not just Friendlies
            if( GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
            {
                //Fire cast spell at event for the specified target
                SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST) );
                //Set the heal effect
                eHeal = EffectHeal(d6(4));
                DelayCommand( fDelay,
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget) );
                DelayCommand( fDelay,
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget) );
                DelayCommand( fDelay,
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget) );
            }
            else
            {
                if( !MyPRCResistSpell(oCaster, oTarget, 0, fDelay) )
                {
                    // Debug message.
                    SendMessageToPC(oCaster, "Not resisted.");
                    nDamage = d6(4);
                    //Adjust damage for Save
                    if( MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, //B-chngd to nDC
                        SAVING_THROW_TYPE_NEGATIVE, oCaster, fDelay) )
                    {
                        nDamage /= 2;
                    }
                    //Fire cast spell at event for the specified target
                    SignalEvent( oTarget,
                        EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST) );
                    //Set the damage effect
                    eDam = EffectDamage( nDamage, DAMAGE_TYPE_NEGATIVE );
                    // Apply effects to the currently selected target.
                    DelayCommand( fDelay,
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );
                    //This visual effect is applied to the target object not the location as above.
                    DelayCommand( fDelay,
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget) );

                    // Heal the caster
                    if( GetCurrentHitPoints(oCaster) <= GetMaxHitPoints(oCaster) * 2 )
                    {
                        eHeal = EffectTemporaryHitpoints(nDamage);
                        DelayCommand( 2.1,
                            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                eVisHeal, oCaster) );
                        DelayCommand( 2.1,
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                eHeal, oCaster,
                                    TurnsToSeconds(GetCasterLevel(oCaster))) );
                    }
                }
            }
        }
    //Select the next target within the spell shape.
    oTarget = GetNextInPersistentObject();
    }
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
