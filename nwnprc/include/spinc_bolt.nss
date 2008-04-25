/////////////////////////////////////////////////////////////////////////
//
// DoBolt - Function to apply an elemental bolt damage effect given
// the following arguments:
//
//        nDieSize - die size to roll (d4, d6, or d8)
//        nBonusDam - bonus damage per die, or 0 for none
//        nDice = number of dice to roll.
//        nBoltEffect - visual effect to use for bolt(s)
//        nVictimEffect - visual effect to apply to target(s)
//        nDamageType - elemental damage type of the cone (DAMAGE_TYPE_xxx)
//        nSaveType - save type used for cone (SAVING_THROW_TYPE_xxx)
//        nSchool - spell school, defaults to SPELL_SCHOOL_EVOCATION.
//        fDoKnockdown - flag indicating whether spell does knockdown, defaults to FALSE.
//        nSpellID - spell ID to use for events
//
/////////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"

float GetVFXLength(location lCaster, float fLength, float fAngle);

void DoBolt(int nCasterLevel, int nDieSize, int nBonusDam, int nDice, int nBoltEffect,
     int nVictimEffect, int nDamageType, int nSaveType,
     int nSchool = SPELL_SCHOOL_EVOCATION, int nDoKnockdown = FALSE, int nSpellID = -1, float fRangeFt = 120.0f)
{
     // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
     //if (!X2PreSpellCastCode()) return;

     PRCSetSchool(nSchool);
     
     object oCaster = OBJECT_SELF;

     // Get the spell ID if it was not given.
     if (-1 == nSpellID) nSpellID = PRCGetSpellId();

     // Adjust the damage type if necessary.
     nDamageType = PRCGetElementalDamageType(nDamageType, OBJECT_SELF);

    int nDamage;
    int nSaveDC;
    int bKnockdownTarget;
    float fDelay;

    int nPenetr = nCasterLevel + SPGetPenetr();

    // individual effect
    effect eVis  = EffectVisualEffect(nVictimEffect);
    effect eKnockdown = EffectKnockdown();
    effect eDamage;
    
    // where is the caster?
    location lCaster = GetLocation(oCaster);

    // where is the target?
    location lTarget = PRCGetSpellTargetLocation();
    vector vOrigin = GetPosition(oCaster);
    float fLength = FeetToMeters(fRangeFt);
    
    // run away! Vector maths coming up...
    // VFX length
    float fAngle             = GetRelativeAngleBetweenLocations(lCaster, lTarget);
    float fVFXLength         = GetVFXLength(lCaster, fLength, fAngle);
    float fDuration          = 3.0f;
    

    BeamLineFromCenter(DURATION_TYPE_TEMPORARY, nBoltEffect, lCaster, fVFXLength, fAngle, fDuration, "prc_invisobj", 0.0f, "z", 0.0f, 0.0f,
                      -1, -1, 0.0f, 1.0f, // no secondary VFX
                      fDuration);
                      
    // spell damage effects
    // Loop over targets in the spell shape
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oCaster && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            // Let the AI know
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oCaster);
            // Reset the knockdown target flag.
            bKnockdownTarget = FALSE;
            // Make an SR check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                // Roll damage
                nDamage = PRCGetMetaMagicDamage(nDamageType, nDice, nDieSize, nBonusDam);
                int nFullDamage = nDamage;
                
                // Do save
                nSaveDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                if(nSaveType == SAVING_THROW_TYPE_COLD)
                {
                    // Cold has a fort save for half
                    if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, nSaveType))
                    {
                        if (GetHasMettle(oTarget, SAVING_THROW_FORT))
                            nDamage = 0;
                        nDamage /= 2;
                    }
                }
                else
                    // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, nSaveType);

                if(nDamage > 0)
                {
                    fDelay = GetDistanceBetweenLocations(lCaster, GetLocation(oTarget)) / 20.0f;
                    eDamage = EffectDamage(nDamage, nDamageType);
                    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    DelayCommand(1.0f + fDelay, PRCBonusDamage(oTarget));
                    DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }// end if - There was still damage remaining to be dealt after adjustments
                                        
                // Determine if the target needs to be knocked down.  The target is knocked down
                // if all of the following criteria are met:
                //    - Knockdown is enabled.
                //    - The damage from the spell didn't kill the creature
                //    - The creature is large or smaller
                //    - The creature failed it's reflex save.
                // If the spell does knockdown we need to figure out whether the target made or failed
                // the reflex save.  If the target doesn't have improved evasion this is easy, if the
                // damage is the same as the original damage then the target failed it's save.  If the
                // target has improved evasion then it's harder as the damage is halved even on a failed
                // save, so we have to catch that case.
                bKnockdownTarget = nDoKnockdown && !GetIsDead(oTarget) &&
                           PRCGetCreatureSize(oTarget) <= CREATURE_SIZE_LARGE &&
                           (nFullDamage == nDamage || (0 != nDamage && GetHasFeat(FEAT_IMPROVED_EVASION, oTarget)));
                // If we're supposed to apply knockdown then do so for 1 round.
                 if (bKnockdownTarget)
                      SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(1),TRUE,-1,nCasterLevel);
                
            }// end if - SR check
        }// end if - Target validity check

       // Get next target
        oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
    }// end while - Target loop

     PRCSetSchool();
}

// taken with minor modification from  psi_power_enbolt

float GetVFXLength(location lCaster, float fLength, float fAngle)
{
    float fLowerBound = 0.0f;
    float fUpperBound = fLength;
    float fVFXLength  = fLength / 2;
    vector vVFXOrigin = GetPositionFromLocation(lCaster);
    vector vAngle     = AngleToVector(fAngle);
    vector vVFXEnd;
    int bConverged    = FALSE;
    while(!bConverged)
    {
        // Create the test vector for this loop
        vVFXEnd = vVFXOrigin + (fVFXLength * vAngle);

        // Determine which bound to move.
        if(LineOfSightVector(vVFXOrigin, vVFXEnd))
            fLowerBound = fVFXLength;
        else
            fUpperBound = fVFXLength;

        // Get the new middle point
        fVFXLength = (fUpperBound + fLowerBound) / 2;

        // Check if the locations have converged
        if(fabs(fUpperBound - fLowerBound) < 2.5f)
            bConverged = TRUE;
    }

    return fVFXLength;
}


// Test main
//void main(){}
