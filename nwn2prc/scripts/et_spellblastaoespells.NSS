#include "nw_i0_spells"
#include "nwn2_inc_spells"
#include "x2_inc_toollib"
#include "x0_I0_SPELLS"
#include "x2_inc_spellhook"

/*//////////////////////////////////////////////////////////////////////////////////////*/	
//																						//
//								AOE SPELLS FOR SPELLBLAST								//
//																						//
/*//////////////////////////////////////////////////////////////////////////////////////*/

void DoETAoEAcidFog(int nCasterLevel, int nMetaMagic, location lTarget)
{	//Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID);
    
    int nDuration = nCasterLevel / 2;
    
    //Make sure duration does not equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETAoEBurningHands(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables
    float fDist;
    int nDamage;
    effect eFire;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	//effect eCone = EffectVisualEffect(VFX_DUR_CONE_FIRE);	// NWN1 VFX
	effect eCone = EffectVisualEffect( VFX_DUR_SPELL_BURNING_HANDS );	// NWN2 VFX
	float fMaxDelay = 0.0f; // Used to determine the duration of the flame cone.
    //Limit Maximum caster level to keep damage to spell specifications.
    if (nCasterLevel > 5)
    {
        nCasterLevel = 5;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE,
								    OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Signal spell cast at event to fire.
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BURNING_HANDS));
            //Calculate the delay time on the application of effects based on the distance
            //between the caster and the target
 //           fDist = GetDistanceBetween(ConeRelay, oTarget)/20;
			//fDist += 2.0f;
			if (fDist > fMaxDelay)
			{
				fMaxDelay = fDist;
			}
            //Make SR check, and appropriate saving throw.
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDist) && oTarget != OBJECT_SELF)
            {
                nDamage = d4(nCasterLevel);
    		    //Enter Metamagic conditions
    		    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    		    {
    			     nDamage = 4 * nCasterLevel;//Damage is at max
    		    }
    	        else if (nMetaMagic == METAMAGIC_EMPOWER)
    		    {
    			     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
    		    }
                //Run the damage through the various reflex save and evasion feats
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                eFire = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                    DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE,
									   OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oTarget, fMaxDelay);
}

void DoETAoECloudkill(int nCasterLevel, int nMetaMagic, location lTarget)
{
	 //Declare major variables
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGKILL);
    int nDuration = nCasterLevel / 2;
    //effect eImpact = EffectVisualEffect(258);	// no longer using NWN1 VFX
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);	// no longer using NWN1 VFX
    if(nDuration < 1) nDuration = 1;
    //Metamagic checks for entend
	if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
	//Apply the AOE object to the specified location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETAoEColorSpray(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables
    int nHD;
    int nDuration;
    float fDelay;
	float fMaxDelay = 0.0f; // Used to determine length of spell cone
    object oTarget;
    effect eSleep = EffectSleep();
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_COLORSPRAY);
    effect eLink2 = EffectLinkEffects(eStun, eSleep);
    effect eLink3 = EffectLinkEffects(eBlind, eSleep);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);
    //Get first object in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE);
    //Cycle through the target until the current object is invalid
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COLOR_SPRAY));
   //         fDelay = GetDistanceBetween(ConeRelay, oTarget)/30;
	//		if (fDelay > fMaxDelay) fMaxDelay = fDelay;
			if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && oTarget != OBJECT_SELF)
            {
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    nDuration = 3 + d4();
                    //Enter Metamagic conditions
    		        if (nMetaMagic == METAMAGIC_MAXIMIZE) nDuration = 7;//Damage is at max
    		        else if (nMetaMagic == METAMAGIC_EMPOWER) nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    		        else if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
    		        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
                    nHD = GetHitDice(oTarget);
                    if(nHD <= 2)DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oTarget, RoundsToSeconds(nDuration)));
                    else if(nHD > 2 && nHD < 5)  
                    {
                         nDuration = nDuration - 1;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration)));                }
                    else
                    {
                         nDuration = nDuration - 2;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nDuration)));
                    }
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE);
    }
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oTarget, fMaxDelay);
}


void DoETAoEConeOfCold(int nCasterLevel, int nMetaMagic, location lTargetLocation)
{
	//Declare major variables
    int nDamage;
    float fDelay;
    float fMaxDelay = 0.0f; // Used to determine duration of cold cone
    object oTarget;
//	lTargetLocation = GetAheadLocation(OBJECT_SELF, 2.0);
    //Limit Caster level for the purposes of damage.
    if (nCasterLevel > 15) nCasterLevel = 15;
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
     // March 2003. Removed this as part of the reputation pass
     //            if((GetSpellId() == 340 && !GetIsFriend(oTarget)) || GetSpellId() == 25)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
                //Get the distance between the target and caster to delay the application of effects
              /*  fDelay = GetDistanceBetween(ConeRelay, oTarget)/20.0;
				if (fDelay > fMaxDelay)
				{
					fMaxDelay = fDelay;
				}
                //Make SR check, and appropriate saving throw(s).*/
                if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
                {
                    //Detemine damage
                    nDamage = d6(nCasterLevel);
        		    //Enter Metamagic conditions
        		    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;//Damage is at max
        		    else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                   //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD);
                    // Apply effects to the currently selected target.
                    effect eCold = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
                    if(nDamage > 0) 
                    {
                        //Apply delayed effects
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 11.0, GetLocation(oTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_ICE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}

void DoETAoEFireball(object oCaster, int nCasterLvl, int nMetaMagic, location lTarget)
{
	//Declare major variables
    int nDamage;
    float fDelay;
    
    // Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL); 
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10) nCasterLvl = 10;
    //Apply the fireball explosion at the location captured above.
    // Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
        	{
            	//Roll damage for each target
            	nDamage = d6(nCasterLvl);
            	//Resolve metamagic
            	if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLvl;
            	else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + nDamage / 2;
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            	nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
            	//Set the damage effect
            	eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            	if(nDamage > 0)
            	{
	            	// Apply effects to the currently selected target.
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                	//This visual effect is applied to the target object not the location as above.  This visual effect
                	//represents the flame that erupts on the target not on the ground.
                	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            	}
			}//Select the next target within the spell shape.
			 oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		}
	}
       
      
    
}

void DoETAoECircleOfDeath(int nCasterLevel, int nMetaMagic, location lTarget)
{
    object oLowest;
    effect eDeath =  EffectDeath();
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    int bContinueLoop = FALSE; //Used to determine if we have a next valid target
    int nHD = d4(nCasterLevel); //Roll to see how many HD worth of creature will be killed
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = 10;// maximun hd creature affected, set this to 9 so that a lower HD creature is chosen automatically
    //Also 9 is the maximum HD a creature can have and still be affected by the spell
    float fDelay;
    string sIdentifier = GetTag(OBJECT_SELF);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nHD = 4 * nCasterLevel;//Damage is at max
    if (nMetaMagic == METAMAGIC_EMPOWER) nHD = nHD + (nHD/2); //Damage/Healing is +50%

    //Check for at least one valid object to start the main loop
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    if (GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.  If no value target exists we do not enter
    // the loop.

    while ((nHD > 0) && (bContinueLoop))
    {
        int nLow = nMax; //Set nLow to the lowest HD creature in the last pass through the loop
        bContinueLoop = FALSE; //Set this to false so that the loop only continues in the case of new low HD creature
        //Get first target creature in loop
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            //Make sure the currect target is not an enemy
        	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        	{
                //Get a local set on the creature that checks if the spell has already allowed them to save
                bAlreadyAffected = GetLocalInt(oTarget, "bDEATH" + sIdentifier);
                if (!bAlreadyAffected)
                {
                     nCurrentHD = GetHitDice(oTarget);
                     //If the selected creature is of lower HD then the current nLow value and
                     //the HD of the creature is of less HD than the number of HD available for
                     //the spell to affect then set the creature as the currect primary target
                     if(nCurrentHD < nLow && nCurrentHD <= nHD)
                     {
                         nLow = nCurrentHD;
                         oLowest = oTarget;
                         bContinueLoop = TRUE;
                     }
                }
            }
            //Get next target in shape to test for a new
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        }
        //Check to make sure that oLowest has changed
        if(bContinueLoop == TRUE)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oLowest, EventSpellCastAt(OBJECT_SELF, SPELL_CIRCLE_OF_DEATH));
            fDelay = GetRandomDelay();
            if(!MyResistSpell(OBJECT_SELF, oLowest, fDelay))
            {
                //Make a Fort Save versus death effects
                if(!MySavingThrow(SAVING_THROW_FORT, oLowest, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oLowest));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest));
                }
            }
            //Even if the target made their save mark them as having been affected by the spell
            SetLocalInt(oLowest, "bDEATH" + sIdentifier, TRUE);
            //Destroy the local after 1/4 of a second in case other Circles of Death are cast on
            //the creature laster
            DelayCommand(fDelay + 0.25, DeleteLocalInt(oLowest, "bDEATH" + sIdentifier));
            //Adjust the number of HD that have been affected by the spell
            nHD = nHD - GetHitDice(oLowest);
            oLowest = OBJECT_INVALID;
        }
    }
}

void DoETAoEGrease(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_GREASE);
    int nDuration = nCasterLevel;	// AFW-OEI 04/16/2007: Change duration to 1 round/level.

    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
    	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETAoEGreaterFireburst(int nCasterLvl, int nMetaMagic, location lTarget)
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nMaxLvl; 
    if ( nCasterLvl > 15 ) nMaxLvl = 15;
    else nMaxLvl = nCasterLvl;
    
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    effect eDam;
    
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))// && oTarget != OBJECT_SELF)
        {
            fDelay = GetRandomDelay(0.15, 0.35);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBURST));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d8(nMaxLvl);
                //Resolve metamagic
                nDamage = ApplyMetamagicVariableMods(nDamage, nMaxLvl * 8);

                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
                if ( nDamage > 0 )
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the impact that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void DoETAoEHorridWilting(int nCasterLvl, int nMetaMagic, location lTarget)
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    effect eDam;
    
    //Limit Caster level for the purposes of damage 
    if (nCasterLvl > 20) nCasterLvl = 20;
    
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // GZ: Not much fun if the caster is always killing himself
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HORRID_WILTING));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetRandomDelay(1.5, 2.5);
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                if(GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                    //Roll damage for each target
                    nDamage = d6(nCasterLvl);	// JLR - OEI 07/22/05 -- 3.5 Change
                    //Resolve metamagic
                    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLvl;
                    else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + nDamage / 2;

                    if(/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        nDamage = nDamage/2;
                    }
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    }
}

