/*
   ----------------
   Daze
   
   prc_all_daze
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 2 Rounds
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You daze a single creature with 4 HD or less.
   
   Augment: For every additional power point spent, this power can affect a target
   that has HD equal to 4 + the additional power points spent.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

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
    int nAugCost = 1;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	int nTargetHD = 4;
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDaze = EffectDazed();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eDaze);
    	eLink = EffectLinkEffects(eLink, eDur);
    	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to HD
	if (nAugment > 0) nTargetHD += nAugment;
	
    	//Make sure the target is a humaniod
    	if (AmIAHumanoid(oTarget) == TRUE)
    	{
    	    if(GetHitDice(oTarget) <= nTargetHD)
    	    {
		
			//Check for Power Resistance
			if (PRCMyResistPower(oCaster, oTarget, nCaster))
			{
			
			    //Fire cast spell at event for the specified target
		            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		            
		                //Make a saving throw check
		                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		                {
		                        //Apply VFX Impact and daze effect
		                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2),TRUE,-1,nCaster);
                        		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		                }
			}
		}
	}
    }
}