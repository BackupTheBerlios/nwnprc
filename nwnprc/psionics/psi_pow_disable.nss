/*
   ----------------
   Disable
   
   prc_all_disable
   ----------------

   29/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Area: 20' Cone
   Duration: 1 Min/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You broadcast a mental compulsion that convinces one or more creatures of 4 or less HD that it is disabled. 
   This has the effect of slowing them down, as they are lethargic.
   
   Augment: For every 2 additional power points spent, this power's range increases by 5 and its DC by 1. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

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
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 20.0, PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nTargetHD = 4;
	float fDistance = 20.0;
	float fDur = 60.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2;	
	
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDaze = EffectSlow();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eDaze);
    	eLink = EffectLinkEffects(eLink, eDur);
    	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    			
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to HD
	if (nAugment > 0)
	{
		fDistance += (5.0 * nAugment);
		nDC += nAugment;
	}
	
    	//Cycle through the targets within the spell shape until an invalid object is captured.
    	while(GetIsObjectValid(oTarget))
    	{
    	    	if(GetHitDice(oTarget) <= nTargetHD)
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
		                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
                        		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		                }
			}
		}
   	
    	//Select the next target within the spell shape.
    	oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 20.0, PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    	}

	

    }
}