void DoETAoEIceStorm(int nCasterLvl, int nMetaMagic, location lTarget)
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nDamage, nDamage2, nDamage3;
    int nVariable = nCasterLvl/3;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
    effect eDam,eDam2, eDam3;
 
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //fDelay = GetRandomDelay(0.75, 2.25);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ICE_STORM));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
    	    {
                //Roll damage for each target
                nDamage = d6(3);
                nDamage2 = d6(2);
                nDamage3 = d6(nVariable);
                //Resolve metamagic
        	    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 18;
                    nDamage2 = 12;
                    nDamage3 = 6 * nVariable;
                }
    	        else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                   nDamage = nDamage + (nDamage / 2);
                   nDamage2 = nDamage2 + (nDamage2 / 2);
                   nDamage3 = nDamage3 + (nDamage3 / 2);
                }
                nDamage2 = nDamage2 + nDamage3;
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_COLD);
                // Apply effects to the currently selected target.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget);
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the impact that erupts on the target not on the ground.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void DoETAoEIncendiaryCloud(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables, including the Area of Effect object.
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGFIRE);
    //Capture the spell target location so that the AoE object can be created.
    int nDuration = nCasterLevel;
    if(nDuration < 1) nDuration = 1;
    
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%

    //Create the object at the location so that the objects scripts will start working.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}


void DoETAoELesserDispelMagic(int nCasterLevel, int nMetaMagic, location lLocal)
{
    //Declare major variables
    effect    eVis         = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
    effect    eImpact      = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);

    if(nCasterLevel > 5) nCasterLevel = 5;
    
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lLocal);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT) spellsDispelAoE(oTarget, OBJECT_SELF,nCasterLevel);

            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
}



void DoETAoEMassBlindnessDeafness(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eBlind =  EffectBlindness();
    effect eDeaf = EffectDeaf();
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_BLIND_DEAF );	// NWN2 VFX

    //Link the blindness and deafness effects
    effect eLink = EffectLinkEffects(eBlind, eDeaf);
    eLink = EffectLinkEffects(eLink, eDur);
    
     //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;
    
    //Get the first target in the spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_BLINDNESS_AND_DEAFNESS));
            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget))
    	    {
                //Make Fort save
                if (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
                {
                    //Apply the linked effects and the VFX impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
                }
            }
        }
        //Get next object in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    }
}

void DoETAoEMindFog(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGMIND);
    int nDuration = 2 + nCasterLevel / 2;
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}


void DoETAoEMordenkainensDisjunction(int nCasterLevel, int nMetaMagic, location lLocal)
{
    effect  eVis        = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
    effect eImpact; // Now handled by ImpactSEF column in spells.2da, but req'd for DispelMagic function
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT) spellsDispelAoE(oTarget, OBJECT_SELF,nCasterLevel);
            
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE,TRUE);
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
}

void DoETAoEMassCharmMonster(int nCasterLevel, int nMetaMagic, location lTarget)
{
    object oTarget;
    effect eCharm = EffectCharmed();

    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
    int nDuration = nCasterLevel/2;
    int nHD = nCasterLevel;
    int nCnt = 0;
    int nRacial;
    float fDelay;
    int nAmount = nHD * 2;
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nCasterLevel;
    
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    while (GetIsObjectValid(oTarget) && nAmount > 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //nRacial = GetRacialType(oTarget);	// the target can be any creature; this check is not relevant
            //Check that the target is humanoid or animal
            {
                //SpeakString(IntToString(nAmount) + " and HD of " + IntToString(GetHitDice(oTarget)));
                if(nAmount > GetHitDice(oTarget))
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_CHARM, FALSE));
                    //Make an SR check
                    if (!MyResistSpell(OBJECT_SELF, oTarget))
                	{
                        //Make a Will save to negate
                        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                        {
							eCharm = GetScaledEffect( eCharm, oTarget );	// 11/09/06 - BDF(OEI): this line was missing, causing PCs to get charmed
                            //Apply the linked effects and the VFX impact
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(nDuration)));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }
                    }
                    //Add the creatures HD to the count of affected creatures
                    //nCnt = nCnt + GetHitDice(oTarget);
                    nAmount = nAmount - GetHitDice(oTarget);
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }
}

void HoldTarget( object oTarget, float fDuration, int nSaveDC)
{
    effect eParal 	= EffectParalyze(nSaveDC, SAVING_THROW_WILL);
    effect eVis 	= EffectVisualEffect( VFX_DUR_SPELL_HOLD_MONSTER );
    eParal = EffectLinkEffects( eParal, eVis );

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_PERSON));

    float fDelay = GetRandomDelay( 0.25, 1.25 );

    //Make SR Check
    if ( MyResistSpell(OBJECT_SELF, oTarget, fDelay) == 0 )
    {
	//Make Will save
	if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
	{
		//Apply paralyze effect and VFX impact
		DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, fDuration ) );
		//DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		}
	}

}

void DoETAoEMassHoldMonster(int nCasterLevel, int nMeta, location locTarget)
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nRounds = nCasterLevel;
    int nSaveDC	= GetSpellSaveDC();

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, locTarget );
    while (GetIsObjectValid(oTarget) )
    {
		if ( TRUE == spellsIsTarget( oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster ) )
		{
			float fDuration = RoundsToSeconds( GetScaledDuration(nRounds, oTarget) );

			//Make metamagic extend check
    		fDuration = ApplyMetamagicDurationMods(fDuration);
	        HoldTarget( oTarget, fDuration, nSaveDC );
	    }

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, locTarget );
    }
}

void DoETAoEMassHoldPerson(int nCasterLevel, int nMeta, location locTarget)
{
    //Declare major variables
    int nRounds = nCasterLevel;
    //Make metamagic extend check
    if (nMeta == METAMAGIC_EXTEND) nRounds = nRounds * 2;
    int nSaveDC = GetSpellSaveDC();

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, locTarget );
    while (GetIsObjectValid(oTarget) )
    {
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
	       //Make sure the target is a humanoid
	       if (GetIsPlayableRacialType(oTarget) ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
	            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN) 
	        {
	            float fDuration = RoundsToSeconds( GetScaledDuration(nRounds, oTarget) );
	            HoldTarget( oTarget, fDuration, nSaveDC );
	        }
	    }

        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, locTarget );
    }
}

const int PS_EFFECT_FIRE 			= 0;
const int PS_EFFECT_ACID 			= 1;
const int PS_EFFECT_ELECTRICITY 	= 2;
const int PS_EFFECT_POISON 			= 3;
const int PS_EFFECT_PARALYZE		= 4;
const int PS_EFFECT_CONFUSION		= 5;
const int PS_EFFECT_DEATH 			= 6;
const int PS_EFFECT_STONE 			= 7;
const int PS_EFFECT_COUNT 			= 8;

float GetDelayForTarget( object oTarget)
{
	float fDelay = 1.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
	return fDelay;
}

int ApplyPrismaticEffect(int nEffect, object oTarget)
{

//Set the delay to apply to effects based on the distance to the target


    effect 	ePrism;
    effect 	eVis;
    effect 	eDur 	= EffectVisualEffect( VFX_DUR_SPELL_PRISMATIC_SPRAY );
    effect	eLink;
    int 	nDamage = 0;
    int 	nVis 	= 0;
     float 	fDelay	= GetDelayForTarget( oTarget );

    //Based on the random number passed in, apply the appropriate effect and set the visual to
    //the correct constant
    switch(nEffect)
    {
        case PS_EFFECT_FIRE://fire
			{
	            nDamage = 20;
	            nVis = VFX_HIT_SPELL_FIRE;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_ACID: //Acid
			{
	            nDamage = 40;
	            nVis = VFX_HIT_SPELL_ACID;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ACID);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_ELECTRICITY: //Electricity
			{
	            nDamage = 80;
	            nVis = VFX_HIT_SPELL_LIGHTNING;
	            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
	            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
			}
        break;

        case PS_EFFECT_POISON: //Poison
            {
                effect ePoison = EffectPoison(POISON_BEBILITH_VENOM);
				nVis = VFX_HIT_SPELL_POISON;
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget));
            }
        break;

        case PS_EFFECT_PARALYZE: //Paralyze
            {
				nVis = VFX_HIT_SPELL_ENCHANTMENT;
                effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
				int nSaveDC = GetSpellSaveDC();
                if (MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC) == 0)
                {
                    ePrism = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
                    eLink = EffectLinkEffects(eDur2, ePrism);
//                    eLink = EffectLinkEffects(eLink, eDur2);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
                }
            }
        break;

        case PS_EFFECT_CONFUSION: //Confusion
            {
                effect eDur = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
                ePrism = EffectConfused();
                eLink = EffectLinkEffects(eDur, ePrism);
                //eLink = EffectLinkEffects(eLink, eDur);

                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    //nVis = VFX_HIT_SPELL_ENCHANTMENT;
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
                }
            }
        break;

        case PS_EFFECT_DEATH: //Death
            {
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    nVis = VFX_HIT_SPELL_NECROMANCY;
                    ePrism = EffectDeath();
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
                }
            }
        break;

		case PS_EFFECT_STONE: // Flesh to Stone 
			{
                //if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
					//nVis = VFX_HIT_SPELL_TRANSMUTATION;
				    //object oTarget = GetSpellTargetObject();
				    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
				
				    //if (MyResistSpell(OBJECT_SELF,oTarget) <1)
				    {
				    	DelayCommand(fDelay, DoPetrification(nCasterLvl, OBJECT_SELF, oTarget, GetSpellId(), GetSpellSaveDC()) );
					}
				}
			}
    }
    return nVis;
}

void DoETAoEPrismaticSpray(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables
    int nRandom, nHD, nVisual, bTwoEffects;
    effect eCone = EffectVisualEffect(VFX_DUR_CONE_COLORSPRAY);
    float fMaxDelay = 0.0f; // Used to determine length of Cone effect
    effect eVisual; int nVisual2 = 0;

    //Get first target in the spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 11.0, lTarget);
	while (GetIsObjectValid(oTarget))
	{
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
		   
		    float fDelay = GetDelayForTarget( oTarget );
			if (fMaxDelay < fDelay)
			{
				fMaxDelay = fDelay;
			}

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRISMATIC_SPRAY));
            //Make an SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
            {
                //Blind the target if they are less than 9 HD
                nHD = GetHitDice(oTarget);
                if (nHD <= 8)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(nCasterLevel));
                }

                //Determine if 1 or 2 effects are going to be applied
                nRandom = Random( PS_EFFECT_COUNT+1 ); // Get an integer between 0 and nMaxInteger-1.
				//nRandom = 7;
                if ( nRandom == PS_EFFECT_COUNT )
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect( Random(PS_EFFECT_COUNT), oTarget);
                    nVisual2 = ApplyPrismaticEffect( Random(PS_EFFECT_COUNT), oTarget);
                }
                else
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect(nRandom, oTarget);
                }
                //Set the visual effect
                if(nVisual != 0)
                {
                    eVisual = EffectVisualEffect(nVisual);
                    //Apply the visual effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
                }
                if(nVisual2 != 0)
                {
                    eVisual = EffectVisualEffect(nVisual2);
                    //Apply the visual effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
                }
            }
        }
        //Get next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 11.0, GetSpellTargetLocation());
	}
	// Apply Cone visual fx
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}

