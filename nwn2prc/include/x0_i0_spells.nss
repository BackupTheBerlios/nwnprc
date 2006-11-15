//::///////////////////////////////////////////////
//:: x0_i0_spells
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Expansion 1 and above include file for spells
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:: Updated On: August 2003, Georg Zoeller:
//::                          Arcane Archer special ability fix,
//::                          New creatures added to Flying/Petrification check
//::                          Several Fixes toMDispelagic
//::                          Added spellsGetHighestSpellcastingClassLevel
//::                          Added code to spellsIsTarget to make NPCs hurt their allies with AoE spells if ModuleSwitch MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES is set
//::                          Creatures with Plot or DM Flag set will no longer be affected by petrify. DMs used to get a GUI panel, even if unaffected.
//:: Updated On: September 2003, Georg Zoeller:
//::                          spellsIsTarget was not using oSource in source checks.
//::                          Creatures with Plot or DM Flag set will no longer be affected by petrify. DMs used to get a GUI panel, even if unaffected.
//:: Updated On: October 2003, Georg Zoeller:
//::                          Missile storm's no longer do a SR check for each missile, but only one per target
//::                          ... and there was much rejoicing
//::                          Added code to handleldispeling of AoE spells better
//::                          Henchmen are booted from the party when petrified
//::                          Dispel Magic delay until VFX hit has been set down to 0.3
//:://////////////////////////////////////////////
//:: 8/15/06 - BDF-OEI: modified spellsIsTarget (case SPELL_TARGET_STANDARDHOSTILE) to disregard targets that are associates of 
//:: 	non-hostile PC's that are in the party, based on personal reputation global flag
// ChazM 8/29/06 moved spellsIsTarget() (and includes and constants) to NW_I0_SPELLS

//* get the hightest spellcasting class level of oCreature)
int GZGetHighestSpellcastingClassLevel(object oCreature);

// * dispel magic on one or multiple targets.
// * if bAll is set to TRUE, all effects are dispelled from a creature
// * else it will only dispel the best effect from each creature (used for AoE)
// * Specify bBreachSpells to add Mord's Disjunction to the dispel
void spellsDispelMagic(object oTarget, int nCasterLevel, effect eVis, effect eImpac, int bAll = TRUE, int bBreachSpells = FALSE);

// * returns true if oCreature does not have a mind
int spellsIsMindless(object oCreature);

// * Returns true or false depending on whether the creature is flying
// * or not
int spellsIsFlying(object oCreature);

// * returns true if the creature has flesh
int spellsIsImmuneToPetrification(object oCreature);

// * Generic apply area of effect Wrapper
// * lTargetLoc = where spell was targeted
// * fRadius = RADIUS_SIZE_ constant
// * nSpellID
// * eImpact = ring impact
// * eLink = Linked effects to apply to targets in area
// * eVis
void spellsGenericAreaOfEffect(
        object oCaster, location lTargetLoc,
        int nShape, float fRadiusSize, int nSpellID,
        effect eImpact, effect eLink, effect eVis,
        int nDurationType=DURATION_TYPE_INSTANT, float fDuration = 0.0,
        int nTargetType=SPELL_TARGET_ALLALLIES, int bHarmful = FALSE,
        int nRemoveEffectSpell=FALSE, int nRemoveEffect1=0, int nRemoveEffect2=0, int nRemoveEffect3=0,
        int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE,
        int bPersistentObject=FALSE, int bResistCheck=FALSE, int nSavingThrowType=SAVING_THROW_NONE,
        int nSavingThrowSubType=SAVING_THROW_TYPE_ALL
        );



// * how much should special archer arrows do for damage
int ArcaneArcherDamageDoneByBow(int bCrit = FALSE, object oUser = OBJECT_SELF);

// * simulating enchant arrow
int ArcaneArcherCalculateBonus();

// * returns the size modifier for bullrush in spells
int GetSizeModifier(object oCreature);

// *  Returns the modifier from the ability    score that matters for this caster
int GetCasterAbilityModifier(object oCaster);

// * Checks the appropriate metamagic to see
// * how the damage should be scaled.
int MaximizeOrEmpower(int nDice, int nNumberOfDice, int nMeta, int nBonus = 0);

// * can the creature be destroyed without breaking a plot
int CanCreatureBeDestroyed(object oTarget);

// * Does a stinking cloud. If oTarget is Invalid, then does area effect, otherwise
// * just attempts on otarget
void spellsStinkingCloud(object oTarget = OBJECT_INVALID, int nSaveDC = 15);

// * caltrops do 25 points of damage (1 pnt per target per round) and then are gone
void DoCaltropEffect(object oTarget);

// * apply effects of spike trap on entering object
void DoTrapSpike(int nDamage);

//* fires a storm of nCap missiles at targets in area
void DoMissileStorm(int nD6Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE, int nMaxHits = 10 );

// * Applies ability score damage
void DoDirgeEffect(object oTarget,int nPenetr);

void spellsInflictTouchAttack(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID,int ModCasterlevel = 0, int nDC = 0);

// * improves an animal companion or summoned creature's attack and damage and the ability to hit
// * magically protected creatures
void DoMagicFang(int nPower, int nDamagePower,int nCasterLevel);

// * for spike growth area of effect object
// * applies damage and slow effect
void DoSpikeGrowthEffect(object oTarget, int nPenetr);

// * Applies the 'camoflage' magical effect to the target
void DoCamoflage(object oTarget);

// * Does a damage type grenade (direct or splash on miss)
void DoGrenade(int nDirectDamage, int nSplashDamage, int vSmallHit, int vRingHit, int nDamageType, float fExplosionRadius , int nObjectFilter, int nRacialType=RACIAL_TYPE_ALL);

// * This is a wrapper for how Petrify will work in Expansion Pack 1
// * Scripts affected: flesh to stone, breath petrification, gaze petrification, touch petrification
// * nPower : This is the Hit Dice of a Monster using Gaze, Breath or Touch OR it is the Caster Spell of
// *   a spellcaster
// * nFortSaveDC: pass in this number from the spell script
void DoPetrification(int nPower, object oSource, object oTarget, int nSpellID, int nFortSaveDC);

// * removed mind effects and provide mind protection
void spellApplyMindBlank(object oTarget, int nSpellId, float fDelay=0.0);

// * Handle dispel magic of AoEs
void spellsDispelAoE(object oTargetAoE, object oCaster, int nCasterLevel);

#include "prc_alterations"
#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "x0_i0_henchman"
#include "prc_inc_combat"
#include "prc_inc_sp_tch"
#include "prc_spellf_inc"

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_metmag"

//::///////////////////////////////////////////////
//:: DoTrapSpike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a spike trap. Reflex save allowed.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
// apply effects of spike trap on entering object
void DoTrapSpike(int nDamage)
{
    //Declare major variables
    object oTarget = GetEnteringObject();

    int nRealDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, 15, SAVING_THROW_TYPE_TRAP, OBJECT_SELF);
    if (nDamage > 0)
    {
        effect eDam = EffectDamage(nRealDamage, DAMAGE_TYPE_PIERCING);
        effect eVis = EffectVisualEffect(253);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
}
//::///////////////////////////////////////////////
//:: MaximizeOrEmpower
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks the appropriate metamagic to see
    how the damage should be scaled.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2002
