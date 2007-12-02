//::///////////////////////////////////////////////
//:: Breath of Life for the Swift Wing
//:: prc_swftwg_bol.nss
//::///////////////////////////////////////////////
/*
    Handles the Breath of Life ability for Swift Wings
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 20, 2007
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "spinc_common"

void main()
{
    object oPC = OBJECT_SELF;
	
    //make sure there's TU uses left
    if (!GetHasFeat(FEAT_TURN_UNDEAD,oPC))
    {
    	FloatingTextStringOnCreature("You are out of Turn Undead uses for the day.", oPC, FALSE);
    	return;
    }
    
    //use up one
    DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);
    
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_S);
    effect eHurtVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    
    int nDC              = 10 + GetAbilityModifier(ABILITY_CHARISMA, oPC) 
                              + GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC);
    int nDieSize         = 6;
    int nNumberOfDice    = GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC);
    int nDamage;
    location lPC         = GetLocation(oPC);
    location lTarget     = PRCGetSpellTargetLocation();
    float fWidth         = FeetToMeters(30.0f);
    float fDelay;
    vector vOrigin       = GetPosition(oPC);
    effect eDamage;
    object oTarget;
    int nSpellID         = GetSpellId();
    int nDamageType      = DAMAGE_TYPE_DIVINE;
    int nSaveType        = SAVING_THROW_TYPE_DIVINE;
    
    // Loop over targets in the cone shape
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
       if(oTarget != oPC &&
          spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)
          )
       {
       	    //if undead, do damage
       	    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
       	    {
                    // Let the AI know
                    SPRaiseSpellCastAt(oTarget, TRUE, nSpellID, oPC);
                    // Roll damage
                    nDamage = 0;
                    int i;
                    for (i = 0; i < nNumberOfDice; i++)
                           nDamage += Random(nDieSize) + 1;
                    // Target-specific stuff
                    nDamage = GetTargetSpecificChangesToDamage(oTarget, oPC, nDamage, TRUE, TRUE);

                    // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType);

                    if(nDamage > 0)
                    {
                        fDelay = GetDistanceBetweenLocations(lPC, GetLocation(oTarget)) / 20.0f;
                        eDamage = EffectDamage(nDamage, nDamageType);
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHurtVis, oTarget));
                    }// end if - There was still damage remaining to be dealt after adjustments
            }//end undead handling
            else //heal otherwise
            {
            	    // Let the AI know
                    SPRaiseSpellCastAt(oTarget, FALSE, nSpellID, oPC);
                    // apply healing
                    fDelay = GetDistanceBetweenLocations(lPC, GetLocation(oTarget)) / 20.0f;
                    effect eHealed = EffectHeal(nNumberOfDice);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealed, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget));
            }//end healing handling

        }// end if - Target validity check

        // Get next target
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }// end while - Target loop
    
}