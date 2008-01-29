//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"
#include "X0_I0_SPELLS"
#include "inv_inc_invfunc"

void main()
{
 ActionDoCommand(SetAllAoEInts(INVOKE_AOE_CHILLFOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nDamage = d6(2);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    object oTarget;
    float fDelay;

   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());
    
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            
            fDelay = GetRandomDelay(0.4, 1.2);
            //Fire cast spell at event for the affected target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), INVOKE_CHILLING_FOG));
            //Spell resistance check
            if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr, fDelay))
            {
               //Apply damage and visuals
                //Set the damage effect
    		eDam = PRCEffectDamage(nDamage, DAMAGE_TYPE_COLD);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }


}
