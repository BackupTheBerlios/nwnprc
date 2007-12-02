//::///////////////////////////////////////////////
//:: Psionic Breath Weapon feats for Diamond Dragon
//:: psi_diadra_bth.nss
//::///////////////////////////////////////////////
/*
    Handles the breath weapon for the Diamond Dragon prestige class.
    Since it acts like a power, it uses the psionics system and constants.
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 14, 2007
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "spinc_common"
#include "psi_inc_enrgypow"





void main()
{

    object oManifester = OBJECT_SELF;
    struct manifestation manif =
        EvaluateDiaDragChannel(oManifester, OBJECT_INVALID,
                              PowerAugmentationProfile(1,
                                                       1, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              3 //Acts as a Level 3 Power for PP cost
                              );

    if(manif.bCanManifest)
    {
        struct energy_adjustments enAdj =
            EvaluateEnergy(manif.nSpellID, POWER_DIADRAG_BREATH_COLD, POWER_DIADRAG_BREATH_ELEC, 
                           POWER_DIADRAG_BREATH_FIRE, POWER_DIADRAG_BREATH_SONIC,
                           VFX_IMP_FROST_L, VFX_IMP_LIGHTNING_S, VFX_IMP_FLAME_M, VFX_IMP_SONIC);
        int nDC              = 10 + GetAbilityModifier(ABILITY_INTELLIGENCE, oManifester) 
                               + GetLevelByClass(CLASS_TYPE_DIAMOND_DRAGON, oManifester) + enAdj.nDCMod;
        int nNumberOfDice    = 5 + manif.nTimesAugOptUsed_1;
        int nDieSize         = 6;
        int nDamage;
        location lManifester = GetLocation(oManifester);
        location lTarget     = PRCGetSpellTargetLocation();
        float fWidth         = FeetToMeters(30.0f);
        float fLength        = FeetToMeters(60.0f);
        float fDelay;
        vector vOrigin       = GetPosition(oManifester);
        effect eVis          = EffectVisualEffect(enAdj.nVFX2);
        effect eDamage;
        object oTarget;

        //cone handling for sonic, fire, and cold
        if(enAdj.nSaveType != SAVING_THROW_TYPE_ELECTRICITY)
        {
            // Loop over targets in the cone shape
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oManifester &&
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oManifester)
                   )
                {
                    // Let the AI know
                    SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, FALSE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE);

                    // Do save
                    if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
                    {
                        // Cold has a fort save for half
                        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, enAdj.nSaveType))
                        {
                            nDamage /= 2;
                            if (GetHasMettle(oTarget, SAVING_THROW_FORT))
	                    // This script does nothing if it has Mettle, bail
				nDamage = 0;  
			}
                    }
                    else
                        // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType);

                    if(nDamage > 0)
                    {
                        fDelay = GetDistanceBetweenLocations(lManifester, GetLocation(oTarget)) / 20.0f;
                        eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }// end if - There was still damage remaining to be dealt after adjustments
                }// end if - Target validity check

                // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }// end while - Target loop
        }//end cone handling
            
        //otherwise do a line
        else
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
                    // Roll damage
                    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, FALSE);
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oTarget, oManifester, nDamage, TRUE, TRUE);
                    
                    // Do save
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType);

                    if(nDamage > 0)
                    {
                        fDelay = GetDistanceBetweenLocations(lManifester, GetLocation(oTarget)) / 20.0f;
                        eDamage = EffectDamage(nDamage, enAdj.nDamageType);
                        DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                        DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }// end if - There was still damage remaining to be dealt after adjustments
                }// end if - Target validity check

               // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            }// end while - Target loop
        }//end Electric line breath handling
            
    }// end if - Successfull manifestation
}
