/*
   ----------------
   Energy Bolt

   psi_pow_enbolt
   ----------------

   6/11/04 by Stratovarius

    Psychokinesis [see text]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: 120 ft.
    Area: 120-ft. line
    Duration: Instantaneous
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: Yes
    Power Points: 5
    Metapsionics: Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You release a powerful stroke of energy of the chosen type that deals 5d6
    points of damage to every creature or object within the area. The beam
    begins at your fingertips.

    Cold: A bolt of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold bolt is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a bolt of this energy type provides a +2 bonus to
                 the save DC and a +2 bonus on manifester level checks for the
                 purpose of overcoming power resistance.
    Fire: A bolt of this energy type deals +1 point of damage per die.
    Sonic: A bolt of this energy type deals -1 point of damage per die and
           ignores an object’s hardness.

    This power’s subtype is the same as the type of energy you manifest.

    Augment: For every additional power point you spend, this power’s damage
             increases by one die (d6). For each extra two dice of damage,
             this power’s save DC increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"
#include "psi_inc_enrgypow"
/*
vector ornHack_RotateVectorInSpace(vector v, float fRotate)
{
    // Heavyish operation, so avoid if unnecessary
    if(fRotate != 0.0f)
    {
        // Determine the length of the vector
        float fLength = sqrt((v.x * v.x) + (v.z * v.z));
        // Determine the angle of the vector relative to the Z axle
        float fAngle  = acos(v.z / fLength);
        // Adjust for arcuscosine ambiquity
        if(v.x < 0.0f) fAngle = 360.0f - fAngle;

        // Add in the new angle to rotate by and calculate new coordinates
        fAngle += fRotate;
        v.x = fLength * sin(fAngle);
        v.z = fLength * cos(fAngle);
    }

    return v;
}
*/
vector gao_RotateVector_Hackd(vector vCenter, string sAxis, float x, float y, float z, float fRotateXZ)
{
    // Heavyish operation, so avoid if unnecessary
    if(fRotateXZ != 0.0f)
    {
        // Determine the length of the vector
        float fLength = sqrt((x * x) + (z * z));
        // Determine the angle of the vector relative to the Z axle
        float fAngle  = acos(z / fLength);
        // Adjust for arcuscosine ambiquity
        if(x < 0.0f) fAngle = 360.0f - fAngle;

        // Add in the new angle to rotate by and calculate new coordinates
        fAngle += fRotateXZ;
        x = fLength * sin(fAngle);
        z = fLength * cos(fAngle);
    }

    vector vPos;
    if (sAxis == "x") vPos = Vector(y, z, x) ;
    else if (sAxis == "y") vPos = Vector(z, x, y) ;
    else vPos = Vector(x, y, z) ;
    return vPos + vCenter ;
}

object LocalObjectBeamGengon(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, string sTemplate="", float fTime=6.0f, float fWait=1.0f, float fRotate = 0.0f, float fTwist=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f, float fLifetime=0.0f, string sTag="PSC_B_GENGON", float fDirection = 0.0f)
{
    int i;
    if (nSides < 3) nSides = 3;
    if (fWait < 1.0) fWait = 1.0;
    if (fWait2 < 1.0) fWait2 = 1.0;
    if (fTime < 0.0) fTime = 6.0;
    if (fLifetime < 0.0) fLifetime = 0.0;
    if (sTemplate == "") sTemplate = "prc_invisobj";
    float fEta = 360.0/IntToFloat(nSides); // angle of segment
    float fDelay = fTime/IntToFloat(3*nSides); // delay per edge
    vector vCenter = GetPositionFromLocation(lCenter);
    object oArea = GetAreaFromLocation(lCenter);
    float f, fAngle;
    object oData;
    location lPos;
    fTwist += fRotate;
    fWait += fDelay;
    string sNumber1, sNumber2;
    oData = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter, FALSE, sTag);
    AssignCommand(oData, ActionDoCommand(SetLocalInt(oData, "storetotal", 2*nSides)));

    for (i = 0; i < 2*nSides; i++)
    {
        f = IntToFloat(i);
        if (i<nSides)
        {
            fAngle = fEta*f + fRotate;
            lPos = Location(oArea, gao_RotateVector_Hackd(vCenter, sAxis,
                                                          fRadiusStart * cos(fAngle),
                                                          fRadiusStart * sin(fAngle),
                                                          fHeightStart,
                                                          fDirection
                                                          ),
                            fAngle
                            );
        }
        else
        {
            fAngle = fEta*f + fTwist;
            lPos = Location(oArea, gao_RotateVector_Hackd(vCenter, sAxis,
                                                          fRadiusEnd * cos(fAngle),
                                                          fRadiusEnd * sin(fAngle),
                                                          fHeightEnd,
                                                          fDirection
                                                          ),
                            fAngle
                            );
        }
        sNumber1 = "store"+IntToString(i);
        DelayCommand(fDelay*f, gao_ActionCreateLocalObject(sTemplate, lPos, sNumber1, oData, nDurationType2, nVFX2, fDuration2, fWait2, fLifetime));
    }

    for (i=0; i<2*nSides; i++)
    {
        f = (i<nSides) ? IntToFloat(i) : IntToFloat(i+nSides);
        sNumber1 = "store" + IntToString(i);
        sNumber2 = (i==nSides-1) ? "store0" : (i==2*nSides-1) ? "store" + IntToString(nSides) : "store" + IntToString(i+1);
        DelayCommand(fDelay*f+fWait, gao_ActionApplyLocalBeamEffect(oData, sNumber1, sNumber2, nDurationType, nVFX, fDuration));
    }
    for (i=0; i<nSides; i++)
    {
         f = IntToFloat(i + nSides);
         sNumber1 = "store" + IntToString(i);
         sNumber2 = "store" + IntToString(i + nSides);
         DelayCommand(fDelay*f+fWait, gao_ActionApplyLocalBeamEffect(oData, sNumber1, sNumber2, nDurationType, nVFX, fDuration));
    }

    if (fLifetime > 0.0)
    {
        DestroyObject(oData, fLifetime + fTime + fWait + fWait2 + 5.0);
        return OBJECT_INVALID;
    }
    return oData;
}

