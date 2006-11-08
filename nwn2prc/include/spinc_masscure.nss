/////////////////////////////////////////////////////////////////////////////////
//
// DoMassCure - Does a mass cure spell effect on the spell's location.
//      nDice - the number of d8 to roll for healing.
//      nBonusCap - the cap on bonus hp, bonus hp equal to caster level up to
//      the cap is added.
//      nHealEffect - the vfx to apply to the target(s).
//      nSpellID - the spell ID to use for event firing.
//
/////////////////////////////////////////////////////////////////////////////////

#include "prc_inc_racial"
#include "spinc_common"

int biowareSpellsCure(int nCasterLvl, object oTarget, int nDamage, int nMaxExtraDamage, int nMaximized,
    effect vfx_impactHurt, effect vfx_impactHeal, int nSpellID);

void DoMassCure (int nDice, int nBonusCap, int nHealEffect, int nSpellID = -1)
{
    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    // Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();

    // Get the effective caster level.
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
//  int nBonusHP = nCasterLvl > nBonusCap ? nBonusCap : nCasterLvl;

    // Get the spell ID if it was not given.
    if (-1 == nSpellID) nSpellID = PRCGetSpellId();

    // Apply the burst vfx.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_20), PRCGetSpellTargetLocation());

    effect eVisCure = EffectVisualEffect(nHealEffect);
    effect eVisHarm = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    float fDelay;

    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    int nHealed = 0;
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        // Call our modified bioware cure logic to do the actual cure/harm effect.
        if (biowareSpellsCure(nCasterLvl,oTarget, d8(nDice), nBonusCap, 8 * nDice,
            eVisHarm, eVisCure, nSpellID))
            nHealed++;

        // If we've healed as manay targets as we can we're done.
        if (nHealed >= nCasterLvl) break;

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    SPSetSchool();
}



/////////////////////////////////////////////////////////////////////////////////
//
// This is a copy of the spellsCure() function from nw_s0_spells.nss, with the
// following changes:
//
//      - modified to accept the target of the spell as an argument
//      - modified to not do a touch attack to land on undead
//      - modified to return 0 if the target was not effected, 1 if it is
//      - modified the effect arguments to be effect objects rather than ints
//
/////////////////////////////////////////////////////////////////////////////////

int biowareSpellsCure(int nCasterLvl,object oTarget, int nDamage, int nMaxExtraDamage, int nMaximized, effect vfx_impactHurt, effect vfx_impactHeal, int nSpellID)
{
    // NEW CODE
    int nEffected = 0;

    //Declare major variables
    // COMMENT OUT BIOWARE CODE
    //object oTarget = PRCGetSpellTargetObject();
    int nHeal;
    int nMetaMagic = PRCGetMetaMagicFeat();
    // CHANGED CODE
    effect eVis = vfx_impactHurt;
    effect eVis2 = vfx_impactHeal;
    effect eHeal, eDam;

    int nExtraDamage = nCasterLvl; // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }
    nDamage = nDamage + nExtraDamage;


    //Make metamagic checks
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_POSITIVE, TRUE);
    if((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith)
    {
        nDamage = nMaximized + nExtraDamage;
        // * if low or normal difficulty then MAXMIZED is doubled.
        if(GetIsPC(OBJECT_SELF) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
        {
            nDamage = nDamage + nExtraDamage;
        }
    }
    if((nMetaMagic & METAMAGIC_EMPOWER))
    {
        nDamage = nDamage + (nDamage/2);
    }
    if (GetLevelByClass(CLASS_TYPE_HEALER, OBJECT_SELF))
        nDamage += GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);    

    // The caster is the one who called the script, so OBJECT_SELF should work
    // Applies the Augment Healing feat, which adds 2 points of healing per spell level.
    if (GetHasFeat(FEAT_AUGMENT_HEALING, OBJECT_SELF)) nDamage += (StringToInt(lookup_spell_cleric_level(PRCGetSpellId())) * 2);

    if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        // NEW CODE
        // Add target check since we only want this to land on friendly targets and
        // it's not targetted.
        if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
            // NEW CODE
            nEffected = 1;

            //Figure out the amount of damage to heal
            nHeal = nDamage;
            //Set the heal effect
            eHeal = EffectHeal(nHeal);
            //Apply heal effect and VFX impact
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            //Fire cast spell at event for the specified target
            SPRaiseSpellCastAt(oTarget, FALSE, nSpellID);
        }
    }
    //Check that the target is undead
    else
    {
        // COMMENT OUT BIOWARE CODE
        int nTouch = 1;
        //int nTouch = PRCDoMeleeTouchAttack(oTarget);;
        if (nTouch > 0)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                // NEW CODE
                nEffected = 1;

                //Fire cast spell at event for the specified target
                SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);
                if (!SPResistSpell(OBJECT_SELF, oTarget,nCasterLvl+SPGetPenetr()))
                {
                    eDam = SPEffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                    //Apply the VFX impact and effects
                    DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }


    // NEW CODE
    return nEffected;
}

// Test main
//void main(){}