//:://////////////////////////////////////////////

int MaximizeOrEmpower(int nDice, int nNumberOfDice, int nMeta, int nBonus = 0)
{
    int i = 0;
    int nDamage = 0;
    for (i=1; i<=nNumberOfDice; i++)
    {
        nDamage = nDamage + Random(nDice) + 1;
    }
    //Resolve metamagic
    if (nMeta & METAMAGIC_MAXIMIZE)
    {
        nDamage = nDice * nNumberOfDice;
    }
    else if (nMeta & METAMAGIC_EMPOWER)
    {
       nDamage = nDamage + nDamage / 2;
    }
    return nDamage + nBonus;
}

//::///////////////////////////////////////////////
//:: DoGrenade
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does a damage type grenade (direct or splash on miss)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void DoGrenade(int nDirectDamage, int nSplashDamage, int vSmallHit, int vRingHit, int nDamageType, float fExplosionRadius , int nObjectFilter, int nRacialType=RACIAL_TYPE_ALL)
{
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDamage = 0;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCnt;
    effect eMissile;
    effect eVis = EffectVisualEffect(vSmallHit);
    location lTarget = GetSpellTargetLocation();


    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    int nTouch;


    if (GetIsObjectValid(oTarget) == TRUE)
    {
/*        // * BK September 27 2002
        // * if the object is 'far' from the original impact it
        // * will be an automatic miss too
        location lObject = GetLocation(oTarget);
        float fDistance = GetDistanceBetweenLocations(lTarget, lObject);
//        SpawnScriptDebugger();
        if (fDistance > 1.0)
        {
            nTouch = -1;
        }
        else
        This did not work. The location and object location are the same.
        For now we'll have to live with the possiblity of the 'explosion'
        happening away from where the grenade hits.
        We could convert everything to splash...
        */
            nTouch = PRCDoRangedTouchAttack(oTarget);;

    }
    else
    {
        nTouch = -1; // * this means that target was the ground, so the user
                    // * intended to splash
    }
    if (nTouch >= 1)
    {
        //Roll damage
        int nDam = nDirectDamage;

        if(nTouch == 2)
        {
            nDam *= 2;
        }

        //Set damage effect
        effect eDam = EffectDamage(nDam, nDamageType);
        //Apply the MIRV and damage effect

        // * only damage enemies
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
        // * must be the correct racial type (only used with Holy Water)
            if ((nRacialType != RACIAL_TYPE_ALL) && (nRacialType == MyPRCGetRacialType(oTarget)))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget); VISUALS outrace the grenade, looks bad
            }
            else
            if ((nRacialType == RACIAL_TYPE_ALL) )
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget); VISUALS outrace the grenade, looks bad
            }

        }

    //    ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
    }

// *
// * Splash damage always happens as well now
// *
    {
        effect eExplode = EffectVisualEffect(vRingHit);
       //Apply the fireball explosion at the location captured above.

/*       float fFace = GetFacingFromLocation(lTarget);
       vector vPos = GetPositionFromLocation(lTarget);
       object oArea = GetAreaFromLocation(lTarget);
       vPos.x = vPos.x - 1.0;
       vPos.y = vPos.y - 1.0;
       lTarget = Location(oArea, vPos, fFace);
       missing code looks bad because it does not jive with visual
*/
       ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, nObjectFilter);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) )
        {
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            //Roll damage for each target
            nDamage = nSplashDamage;

            //Set the damage effect
            effect eDam = EffectDamage(nDamage, nDamageType);
            if(nDamage > 0)
            {
        // * must be the correct racial type (only used with Holy Water)
                if ((nRacialType != RACIAL_TYPE_ALL) && (nRacialType == MyPRCGetRacialType(oTarget)))
                {
                    // Apply effects to the currently selected target.
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                if ((nRacialType == RACIAL_TYPE_ALL) )
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId()));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }

            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, fExplosionRadius, lTarget, TRUE, nObjectFilter);
       }
    }
}

//::///////////////////////////////////////////////
//:: GetCasterAbilityModifier
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the modifier from the ability
    score that matters for this caster
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int GetCasterAbilityModifier(object oCaster)
{
    int nClass = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
    int nAbility;
    if (nClass > 0)
    {
        nAbility = ABILITY_INTELLIGENCE;
    }
    else
        nAbility = ABILITY_CHARISMA;

    return GetAbilityModifier(nAbility, oCaster);
}
//::///////////////////////////////////////////////
//:: GetSizeModifier
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gets the creature's applicable size modifier.
    Used in Bigby's Forceful hand for the 'bullrush'
    attack.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int GetSizeModifier(object oCreature)
{
    int nSize = PRCGetCreatureSize(oCreature);
    int nModifier = 0;
    switch (nSize)
    {
    case CREATURE_SIZE_TINY: nModifier = -8;  break;
    case CREATURE_SIZE_SMALL: nModifier = -4; break;
    case CREATURE_SIZE_MEDIUM: nModifier = 0; break;
    case CREATURE_SIZE_LARGE: nModifier = 4;  break;
    case CREATURE_SIZE_HUGE: nModifier = 8;   break;
    }
    return nModifier;
}

//::///////////////////////////////////////////////
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies the ability score damage of the dirge effect.

    March 2003
    Because ability score penalties do not stack, I need
    to store the ability score damage done
    and increment each round.
    To that effect I am going to update the description and
    remove the dirge effects if the player leaves the area of effect.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoDirgeEffect(object oTarget,int nPenetr)
{    //Declare major variables
//    int nMetaMagic = PRCGetMetaMagicFeat();

   // SpawnScriptDebugger();

    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), PRCGetSpellId()));
        //Spell resistance check
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        {

            //Make a Fortitude Save to avoid the effects of the movement hit.
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,GetAreaOfEffectCreator()), SAVING_THROW_ALL, GetAreaOfEffectCreator()))
            {
                int nGetLastPenalty = GetLocalInt(oTarget, "X0_L_LASTPENALTY");
                // * increase penalty by 2
                nGetLastPenalty = nGetLastPenalty + 2;

                //effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nGetLastPenalty);
                //effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nGetLastPenalty);
                //change from sonic effect to bard song...
                //effect eVis =    EffectVisualEffect(VFX_HIT_SPELL_EVOCATION);	// NWN1 VFX
                effect eVis =    EffectVisualEffect( VFX_HIT_SPELL_SONIC );	// NWN2 VFX
                //effect eLink = EffectLinkEffects(eDex, eStr);

                //Apply damage and visuals
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nGetLastPenalty, DURATION_TYPE_PERMANENT, TRUE);
                ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, nGetLastPenalty, DURATION_TYPE_PERMANENT, TRUE);
                SetLocalInt(oTarget, "X0_L_LASTPENALTY", nGetLastPenalty);
            }

        }
    }
}
//::///////////////////////////////////////////////
//:: DoCamoflage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies the 'camoflage' magical effect
    to the target
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoCamoflage(object oTarget)
{
    //Declare major variables
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);	// NWN1 VFX
    effect eVis = EffectVisualEffect( 631 );	// NWN2 VFX: VFX_DUR_SPELL_CAMOFLAGE
    int nMetaMagic = PRCGetMetaMagicFeat();
    effect eHide = EffectSkillIncrease(SKILL_HIDE, 10);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    effect eLink = EffectLinkEffects(eHide, eVis);

    int nDuration = 10*PRCGetCasterLevel(OBJECT_SELF); // * Duration 10 turn/level
     if (nMetaMagic & METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 421, FALSE));

    //Apply VFX impact and bonus effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}
