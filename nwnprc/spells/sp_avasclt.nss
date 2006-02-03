//::///////////////////////////////////////////////
//:: Name     Avasculate
//:: FileName   prc_avasclt.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/** @file
    Necromancy [Death, Evil]
    Sorc/Wizard 7
    Range: Close
    Saving Throw: Fortitude partial
    Spell Resistance: yes

    You shoot a ray of necromantic energy from your outstretched hand,
    causing any living creature struck by the ray to violently purge
    blood or other vital fluids through its skin. You must succeed on
    a ranged touch attack to affect the subject. If successful, the
    subject is reduced to half of its current hit points (rounded down)
    and stunned for 1 round. On a successful Fortitude saving throw the
    subject is not stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 9/20/05
//::
//:: Modified By: Flaming_Sword
//:: Modified On: 9/21/05
//:://////////////////////////////////////////////

#include "spinc_common"
#include "inc_item_props"
#include "x2_inc_itemprop"

void main()
{
    // Set the spellschool
    SPSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Run the spellhook
    if (!X2PreSpellCastCode()) return;

    //define variables
    object oTarget = GetSpellTargetObject();
    object oPC = OBJECT_SELF;
    int nDC = SPGetSpellSaveDC(oTarget, oPC);
    int nHP = GetCurrentHitPoints(oTarget);
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    //Make touch attack
    int nTouch = PRCDoRangedTouchAttack(oTarget);
    
    //Beam VFX.  Ornedan is my hero.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 

    if (nTouch)
    {
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
        {
            //damage rounds up now
            int nDam = (nHP - (nHP / 2));
            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
            effect eBeam = EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_HAND);
            
            //Blood VFX.  Lots of em.
            effect eBlood = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
                   eBlood = EffectLinkEffects(eBlood, EffectVisualEffect(VFX_COM_BLOOD_CRT_RED));
                   eBlood = EffectLinkEffects(eBlood, EffectVisualEffect(VFX_COM_BLOOD_REG_RED));
                   eBlood = EffectLinkEffects(eBlood, EffectVisualEffect(VFX_COM_BLOOD_SPARK_LARGE)); 
            
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.0);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBlood, oTarget);

            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
            {
                effect eStun = EffectStunned();
                effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eStunVis, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0);
            }
        }
    }
    SPEvilShift(oPC);
}