void DoETAoEScare(int nCasterLvl, int nMetaMagic, location lTarget, object oTarget)
{
    //Declare major variables
    object oOrigTgt = oTarget;
    float fDuration = RoundsToSeconds(nCasterLvl);
    int nNumTargets = (nCasterLvl / 3) + 1;

    //Do metamagic checks
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    // First, do the one we explicitly targeted, if any:
    if ( GetIsObjectValid(oTarget) )
    {
        //Check the Hit Dice of the creature
        if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            // * added rep check April 2003
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
            {
                nNumTargets = nNumTargets - 1;

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SCARE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    //Make Will save versus fear
                    if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
                    {
                        effect eScare = EffectFrightened();
                        effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
                        //effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
                        effect eDur = EffectVisualEffect( VFX_DUR_SPELL_CAUSE_FEAR );
                        effect eDamagePenalty = EffectDamageDecrease(2);
                        effect eAttackPenalty = EffectAttackDecrease(2);
                        //effect eLink = EffectLinkEffects(eMind, eScare);
                        effect eLink2 = EffectLinkEffects(eSave, eDur);
                        eLink2 = EffectLinkEffects(eLink2, eDamagePenalty);
                        eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);
                        eLink2 = EffectLinkEffects(eLink2, eScare);

                        //Apply linked effects and VFX impact
                        //ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
                        ApplyEffectToObject(nDurType, eLink2, oTarget, fDuration);
                    }
                }
            }
        }
    }


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && (nNumTargets > 0) && (oOrigTgt != oTarget))
    {
        //Check the Hit Dice of the creature
        if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            // * added rep check April 2003
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
            {
                nNumTargets = nNumTargets - 1;

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SCARE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    //Make Will save versus fear
                    if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
                    {
                        effect eScare = EffectFrightened();
                        effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
                        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
                        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                        effect eDamagePenalty = EffectDamageDecrease(2);
                        effect eAttackPenalty = EffectAttackDecrease(2);
                        effect eLink = EffectLinkEffects(eMind, eScare);
                        effect eLink2 = EffectLinkEffects(eSave, eDur);
                        eLink2 = EffectLinkEffects(eLink2, eDamagePenalty);
                        eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);

                        //Apply linked effects and VFX impact
                        ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
                        ApplyEffectToObject(nDurType, eLink2, oTarget, fDuration);
                    }
                }
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void DoETAoESleep(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables
    object oTarget;
    object oLowest;
    effect eSleep =  EffectSleep();
    effect eDur = EffectVisualEffect( VFX_DUR_SLEEP );
    
    effect eLink = EffectLinkEffects( eSleep, eDur);
	
     // * Moved the linking for the ZZZZs into the later code
     // * so that they won't appear if creature immune

    int bContinueLoop;
    int nHD = 4 + d4();
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = 9;// maximun hd creature affected
    int nLow;
    int nDuration = nCasterLevel;
    nDuration = 3 + GetScaledDuration(nDuration, oTarget);

    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nHD = 8;//Damage is at max
    if (nMetaMagic == METAMAGIC_EMPOWER) nHD = nHD + (nHD/2); //Damage/Healing is +50%
    else if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
    
    nDuration += 2;
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    //If no valid targets exists ignore the loop
    if (GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.
    while ((nHD > 0) && (bContinueLoop))
    {
        nLow = nMax;
        bContinueLoop = FALSE;
        //Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
        while (GetIsObjectValid(oTarget))
        {
            //Make faction check to ignore allies
        	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
                && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
        	{
                //Get the local variable off the target and determined if the spell has already checked them.
                bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!bAlreadyAffected)
                {
                     //Get the current HD of the target creature
                     nCurrentHD = GetHitDice(oTarget);
                     //Check to see if the HD are lower than the current Lowest HD stored and that the
                     //HD of the monster are lower than the number of HD left to use up.
                     if(nCurrentHD < nLow && nCurrentHD <= nHD && nCurrentHD < 6)
                     {
                         nLow = nCurrentHD;
                         oLowest = oTarget;
                         bContinueLoop = TRUE;
                     }
                }
            }
            //Get the next target in the shape
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
        }
        //Check to see if oLowest returned a valid object
        if(oLowest != OBJECT_INVALID)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLEEP));
            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oLowest))
            {
                //Make Fort save
                if(!MySavingThrow(SAVING_THROW_WILL, oLowest, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest);
                    if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE)
                    {
                        //effect eLink2 = EffectLinkEffects(eLink, eVis);
                        //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oLowest, RoundsToSeconds(nDuration));
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oLowest, RoundsToSeconds(nDuration));
                    }
                    else
                    // * even though I am immune apply just the sleep effect for the immunity message
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oLowest, RoundsToSeconds(nDuration));
                    }

                }
            }
        }
        //Set a local int to make sure the creature is not used twice in the pass.  Destroy that variable in
        //.3 seconds to remove it from the creature
        SetLocalInt(oLowest, sSpellLocal, TRUE);
        DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
        DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
        //Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}

void DoETAoEStinkingCloud(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGSTINK);
    int nDuration = nCasterLevel;
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
    //Create the AOE object at the selected location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

const float SPELL_EFFECT_RADIUS = 3.048;
const float DELAY_ONE_ROUND     = 6.0f;

void DamageVictim(int nDice, object oVictim, object oCaster, int nSpellSaveDC )
{
	// Returns: 0 if the saving throw roll failed
	// Returns: 1 if the saving throw roll succeeded
	// Returns: 2 if the target was immune to the save type specified
    int nSave = ReflexSave( oVictim, nSpellSaveDC, SAVING_THROW_TYPE_ACID, oCaster );

    SignalEvent(oVictim, EventSpellCastAt(oCaster, SPELL_VITRIOLIC_SPHERE));

    if ( nSave != 2 )
    {
        int nDamage = d4(nDice);

		int nMaxVal = nDice * 4; // nDice * d4

        //Resolve metamagic
        nDamage = ApplyMetamagicVariableMods( nDamage, nMaxVal );   		

		// A successful saving throw results in half damage
		if ( nSave == 1 )
			nDamage = nDamage / 2;

		if ((nDice > 6) && (nSave == 1))
		{
			if (GetHasFeat(FEAT_EVASION, oVictim) || GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
				nDamage = 0;
		}
		if ((nDice > 6) && (nSave == 0))
		{
			if (GetHasFeat(FEAT_IMPROVED_EVASION, oVictim))
				nDamage = nDamage / 2;
		}

        if (nDamage > 0)
        {
        effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_ACID);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVisual, oVictim );        

        effect eDamage  = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oVictim );
        }
    }
    if ((nSave == 0) && (nDice > 6))
    {
        DelayCommand( 6.0, DamageVictim( 6, oVictim, oCaster, nSpellSaveDC ) );
    }
    else if ((nSave == 0) && (nDice == 6))
    {
        DelayCommand( 6.0, DamageVictim( 3, oVictim, oCaster, nSpellSaveDC ) );
    }
}



void RunRecurringEffects( location lTarget, object oCaster, int nCasterLevel, int nSpellSaveDC, int nRound )
{
	int nDice = 0;

	if (nCasterLevel > 15) nDice = 15;
	else nDice = nCasterLevel;

        object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, SPELL_EFFECT_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );

        while ( GetIsObjectValid(oVictim) )
        {
          if ( spellsIsTarget( oVictim, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
	  {
	    float fDistance = GetDistanceBetweenLocations( lTarget, GetLocation(oVictim) );
	    float fDelay = 0.15f * fDistance;
	    if ( fDelay > 1.0f ) fDelay = 1.0f;
	     DamageVictim( nDice, oVictim, oCaster, nSpellSaveDC );
	  }
			
          oVictim = GetNextObjectInShape(SHAPE_SPHERE, SPELL_EFFECT_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE );
        }
	
}


void DoETAoEVitriolicSphere(int nCasterLevel, int nMetaMagic, location lTarget)
{
	
    object oCaster   = OBJECT_SELF;
    int nSpellSaveDC = GetSpellSaveDC();

    RunRecurringEffects( lTarget, oCaster, nCasterLevel, nSpellSaveDC, 1 );


}

void DoETAoEWeird(int nCasterLvl, int nMetaMagic, location lTarget)
{
    //Declare major variables
    object oTarget;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
    effect eVis2 = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	
    effect eWeird = EffectVisualEffect(VFX_FNF_WEIRD);
    effect eAbyss = EffectVisualEffect(VFX_HIT_AOE_EVIL);//PMills OEI 07.07.06 This is never called in this script, but if someone wants to put it in I've updated the vfx for it
    effect eDeath = EffectDeath();
	effect eLink2 = EffectLinkEffects(eVis2, eDeath);
	eLink2 = EffectLinkEffects(eLink2, eAbyss);
    int nDamage;
    float fDelay;

    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWeird, lTarget);
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE);
    while (GetIsObjectValid(oTarget))
    {
        //Make a faction check
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
               fDelay = GetRandomDelay(3.0, 4.0);
               //Fire cast spell at event for the specified target
               SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WEIRD));
               //Make an SR Check
               if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
               {
                    if ( !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) &&
                         !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) &&
						 !GetHasFeat(FEAT_IMMUNITY_PHANTASMS, oTarget) )	// AFW-OEI 04/20/2006: If I'm Immune to Phantasms, I'm immune to this spell
                    {
                        if(GetHitDice(oTarget) >= 4)
                        { //Make a Will save against mind-affecting
                            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF))
                            { //Make a fortitude save against death
                                if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF))
                                { // * I made my saving throw but I still have to take the 3d6 damage
                                    //Roll damage
                                    nDamage = d6(3);
                                    //Make metamagic check
                                    if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 18;
                                    if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + nDamage / 2;
                                    //Set damage effect
                                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                                    //Apply VFX Impact and damage effect
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                                }
                                else // * I failed BOTH saving throws. Now I die. 
                                {  //Apply VFX impact and death effect
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                                }
                            } // Will save
                        }
                        else // * I have less than 4HD, I die.
                        {   //Apply VFX impact and death effect
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget));
                            //effect eDeath = EffectDeath();
                            //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                        }
                    }
               }
        } //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
    }
}