//::///////////////////////////////////////////////
//:: DoSpikeGrowthEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    1d4 damage, plus a 24 hr slow if take damage.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoSpikeGrowthEffect(object oTarget,int nPenetr)
{
    float fDelay = GetRandomDelay(1.0, 2.2);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_SPIKE_GROWTH));
        //Spell resistance check
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr, fDelay))
        {
            int nMetaMagic = PRCGetMetaMagicFeat();
            int nDam = MaximizeOrEmpower(4, 1, nMetaMagic);
            nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
            float fDuration = HoursToSeconds(24);
            fDuration = ApplyMetamagicDurationMods(fDuration);
            int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_PIERCING);
            //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);	// NWN1 VFX
            //effect eVis = EffectVisualEffect( VFX_COM_BLOOD_REG_RED );	// NWN2 VFX
            //effect eLink = eDam;
            //Apply damage and visuals
            //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam/*eLink*/, oTarget));

           // * only apply a slow effect from this spell once
           if (GetHasSpellEffect(SPELL_SPIKE_GROWTH, oTarget) == FALSE)
           {
                //Make a Reflex Save to avoid the effects of the movement hit.
                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, PRCGetSaveDC(oTarget,GetAreaOfEffectCreator()), SAVING_THROW_ALL, GetAreaOfEffectCreator(), fDelay))
                {
                    effect eSpeed = EffectMovementSpeedDecrease(30);
					effect eVisSlow = EffectVisualEffect( VFX_DUR_SPELL_SLOW );
					effect eLink = EffectLinkEffects( eSpeed, eVisSlow );
                    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
                }
           }
        }
    }
}
//::///////////////////////////////////////////////
//:: spellsInflictTouchAttack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    nDamage: Amount of damage to do
    nMaxExtraDamage: Max amount of +1 per level damage
    nMaximized: Amount of damage to do if maximized
    vfx_impactHurt: Impact to play if hurt by spell
    vfx_impactHeal: Impact to play if healed by spell
    nSpellID: SpellID to broactcast in the signal event
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void spellsInflictTouchAttack(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID,int ModCasterlevel = 0 , int nDC = 0)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nTouch = PRCDoMeleeTouchAttack(oTarget);;

    int CasterLvl;
    if ( ModCasterlevel == 0)
       CasterLvl  = PRCGetCasterLevel(OBJECT_SELF);
    else
       CasterLvl = ModCasterlevel;
    int nExtraDamage = CasterLvl; // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }

        //Check for metamagic
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_NEGATIVE, TRUE);
    if ((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith)
    {
        nDamage = nMaximized;
    }
    else
    if ((nMetaMagic & METAMAGIC_EMPOWER))
    {
        nDamage = nDamage + (nDamage / 2);
    }


    //Check that the target is undead
    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        effect eVis2 = EffectVisualEffect(vfx_impactHeal);
        //Figure out the amount of damage to heal
        //nHeal = nDamage;
        //Set the heal effect
        effect eHeal = EffectHeal(nDamage + nExtraDamage);
        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
    }
    else if (nTouch >0 )
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl))
            {
                int nDamageTotal = nDamage + nExtraDamage;
                // A succesful will save halves the damage
                if (nDC == 0) nDC = PRCGetSaveDC(oTarget, OBJECT_SELF) ;
                if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_ALL,OBJECT_SELF))
                {
                    nDamageTotal = nDamageTotal / 2;
                    
                        if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
                        {
                        nDamageTotal = 0;
                        }                     
                }
                effect eVis = EffectVisualEffect(vfx_impactHurt);
                effect eDam = EffectDamage(nDamageTotal,DAMAGE_TYPE_NEGATIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            }
        }
    }
}

//::///////////////////////////////////////////////
//:: DoMissileStorm
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fires a volley of missiles around the area
    of the object selected.

    Each missiles (nD6Dice)d6 damage.
    There are casterlevel missiles (to a cap as specified)
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Modified March 14 2003: Removed the option to hurt chests/doors
//::  was potentially causing bugs when no creature targets available.
//:: 
//:: Brock Heinz - OEI - 08/15/05 - Limit hits per target
//::    This function now limits the number of hits done to any 
//::    creature to no more than nMaxHits each
//::
//:: AFW-OEI 06/06/2006:
//::	Changed to target only enemies.

