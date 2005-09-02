/////////////////////////////////////////////////
// Magma Burst: On Heartbeat
// tm_s0_epMagmaBuB.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: Initial explosion (20d8) reflex save, then AoE of lava (10d8),
// fort save.  If more then 5 rnds in the cloud cumulative, you turn to stone
// as the lava hardens (fort save).
/////////////////////////////////////////////////
// Last Updated: 03/15/2004, Nron Ksr
/////////////////////////////////////////////////

// Current error is caused by the includes...
// This spell needs several items from x0_i0_spells.
// x0_i0_spells --> nw_i0_generic.
// x0_i0_spells --> nw_i0_spells --> inc_dispel --> nw_i0_generic
// So we have a large repeating chain of includes.
// prc_alterations is also duplicated similarly.
// inc_epicspells --> prc_getcast_lvl  --> prc_alterations
// nw_i0_spells   --> prc_inc_function --> prc_alterations

// If anyone can think of a way to fix it please go ahead...
// I managed to fix all the other scripts though =)

#include "prc_alterations"
#include "prc_class_const"
#include "inc_epicspells"
#include "x2_inc_spellhook"

//#include "inc_epicspells"
     //#include "prc_getcast_lvl"
        //#include "prc_alterations"***
      
//#include "prc_alterations"
   //#include "x2_inc_switches"
   //#include "prc_alterations"
   //#include "x0_i0_match"

   //#include "x0_i0_henchman"
      //#include "x0_i0_common"
         //#include "x0_i0_partywide"
            //#include "x0_i0_campaign"
         //#include "x0_i0_transport"
      //#include "nw_i0_plot"
      //#include "nw_i0_generic" *
         //#include "x0_i0_behavior"
         //#include "x0_i0_anims"
            //#include "x0_i0_position"
            //#include "x0_i0_modes"
            //#include "x0_i0_voice"
            //#include "x0_i0_walkway"
               //#include "x0_o0_spawncond"
                  //#include "x0_i0_combat"
                     //#include "x0_i0_talent"
                        //#include "x0_inc_generic"
                           //#include "x0_i0_debug"
                           //#include "x0_i0_equip"
                              //#include "x0_i0_assoc"
                              //#include "x0_i0_enemy"
                                 //#include "x0_i0_match"
      //#include "prc_alterations"
         //#include "prc_alterations"
            //#include "prc_alterations"***
               //#include "x2_inc_switches"
               //#include "prc_feat_const"
               //#include "prc_class_const"
               //#include "prc_spell_const"
               //#include "lookup_2da_spell"
               //#include "prcsp_reputation"
               //#include "prcsp_archmaginc"
               //#include "prcsp_spell_adjs"
               //#include "prcsp_engine"
         //#include "inc_dispel"
            //#include "nw_i0_generic" *
            //#include "prc_feat_const"
            //#include "lookup_2da_spell"
            //#include "prcsp_spell_adjs"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    int nDamage;
    effect eDam;
    object oTarget;
    float fDelay;
    oTarget = GetFirstInPersistentObject
        ( OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    if( !GetIsObjectValid(GetAreaOfEffectCreator()) )
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        DestroyObject(OBJECT_SELF);
        return;
    }


    //Declare the spell shape, size and the location.
    while( GetIsObjectValid(oTarget) )
    {
        if( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()) )
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Roll damage.
            nDamage = d8(10);

            //Adjust damage for Fort Save:  How does one avoid lava and not leave the area?
            // Flying, I guess:  To bad NWN doesn't have a "Z" Axis. :D
            if( !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(GetAreaOfEffectCreator(), oTarget, SPELL_EPIC_MAGMA_B) , // B- ch to nDC
                    SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator()) )
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

            int nMagmaBurstCounter = GetLocalInt( oTarget, "MagmaBurst" );
            if( nMagmaBurstCounter >= 1 )
            {
                int nCounterIncrease = nMagmaBurstCounter +1;
                SetLocalInt( oTarget, "MagmaBurst", nCounterIncrease );
                if( nCounterIncrease >= 5 )
                    DoPetrification(GetTotalCastingLevel(GetAreaOfEffectCreator()), 
                        OBJECT_SELF, oTarget, PRCGetSpellId(), 
                        GetEpicSpellSaveDC(GetAreaOfEffectCreator(), oTarget));
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject
            (OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
