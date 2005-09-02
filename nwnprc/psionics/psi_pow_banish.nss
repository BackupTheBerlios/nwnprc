/*
   ----------------
   Banishment
   
   prc_pow_banish
   ----------------

   28/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 6
   Range: Close
   Target: One or more Extraplanar Creature
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 11
   
   This spell forces extraplanar creatures back to their home plane if they fails a save. Affected creatures include summons, 
   outsiders, and elementals. You can banish up to 2 HD per caster level. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 1);

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

    object oCaster = OBJECT_SELF;
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    
    if (nMetaPsi) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	
	if (nAugment > 0)
	{
		nDC += nAugment;
		nPen += nAugment;
	}
	
	if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || MyPRCGetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
		
		    //Fire cast spell at event for the specified target
        	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        	    
        	        //Make a saving throw check
        	        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        	        {
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        	        }
		}
	}
	
	
	object oMaster;
	effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
	effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
	location lLoc = PRCGetSpellTargetLocation();

	//Get the first object in the are of effect
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);

	int nPool = 2 * nCaster;

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
			if(nPool > 0 && (((GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget && GetStringLeft(GetTag(oTarget), 14) != "psi_astral_con") || GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget || GetTag(OBJECT_SELF)=="BONDFAMILIAR" || GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget) || MyPRCGetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL || MyPRCGetRacialType((oTarget)) == RACIAL_TYPE_OUTSIDER))
			{
				// * March 2003. Added a check so that 'friendlies' will not be
				// * unsummoned.
				if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
					//Determine correct save

					// * Must be enough points in the pool to destroy target
					if (nPool >= GetHitDice(oTarget))
					{
						

						// * Make SR and will save checks
						if (PRCMyResistPower(oCaster, oTarget, nPen) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
						{
							//Apply the VFX and delay the destruction of the summoned monster so
							//that the script and VFX can play.
							ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
							if (CanCreatureBeDestroyed(oTarget) == TRUE)
							{
								nPool = nPool - GetHitDice(oTarget);
								//bugfix: Simply destroying the object won't fire it's OnDeath script.
								//Which is bad when you have plot-specific things being done in that
								//OnDeath script... so lets kill it.
								effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
								//just to be extra-sure... :)
								effect eDeath = EffectDeath(FALSE, FALSE);
								DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
								DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
							}
						}
					}
				} // rep check
			}
		}
		//Get next creature in the shape.
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
	}	
	
	
	
	
	
    }
}