void DoMissileStorm(int nD6Dice, int nCap, int nSpell, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE, int nMaxHits = 10 )
{
	//SpawnScriptDebugger();
	
	location lTarget = GetSpellTargetLocation(); // missile spread centered around caster
    object oTarget 	= OBJECT_INVALID;
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nCnt 		= 1; // # of enemies processed
    //effect eMissile = EffectVisualEffect(nMIRV);	// this information is no longer valid for NWN2; the projectile effect is now being created by SpawnSpellProjectile()
    effect eVis 	= EffectVisualEffect(nVIS);
    float fDist 	= 0.0;
    float fDelay 	= 0.0;
//    float fDelay2	= 0.0;
	float fTime		= 0.0;
	float fTime2	= 0.0;
    int nMissiles 	= nCasterLvl;
	int nSpellID 	= GetSpellId();
	location lSourceLoc = GetLocation( OBJECT_SELF );
	int nPathType = PROJECTILE_PATH_TYPE_BURST;
	
    nCasterLvl +=SPGetPenetr();
	// Clamp the number of missles
    if (nMissiles > nCap)	nMissiles = nCap;

    /* 
        Brock Heinz - OEI - 08/15/05 - Limit hits per target
            1. Count # of targets
            2. First target gets nMaxHits missles
            3. Remaining missles divided evenly between 
                other enemies, with a minimum of 1 and a 
                max of nMaxHits per enemy
    */
	
    int nEnemies = 0;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nEnemies < nMissiles )
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        {
            // * You can only fire missiles on visible targets
            if (GetObjectSeen(oTarget,OBJECT_SELF))
            {
                nEnemies++;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }


     // * Exit if no enemies to hit
     if (nEnemies == 0) 
        return; 

    // Since we can't have more than nMaxHits per enemy, make sure that we're not
    // trying to target more missles than can allocate
	int nMaxMissiles = nEnemies * nMaxHits;
    if ( nMissiles > nMaxMissiles )
        nMissiles = nMaxMissiles;

     // make sure the primary target gets a full payload
     int nMissilesAtPrimary  = nMissiles;
     if ( nMissilesAtPrimary > nMaxHits ) nMissilesAtPrimary = nMaxHits;

     // divide the remaining missles evenly amongst the rest of the enemies;
     int nMissilesAtOthers   = (nMissiles - nMissilesAtPrimary) / nEnemies;

     if ( nMissilesAtOthers < 1 )
        nMissilesAtOthers = 1; 	// No less than 1 missle per enemy. Note that this results in a possible
								// state where more missles are fired than should be, but it was in last
								// year's game, so I'm leaving it in... :P

     if ( nMissilesAtOthers > nMaxHits )
        nMissilesAtOthers = nMaxHits; // No more than this many missles per enemy

	 // Another way to get the remainder, since we're mathing it up with ints...
     int nRemainingMissiles  = nMissiles - ( nMissilesAtPrimary + 
                               ( nMissilesAtOthers * (nEnemies-1) ) );

	// If we've overflowed our missle allocation, this will be negative...
	// just clamp it. 
	if ( nRemainingMissiles < 0 ) nRemainingMissiles = 0;


	// Firebrand.
	// It means that once the target has taken damage this round from the
	// spell it won't take subsequent damage
	if ( nONEHIT == TRUE )
	{
		nMissilesAtPrimary	= 1;
	    nMissilesAtOthers	= 1;
	}

	int nMissilesForThisTarget = 0;
    int nHasProcessedPrimary = FALSE;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nCnt <= nEnemies)
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF)))
        {
			lTarget = GetLocation( oTarget );
			
			//if ( nCnt == 1 )
			//{
			//	fDelay = 0.0;
			//}
			//else fDelay = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
			fDelay = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
			
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			
			// * recalculate appropriate distances
			//fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
			//fDelay = fDist/(3.0 * log(fDist) + 2.0);
			
			// * determine the number of missles to fire at this target
			if ( nHasProcessedPrimary == TRUE )
			{
			    nMissilesForThisTarget = nMissilesAtOthers;
			
				// Any unallocated missles? try to launch a few here... 
				if ( nRemainingMissiles > 0 )
				{
					int nExtra = nMaxHits - nMissilesForThisTarget;
					if ( nExtra > nRemainingMissiles )
						nExtra = nRemainingMissiles; 
				
					nRemainingMissiles -= nExtra;
					nMissilesForThisTarget += nExtra;
				}
			}
			else
			{
				nMissilesForThisTarget = nMissilesAtPrimary;
			    nHasProcessedPrimary = TRUE;
			}
			
			int i = 0;
			//--------------------------------------------------------------
			// GZ: Moved SR check out of loop to have 1 check per target
			//     not one check per missile, which would rip spell mantels
			//     apart
			//--------------------------------------------------------------
			if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
			{
			    for (i=1; i <= nMissilesForThisTarget; i++)
			    {
					fTime = fDelay + ((nCnt - 1) * 0.25);
					fTime2 = ((nCnt - 1) * 0.25);	
							
			        //Roll damage
			        int nDam = d6(nD6Dice);
			        //Enter Metamagic conditions
                        if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                        {
                             nDam = nD6Dice*6;//Damage is at max
                        }
                        if ((nMetaMagic & METAMAGIC_EMPOWER))
			        {
			              nDam = nDam + nDam/2; //Damage/Healing is +50%
			        }
                        if(i == 1)
                        {
                            nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
                            DelayCommand(fDelay, PRCBonusDamage(oTarget));
                        }
			        // Jan. 29, 2004 - Jonathan Epp
			        // Reflex save was not being calculated for Firebrand
			        if(nReflexSave)
			        {
                            if(nDAMAGETYPE == DAMAGE_TYPE_FIRE)
                                nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_FIRE);
                            else if(nDAMAGETYPE == DAMAGE_TYPE_ELECTRICAL)
                                nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_ELECTRICITY);
                            else if(nDAMAGETYPE == DAMAGE_TYPE_COLD)
                                nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_COLD);
                            else if(nDAMAGETYPE == DAMAGE_TYPE_ACID)
                                nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_ACID);
                            else if(nDAMAGETYPE == DAMAGE_TYPE_SONIC)
                                nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_SONIC);
			        }
			
					/*
			        fTime = fDelay;
			        fDelay2 += 0.1;
			        fTime += fDelay2;
					*/
					
			        //Set damage effect
			        effect eDam = EffectDamage(nDam, nDAMAGETYPE);
					eDam = EffectLinkEffects( eDam, eVis );
			        //Apply the MIRV and damage effect
			        //DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	// NWN1 VFX
			        //DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));	// NWN1 VFX
			        DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand( fTime2, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
			    }
			} 
			else
			{   // * apply a dummy visual effect
			    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);	// NWN1 VFX
				DelayCommand( fTime2, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTarget, nSpell, nPathType) );
			}
			
			nCnt++;// * increment count of enemies processed
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

//::///////////////////////////////////////////////
//:: DoMagicFang
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +1 enhancement bonus to attack and damage rolls.
 Also applys damage reduction +1; this allows the creature
 to strike creatures with +1 damage reduction.

 Checks to see if a valid summoned monster or animal companion
 exists to apply the effects to. If none exists, then
 the spell is wasted.

FEB 19: Made it so only Animal Companions get these bonuses
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoMagicFang(int nPower, int nDamagePower,int nCasterLevel)
{
    //Declare major variables
    object oTarget = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);

    if (GetIsObjectValid(oTarget) == FALSE)
    {
            FloatingTextStrRefOnCreature(8962, OBJECT_SELF, FALSE);
            return; // has neither an animal companion
    }

    //Remove effects of anyother fang spells
    RemoveSpellEffects(452, GetMaster(oTarget), oTarget);
    RemoveSpellEffects(453, GetMaster(oTarget), oTarget);

    //effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);	// old NWN1 VFX
    effect eVis;
	if ( GetSpellId() == SPELL_MAGIC_FANG )	eVis = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_FANG );	// Check if we got here from Magic Fang; adjust VFX accordingly
	else 									eVis = EffectVisualEffect( VFX_DUR_SPELL_GREATER_MAGIC_FANG );	// otherwise assume that we cast Greater Magic Fang; adjust VFX accordingly
    int nMetaMagic = PRCGetMetaMagicFeat();

    effect eAttack = EffectAttackIncrease(nPower);
    effect eDamage = EffectDamageIncrease(nPower);
	effect eReduction;
	switch( nDamagePower )
	{
		case DAMAGE_POWER_PLUS_ONE:
			eReduction = EffectDamageReduction( nPower, DAMAGE_TYPE_MAGICAL, 0, DR_TYPE_DMGTYPE ); 	// * doing this because
                                                                  									// * it creates a true
                                                                  									// * enhancement bonus
			break;
		
		// stubs for 3.5 DR approximation
		case DAMAGE_POWER_PLUS_TWO:		
		case DAMAGE_POWER_PLUS_THREE:
		case DAMAGE_POWER_PLUS_FOUR:
		case DAMAGE_POWER_PLUS_FIVE:
		default:
			eReduction = EffectDamageReduction( nPower, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL );
			break;	
	}

    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    effect eLink = EffectLinkEffects(eAttack, eVis);
    eLink = EffectLinkEffects(eLink, eDamage);
    eLink = EffectLinkEffects(eLink, eReduction);

    int nDuration = nCasterLevel; // * Duration 1 turn/level
     if ((nMetaMagic & METAMAGIC_EXTEND))    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));

    //Apply VFX impact and bonus effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

