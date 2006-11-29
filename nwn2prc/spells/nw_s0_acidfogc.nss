//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/**@file Acid Fog
Conjuration (Creation) [Acid]
Level: 	Sor/Wiz 6, Water 7
Components: 	V, S, M/DF
Casting Time: 	1 standard action
Range: 	Medium (100 ft. + 10 ft./level)
Effect: 	Fog spreads in 20-ft. radius, 20 ft. high
Duration: 	1 round/level
Saving Throw: 	None
Spell Resistance: 	No

Acid fog creates a billowing mass of misty vapors similar 
to that produced by a solid fog spell. In addition to 
slowing creatures down and obscuring sight, this spell's
vapors are highly acidic. Each round on your turn, 
starting when you cast the spell, the fog deals 2d6 points
of acid damage to each creature and object within it.

Material Component: A pinch of dried, powdered peas 
                    combined with powdered animal hoof.

**/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
// rewritten by fluffyamoeba to work like the SRD 29.11.2006
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    ActionDoCommand(SetAllAoEInts(SPELL_ACID_FOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDamage =  PRCMaximizeOrEmpower(6,2,nMetaMagic);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
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
    
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            
            fDelay = GetRandomDelay(0.4, 1.2);
            //Fire cast spell at event for the affected target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));

            //Apply damage and visuals
            //Set the damage effect
            eDam = EffectDamage(nDamage, ChangedElementalDamage(GetAreaOfEffectCreator(), DAMAGE_TYPE_ACID));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }

}