void DoETAoEWailOfTheBanshee(int nCasterLevel, int nMetaMagic, location lTarget)
{    //Declare major variables
    int nToAffect = nCasterLevel;
    object oTarget;
    float fTargetDistance;
    float fDelay;
    effect eVis = EffectVisualEffect (VFX_HIT_SPELL_NECROMANCY);//looks cooler
    effect eWail = EffectVisualEffect( VFX_HIT_SPELL_WAIL_OF_THE_BANSHEE );	// makes use of NWN2 VFX
	int nCnt = 0;
    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWail, lTarget);
    //Get the closet target from the spell target location
    oTarget = GetSpellTargetObject(); // direct target
    if (!GetIsObjectValid(oTarget))
      oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lTarget, nCnt);
    while (nCnt < nToAffect)
    {
        lTarget = GetLocation(oTarget);
        //Get the distance of the target from the center of the effect
        fDelay = GetRandomDelay(3.0, 4.0);//
        fTargetDistance = GetDistanceBetweenLocations(GetSpellTargetLocation(), lTarget);
        //Check that the current target is valid and closer than 10.0m
        if(GetIsObjectValid(oTarget) && fTargetDistance <= 10.0)
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget)) //, 0.1))
                {
                    //Make a fortitude save to avoid death
                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH)) //, OBJECT_SELF, 3.0))
                    {
                        //Apply the delay VFX impact and death effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        effect eDeath = EffectDeath();
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget)); // no delay
                    }
                }
            }
        }
        else
        {
            //Kick out of the loop
            nCnt = nToAffect;
        }
        //Increment the count of creatures targeted
        nCnt++;
        //Get the next closest target in the spell target location.
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, GetSpellTargetLocation(), nCnt);
    }
}

void DoETAoEWallOfFire(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare Area of Effect object using the appropriate constant
    effect eAOE = EffectAreaOfEffect(AOE_PER_WALLFIRE);
    //Get the location where the wall is to be placed.
    int nDuration = nCasterLevel / 2;
    if(nDuration == 0) nDuration = 1;
    //Check fort metamagic
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
	//Create the Area of Effect Object declared above.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETAoEWeb(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_WEB);
    int nDuration = nCasterLevel / 2;
   //Make sure duration does no equal 0
    if (nDuration < 1) nDuration = 1;
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETMissileStorm(int nD6Dice, int nCap, int nSpell, int nMetaMagic, object oTarget, int nVIS = VFX_IMP_MAGBLUE, int nDamageType = DAMAGE_TYPE_MAGICAL, int iReflexSaveType = -1, int nMaxHits = 10 )
{
	//SpawnScriptDebugger();
	
	location lTargetLoc	= GetLocation(oTarget); // missile spread centered around target location
	location lSourceLoc = GetLocation(oTarget);
	
	int nSpellID 		= GetSpellId();
    int nMetaMagic 		= GetMetaMagicFeat();
    effect eVis 		= EffectVisualEffect(nVIS);
	
    float fDelay 		= 0.0;
    int nMissiles 		= GetCappedCasterLevel(nCap);
	int nPathType 		= PROJECTILE_PATH_TYPE_BURST;
	int nEnemies 		= CountEnemies(lTargetLoc, RADIUS_SIZE_GARGANTUAN, nMissiles); // how many enemies (up to max number of missiles)

     // * Exit if no enemies to hit
     if (nEnemies == 0) 
        return; 

     // divide the missles evenly amongst the enemies;
    int nMissilesPerTarget	= nMissiles / nEnemies;
	int nExtraMissiles   	= nMissiles % nEnemies;
	
	int nMissilesForThisTarget 	= 0;
	location lThisTargetLoc;
    int nCnt 				= 1; // # of enemies processed
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget 			= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTargetLoc, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget) && nCnt <= nEnemies)
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF)))
        {
			lThisTargetLoc = GetLocation( oTarget );
			fDelay = GetProjectileTravelTime( lSourceLoc, lThisTargetLoc, nPathType );
			
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell));
			
			// * determine the number of missles to fire at this target
	    	nMissilesForThisTarget = nMissilesPerTarget;
			if (nCnt <= nExtraMissiles)
				nMissilesForThisTarget++;
				
			// ensure we observe cap
			nMissilesForThisTarget = GetIntInRange(nMissilesForThisTarget, 0, nMaxHits);
			
			ShootMissilesAtTarget(oTarget, lSourceLoc, lThisTargetLoc, nSpell, nPathType, 
							nMissilesForThisTarget, eVis, fDelay, nCnt, 
							nD6Dice, nDamageType, nMetaMagic, iReflexSaveType);
			
			nCnt++;// * increment count of enemies processed
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTargetLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void DoETAoEFirebrand(int nCasterLevel, int nMetaMagic, location lTarget, object oTarget)
{
	int nDamageDice = nCasterLevel;
    if (nDamageDice > 15) nDamageDice = 15;
    DoETMissileStorm(nDamageDice, 15, SPELL_FIREBRAND, nMetaMagic, oTarget, VFX_HIT_SPELL_FIRE, DAMAGE_TYPE_FIRE, SAVING_THROW_TYPE_FIRE, 1);
}

void DoETAoEGustOfWind(int nCasterLvl, int nMetaMagic, location lTarget)
{
	//Declare major variables
    object oCaster = OBJECT_SELF;
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            DestroyObject(oTarget);
        }
        else
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                // * unlocked doors will reverse their open state
                if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
                {
                    if (GetLocked(oTarget) == FALSE)
                    {
                        if (GetIsOpen(oTarget) == FALSE)
                        {
                            AssignCommand(oTarget, ActionOpenDoor(oTarget));
                        }
                        else
                            AssignCommand(oTarget, ActionCloseDoor(oTarget));
                    }
                }
                if(!MyResistSpell(OBJECT_SELF, oTarget) && !/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
        	    {
                    effect eKnockdown = EffectKnockdown();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(3));
                    // Apply effects to the currently selected target.
                 //   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    
                 }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
    }
}

void DoETAoEBalagarsIronHorn(int nCasterLvl, int nMetaMagic, location lTarget)
{
	//Declare major variables
    object oCaster = OBJECT_SELF;
    float fDelay;
	float fMaxDelay;
    float nSize =  RADIUS_SIZE_HUGE;	// AFW-OEI 12/06/2006: Colossal -> Huge
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_BALAGARN_IRON_HORN );	// NWN2 VFX
    effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 20) nCasterLvl = 20;
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(d3()));
    //Apply epicenter explosion on caster
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, GetLocation(OBJECT_SELF));
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // * spell should not affect the caster
     	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && (oTarget != oCaster))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 436));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
    	    {
                effect eTrip = EffectKnockdown();
                // * DO a strength check vs. Strength 20
                if (d20() + GetAbilityScore(oTarget, ABILITY_STRENGTH) <= 20 + d20() )
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 6.0));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                    FloatingTextStrRefOnCreature(2750, OBJECT_SELF, FALSE);
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
	
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect( VFX_DUR_CONE_SONIC );
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}

void DoETAoEIsaacsLesserMissileStorm(int nCasterLevel, int nMetaMagic, location lTarget, object oTarget)
{
	DoETMissileStorm(1, 10, SPELL_ISAACS_LESSER_MISSILE_STORM, nMetaMagic, oTarget, VFX_IMP_MAGBLUE, DAMAGE_TYPE_MAGICAL, -1, 10);
}

void DoETAoEIsaacsGreaterMissileStorm(int nCasterLevel, int nMetaMagic, location lTarget, object oTarget)
{
    DoETMissileStorm(2, 20, SPELL_ISAACS_GREATER_MISSILE_STORM, nMetaMagic, oTarget, VFX_IMP_MAGBLUE, DAMAGE_TYPE_MAGICAL, -1, 10);
}

void DoETAoESunburst(int nCasterLvl, int nMetaMagic, location lTarget)
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nDamage = 0;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    effect eHitVis = EffectVisualEffect( VFX_HIT_SPELL_HOLY );
    effect eLOS = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    effect eDam;
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 25) nCasterLvl = 25;
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eLOS, lTarget);
    int bDoNotDoDamage = FALSE;

	
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBURST));
            //This visual effect is applied to the target object not the location as above.  This visual effect
            //represents the flame that erupts on the target not on the ground.
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHitVis, oTarget);

            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                {
                    //Roll damage for each target
                    nDamage = MaximizeOrEmpower(6, nCasterLvl, nMetaMagic);
                }
                else
                {
                    nDamage = MaximizeOrEmpower(6, 6, nMetaMagic);
               	}

                // * if a vampire then destroy it
                if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_MALE || GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_FEMALE /*|| GetStringLowerCase(GetSubRace(oTarget)) == "vampire"*/ )
                {
                    // SpeakString("I vampire");
                    // * if reflex saving throw fails no blindness
                    if (!ReflexSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
                    {
                        effect eDead = EffectDamage(GetCurrentHitPoints(oTarget));
                        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);

                        //Apply epicenter explosion on caster
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oTarget);

                        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDead, oTarget));
                        bDoNotDoDamage = TRUE;
                    }
                }
                if (bDoNotDoDamage == FALSE)
                    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL);

                // * Do damage
                if ((nDamage > 0) && (bDoNotDoDamage == FALSE))
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

                    // Apply effects to the currently selected target.
                    DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

                     // * if reflex saving throw fails apply blindness
                    if (!ReflexSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
                    {
                        effect eBlindness = EffectBlindness();
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlindness, oTarget);
                    }
                } // nDamage > 0
             }

             //-----------------------------------------------------------------
             // GZ: Bugfix, reenable damage for next object
             //-----------------------------------------------------------------
             bDoNotDoDamage = FALSE;
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}


