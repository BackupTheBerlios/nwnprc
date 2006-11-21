//::///////////////////////////////////////////////
//:: Name      Kelgore's Fire Bolt
//:: FileName  sp_kelgore_fb.nss
//:://////////////////////////////////////////////
/**@file Kelgore's Fire Bolt
Conjuration/Evocation [Fire]
Level: Duskblade 1, sorcerer/wizard 1
Components: V,S,M
Casting Time: 1 standard action
Range: Medium
Target: One creature
Duration: Instantaneous
Saving Thorw: Reflex half
Spell Resistance: See text

This spell conjures a small orb of rock and sheathes
it in arcane energy.  This spell deals 1d6 point of
fire damage per caster level (maximum 5d6).  If you
fail to overcome the target's spell resistance, the
spell still deals 1d6 points of fire damage from the
heat and force of the conjured orb's impact.

Material component: A handful of ashes
**/

////////////////////////////////////////////////////
// Author: Tenjac
// Date:   21.9.06
////////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
    if(!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_EVOCATION);

    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nMax = nCasterLvl;
    if (nMax > 5) nMax = 5;
    int nDam = d6(nMax);

    SPRaiseSpellCastAt(oTarget,TRUE, SPELL_KELGORES_FIRE_ORB, oPC);

    if(nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDam = 6 * nMax;
    }
    if(nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDam += (nDam/2);
    }

    if(MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        nDam = d6(1);
        eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    }

    nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, nDC, SAVING_THROW_TYPE_FIRE);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_FIRE), oTarget);

    SPSetSchool();
}