//::///////////////////////////////////////////////
//:: DoCaltropEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The area effect will only do a total of
    25 points of damage and then destroy itself.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void DoCaltropEffect(object oTarget)
{

    //int nDam = 1;

 //   effect eVis = EffectVisualEffect(VFX_IMP_SPIKE_TRAP);
    //effect eLink = eDam;

    if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator())
     && spellsIsFlying(oTarget) == FALSE)
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), 471));
        {
            effect eDam = EffectDamage(1, DAMAGE_TYPE_PIERCING);
            float fDelay = GetRandomDelay(1.0, 2.2);
            //Apply damage and visuals
            //DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget)));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            int nDamageDone = GetLocalInt(OBJECT_SELF, "NW_L_TOTAL_DAMAGE");
            nDamageDone++;

            //  * storing variable on area of effect object
            SetLocalInt(OBJECT_SELF, "NW_L_TOTAL_DAMAGE", nDamageDone);
            if (nDamageDone == 25)
            {
                DestroyObject(OBJECT_SELF);
                object oImpactNode = GetLocalObject(OBJECT_SELF, "X0_L_IMPACT");
                if (GetIsObjectValid(oImpactNode) == TRUE)
                {
                    DestroyObject(oImpactNode);
                }
            }

        }
    }
}

//::///////////////////////////////////////////////
//:: CanCreatureBeDestroyed
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the creature is allowed
    to die (i.e., not plot)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int CanCreatureBeDestroyed(object oTarget)
{
    if (GetPlotFlag(oTarget) == FALSE && GetImmortal(oTarget) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}

//*GZ: 2003-07-23. honor critical and weapon spec
// nCrit -

int ArcaneArcherDamageDoneByBow(int bCrit = FALSE, object oUser = OBJECT_SELF)
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int nDamage;
    int bSpec = FALSE;

    if (GetIsObjectValid(oItem) == TRUE)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW )
        {
            nDamage = d8();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bSpec = TRUE;
            }
        }
        else
        if (GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW)
        {
            nDamage = d6();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bSpec = TRUE;
            }
        }
        else
            return 0;
    }
    else
    {
            return 0;
    }

    // add strength bonus
    int nStrength = GetAbilityModifier(ABILITY_STRENGTH,oUser);
    nDamage += nStrength;

    if (bSpec == TRUE)
    {
        nDamage +=2;
    }
    if (bCrit == TRUE)
    {
         nDamage *=3;
    }

    return nDamage;
}

//*GZ: 2003-07-23. Properly calculated enhancement bonus
int ArcaneArcherCalculateBonus()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);

    if (nLevel == 0) //not an arcane archer?
    {
        return 0;
    }
    int nBonus = ((nLevel+1)/2); // every odd level after 1 get +1
    return nBonus;
}


// *  This is a wrapper for how Petrify will work in Expansion Pack 1
// * Scripts affected: flesh to stone, breath petrification, gaze petrification, touch petrification
// * nPower : This is the Hit Dice of a Monster using Gaze, Breath or Touch OR it is the Caster Spell of
// *   a spellcaster
// * nFortSaveDC: pass in this number from the spell script
void DoPetrification(int nPower, object oSource, object oTarget, int nSpellID, int nFortSaveDC)
{

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // * exit if creature is immune to petrification
        if (spellsIsImmuneToPetrification(oTarget) == TRUE)
        {
            return;
        }
        float fDifficulty = 0.0;
        int bIsPC = GetIsPC(oTarget);
        int bShowPopup = FALSE;

        // * calculate Duration based on difficulty settings
        int nGameDiff = GetGameDifficulty();
        switch (nGameDiff)
        {
            case GAME_DIFFICULTY_VERY_EASY:
            case GAME_DIFFICULTY_EASY:
            case GAME_DIFFICULTY_NORMAL:
                    fDifficulty = RoundsToSeconds(nPower); // One Round per hit-die or caster level
                break;
            case GAME_DIFFICULTY_CORE_RULES:
            case GAME_DIFFICULTY_DIFFICULT:
                bShowPopup = TRUE;
            break;
        }

        int nSaveDC = nFortSaveDC;
        effect ePetrify = EffectPetrify();

        effect eDur = EffectVisualEffect( VFX_DUR_SPELL_FLESH_TO_STONE );

        effect eLink = EffectLinkEffects(eDur, ePetrify);

            // Let target know the negative spell has been cast
            SignalEvent(oTarget,
                        EventSpellCastAt(OBJECT_SELF, nSpellID));
                        //SpeakString(IntToString(nSpellID));

            // Do a fortitude save check
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC))
            {
                // Save failed; apply paralyze effect and VFX impact

                /// * The duration is permanent against NPCs but only temporary against PCs
                if (bIsPC == TRUE)
                {
                    if (bShowPopup == TRUE)
                    {
                        // * under hardcore rules or higher, this is an instant death
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                        //only pop up death panel if switch is not set
                        if(!GetPRCSwitch(PRC_NO_PETRIFY_GUI))
                        DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, 40579));
                        //run the PRC Ondeath code
                        //no way to run the normal module ondeath code too
                        //so a execute script has been added for builders to take advantage of
                        DelayCommand(2.75, ExecuteScript("prc_ondeath", oTarget));
                        DelayCommand(2.75, ExecuteScript("prc_pw_petrific", oTarget));
                        // if in hardcore, treat the player as an NPC
                        bIsPC = FALSE;
                        //fDifficulty = TurnsToSeconds(nPower); // One turn per hit-die
                    }
                    else
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDifficulty);
                }
                else
                {
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);

                    //----------------------------------------------------------
                    // GZ: Fix for henchmen statues haunting you when changing
                    //     areas. Henchmen are now kicked from the party if
                    //     petrified.
                    //----------------------------------------------------------
                    if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_HENCHMAN)
                    {
                        FireHenchman(GetMaster(oTarget),oTarget);
                    }

                }
                // April 2003: Clearing actions to kick them out of conversation when petrified
                AssignCommand(oTarget, ClearAllActions(TRUE));
            }
    }

}