void DoETAoEMestilsAcidBreath(int nCasterLevel, int nMetaMagic, location lTargetLocation)
{
    //Declare major variables
    int nDamage;
    float fDelay;
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_ACID);
	float fMaxDelay = 0.0f; // used to determine duration of eCone effect
    object oTarget;
    //Limit Caster level for the purposes of damage.
    if (nCasterLevel > 10) nCasterLevel = 10;
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
    	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the target and caster to delay the application of effects
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
            //Make SR check, and appropriate saving throw(s).
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
            {
                //Detemine damage
                nDamage = d6(nCasterLevel);
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLevel;//Damage is at max
                else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID);
                // Apply effects to the currently selected target.
                effect eAcid = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
                effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
                if(nDamage > 0)
                {
                    //Apply delayed effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 8.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}

void DoETAoECloudOfBewilderment(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables
    effect eAOE = EffectAreaOfEffect( AOE_PER_FOG_OF_BEWILDERMENT );
    int nDuration = nCasterLevel;
    effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    if (nDuration < 1) nDuration = 1;
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;   //Duration is +100%
    //Create the AOE object at the selected location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETAoEGedleesElectricLoop(int nCasterLevel, int nMetaMagic, location lTarget)
{
	effect   eStrike    = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    float    fDelay;
    effect   eBeam;
    int      nDamage;
    int      nPotential;
    effect   eDam;
    object   oLastValid;
    effect   eStun = EffectLinkEffects(EffectVisualEffect(VFX_IMP_STUN),EffectStunned());

    //--------------------------------------------------------------------------
    // Calculate Damage Dice. 1d per 2 caster levels, max 5d
    //--------------------------------------------------------------------------
    int nNumDice = nCasterLevel/2;
    if (nNumDice<1) nNumDice = 1;
    else if (nNumDice >5) nNumDice = 5;
    //--------------------------------------------------------------------------
    // Loop through all targets
    //--------------------------------------------------------------------------
	// BCH - OEI 03/17/06, bumped up to MEDIUM size otherwise it only hits one target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            //------------------------------------------------------------------
            // Calculate delay until spell hits current target. If we are the
            // first target, the delay is the time until the spell hits us
            //------------------------------------------------------------------
            if (GetIsObjectValid(oLastValid))
            {
                   fDelay += 0.2f;
                   fDelay += GetDistanceBetweenLocations(GetLocation(oLastValid), GetLocation(oTarget))/20;
            }
            else
            {
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            }

            //------------------------------------------------------------------
            // If there was a previous target, draw a lightning beam between us
            // and iterate delay so it appears that the beam is jumping from
            // target to target
            //------------------------------------------------------------------
            if (GetIsObjectValid(oLastValid))
            {
                 eBeam = EffectBeam(VFX_BEAM_LIGHTNING, oLastValid, BODY_NODE_CHEST);
                 DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam,oTarget,1.5f));
            }

            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {

                nPotential = MaximizeOrEmpower(6, nNumDice, nMetaMagic);
                nDamage    = GetReflexAdjustedDamage(nPotential, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);

                //--------------------------------------------------------------
                // If we failed the reflex save, we save vs will or are stunned
                // for one round
                //--------------------------------------------------------------
                if (nPotential == nDamage || (GetHasFeat(FEAT_IMPROVED_EVASION,oTarget) &&  nDamage == (nPotential/2)))
                {
                    if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                    {
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eStun,oTarget, RoundsToSeconds(1)));
                    }

                }


                if (nDamage >0)
                {
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, oTarget));
                 }
            }

            //------------------------------------------------------------------
            // Store Target to make it appear that the lightning bolt is jumping
            // from target to target
            //------------------------------------------------------------------
            oLastValid = oTarget;

        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }

}

void DoETAoEScintillatingSphere(int nCasterLvl, int nMetaMagic, location lTarget)
{
	//Declare major variables
    object oCaster = OBJECT_SELF;
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
     //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10) nCasterLvl = 10;
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                //Resolve metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = 6 * nCasterLvl;
                else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage = nDamage + nDamage / 2;
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void DoUndeadToDeath(object oCreature)
{
    SignalEvent(oCreature, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    SetLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD", TRUE);

    if (!MySavingThrow(SAVING_THROW_WILL,oCreature,GetSpellSaveDC(),SAVING_THROW_TYPE_NONE,OBJECT_SELF))
    {
       float fDelay = GetRandomDelay(0.2f,0.4f);
       if (!MyResistSpell(OBJECT_SELF, oCreature, fDelay))
       {
            effect eDeath = EffectDamage(GetCurrentHitPoints(oCreature),DAMAGE_TYPE_DIVINE,DAMAGE_POWER_ENERGY);
            effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
            DelayCommand(fDelay+0.5f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oCreature));
            DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oCreature));
       }
       else
       {
            DelayCommand(1.0f,DeleteLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD"));
       }
   }
          else
       {
            DelayCommand(1.0f,DeleteLocalInt(oCreature,"X2_EBLIGHT_I_AM_DEAD"));
       }
}

void DoETAoEUndeathToDeath(int nCasterLevel, int nMetaMagic, location lLoc)
{
     int nLevel = nCasterLevel;
     if (nLevel>20) nLevel = 20;
     // calculate number of hitdice affected
     int nLow = 9999;
     object oLow;
     int nHDLeft = nLevel *d4();
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE) nHDLeft = 4 * GetCasterLevel(OBJECT_SELF);//Damage is at max
    if (nMetaMagic == METAMAGIC_EMPOWER) nHDLeft += (nHDLeft/2); //Damage/Healing is +50%
    int nCurHD;
    object oFirst = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f,lLoc );
    // Only start loop if there is a creature in the area of effect
     if  (GetIsObjectValid(oFirst))
     {

        object oTarget = oFirst;
        while (GetIsObjectValid(oTarget) && nHDLeft >0)
        {

            if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                nCurHD = GetHitDice(oTarget);
                if (nCurHD <= nHDLeft )
                {
                    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                    {
                        // ignore creatures already affected
                        if (GetLocalInt(oTarget,"X2_EBLIGHT_I_AM_DEAD") == 0 && !GetPlotFlag(oTarget) && !GetIsDead(oTarget))
                        {
                            // store the creature with the lowest HD
                            if (GetHitDice(oTarget) <= nLow)
                            {
                                nLow = GetHitDice(oTarget);
                                oLow = oTarget;
                            }
                        }
                    }
                }
            }

            // Get next target
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f ,lLoc);

            // End of cycle, time to kill the lowest creature
            if (!GetIsObjectValid(oTarget))
            {
                // we have a valid lowest creature we can affect with the remaining HD
                if (GetIsObjectValid(oLow) && nHDLeft >= nLow)
                {
                    DoUndeadToDeath(oLow);
                    // decrement remaining HD
                    nHDLeft -= nLow;
                    // restart the loop
                    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, GetSpellTargetLocation());
                }
                // reset counters
                oLow = OBJECT_INVALID;
                nLow = 9999;
            }
        }
    }
}

void DoETAoEConfusion(int nCasterLevel, int nMetaMagic, location lTarget)
{   //Declare major variables
    object oTarget;
    int nDuration = nCasterLevel;
    effect eConfuse = EffectConfused();
    effect eMind = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
    float fDelay;
    //Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eMind, eConfuse);
    //Perform metamagic checks
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration * 2;
    
	//Search through target area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	while (GetIsObjectValid(oTarget))
	{
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONFUSION));
           fDelay = GetRandomDelay();
           //Make SR Check and faction check
           if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
    	   {
                //Make Will Save
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                   //Apply linked effect and VFX Impact
                   nDuration = GetScaledDuration(GetCasterLevel(OBJECT_SELF), oTarget);
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                   //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	// NWN1 VFX
                }
            }
        }
        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
	}
}

void DoETAoEDarkness(int nCasterLevel, int nMetaMagic, location lTarget, object oTarget)
{
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
	if (GetIsObjectValid(oTarget))
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARKNESS));
    int nDuration = nCasterLevel;
    //Make sure duration does no equal 0
    if (nDuration < 1) nDuration = 1;
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETAoEDelayedBlastFireball(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DELAY_BLAST_FIREBALL);
    int nDuration = nCasterLevel / 2;
    //Make sure the duration is at least one round
    if (nDuration == 0) nDuration = 1;
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;//Duration is +100%
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETAoEDispelMagic(int nCasterLevel, int nMetaMagic, location lLocal)
{
	effect    eVis         = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
	effect 	  eImpact; // Required for the spellsDispelMagic function, but this effect is now handled by spells.2da
					   //   function never uses this value, anyway.
    if(nCasterLevel > 10) nCasterLevel = 10;
	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT) spellsDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);
            
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
            }

           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
}


void DoETAoEFear(int nCasterLevel, int nMetaMagic, location lTarget)
{
	float fDuration = RoundsToSeconds(nCasterLevel);
    int nDamage;
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FEAR );	// NWN2 VFX
    effect eFear = EffectFrightened();
	eFear = EffectLinkEffects( eFear, eVis );
    float fDelay;

    object oTarget;
    //Check for metamagic extend
	if (nMetaMagic == METAMAGIC_EXTEND) fDuration = fDuration * 2.0;	//Duration is +100%
	//Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
            //Make SR Check
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Make a will save
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration));
					//DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	// NWN1 VFX
                }
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE);
    }
}

void DoETAoEGreaterDispelMagic(int nCasterLevel, int nMetaMagic, location lLocal)
{
    // End of Spell Cast Hook

    effect   eVis         = EffectVisualEffect( VFX_HIT_SPELL_ABJURATION );
	effect   eImpact; // Now handled by spells.2da, the ImpactSEF column, but effect required for spellsDispelMagic
    int      nCasterLevel = GetCasterLevel( OBJECT_SELF );

    if(nCasterLevel >15 ) nCasterLevel = 15;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                //--------------------------------------------------------------
                // Handle Area of Effects
                //--------------------------------------------------------------
                spellsDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);
            }
            else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            }
            else
            {
                spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
        }
}

void DoETAoEEvardsBlackTentacles(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_EVARDS_BLACK_TENTACLES);
    int nDuration = nCasterLevel;
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration = nDuration *2;	//Duration is +100%
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

