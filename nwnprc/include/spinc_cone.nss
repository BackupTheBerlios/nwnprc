/////////////////////////////////////////////////////////////////////
//
// DoCone - Function to apply an elemental cone damage effect given
// the following arguments:
//
//		nDieSize - die size to roll (d4, d6, or d8)
//		nBonusDam - bonus damage per die, or 0 for none
//		nConeEffect - unused (this is in 2da)
//		nVictimEffect - visual effect to apply to target(s)
//		nDamageType - elemental damage type of the cone (DAMAGE_TYPE_xxx)
//		nSaveType - save type used for cone (SAVE_TYPE_xxx)
//		nSchool - spell school, defaults to SPELL_SCHOOL_EVOCATION
//		nSpellID - spell ID to use for events
//
/////////////////////////////////////////////////////////////////////

void DoCone (int nDieSize, int nBonusDam, int nDieCap, int nConeEffect /* unused */, 
	int nVictimEffect, int nDamageType, int nSaveType,
	int nSchool = SPELL_SCHOOL_EVOCATION, int nSpellID = -1)
{
	SPSetSchool(nSchool);
	
	// Get the spell ID if it was not given.
	if (-1 == nSpellID) nSpellID = GetSpellId();
	
	// Get effective caster level and hand it to the SR engine.  Then
	// cap it at our die cap.
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
	int nPenetr = nCasterLvl + SPGetPenetr();
	

	if (nCasterLvl > nDieCap) nCasterLvl = nDieCap;
	
	// Figure out where the cone was targetted.
	location lTargetLocation = GetSpellTargetLocation();
	
	// Adjust the damage type of necessary.
	nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

	
	
	//Declare major variables
	int nDamage;
	float fDelay;
	object oTarget;

	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while(GetIsObjectValid(oTarget))
	{
		if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);
			
			//Get the distance between the target and caster to delay the application of effects
			fDelay = GetSpellEffectDelay(lTargetLocation, oTarget);
			
			//Make SR check, and appropriate saving throw(s).
			if(!SPResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay) && (oTarget != OBJECT_SELF))
			{
			        int nSaveDC = SPGetSpellSaveDC(oTarget,OBJECT_SELF);
				// Roll damage for each target
				int nDamage = SPGetMetaMagicDamage(nDamageType, nCasterLvl, nDieSize, nBonusDam);
				
				// Adjust damage according to Reflex Save, Evasion or Improved Evasion
				nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, nSaveType);

				// Apply effects to the currently selected target.
				if(nDamage > 0)
				{
					effect eDamage = SPEffectDamage(nDamage, nDamageType);
					effect eVis = EffectVisualEffect(nVictimEffect);
					DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
					PRCBonusDamage(oTarget);
				}
			}
		}
		
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	// Let the SR engine know that we are done and clear out school local var.

	SPSetSchool();
}

