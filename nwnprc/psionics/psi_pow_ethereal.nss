/*
   ----------------
   Etherealness
   
   prc_pow_ethereal
   ----------------

   26/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 9
   Range: 5' Radius
   Target: Caster + 1 Target/3 levels
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 17
   
   You and 1 friend per 3 levels go to the Ethereal Plane. Once there, you may split up. Taking any hostile action will end the power.
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
	object oFirstTarget = GetSpellTargetObject();
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oFirstTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);

	if (nMetaPsi > 0)
	{
		int nDC = GetManifesterDC(oCaster);
		int nCaster = GetManifesterLevel(oCaster);
		int nPen = GetPsiPenetration(oCaster);
		effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    		effect eSanc = EffectEthereal();
    		effect eLink = EffectLinkEffects(eDur, eSanc);
		int nTargetCount = nCaster/3;
		float fDur = (60.0 * nCaster);
		if (nMetaPsi == 2)	fDur *= 2;

		SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oFirstTarget, fDur,TRUE,-1,nCaster);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);		

		location lTarget = GetSpellTargetLocation();
		//Declare the spell shape, size and the location.  Capture the first target object in the shape.
		object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);

		//Cycle through the targets within the spell shape until you run out of targets.
		while (GetIsObjectValid(oTarget) && nTargetCount > 0)
		{
			if (GetIsFriend(oTarget, oCaster))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			
				 // Use up a target slot only if we actually did something to it
				nTargetCount -= 1;
			}
			
			//Select the next target within the spell shape.
			oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	}
}