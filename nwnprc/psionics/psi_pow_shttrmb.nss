/*
    ----------------
    Shatter Mind Blank
    
    psi_pow_shttrmb
    ----------------

    27/3/05 by Stratovarius

    Class: Psion/Wilder
    Power Level: 5
    Range: Personal
    Target: 30' Radius
    Duration: Instantaneous
    Saving Throw: Will Negates
    Power Resistance: Yes
    Power Point Cost: 9
 
    This power can negate a Personal Mind Blank or Psionic Mind Blank affecting the targets. If the target fails its save and you 
    overcome its power resistance, you can shatter the mind blank by making a check of 1d20 + Manifester level against a DC of
    11 + targets manifester level.
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, METAPSIONIC_WIDEN);
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCasterLevel = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
    	effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
    	effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
    	effect	  eLink        = EffectLinkEffects(eVis, eImpact);
    	location  lTarget      = GetSpellTargetLocation();
    	float fWidth = DoWiden(10.0, nMetaPsi);

	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
		int bValid = FALSE;
		
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
			{
				if (GetHasSpellEffect(POWER_MINDBLANKPERSONAL, oTarget) || GetHasSpellEffect(POWER_PSIMINDBLANK, oTarget))
				{
				        //Search through the valid effects on the target.
				        effect eAOE = GetFirstEffect(oTarget);
				        while (GetIsEffectValid(eAOE) && bValid == FALSE)
				        {
			                    //If the effect was created by the Acid_Fog then remove it
			                    if(GetEffectSpellId(eAOE) == POWER_MINDBLANKPERSONAL || GetEffectSpellId(eAOE) == POWER_PSIMINDBLANK)
			                    {
			                        RemoveEffect(oTarget, eAOE);
			                        bValid = TRUE;
			                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
			                    }
				            //Get next effect on the target
				            eAOE = GetNextEffect(oTarget);
        				}
				}
			}
		}
		//Select the next target within the spell shape.
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

    }
}