// * generic area of effect constructor
void spellsGenericAreaOfEffect(
        object oCaster, location lTargetLoc,
        int nShape, float fRadiusSize, int nSpellID,
        effect eImpact, effect eLink, effect eVis,
        int nDurationType=DURATION_TYPE_INSTANT, float fDuration = 0.0,
        int nTargetType=SPELL_TARGET_ALLALLIES, int bHarmful = FALSE,
        int nRemoveEffectSpell=FALSE, int nRemoveEffect1=0, int nRemoveEffect2=0, int nRemoveEffect3=0,
        int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE,
        int bPersistentObject=FALSE, int bResistCheck=FALSE, int nSavingThrowType=SAVING_THROW_NONE,
        int nSavingThrowSubType=SAVING_THROW_TYPE_ALL
        )
{
    //Apply Impact
    if (GetEffectType(eImpact) != 0)
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTargetLoc);
    }

    object oTarget = OBJECT_INVALID;
    float fDelay = 0.0;

    int nPenetr = PRCGetCasterLevel(oCaster);
    //Get the first target in the radius around the caster
    if (bPersistentObject == TRUE)
        oTarget = GetFirstInPersistentObject();
    else
        oTarget = GetFirstObjectInShape(nShape, fRadiusSize, lTargetLoc, bLineOfSight, nObjectFilter);

    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, nTargetType, oCaster) == TRUE)
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, bHarmful));
            int nResistSpellSuccess = FALSE;
            // * actually perform the resist check
            if (bResistCheck == TRUE)
            {
                nResistSpellSuccess = MyPRCResistSpell(oCaster, oTarget,nPenetr);
            }
          if(!nResistSpellSuccess)
          {
                int nDC = PRCGetSaveDC(oTarget, oCaster);
                int nSavingThrowSuccess = FALSE;
                // * actually roll saving throw if told to
                if (nSavingThrowType != SAVING_THROW_NONE)
                {
                  nSavingThrowSuccess = PRCMySavingThrow(nSavingThrowType, oTarget, nDC, nSavingThrowSubType);
                }
                if (!nSavingThrowSuccess)
                {
                    fDelay = GetRandomDelay(0.4, 1.1);



                    //Apply VFX impact
                    if (GetEffectType(eVis) != 0)
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }

                    // * Apply effects
                   // if (GetEffectType(eLink) != 0)
                   // * Had to remove this test because LINKED effects have no valid type.
                    {

                        DelayCommand(fDelay, ApplyEffectToObject(nDurationType, eLink, oTarget, fDuration));
                    }

                    // * If this is a removal spell then perform the appropriate removals
                    if (nRemoveEffectSpell == TRUE)
                    {
                        //Remove effects
                        RemoveSpecificEffect(nRemoveEffect1, oTarget);
                        if(nRemoveEffect2 != 0)
                        {
                            RemoveSpecificEffect(nRemoveEffect2, oTarget);
                        }
                        if(nRemoveEffect3 != 0)
                        {
                            RemoveSpecificEffect(nRemoveEffect3, oTarget);
                        }

                    }
                }// saving throw
            } // resist spell check
        }
        //Get the next target in the specified area around the caster
        if (bPersistentObject == TRUE)
            oTarget = GetNextInPersistentObject();
        else
            oTarget = GetNextObjectInShape(nShape, fRadiusSize, lTargetLoc, bLineOfSight, nObjectFilter);

    }
}

//::///////////////////////////////////////////////
//:: ApplyMindBlank
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies Mind blank to the target
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void spellApplyMindBlank(object oTarget, int nSpellId, float fDelay=0.0)
{
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	effect eVis;
	if ( nSpellId == SPELL_LESSER_MIND_BLANK )
	{
		eVis = EffectVisualEffect( VFX_DUR_SPELL_LESSER_MIND_BLANK );
	}
	else if ( nSpellId == SPELL_MIND_BLANK )
	{
		eVis = EffectVisualEffect( VFX_DUR_SPELL_MIND_BLANK );	
	}
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX

    effect eLink = EffectLinkEffects(eImm1, eVis);
    effect eSearch = GetFirstEffect(oTarget);
    int bValid;
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Enter Metamagic conditions
    if (nMetaMagic & METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));

    //Search through effects
    while(GetIsEffectValid(eSearch))
    {
        bValid = FALSE;
        //Check to see if the effect matches a particular type defined below
        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
        {
            bValid = TRUE;
        }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_DOMINATED)
        {
            bValid = TRUE;
        }
    // * Additional March 2003
    // * Remove any feeblemind originating effects
        else if (GetEffectSpellId(eSearch) == SPELL_FEEBLEMIND)
        {
            bValid = TRUE;
        }
        else if (GetEffectSpellId(eSearch) == SPELL_BANE)
        {
            bValid = TRUE;
        }

        //Apply damage and remove effect if the effect is a match
        if (bValid == TRUE)
        {
            RemoveEffect(oTarget, eSearch);
        }
        eSearch = GetNextEffect(oTarget);
    }

    //After effects are removed we apply the immunity to mind spells to the target
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
    //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	// NWN1 VFX
}
//::///////////////////////////////////////////////
//:: doAura
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used in the Alignment aura - unholy and holy
    aura scripts fromthe original campaign
    spells. Cleaned them up to be consistent.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void doAura(int nAlign, int nVis1, int nVis2, int nDamageType)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    float fDuration = RoundsToSeconds(PRCGetCasterLevel(OBJECT_SELF));

    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eVis = EffectVisualEffect(nVis1);
    effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
    //Change the effects so that it only applies when the target is evil
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eSR = EffectSpellResistanceIncrease(25); //Check if this is a bonus or a setting.
    //effect eDur = EffectVisualEffect(nVis2);	// NWN1 VFX
    //effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);	// NWN1 VFX
    effect eShield = EffectDamageShield(6, DAMAGE_BONUS_1d8, nDamageType);


    // * make them versus the alignment

    eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, nAlign);
    eSR = VersusAlignmentEffect(eSR,ALIGNMENT_ALL, nAlign);
    eAC =  VersusAlignmentEffect(eAC,ALIGNMENT_ALL, nAlign);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
    eShield = VersusAlignmentEffect(eShield,ALIGNMENT_ALL, nAlign);


    //Link effects
    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSR);
    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX
    //eLink = EffectLinkEffects(eLink, eDur2);	// NWN1 VFX
    eLink = EffectLinkEffects(eLink, eShield);
    eLink = EffectLinkEffects(eLink, eVis);	// NWN2 VFX

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));

    //Apply the VFX impact and effects
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
	
void DoStinkingCloud(object oTarget, object oSource, int nSaveDC, effect eVis, effect eStink)
{
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
		SignalEvent(oTarget, EventSpellCastAt(oSource, GetSpellId()));
		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_POISON))
		{
			if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
            {
				float fDelay = GetRandomDelay(0.75, 1.75);
        		//Apply the VFX impact and linked effects
        		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStink, oTarget, RoundsToSeconds(2)));
            }
		}
	}	
}

