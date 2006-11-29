//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
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
//:://///////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003
// rewritten by fluffyamoeba to work like the SRD 29.11.06

#include "spinc_common"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    ActionDoCommand(SetAllAoEInts(SPELL_ACID_FOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    object oTarget = GetEnteringObject();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    // the fog effects
    effect eSlow = EffectMovementSpeedDecrease(80);
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConceal2 = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_VS_RANGED);
    effect eHitReduce = EffectAttackDecrease(2);
    effect eDamReduce = EffectDamageDecrease(2);
   
    // Link
    effect eLink = EffectLinkEffects(eConceal, eConceal2);
    eLink = EffectLinkEffects(eLink, eSlow);
    eLink = EffectLinkEffects(eLink, eMiss);
    eLink = EffectLinkEffects(eLink, eHitReduce);
    eLink = EffectLinkEffects(eLink, eDamReduce);
    
    float fDelay = GetRandomDelay(1.0, 2.2);
    
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));
        //Roll Damage
        //Enter Metamagic conditions
        nDamage =  PRCMaximizeOrEmpower(6,2,nMetaMagic);
        
        // add the fog effects to the target
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget,0.0f,FALSE);

        //Set Damage Effect with the modified damage
        eDam = EffectDamage(nDamage, ChangedElementalDamage(GetAreaOfEffectCreator(), DAMAGE_TYPE_ACID));
        //Apply damage and visuals
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }

}