void DoETAoEFireburst(int nCasterLvl, int nMetaMagic, location lTarget)
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nMaxLvl; 
    if ( nCasterLvl > 5 ) nMaxLvl = 5;    
    else nMaxLvl = nCasterLvl;
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    //Apply the ice storm VFX at the location captured above.
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) //&& oTarget != oCaster) //Additional target check to make sure that the caster cannot be harmed by this spell
        {
            fDelay = GetRandomDelay(0.15, 0.35);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBURST));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
			
				nDamage = d8(nMaxLvl);
				nDamage = ApplyMetamagicVariableMods(nDamage, nMaxLvl * 8);
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
			
				 if ( nDamage > 0 )
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the impact that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                } 
               }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void DoETAoEDeepSlumber(int nCasterLevel, int nMetaMagic, location lTarget)
{
   //Declare major variables
    object oTarget;
    object oLowest;
    effect eSleep =  EffectSleep();
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);

     // * Moved the linking for the ZZZZs into the later code
     // * so that they won't appear if creature immune

    int bContinueLoop;
    int nHD = 10 + d10();
    int nCurrentHD;
    int bAlreadyAffected;
    int nMax = 9;// maximun hd creature affected
    int nLow;
    int nDur = nCasterLevel;
    nDur = 3 + GetScaledDuration(nDur, oTarget);
    float fDuration = RoundsToSeconds(nDur);

    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);

    //Enter Metamagic conditions
    nHD = ApplyMetamagicVariableMods(nHD, 20);
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    fDuration += RoundsToSeconds(2);

    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    //If no valid targets exists ignore the loop
    if (GetIsObjectValid(oTarget))
    {
        bContinueLoop = TRUE;
    }
    // The above checks to see if there is at least one valid target.
    while ((nHD > 0) && (bContinueLoop))
    {
        nLow = nMax;
        bContinueLoop = FALSE;
        //Get the first creature in the spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            //Make faction check to ignore allies
        	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
                && GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
        	{
                //Get the local variable off the target and determined if the spell has already checked them.
                bAlreadyAffected = GetLocalInt(oTarget, sSpellLocal);
                if (!bAlreadyAffected)
                {
                     //Get the current HD of the target creature
                     nCurrentHD = GetHitDice(oTarget);
                     //Check to see if the HD are lower than the current Lowest HD stored and that the
                     //HD of the monster are lower than the number of HD left to use up.
                     if(nCurrentHD < nLow && nCurrentHD <= nHD && nCurrentHD < 6)
                     {
                         nLow = nCurrentHD;
                         oLowest = oTarget;
                         bContinueLoop = TRUE;
                     }
                }
            }
            //Get the next target in the shape
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
        }
        //Check to see if oLowest returned a valid object
        if(oLowest != OBJECT_INVALID)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLEEP));
            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oLowest))
            {
                //Make Will save
                if(!MySavingThrow(SAVING_THROW_WILL, oLowest, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest);
                    if (GetIsImmune(oLowest, IMMUNITY_TYPE_SLEEP) == FALSE)
                    {
                        ApplyEffectToObject(nDurType, eSleep, oLowest, fDuration);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest);
                    }
                    else
                    // * even though I am immune apply just the sleep effect for the immunity message
                    {
                        ApplyEffectToObject(nDurType, eSleep, oLowest, fDuration);
                    }

                }
            }
        }
        //Set a local int to make sure the creature is not used twice in the pass.  Destroy that variable in
        //.3 seconds to remove it from the creature
        SetLocalInt(oLowest, sSpellLocal, TRUE);
        DelayCommand(0.5, SetLocalInt(oLowest, sSpellLocal, FALSE));
        DelayCommand(0.5, DeleteLocalInt(oLowest, sSpellLocal));
        //Remove the HD of the creature from the total
        nHD = nHD - GetHitDice(oLowest);
        oLowest = OBJECT_INVALID;
    }
}

void DoETAoEBanishment(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables
    object oMaster;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
    int nSpellDC;
    //Get the first object in the are of effect
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);

    // * the pool is the number of hit dice of creatures that can be banished
    int nPool = 2* nCasterLevel;

    while(GetIsObjectValid(oTarget))
    {
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        if (oMaster == OBJECT_INVALID)
        {
            oMaster = OBJECT_SELF;  // TO prevent problems with invalid objects
                                    // passed into GetAssociate
        }

        // * BK: Removed the master check, only applys to Dismissal not banishment
        //Is that master valid and is he an enemy
       // if(GetIsObjectValid(oMaster) && GetIsEnemy(oMaster))
        {
            // * Is the creature a summoned associate
            // * or is the creature an outsider
            // * and is there enough points in the pool
            if(
               (GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget ) ||
               (GetRacialType((oTarget)) == RACIAL_TYPE_OUTSIDER)  &&
               (nPool > 0)
               )
            {
                // * March 2003. Added a check so that 'friendlies' will not be
                // * unsummoned.
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 430));
                    //Determine correct save
                    nSpellDC = GetSpellSaveDC();// + 6;
                    // * Must be enough points in the pool to destroy target
                    if (nPool >= GetHitDice(oTarget))
                    // * Make SR and will save checks
                    if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                    {
                         //Apply the VFX and delay the destruction of the summoned monster so
                         //that the script and VFX can play.

                         nPool = nPool - GetHitDice(oTarget);
                         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
                         if (CanCreatureBeDestroyed(oTarget) == TRUE)
                         {
                            //bugfix: Simply destroying the object won't fire it's OnDeath script.
                            //Which is bad when you have plot-specific things being done in that
                            //OnDeath script... so lets kill it.
                            effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
                            //just to be extra-sure... :)
                            effect eDeath = EffectDeath(FALSE, FALSE);
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                            DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));

                            //DestroyObject(oTarget, 0.3);
                         }
                    }
                } // rep check
            }
        }
        //Get next creature in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}

void DoETAoEChainLightning(int nCasterLevel, int nMetaMagic, location lSpellLocation)
{
	//Declare major variables
    //Limit caster level
    // June 2/04 - Bugfix: Cap the level BEFORE the damage calculation, not after. Doh.
    if (nCasterLevel > 20)
    {
        nCasterLevel = 20;
    }
    int nDamage = d6(nCasterLevel);
    int nDamStrike;
    int nNumAffected = 0;
    //Declare lightning effect connected the casters hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);;
    effect eVis  = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    effect eDamage;
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = 6 * nCasterLevel;//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDamage = nDamage + (nDamage/2); //Damage/is +50%
    }
    //Damage the initial target
    if (spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
        //Make an SR Check
        if (!MyResistSpell(OBJECT_SELF, oFirstTarget))
        {
            //Adjust damage via Reflex Save or Evasion or Improved Evasion
            nDamStrike = GetReflexAdjustedDamage(nDamage, oFirstTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);
            //Set the damage effect for the first target
            eDamage = EffectDamage(nDamStrike, DAMAGE_TYPE_ELECTRICAL);
            //Apply damage to the first target and the VFX impact.
            if(nDamStrike > 0)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oFirstTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
            }
        }
    }
    //Apply the lightning stream effect to the first target, connecting it with the caster
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);


    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);


    float fDelay = 0.2;
    int nCnt = 0;


    // *
    // * Secondary Targets
    // *


    //Get the first target in the spell shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget) && nCnt < nCasterLevel)
    {
        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
            //Do an SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {

                nDamage = d6(nCasterLevel) ;

                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 6 * nCasterLevel;//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2); //Damage/is +50%
                }
                //Adjust damage via Reflex Save or Evasion or Improved Evasion
                nDamStrike = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ELECTRICITY);
                //Apply the damage and VFX impact to the current target
                eDamage = EffectDamage(nDamStrike /2, DAMAGE_TYPE_ELECTRICAL);
                if(nDamStrike > 0) //age > 0)
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                }
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
            eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
            }
            else
            {
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
                if(GetIsEffectValid(eNewLightning))
                {
                    eLightning =  eNewLightning;
                }
            }

            fDelay = fDelay + 0.1f;
        }
        //Count the number of targets that have been hit.
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            nCnt++;
        }

        // April 2003: Setting the new origin for the beam
       // oFirstTarget = oTarget;

        //Get the next target in the shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
      }
 }
 
 void DoETAoECrushingDespair(int nCasterLvl, int nMetaMagic, location lTarget, object oTarget)
 {
 	//Declare major variables
    object oOrigTgt = oTarget;
    //Get the spell target location as opposed to the spell target.
    float fDuration = TurnsToSeconds(nCasterLvl);
    int nNumTargets = (nCasterLvl / 3) + 1;

    // Do Metamagic Checks
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            // * added rep check April 2003
			// Removed rep check Spetember 2006 cause that ain't how we roll
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) == TRUE)
            {
                nNumTargets = nNumTargets - 1;

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    //Make Will save versus fear
                    if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
						//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);	// NWN1 VFX
						effect eHit = EffectVisualEffect( VFX_DUR_SPELL_CRUSHING_DESP );	// NWN2 VFX
// Ability & Skill ***CHECKS***!!!
                        //effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
                        //effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
                        //effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
                        //effect eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 2);
                        //effect eWis = EffectAbilityDecrease(ABILITY_WISDOM, 2);
                        //effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, 2);
//Ability scores are no longer reduced by two.  This was an incorrect interpretation of the rules. //PKM OEI 11.02.06						

                        effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);

                        effect eDamagePenalty = EffectDamageDecrease(2);
                        effect eAttackPenalty = EffectAttackDecrease(2);
                        //effect eLink2 = EffectLinkEffects(eSkill, eStr );
                        //eLink2 = EffectLinkEffects(eLink2, eDex );
                        //eLink2 = EffectLinkEffects(eLink2, eCon );
                        //eLink2 = EffectLinkEffects(eLink2, eInt );
                        //eLink2 = EffectLinkEffects(eLink2, eWis );
                        //eLink2 = EffectLinkEffects(eLink2, eCha );
                        //eLink2 = EffectLinkEffects(eLink2, eDamagePenalty);
                        //eLink2 = EffectLinkEffects(eLink2, eAttackPenalty);
						effect eLink2 = EffectLinkEffects(eDamagePenalty, eAttackPenalty);

                        //Apply linked effects and VFX impact
                        ApplyEffectToObject(nDurType, eSave, oTarget, fDuration);
                        ApplyEffectToObject(nDurType, eLink2, oTarget, fDuration);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
                    }
                }
            }
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void DoETAoELightningBolt(int nCasterLevel, int nMetaMagic, location lTarget, object oTarget)
{
     //Limit caster level
    if (nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }
    int nDamage;

    //Set the lightning stream to start at the caster's hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
    effect eDamage;
	location lTarget2 = GetSpellTargetLocation();
	
	//string sTarget2 = "wp_lbolttrgt2";
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
	
	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget2);
	SetScriptHidden(oPoint, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
	//CreateObject(OBJECT_TYPE_WAYPOINT, sTarget2, lTarget2);
	//object oPoint = GetObjectByTag(sTarget2);
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	//PrettyDebug("Lightning bolt!  Woo Hoo!");
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
		//PrettyDebug("investigating target " + GetName(oTarget));
         while (GetIsObjectValid(oTarget))
        {
           //Exclude the caster from the damage effects
           if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
           {
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{
                   //Fire cast spell at event for the specified target
					//PrettyDebug("Signaling Lightning Bolt on " + GetName(oTarget));
                   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHTNING_BOLT));
                   //Make an SR check
                   if (!MyResistSpell(OBJECT_SELF, oTarget))
        	       {
                        //Roll damage
                        nDamage =  d6(nCasterLevel);
        		        //Enter Metamagic conditions
        		        if (nMetaMagic == METAMAGIC_MAXIMIZE)
        		        {
        			         nDamage = 6 * nCasterLevel;//Damage is at max
                        }
        		        if (nMetaMagic == METAMAGIC_EMPOWER)
        		        {
        			         nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                        }
                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_ELECTRICITY);
                        //Set damage effect
                        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
                        if(nDamage > 0)
                        {
                            fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            //Apply VFX impcat, damage effect and lightning effect
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                        }
                    }
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oNextTarget, BODY_NODE_CHEST);
                }
           }
           //Get the next object in the lightning cylinder
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        }
        nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}