// * Does a stinking cloud. If oTarget is Invalid, then does area effect, otherwise
// * just attempts on otarget
//
//	BrianH - OEI: 04/22/2006 - changed to use own logic rather than GenericAOE. SaveDC is now passed in.
void spellsStinkingCloud(object oTarget = OBJECT_INVALID, int nSaveDC = 15)
{
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// NWN1 VFX
    effect eLink = EffectLinkEffects(eMind, eStink);
    //eLink = EffectLinkEffects(eLink, eDur);	// NWN1 VFX

    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_CONJURATION);

    if (GetIsObjectValid(oTarget) == TRUE)
    {
    	DoStinkingCloud(oTarget, OBJECT_SELF, nSaveDC, eVis, eStink);
    }
    else
    {
      	oTarget = GetFirstInPersistentObject();
      	while (GetIsObjectValid(oTarget))
      	{
    		DoStinkingCloud(oTarget, OBJECT_SELF, nSaveDC, eVis, eStink);
			oTarget = GetNextInPersistentObject();
      	}
    }
}

//::///////////////////////////////////////////////
//:: RemoveSpellEffects2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Advanced version of RemoveSpellEffects to
    handle multiple spells (allows code reuse
    for shadow conjuration darkness)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void RemoveSpellEffects2(int nSpell_ID, object oCaster, object oTarget, int nSpell_ID2, int nSpell_ID3)
{

    //Declare major variables
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(nSpell_ID, oTarget) || GetHasSpellEffect(nSpell_ID2, oTarget) || GetHasSpellEffect(nSpell_ID3, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == oCaster)
            {
                //If the effect was created by the spell then remove it
                if(GetEffectSpellId(eAOE) == nSpell_ID || GetEffectSpellId(eAOE) == nSpell_ID2
                 || GetEffectSpellId(eAOE) == nSpell_ID3)
                {
                    RemoveEffect(oTarget, eAOE);
                    bValid = TRUE;
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

// * returns true if the creature has flesh
int spellsIsImmuneToPetrification(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bImmune = FALSE;
    switch (nAppearance)
    {
    case APPEARANCE_TYPE_BASILISK:
    case APPEARANCE_TYPE_COCKATRICE:
    case APPEARANCE_TYPE_MEDUSA:
    case APPEARANCE_TYPE_ALLIP:
    case APPEARANCE_TYPE_ELEMENTAL_AIR:
    case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
    case APPEARANCE_TYPE_ELEMENTAL_EARTH:
    case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
    case APPEARANCE_TYPE_ELEMENTAL_FIRE:
    case APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER:
    case APPEARANCE_TYPE_ELEMENTAL_WATER:
    case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
    case APPEARANCE_TYPE_GOLEM_STONE:
    case APPEARANCE_TYPE_GOLEM_IRON:
    case APPEARANCE_TYPE_GOLEM_CLAY:
    case APPEARANCE_TYPE_GOLEM_BONE:
    case APPEARANCE_TYPE_GORGON:
    case APPEARANCE_TYPE_HEURODIS_LICH:
    case APPEARANCE_TYPE_LANTERN_ARCHON:
    case APPEARANCE_TYPE_SHADOW:
    case APPEARANCE_TYPE_SHADOW_FIEND:
    case APPEARANCE_TYPE_SHIELD_GUARDIAN:
    case APPEARANCE_TYPE_SKELETAL_DEVOURER:
    case APPEARANCE_TYPE_SKELETON_CHIEFTAIN:
    case APPEARANCE_TYPE_SKELETON_COMMON:
    case APPEARANCE_TYPE_SKELETON_MAGE:
    case APPEARANCE_TYPE_SKELETON_PRIEST:
    case APPEARANCE_TYPE_SKELETON_WARRIOR:
    case APPEARANCE_TYPE_SKELETON_WARRIOR_1:
    case APPEARANCE_TYPE_SPECTRE:
    case APPEARANCE_TYPE_WILL_O_WISP:
    case APPEARANCE_TYPE_WRAITH:
    case APPEARANCE_TYPE_BAT_HORROR:
    case 405: // Dracolich:
    case 415: // Alhoon
    case 418: // shadow dragon
    case 420: // mithral golem
    case 421: // admantium golem
    case 430: // Demi Lich
    case 469: // animated chest
    case 474: // golems
    case 475: // golems
        bImmune = TRUE;
    }
    int nRacialType = MyPRCGetRacialType(oCreature);
    switch(nRacialType)
    {
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_OOZE:
        case RACIAL_TYPE_UNDEAD:
        bImmune = TRUE;
    }



    // * GZ: Sept 2003 - Prevent people from petrifying DM, resulting in GUI even when
    //                   effect is not successful.
    if (!GetPlotFlag(oCreature) && GetIsDM(oCreature))
    {
       bImmune = FALSE;
    }
    return bImmune;
}

// * Returns true or false depending on whether the creature is flying
// * or not
int spellsIsFlying(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bFlying = FALSE;
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ALLIP:
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_FAERIE_DRAGON:
        case APPEARANCE_TYPE_FALCON:
        case APPEARANCE_TYPE_FAIRY:
        case APPEARANCE_TYPE_HELMED_HORROR:
        case APPEARANCE_TYPE_IMP:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case APPEARANCE_TYPE_MEPHIT_AIR:
        case APPEARANCE_TYPE_MEPHIT_DUST:
        case APPEARANCE_TYPE_MEPHIT_EARTH:
        case APPEARANCE_TYPE_MEPHIT_FIRE:
        case APPEARANCE_TYPE_MEPHIT_ICE:
        case APPEARANCE_TYPE_MEPHIT_MAGMA:
        case APPEARANCE_TYPE_MEPHIT_OOZE:
        case APPEARANCE_TYPE_MEPHIT_SALT:
        case APPEARANCE_TYPE_MEPHIT_STEAM:
        case APPEARANCE_TYPE_MEPHIT_WATER:
        case APPEARANCE_TYPE_QUASIT:
        case APPEARANCE_TYPE_RAVEN:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_SPECTRE:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_WRAITH:
        case APPEARANCE_TYPE_WYRMLING_BLACK:
        case APPEARANCE_TYPE_WYRMLING_BLUE:
        case APPEARANCE_TYPE_WYRMLING_BRASS:
        case APPEARANCE_TYPE_WYRMLING_BRONZE:
        case APPEARANCE_TYPE_WYRMLING_COPPER:
        case APPEARANCE_TYPE_WYRMLING_GOLD:
        case APPEARANCE_TYPE_WYRMLING_GREEN:
        case APPEARANCE_TYPE_WYRMLING_RED:
        case APPEARANCE_TYPE_WYRMLING_SILVER:
        case APPEARANCE_TYPE_WYRMLING_WHITE:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case 401: //beholder
        case 402: //beholder
        case 403: //beholder
        case 419: // harpy
        case 430: // Demi Lich
        case 472: // Hive mother
        bFlying = TRUE;
    }
    return bFlying;
}

// * returns true if oCreature does not have a mind
int spellsIsMindless(object oCreature)
{
    int nRacialType = MyPRCGetRacialType(oCreature);
    int nMindless;
    switch(nRacialType)
    {
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_VERMIN:
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_OOZE:
        nMindless = TRUE;
    }
    if(GetAbilityScore(oCreature, ABILITY_INTELLIGENCE) > 3)
        nMindless = FALSE;

    return nMindless;
}


//------------------------------------------------------------------------------
// Doesn't care who the caster was removes the effects of the spell nSpell_ID.
// will ignore the subtype as well...
// GZ: Removed the check that made it remove only one effect.
//------------------------------------------------------------------------------
void RemoveAnySpellEffects(int nSpell_ID, object oTarget)
{
    //Declare major variables

    effect eAOE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            //If the effect was created by the spell then remove it
            if(GetEffectSpellId(eAOE) == nSpell_ID)
            {
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}

void OnDispelEffect( object oTarget, int nSpellID )
{
	// Do nothing for now
}

//------------------------------------------------------------------------------
// Attempts a dispel on one target, with all safety checks put in.
//------------------------------------------------------------------------------
void spellsDispelMagic(object oTarget, int nCasterLevel, effect eVis, effect eImpac, int bAll = TRUE, int bBreachSpells = FALSE)
{
    //--------------------------------------------------------------------------
    // Don't dispel magic on petrified targets
    // this change is in to prevent weird things from happening with 'statue'
    // creatures. Also creature can be scripted to be immune to dispel
    // magic as well.
    //--------------------------------------------------------------------------
    if (GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) == TRUE || GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") == 10)
    {
        return;
    }

    effect eDispel;
    float fDelay = GetRandomDelay(0.1, 0.3);
    int nId = PRCGetSpellId();

    //--------------------------------------------------------------------------
    // Fire hostile event only if the target is hostile...
    //--------------------------------------------------------------------------
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId));
    }
    else
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));
    }

    //--------------------------------------------------------------------------
    // GZ: Bugfix. Was always dispelling all effects, even if used for AoE
    //--------------------------------------------------------------------------
    if (bAll == TRUE )
    {
        eDispel = EffectDispelMagicAll(nCasterLevel, OnDispelEffect( oTarget, nId ) );
        //----------------------------------------------------------------------
        // GZ: Support for Mord's disjunction
        //----------------------------------------------------------------------
        if (bBreachSpells)
        {
            DoSpellBreach(oTarget, 6, 10, nId);
        }
    }
    else
    {
        eDispel = EffectDispelMagicBest(nCasterLevel, OnDispelEffect( oTarget, nId ) );
        if (bBreachSpells)
        {
           DoSpellBreach(oTarget, 2, 10, nId);
        }
    }

    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget));
}

