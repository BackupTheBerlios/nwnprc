/*
    ----------------
    Crystallize
    
    psi_psi_crystlz
    ----------------

    25/10/04 by Stratovarius

    Class: Psion (Shaper)
    Power Level: 6
    Range: Medium
    Target: One Creature
    Duration: Permanent
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Point Cost: 11
 
    You seed the subject's flesh with super-saturated crystal. In an eyeblink, the subjects
    form seems to freeze over, as its flesh and fuilds are instantly crystallized. This has 
    the effect of petrifying the target permanently. 
*/

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 1);

    object oCaster = OBJECT_SELF;
    int nAugCost = 0;
    int nAugment = GetLocalInt(oCaster, "Augment");
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nCaster))
	{
	
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

               	if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
               	{
               		SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPetrify(), oTarget);
              	}
	}
    }
}