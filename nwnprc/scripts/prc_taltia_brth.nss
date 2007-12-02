//::///////////////////////////////////////////////
//:: Talon of Tiamat Breath Weapons
//:: prc_taltia_brth.nss
//::///////////////////////////////////////////////
/*
    Handles the breath weapons of the Talon of Tiamat
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 22, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

//internal function to reset the breath used marker
void RechargeBreath(object oPC)
{
	FloatingTextStringOnCreature("Breath recharged!", oPC, FALSE);
	SetLocalInt(oPC, "UsedBreath", FALSE);
}

void main()
{
	object oPC = OBJECT_SELF;
	
	//check to see if 1d4 rounds have passed
	int bCannotUse = GetLocalInt(oPC, "UsedBreath");
	if(bCannotUse) 
	{
	    FloatingTextStringOnCreature("Your breath is still recharging.", oPC, FALSE);
	    return;
	}
	
	int nDamageType;
	int nSaveType;
        effect eVis;
        int bUseCone;
        int nSpellID = GetSpellId();
        int nNumberOfDice;
        int nDieSize;
        int nClass = GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oPC);
        
        //Acid cone
        if(nSpellID == SPELL_TOT_ACID_LINE)
        {
             nDamageType = DAMAGE_TYPE_ACID;
             nSaveType = SAVING_THROW_TYPE_ACID;
             eVis = EffectVisualEffect(VFX_IMP_ACID_L);
             bUseCone = FALSE;
             nNumberOfDice = 8;
             nDieSize = 4;
             
             if(nClass < 3)
             {
             	FloatingTextStringOnCreature("This breath requires 3rd level Talon of Tiamat.", oPC, FALSE);
             	return;
             }
        }
        
        //Acid line
        if(nSpellID == SPELL_TOT_ACID_CONE)
        {
             nDamageType = DAMAGE_TYPE_ACID;
             nSaveType = SAVING_THROW_TYPE_ACID;
             eVis = EffectVisualEffect(VFX_IMP_ACID_L);
             bUseCone = TRUE;
             nNumberOfDice = 10;
             nDieSize = 6;
             
             if(nClass < 5)
             {
             	FloatingTextStringOnCreature("This breath requires 5th level Talon of Tiamat.", oPC, FALSE);
             	return;
             }
        }
             
        //Cold
        if(nSpellID == SPELL_TOT_COLD_CONE)
        {
             nDamageType = DAMAGE_TYPE_COLD;
             nSaveType = SAVING_THROW_TYPE_COLD;
             eVis = EffectVisualEffect(VFX_IMP_FROST_L);
             bUseCone = TRUE;
             nNumberOfDice = 3;
             nDieSize = 6;
        }
        //Electric
        if(nSpellID == SPELL_TOT_ELEC_LINE)
        {
             nDamageType = DAMAGE_TYPE_ELECTRICAL;
             nSaveType = SAVING_THROW_TYPE_ELECTRICITY;
             eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
             bUseCone = FALSE;
             nNumberOfDice = 12;
             nDieSize = 8;
             
             if(nClass < 7)
             {
             	FloatingTextStringOnCreature("This breath requires 7th level Talon of Tiamat.", oPC, FALSE);
             	return;
             }
        }
        //Fire
        if(nSpellID == SPELL_TOT_FIRE_CONE)
        {
             nDamageType = DAMAGE_TYPE_FIRE;
             nSaveType = SAVING_THROW_TYPE_FIRE;
             eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
             bUseCone = TRUE;
             nNumberOfDice = 14;
             nDieSize = 8;
             
             if(nClass < 9)
             {
             	FloatingTextStringOnCreature("This breath requires 9th level Talon of Tiamat.", oPC, FALSE);
             	return;
             }
        }
        
        
        int nDC              = 10 + GetAbilityModifier(ABILITY_CONSTITUTION, oPC) + nClass;
        int nDamage;
        location lPC         = GetLocation(oPC);
        location lTarget     = PRCGetSpellTargetLocation();
        float fWidth         = FeetToMeters(30.0f);
        float fLength        = FeetToMeters(60.0f);
        float fDelay;
        vector vOrigin       = GetPosition(oPC);
        effect eDamage;
        object oTarget;
        
        //cone handling for acid, fire, and cold
        if(bUseCone)
        {
            // Loop over targets in the cone shape
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while(GetIsObjectValid(oTarget))
            {
                if(oTarget != oPC &&
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)
                   )
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
                if(oTarget != oPC &&
                   spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)
                   )
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
                    
                    // Do save
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType);

                    if(nDamage > 0)
                    {
                        fDelay = GetDistanceBetweenLocations(lPC, GetLocation(oTarget)) / 20.0f;
                        eDamage = EffectDamage(nDamage, nDamageType);
                        DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                        DelayCommand(1.0f + fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }// end if - There was still damage remaining to be dealt after adjustments
                }// end if - Target validity check

               // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, vOrigin);
            }// end while - Target loop
        }//end line breath handling
        
        //roll the 1d4 delay
        int nBreathDelay = d4();
        SetLocalInt(oPC, "UsedBreath", TRUE);
        FloatingTextStringOnCreature(IntToString(nBreathDelay) + " rounds until you can use your breath.", oPC, FALSE);
        DelayCommand( nBreathDelay * 6.0f, RechargeBreath(oPC));
}