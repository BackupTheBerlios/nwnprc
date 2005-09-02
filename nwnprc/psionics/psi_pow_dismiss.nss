/*
   ----------------
   Dismissal
   
   prc_pow_dismiss
   ----------------

   28/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 4
   Range: Close
   Target: One Extraplanar Creature
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   This spell forces an extraplanar creature back to its home plane if it fails a save. Extraplanar creatures are outsiders and 
   elementals. This spell does not work on summons that are not of these races. 
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    
    if (nMetaPsi) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	
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
    }
}