void DoETAoESilence(int nCasterLevel, int nMetaMagic, location lTarget, object oTarget)
{
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect( AOE_MOB_SILENCE );
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_SILENCE );
    float fDuration = RoundsToSeconds(nCasterLevel);
	
    //Make sure duration does no equal 0
    if (fDuration < 1.0)
    {
        fDuration = 1.0;
    }
    //Check Extend metamagic feat.
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if ( GetIsObjectValid(oTarget) )	// for when the spell is cast on a target
	{
	    if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	    {
	        if ( !MyResistSpell(OBJECT_SELF, oTarget) )
	        {
	            if ( !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()) )
	            {	
	                //Create an instance of the AOE Object using the Apply Effect function
	                ApplyEffectToObject( nDurType, eAOE, oTarget, fDuration );
					ApplyEffectToObject( DURATION_TYPE_INSTANT, eHit, oTarget );
					SetLocalInt(oTarget, EVENFLW_SILENCE, TRUE);
	            }
	        }
			if(!GetIsInCombat(oTarget))
				SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE) );
	    }
	    else
	    {
			int nObjectType = GetObjectType( oTarget );
			if ( nObjectType == OBJECT_TYPE_CREATURE )
			{
				ApplyEffectToObject( nDurType, eHit, oTarget, fDuration );
				//Create an instance of the AOE Object using the Apply Effect function
	        	ApplyEffectToObject( nDurType, eAOE, oTarget, fDuration );
				SetLocalInt(oTarget, EVENFLW_SILENCE, TRUE);
	        	//Fire cast spell at event for the specified target
	        	SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE, FALSE) );
			}
			else
			{
				lTarget = GetLocation( oTarget );
		        //Create an instance of the AOE Object using the Apply Effect function
		        ApplyEffectAtLocation( nDurType, eAOE, lTarget, fDuration );				
			}
	    }	
	}
	else	// for when the spell is cast at a location
	{
		//Create an instance of the AOE Object using the Apply Effect function
	    ApplyEffectAtLocation( nDurType, eAOE, lTarget, fDuration );
		//ApplyEffectAtLocation( nDurType, eHit, lTarget, fDuration );
	}
}

void DoETAoESoundBurst(int nCasterLevel, int nMetaMagic, location lLoc)
{
	//Declare major variables
    object oTarget;
    int nDamage;
    effect eStun = EffectStunned();
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
    //effect eFNF = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
    effect eMind = EffectVisualEffect(VFX_DUR_STUN);
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eStun, eMind);
    //eLink = EffectLinkEffects(eLink, eDur);

    effect eDam;
    int nDC = GetSpellSaveDC();
    //Apply the FNF to the spell location
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, lLoc);
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SOUND_BURST));
            //Make a SR check
            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Roll damage
                nDamage = d8();
                //Make a Fort roll to avoid being stunned
//                if(!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
                }
                //Make meta magic checks
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 8;
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2);
                }
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
                //Apply the VFX impact and damage effect
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,oTarget);
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
            }
        }
        //Get the next target in the spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
    }
}

void DoETAoESongOfDiscord(int nCasterLevel, int nMetaMagic, location lTarget)
{
	    //Declare major variables
	object oCaster 	= OBJECT_SELF;
    effect eImpact 	= EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT);
    //effect eVis	 	= EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    //effect eMind 	= EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur 	= EffectVisualEffect( VFX_DUR_SPELL_SONG_OF_DISCORD );
    float fDelay	= 0.0f;
	int nDuration 	= 0;

    //Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eDur, eConfuse);
    //eLink = EffectLinkEffects(eLink, eDur);
	
	// Run the visual effect
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget );

    //Search through target area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
	while (GetIsObjectValid(oTarget))
	{
        if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) )
    	{
           //Fire cast spell at event for the specified target
           SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_SONG_OF_DISCORD) );
           fDelay = GetRandomDelay();

           //Make SR Check and faction check
           if ( !MyResistSpell(oCaster, oTarget, fDelay) )
    	   {
                //Make Will Save
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
                {
                   //Apply linked effect and VFX Impact
                   nDuration = GetScaledDuration( nCasterLevel, oTarget );
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDuration ) ));
                   //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }

        //Get next target in the shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
	}
}

void DoETAoEWarCry(int nLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables
    object oTarget;
    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(2, DAMAGE_TYPE_SLASHING);
    effect eFear = EffectFrightened();
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
    effect eLOS = EffectVisualEffect(VFX_HIT_AOE_SONIC);
	effect eBuf = EffectVisualEffect ( VFX_DUR_SPELL_WAR_CRY );
	effect eVisFear = EffectVisualEffect (VFX_DUR_SPELL_CAUSE_FEAR);
    effect eLink = EffectLinkEffects(eAttack, eDamage);
	eLink = EffectLinkEffects(eLink, eBuf);
	eFear = EffectLinkEffects (eFear, eVisFear);
    //Meta Magic
    if(nMetaMagic == METAMAGIC_EXTEND)
    {
       nLevel *= 2;
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLOS, OBJECT_SELF);
    //Determine enemies in the radius around the bard
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY));
           //Make SR and Will saves
           if(!MyResistSpell(OBJECT_SELF, oTarget)  && !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
            {
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(4)));
				//DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));VFX we don't need
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    }
    //Apply bonus and VFX effects to bard.
    RemoveSpellEffects(GetSpellId(),OBJECT_SELF,OBJECT_SELF);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF); //PMils OEI 07.08.06- NWN1 stuff, in NWN2 we're trying to not use the hit fx for buffs
	DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nLevel)));
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY, FALSE));
}

void DoETAoEDirge(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables including Area of Effect Object
    //change from AOE_PER_FOGMIND to AOE_MOB_CIRCGOOD
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "x0_s0_dirgeEN", "x0_s0_dirgeHB", "x0_s0_dirgeEX");
    int nDuration = nCasterLevel;
    //effect eImpact = EffectVisualEffect(257);	// NWN1 VFX
    //effect eCaster = EffectVisualEffect(VFX_DUR_BARD_SONG);	// NWN1 VFX

    //effect eFNF = EffectVisualEffect(VFX_FNF_SOUND_BURST);	// NWN1 VFX
    //Apply the FNF to the spell location
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, GetLocation(OBJECT_SELF));	// NWN1 VFX

    
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetLocation(OBJECT_SELF));	// NWN1 VFX; this is now handled in spells.2da
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration *2;	//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, RoundsToSeconds(nDuration));
    
}

void DoETAoECacophonicBurst(int nCasterLvl, int nMetaMagic, location lTarget)
{
	//Declare major variables
	object oCaster = OBJECT_SELF;
	int nDamage;
	float fDelay;
	effect eImpactVis = EffectVisualEffect(VFX_COM_HIT_SONIC);
	effect eDam;
	
//determine unmodded damage	
	if (nCasterLvl > 15)
	{
		nCasterLvl = 15;
	}

	nDamage = d6(nCasterLvl);
	nDamage = ApplyMetamagicVariableMods(nDamage, 90);

//target discrimination and application of effects
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//Signal spell cast at event
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1016));
			//delay the explosion impacts for visual flair
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (!MyResistSpell(oCaster, oTarget, fDelay))
			{
				//reflex save
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC);
				//set damage effect
				eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
				if (nDamage > 0)
				{
					// Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpactVis, oTarget));
				}
			}
		}
		//find my next victim
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}
	
void DoETAoEBurstOfGlacialWrath(int nCasterLvl, int nMetaMagic, location lLocation)
{
	//Declare major variables
	
	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetFirstObjectInShape(SHAPE_SPHERE, 15.0, lLocation, FALSE);
	int			nDam;
	int			nHP;
	int			nFreezeLvl	=	nCasterLvl / 2;
	effect		eFreeze		=	EffectPetrify();
	effect		eVis		=	EffectVisualEffect(VFX_HIT_SPELL_ICE);
	effect 		eDur		=	EffectVisualEffect(VFX_DUR_SPELL_GLACIAL_WRATH);
	effect		eDam;
	effect		eCold		=	EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
	effect		eElec		=	EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
	effect		eFire		=	EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 100);
	effect		eDR			=	EffectDamageReduction(10);
	effect		eLink;
	effect		eCone		=	EffectVisualEffect(VFX_DUR_CONE_ICE);
	float		fDuration;
	float 		fDist;
	
//determine duration of freeze + metmagic
	if (nCasterLvl > 25)
	{
		nCasterLvl	=	25;
	}
	if (nFreezeLvl > 10)
	{
		nFreezeLvl	=	10;
	}
	
	fDuration	=	RoundsToSeconds(nFreezeLvl);
	fDuration	=	ApplyMetamagicDurationMods(fDuration);
	
//link freeze effects
	eLink	=	EffectLinkEffects(eFreeze, eDur);
	eLink	=	EffectLinkEffects(eLink, eCold);
	eLink	=	EffectLinkEffects(eLink, eElec);
	eLink	=	EffectLinkEffects(eLink, eDR);
	eLink	=	EffectLinkEffects(eLink, eFire);
	eLink	=	EffectLinkEffects(eLink, eVis);


//begin cycling targets + basic discrimination
	while (GetIsObjectValid(oTarget))
	{	//FoF discrimination
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, 1045, TRUE));
			fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/10;
			if (!ResistSpell(oCaster, oTarget))
			{
				//determine damage + metamagic
				nDam	=	d6(nCasterLvl);
				nDam	=	ApplyMetamagicVariableMods(nDam, 150);
				
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD, oCaster))
				{
					nDam	=	nDam / 2;
				}
				
				//determine hp of current target
				nHP		=	GetCurrentHitPoints(oTarget);
				if (nHP-nDam <= 1)
				{
				//	once hit, this sets the creatures hp at 1
				//	NOTE: THIS DOESN'T WORK IF THE TARGET ABSORBS DAMAGE!  I'M STUMPED (ryan young)
					nDam = nHP-1;
					eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
					DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration));
				
				//	effect eRevive 	= EffectHealOnZeroHP(oTarget, 200);
				//	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRevive, oTarget, TurnsToSeconds(50));
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				//	RemoveEffect(oTarget, eRevive);
				}
				else {
					eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration));
				}
									
				//check HP of target, if HP < 10 deal freeze(link) effect	
				nHP		=	GetCurrentHitPoints(oTarget);
				if	(nHP <= 10)
				{			
					DelayCommand(fDist, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				}
			}
			
		}
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, 3.0);
		//cycle back to the next target
		oTarget		=	GetNextObjectInShape(SHAPE_SPHERE, 15.0, lLocation, FALSE);
	}
}