//------------------------------------------------------------------------------
// GZ: Aug 27 2003
// Return the hightest spellcasting class of oCreature, used for dispel magic
// workaround
//------------------------------------------------------------------------------
int GZGetHighestSpellcastingClassLevel(object oCreature)
{
    int nMax;
    if (GetIsPC(oCreature))
    {
        int i;
        int nClass;
        int nLevel;
        for (i =1; i<= 3; i++)
        {
            // This is kind of hacky as high level pally's and ranger's will
            // dispell at their full class level...
            nClass= GetClassByPosition(i,oCreature);
            if (nClass != CLASS_TYPE_INVALID)
            {
                if (nClass ==  CLASS_TYPE_SORCERER || nClass ==  CLASS_TYPE_WIZARD ||
                    nClass ==  CLASS_TYPE_PALEMASTER || nClass == CLASS_TYPE_CLERIC ||
                    nClass == CLASS_TYPE_DRUID || nClass == CLASS_TYPE_BARD ||
                    nClass == CLASS_TYPE_RANGER || nClass == CLASS_TYPE_PALADIN)
                {
                    nLevel = GetLevelByClass(nClass,oCreature);

                    if (nLevel> nMax)
                    {
                        nMax = nLevel;
                    }
                }
            }
        }
    }

    else
    {
        //* not a creature ... be unfair and count full HD :)
        nMax = GetHitDice(oCreature);
    }

    return nMax;
}

//------------------------------------------------------------------------------
// returns TRUE if a creature is not in the condition to use gaze attacks
// i.e. blindness
//------------------------------------------------------------------------------
int GZCanNotUseGazeAttackCheck(object oCreature)
{
    if (GetHasEffect( EFFECT_TYPE_BLINDNESS,oCreature))
    {
        FloatingTextStrRefOnCreature(84530, oCreature ,FALSE); // * blinded
        return TRUE;
    }
    return FALSE;
}

//------------------------------------------------------------------------------
// Handle Dispelling Area of Effects
// Before adding this AoE's got automatically destroyed. Since NWN does not give
// the required information to do proper dispelling on AoEs, we do some simulated
// stuff here:
// - Base chance to dispel is 25, 50, 75 or 100% depending on the spell
// - Chance is modified positive by the caster level of the spellcaster as well
// - as the relevant ability score
// - Chance is modified negative by the highest spellcasting class level of the
//   AoE creator and the releavant ability score.
// Its bad, but its not worse than just dispelling the AoE as the game did until
// now
//------------------------------------------------------------------------------
void spellsDispelAoE(object oTargetAoE, object oCaster, int nCasterLevel)
{
    object oCreator = GetAreaOfEffectCreator(oTargetAoE);
    int nChance;
    int nId   = PRCGetSpellId();
    if ( nId == SPELL_LESSER_DISPEL )
    {
        nChance = 25;
    }
    else if ( nId == SPELL_DISPEL_MAGIC)
    {
        nChance = 50;
    }
    else if ( nId == SPELL_GREATER_DISPELLING )
    {
        nChance = 75;
    }
    else if ( nId == SPELL_MORDENKAINENS_DISJUNCTION )
    {
        nChance = 100;
    }


    nChance += ((nCasterLevel + GetCasterAbilityModifier(oCaster)) - (10  + GetCasterAbilityModifier(oCreator))*2) ;

    //--------------------------------------------------------------------------
    // the AI does cheat here, because it can not react as well as a player to
    // AoE effects. Also DMs are always successful
    //--------------------------------------------------------------------------
    if (!GetIsPC(oCaster))
    {
        nChance +=30;
    }

    if (oCaster == oCreator)
    {
        nChance = 100;
    }

    int nRand = Random(100);

    if ((nRand < nChance )|| GetIsDM(oCaster) || GetIsDMPossessed(oCaster))
    {
        FloatingTextStrRefOnCreature(100929,oCaster);  // "AoE dispelled"
        DestroyObject (oTargetAoE);
    }
    else
    {
        FloatingTextStrRefOnCreature(100930,oCaster); // "AoE not dispelled"
    }

}

//void main() {}