object LocalObjectBeamPolygonalSpring(int nDurationType, int nVFX, location lCenter, float fRadiusStart, float fRadiusEnd=0.0f, float fHeightStart=0.0f, float fHeightEnd=5.0f, int nSides=3, float fDuration=0.0f, string sTemplate="", float fRev=5.0f, float fTime=6.0f, float fRotate=0.0f, string sAxis="z", int nDurationType2=-1, int nVFX2=-1, float fDuration2=0.0f, float fWait2=1.0f, float fLifetime=0.0f, string sTag="PSC_B_POLYGONALSPRING", float fDirection = 0.0f)
{
    int i;
    if (nSides < 3) nSides = 3;
    if (fWait2 < 1.0) fWait2 = 1.0;
    if (fTime < 0.0) fTime = 6.0;
    if (fLifetime < 0.0) fLifetime = 0.0;
    if (fRev == 0.0) fRev = 5.0;
    if (sTemplate == "") sTemplate = "prc_invisobj";
    float fEta = (fRev > 0.0) ? 360.0/IntToFloat(nSides) : -360.0/IntToFloat(nSides); // angle of segment
    float fSidesToDraw = (fRev > 0.0) ? fRev*IntToFloat(nSides) : -fRev*IntToFloat(nSides); // total number of sides to draw including revolutions as float value
    int nSidesToDraw = FloatToInt(fSidesToDraw); // total number of sides to draw including revolutions as int value
    float fDecay = (fRadiusStart - fRadiusEnd)/fSidesToDraw; // change in radius per side
    float fGrowth = (fHeightStart - fHeightEnd)/fSidesToDraw; // change in height per side
    float fDelayPerSide = fTime/fSidesToDraw;
    vector vCenter = GetPositionFromLocation(lCenter);
    vector vOffset;
    object oArea = GetAreaFromLocation(lCenter);
    float f, fAngle;
    object oData;
    location lPos;
    float fWait = 1.0;

    oData = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lCenter, FALSE, sTag);
    AssignCommand(oData, ActionDoCommand(SetLocalInt(oData, "storetotal", nSidesToDraw + 1)));

    for (i = 0; i <= nSidesToDraw; i++)
    {
        f = IntToFloat(i);
        fAngle = fEta*f + fRotate;
        lPos = Location(oArea, gao_RotateVector_Hackd(vCenter, sAxis,
                                                      (fRadiusStart - fDecay * f) * cos(fAngle),
                                                      (fRadiusStart - fDecay * f) * sin(fAngle),
                                                      fHeightStart - fGrowth * f,
                                                      fDirection
                                                      ),
                        fAngle
                        );
        DelayCommand(f*fDelayPerSide, gao_ActionCreateLocalObject(sTemplate, lPos, "store" + IntToString(i), oData, nDurationType2, nVFX2, fDuration2, fWait2, fLifetime));
        if (i > 0) DelayCommand(f*fDelayPerSide+fWait, gao_ActionApplyLocalBeamEffect(oData, "store" + IntToString(i-1), "store" + IntToString(i), nDurationType, nVFX, fDuration));
    }

    if (fLifetime > 0.0)
    {
       DestroyObject(oData, fLifetime + fTime + fWait + fWait2 + 5.0);
       return OBJECT_INVALID;
    }
    return oData;
}

float GetVFXLength(location lManifester, float fLength, float fAngle);

