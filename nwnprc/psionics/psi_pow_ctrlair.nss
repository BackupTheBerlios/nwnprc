/*
    ----------------
    Control Air
    
    psi_pow_ctrlair
    ----------------

    26/3/05 by Stratovarius

    Class: Psion (Kineticist)
    Power Level: 2
    Range: Long
    Target: 50' Circle
    Duration: Instantaneous
    Saving Throw: Fort negates
    Power Resistance: Yes
    Power Point Cost: 3
 
    You summon a gust of wind, knocking down everyone in the area unless they succeed at their save.
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
    object oTarget = OBJECT_SELF;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, METAPSIONIC_WIDEN);
        
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	float fDelay;
	location lTargetLocation = GetSpellTargetLocation();
	float fWidth = DoWiden(RADIUS_SIZE_HUGE, nMetaPsi);
	effect eExplode = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	location lTarget = GetSpellTargetLocation();
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

		if(PRCMyResistPower(OBJECT_SELF, oTarget,nPen, fDelay) && (oTarget != OBJECT_SELF))
		{
			if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
			{
				effect eKnockdown = EffectKnockdown();
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(3),TRUE,-1,nCaster);
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
    }
}