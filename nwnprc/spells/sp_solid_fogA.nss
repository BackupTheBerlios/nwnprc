//::///////////////////////////////////////////////
//:: Name      Solid Fog: On Enter
//:: FileName  sp_solid_fogA.nss
//:://////////////////////////////////////////////
/**@file Solid Fog
Conjuration (Creation)
Level: Sor/Wiz 4, Hexblade 4
Components: V, S, M
Duration: 1 min./level
Spell Resistance: No

This spell functions like fog cloud, but in addition
to obscuring sight, the solid fog is so thick that 
any creature attempting to move through it progresses
at a speed of 5 feet, regardless of its normal speed,
and it takes a -2 penalty on all melee attack and 
melee damage rolls. The vapors prevent effective 
ranged weapon attacks (except for magic rays and the
like). A creature or object that falls into solid fog
is slowed, so that each 10 feet of vapor that it 
passes through reduces falling damage by 1d6. A 
creature can’t take a 5-foot step while in solid fog.

However, unlike normal fog, only a severe wind 
(31+ mph) disperses these vapors, and it does so in 
1 round.

Solid fog can be made permanent with a permanency 
spell. A permanent solid fog dispersed by wind 
reforms in 10 minutes.

Material Component: A pinch of dried, powdered peas 
                    combined with powdered animal hoof.
**/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
 ActionDoCommand(SetAllAoEInts(SPELL_SOLID_FOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    object oTarget = GetEnteringObject();
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

    //Fire cast spell at event for the target
    SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_SOLID_FOG));

    // Maximum time possible. If its less, its simply cleaned up when the spell ends.
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (60.0f * PRCGetCasterLevel(GetAreaOfEffectCreator())));
}