void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateManifestation(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(2,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN | METAPSIONIC_WIDEN
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, POWER_ENERGYBOLT_COLD, POWER_ENERGYBOLT_ELEC, POWER_ENERGYBOLT_FIRE, POWER_ENERGYBOLT_SONIC,
                           VFX_BEAM_COLD, VFX_BEAM_LIGHTNING, VFX_BEAM_FIRE, VFX_BEAM_MIND);
        int nDC              = GetManifesterDC(oManifester) + manif.nTimesGenericAugUsed + enAdj.nDCMod;
        int nPen             = GetPsiPenetration(oManifester) + enAdj.nPenMod;
        int nNumberOfDice    = 5 + manif.nTimesAugOptUsed_1;
        int nDieSize         = 6;
        int nDamage;
        location lManifester = GetLocation(oManifester);
        location lTarget     = PRCGetSpellTargetLocation();
        vector vOrigin       = GetPosition(oManifester);
        float fLength        = EvaluateWidenPower(manif, FeetToMeters(120.0f));
        float fDelay;
        effect eVis          = EffectVisualEffect(enAdj.nVFX1);
        effect eDamage;
        object oTarget;

        // Do VFX. This is moderately heavy, so it isn't duplicated by Twin Power
        float fAngle             = GetRelativeAngleBetweenLocations(lManifester, lTarget);
        float fSpiralStartRadius = FeetToMeters(1.0f);
        float fRadius            = FeetToMeters(5.0f);
        float fDuration          = 4.5f;
        float fVFXLength         = GetVFXLength(lManifester, fLength, GetRelativeAngleBetweenLocations(lManifester, lTarget));
        LocalObjectBeamGengon(DURATION_TYPE_TEMPORARY, enAdj.nVFX2, lManifester, fRadius, fRadius,
                              1.0f, fVFXLength, // Start 1m from the manifester, end at LOS end
                              8, // 8 sides
                              fDuration, "prc_invisobj",
                              0.0f, // Drawn instantly
                              0.0f, 0.0f, 45.0f, "y",
                              -1, -1, 0.0f, 1.0f, // No secondary VFX
                              fDuration, "PRC_EnergyBolt_VFX", fAngle
                              );
        LocalObjectBeamPolygonalSpring(DURATION_TYPE_TEMPORARY, enAdj.nVFX2, lManifester, fSpiralStartRadius, fRadius,
                                       0.0f, fVFXLength, // Start at the manifester, end at LOS end
                                       5, // 5 sides per revolution
                                       fDuration, "prc_invisobj",
                                       fVFXLength / 5, // Revolution per 5 meters
                                       0.0f, // Drawn instantly
                                       0.0f, "y",
                                       -1, -1, 0.0f, 1.0f, // No secondary VFX
                                       fDuration, "PRC_EnergyBolt_VFX", fAngle
                                       );
        /*
        // A tube of beams, radius 5ft, starting 1m from manifester and running for the length of the line
        LocalObjectBeamGengon(DURATION_TYPE_TEMPORARY, enAdj.nVFX2, lManifester, fRadius, fRadius,
                   1.0f, fLength, 8, fDuration, "prc_invisobj", 0.0f, 0.0f, 0.0f, fAngle, 0.0f, 45.0f, "x", -1, -1, 0.0f, 0.0f, fDuration);
        // A spiral inside the tube, starting from the manifester with with radius 1ft and ending with radius 5ft at the end of the line
        BeamPolygonalSpring(DURATION_TYPE_TEMPORARY, enAdj.nVFX2, lManifester, FeetToMeters(1.0f), fRadius,
                            0.0f, fLength, 6, fDuration, "prc_invisobj", fLength / 4, 0.0f, fAngle, "x", -1, -1, 0.0f, 0.0f, fDuration);
        */

        // Handle Twin Power
        int nRepeats = manif.bTwin ? 2 : 1;
        for(; nRepeats > 0; nRepeats--)
        {
            // Loop over targets in the line shape
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester &&
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester)
                   )
                {
                    // Let the AI know
                    SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);
                    // Make an SR check
                    if(PRCMyResistPower(oManifester, oTarget, nPen))
                    {
                        // Roll damage
                        nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, FALSE);
                        // Target-specific stuff
                        nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE);

                        // Do save
                        if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
                        {
                            // Cold has a fort save for half
                            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, enAdj.nSaveType))
                                nDamage /= 2;
                        }
                        else
                            // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType);

                        if(nDamage > 0)
                        {
                            fDelay = GetDistanceBetweenLocations(lManifester, GetLocation(oTarget)) / 20.0f;
                            eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                            DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                            DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }// end if - There was still damage remaining to be dealt after adjustments
                    }// end if - SR check
                }// end if - Target validity check

               // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            }// end while - Target loop
        }// end for - Twin Power
    }// end if - Successfull manifestation
}

float GetVFXLength(location lManifester, float fLength, float fAngle)
{
    float fLowerBound = 0.0f;
    float fUpperBound = fLength;
    float fVFXLength  = fLength / 2;
    vector vVFXOrigin = GetPositionFromLocation(lManifester);
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
