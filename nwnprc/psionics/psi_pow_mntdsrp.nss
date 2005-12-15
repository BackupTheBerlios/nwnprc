/*
   ----------------
   Mental Disruption
   
   prc_all_mntdsrp
   ----------------

   7/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: 10 ft
   Area: 10 ft radius centered on caster
   Duration: 1 Round
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   You generate a mental wave of confusion that sweeps out from your location. Any enemy in the area that fails its save becomes dazed for one round.
   
   Augment: For every 2 additional power points spent, the DC on this power increases by 1.
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
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, METAPSIONIC_WIDEN);    
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	float fWidth = DoWiden(RADIUS_SIZE_LARGE, nMetaPsi);
	int nDur = 1;
	if (nMetaPsi == 2)	nDur *= 2;

	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Size
	if (nAugment > 0) 	nDC += nAugment;
	
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDaze = EffectDazed();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eDaze);
    	eLink = EffectLinkEffects(eLink, eDur);
    	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, GetLocation(OBJECT_SELF));

    	while(GetIsObjectValid(oTarget))
    	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
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
		               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		                }
			}
		}

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, GetLocation(OBJECT_SELF));
    	}	
	
	

    }
}