/*
   ----------------
   Dominate
   
   prc_psi_dominate
   ----------------

   16/4/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 4
   Range: Medium
   Target: One Humanoid
   Duration: 1 Round/Level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   The target temporarily becomes a faithful and loyal servant of the caster.
   
   Augment: If you augment this power 1 time, this power also affects Animal, Fey, Giant, Magical Beast
   or Monstrous Humanoid. If you augment this power 3 times, this power also affects Aberration, Dragon, Outsider
   and Elementals. If you augment this beyond 3, it affects 1 additional target for each additional augmentation. It costs 2 power 
   points to augment once, 6 to augment 3 times, and 2 additional points for each augmentation beyond 3. For every 2 power points spent
   this way, the DC increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

int CheckRace(int nAugment, object oTarget, object oCaster);

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
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nTargetCount = 1;
	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDom = EffectDominated();
	effect eLink = EffectLinkEffects(eMind, eDom);
	
	//Augmentation effects to Damage
	if (nAugment > 0)	
	{
		nDC += nAugment;
		
		// Don't count augmenting for racial type as targets
		if (nAugment > 3)
		{
			nTargetCount += nAugment - 3;
		}
	}
	
	int nTargetRace = CheckRace(nAugment, oTarget, oCaster);
	
	if (nTargetRace)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
		
		    //Fire cast spell at event for the specified target
        	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        	    
        	        //Make a saving throw check
        	        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        	        {
        		        //Apply VFX Impact and daze effect
        	                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
        	        }
		}
	}
	
	if (nTargetCount > 1)
	{

		location lTarget = GetSpellTargetLocation();
		int nTargetsLeft = nTargetCount - 1;
		//Declare the spell shape, size and the location.  Capture the first target object in the shape.
		object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);

		//Cycle through the targets within the spell shape until you run out of targets.
		while (GetIsObjectValid(oAreaTarget) && nTargetsLeft > 0)
		{
		
			if (spellsIsTarget(oAreaTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oAreaTarget != OBJECT_SELF)
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oAreaTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				
				// Check Target's race
				nTargetRace = CheckRace(nAugment, oAreaTarget, oCaster);
				if (nTargetRace)
				{
					//Check for Power Resistance
					if (PRCMyResistPower(oCaster, oAreaTarget, nPen))
					{
			        	        //Make a saving throw check
			        	        if(!PRCMySavingThrow(SAVING_THROW_WILL, oAreaTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			        	        {
			        		        //Apply VFX Impact and daze effect
			        	                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAreaTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
			        	        }
					}
									
				// Use up a target slot only if we actually did something to it
				nTargetsLeft -= 1;
				}
			}
				
		//Select the next target within the spell shape.
		oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	}	
    }
}

int CheckRace(int nAugment, object oTarget, object oCaster)
{

	int nRacial = MyPRCGetRacialType(oTarget);
	int nTargetRace = FALSE;
	//Verify that the Racial Type is humanoid
	if((nRacial == RACIAL_TYPE_DWARF) || (nRacial == RACIAL_TYPE_ELF) || (nRacial == RACIAL_TYPE_GNOME) || (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) || (nRacial == RACIAL_TYPE_HALFLING) || (nRacial == RACIAL_TYPE_HUMAN) || (nRacial == RACIAL_TYPE_HALFELF) || (nRacial == RACIAL_TYPE_HALFORC) || (nRacial == RACIAL_TYPE_HUMANOID_ORC) || (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
        {
		nTargetRace = TRUE;
	}
	if (nAugment >= 1 || GetLevelByClass(CLASS_TYPE_THRALLHERD, OBJECT_SELF) >= 7)
	{
		if (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS || nRacial == RACIAL_TYPE_FEY || nRacial == RACIAL_TYPE_GIANT || nRacial == RACIAL_TYPE_ANIMAL || nRacial == RACIAL_TYPE_MAGICAL_BEAST || nRacial == RACIAL_TYPE_BEAST)
		{
			nTargetRace = TRUE;
		}
	}
	if (nAugment >= 3 || GetLevelByClass(CLASS_TYPE_THRALLHERD, OBJECT_SELF) >= 9)
	{
		if (nRacial == RACIAL_TYPE_ABERRATION || nRacial == RACIAL_TYPE_DRAGON || nRacial == RACIAL_TYPE_OUTSIDER || nRacial == RACIAL_TYPE_ELEMENTAL)
		{
			nTargetRace = TRUE;
		}
	}
	
	return nTargetRace;
}