void DoETAoEGreaterWallOfDispelMagic(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables
	effect 		eAOE	=	EffectAreaOfEffect(61);
	float		fDur	=	RoundsToSeconds(nCasterLevel);
	
//Find proper duration base don possible metamagic modifiers

				fDur	=	ApplyMetamagicDurationMods(fDur);

//Apply AOE effect to location
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDur);
}

void DoETAoEGreaterSHout(int nCasterlevel, int nMetaMagic, location lTarget)
{
	//Declare major variables

	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetFirstObjectInShape(SHAPE_SPHERE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	int			nDam;
	float		fDuration;
	float		fStun		=	RoundsToSeconds(1);
	effect		eDeaf		=	EffectDeaf();
	effect		eDam;
	effect		eImpact		=	EffectVisualEffect(VFX_HIT_SPELL_GREATER_SHOUT);
	effect		eCone		=	EffectVisualEffect(VFX_DUR_CONE_SONIC);	
	effect		eStun		=	EffectStunned();
	effect		eLink;
	
	while(GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1038));
			if (oTarget != oCaster)
			{
				//determine duration and damage + metamagic
				nDam		=	d6(10);
				fDuration	=	RoundsToSeconds(d6(4));
				
				nDam		=	ApplyMetamagicVariableMods(nDam, 30);
				fDuration	=	ApplyMetamagicDurationMods(fDuration);
				fStun		=	ApplyMetamagicDurationMods(fStun);
				
								
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC, oCaster))
				{
					nDam	=	nDam/2;
					eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
					
					eLink	=	EffectLinkEffects(eDam, eImpact);
					
					fDuration	=	fDuration/2;
					
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
					
				}
				else
				{
					eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
					
					eLink	=	EffectLinkEffects(eDam, eImpact);
					
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fStun);
				}
			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, 2.0);
}

void DoETAoEHissOfSleep(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables
	object 		oCaster 	=	OBJECT_SELF;
    object 		oTarget 	= 	GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE,OBJECT_TYPE_CREATURE);
    effect 		eDur 		= 	EffectVisualEffect(VFX_DUR_SPELL_HISS_OF_SLEEP);
	effect		eSleep		=	EffectSleep();
	effect		eLink		=	EffectLinkEffects(eSleep, eDur);
	float		fDuration	=	RoundsToSeconds(nCasterLevel);
	
	fDuration		=	ApplyMetamagicDurationMods(fDuration);

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
			{
            	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

void DoETAoEMassContagion(int nCasterLevel, int nMetaMagic, location lTarget)
{
    //Declare major variables
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	object oCaster = OBJECT_SELF;
    int nRand = Random(7)+1;
    int nDisease;
    //Use a random seed to determine the disease that will be delivered.
    switch (nRand)
    {
        case 1:
            nDisease = DISEASE_BLINDING_SICKNESS;
        break;
        case 2:
            nDisease = DISEASE_CACKLE_FEVER;
        break;
        case 3:
            nDisease = DISEASE_FILTH_FEVER;
        break;
        case 4:
            nDisease = DISEASE_MINDFIRE;
        break;
        case 5:
            nDisease = DISEASE_RED_ACHE;
        break;
        case 6:
            nDisease = DISEASE_SHAKES;
        break;
        case 7:
            nDisease = DISEASE_SLIMY_DOOM;
        break;
    }
	effect eDisease = EffectDisease(nDisease);
	
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//Signal spell cast at event
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1017));
			
			if (!MyResistSpell(oCaster, oTarget))
			{
				//disease resistance and saves are handled by the EffectDisease function automatically
				effect eHit = EffectVisualEffect( VFX_HIT_SPELL_NECROMANCY );
				//eDisease = EffectLinkEffects( eDisease, eHit );
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);

			}
		}
		//find my next victim
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}

void DoETAoEMassCurseOfImpendingBlades(int nCasterLevel, int nMetaMagic, location lLocation)
{
	//Declare major variables
	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	float		fDuration	=	TurnsToSeconds(nCasterLevel);
	int			nDurType	=	ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// AFW-OEI 06/27/2007: Add a hit effect.
	effect		eHit		= 	EffectVisualEffect(VFX_HIT_SPELL_CURSE_OF_IMPENDING_BLADES);
	effect		eAC			=	EffectACDecrease(2);
	effect 		eDur		=	EffectVisualEffect(VFX_DUR_SPELL_MASS_CURSE_OF_BLADES);
	effect		eLink		=	EffectLinkEffects(eAC, eDur);
	
//metamagic
	fDuration	=	ApplyMetamagicDurationMods(fDuration);
	
//Target discrimination, then apply effects

	
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{	
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1035));
			ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	}
}
	
void DoETAoEShout(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables
	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetFirstObjectInShape(SHAPE_SPHERE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	int			nDam;
	float		fDuration;
	effect		eDeaf		=	EffectDeaf();
	effect		eDam;
	effect		eImpact		=	EffectVisualEffect(VFX_HIT_SPELL_SHOUT);
	effect		eCone		=	EffectVisualEffect(VFX_DUR_CONE_SONIC);	
	effect		eLink;
	
	while(GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1037));
			if (oTarget != oCaster)
			{
				//determine duration and damage + metamagic
				nDam		=	d6(5);
				fDuration	=	RoundsToSeconds(d6(2));
				
				nDam		=	ApplyMetamagicVariableMods(nDam, 30);
				fDuration	=	ApplyMetamagicDurationMods(fDuration);
				
								
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC, oCaster))
				{
					nDam	=	nDam/2;
					eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
					
					eLink	=	EffectLinkEffects(eDam, eImpact);
					
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				}
				else
				{
					eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
					
					eLink	=	EffectLinkEffects(eDam, eImpact);
					
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
				}
			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, 2.0);
}
			
void DoETAoEScorchingRay(int nCasterLvl, int nMetaMagic, location lTarget, object oTarget)
{
	//Declare major variables
	location lCaster = lTarget;
	effect eRay = EffectBeam(VFX_BEAM_FIRE, oTarget, BODY_NODE_CHEST);
	effect eFire = EffectNWN2SpecialEffectFile("fx_ignition");
	
	int nNumRays = 0;
	if (nCasterLvl >= 11)
		nNumRays = 3;			// 3 Rays @ lvl 11
	else if (nCasterLvl >= 7)
		nNumRays = 2;			// 2 Rays @ lvl 7
	else if (nCasterLvl >= 3)
		nNumRays = 1;			// 1 Ray  @ lvl 3
		
	int nEnemies = 0;
    object oTarget 	= OBJECT_INVALID;

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget) && nEnemies <= nNumRays )
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
        {
            // * You can only fire missiles on visible targets
            if (GetObjectSeen(oTarget,OBJECT_SELF))
            {
                nEnemies++;
				//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oTarget, 2.5+(nNumRays-1));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
     }

     // * Exit if no enemies to hit
     if (nEnemies == 0 || nNumRays==0) 
        return; 

     // divide the missles evenly amongst the enemies;
    int nRaysPerTarget	= nNumRays / nEnemies;
	int nExtraRays   	= nNumRays % nEnemies;
	
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			//float fDelay = 2.5;
    while (GetIsObjectValid(oTarget))
    {
        // * caster cannot be harmed by this spell
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF)))
        {
			int nRays = nRaysPerTarget;
			if (nExtraRays > 0) {
				nRays = nRays + 1;
				nExtraRays = nExtraRays - 1;
			}
			
			int ni=0;
			float fDelay = 0.75;
			
			//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oTarget, fDelay+(nRays-1));
			
			while (ni<nRays) {
				
		        //Fire cast spell at event for the specified target
		        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				int nTouch      = TouchAttackRanged(oTarget);
		 
				// Ray spells require a ranged touch attack
				if (nTouch != TOUCH_ATTACK_RESULT_MISS)
				{	//Make SR check
		        	if (!MyResistSpell(OBJECT_SELF, oTarget))
		        	{	
						int nDamage = d6(4);

					
						//Enter Metamagic conditions
		    			/*int nMetaMagic = GetMetaMagicFeat();
		                if (nMetaMagic == METAMAGIC_MAXIMIZE)
		                {
		                    nDamage = 6*4;
		                }
		                if (nMetaMagic == METAMAGIC_EMPOWER)
		                {
		                     nDamage = nDamage + (nDamage/2);
		                }
						*/
						nDamage = ApplyMetamagicVariableMods(nDamage, 24);
						
						if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
						{
							nDamage = d6(8);
							nDamage = ApplyMetamagicVariableMods(nDamage, 48);
						}
		                
						//Set ability damage effect
		                effect eFireDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, FALSE);
		  			    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
		                effect eLink = EffectLinkEffects(eFireDamage, eVis);
		
		                //Apply the ability damage effect and VFX impact
		                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
					}
		        }
			   	DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));
				
				ni++;
				fDelay = fDelay + 1.6f;
			}			
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

	// If you want random selection of targets, and rays fired one right after the other instead
	// of all at the same time, use the code below.
	
	/*
	int nRaysLeft = nNumRays;
	float fDelay = 2.5;
	while (nRaysLeft > 0) {
		int nWhichEnemy = Random(nEnemies)-1;
    	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		
		while (nWhichEnemy >= 0) {
    		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			nWhichEnemy--;
		}
		if (GetIsObjectValid(oTarget) && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF)))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		 
			// Ray spells require a ranged touch attack
			if (TouchAttackRanged(oTarget) != TOUCH_ATTACK_RESULT_MISS) 
			{	//Make SR check
	        	if (!MyResistSpell(OBJECT_SELF, oTarget))
	        	{	
					int nDamage = d6(4);
				
					//Enter Metamagic conditions
	    			int nMetaMagic = GetMetaMagicFeat();
	                if (nMetaMagic == METAMAGIC_MAXIMIZE)
	                {
	                    nDamage = 6*4;
	                }
	                if (nMetaMagic == METAMAGIC_EMPOWER)
	                {
	                     nDamage = nDamage + (nDamage/2);
	                }
					
	                //Set ability damage effect
	                effect eFireDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, FALSE);
	  			    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	                effect eLink = EffectLinkEffects(eFireDamage, eVis);
	
	                //Apply the ability damage effect and VFX impact
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
				}
	        }
		   	DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));
		}
		fDelay = fDelay + 1.0;
		nRaysLeft--;
	}
	*/
}

void DoETAoEWallOfDispelMagic(int nCasterLevel, int nMetaMagic, location lTarget)
{
	//Declare major variables
	effect 		eAOE	=	EffectAreaOfEffect(61);
	float		fDur	=	RoundsToSeconds(nCasterLevel);
	
	//Find proper duration base don possible metamagic modifiers

	fDur	=	ApplyMetamagicDurationMods(fDur);

	//Apply AOE effect to location
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDur);
}
	