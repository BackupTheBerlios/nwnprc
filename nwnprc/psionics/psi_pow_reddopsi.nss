/*
   ----------------
   Reddopsi
   
   psi_pow_reddopsi
   ----------------

   6/10/05 by Stratovarius

   Class: Psion (Kineticist)
   Power Level: 7
   Range: Personal
   Area: You
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 13
   
   An invisible barrier surrounds you and moves with you. The space within this barrier is impervious to most psionic effects, including
   powers, psi-like abilities, and supernatural abilities. Likewise, it prevents the functioning of any psionic item.
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);    
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	float fDur = (nCaster * 600.0);
	if (nMetaPsi == 2)	fDur *= 2;	
		
	effect eVis = EffectVisualEffect(VFX_DUR_PROT_EPIC_ARMOR);
	SetLocalInt(oTarget, "Reddopsi", TRUE);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur,TRUE,-1,nCaster);
	DelayCommand(fDur, DeleteLocalInt(oTarget, "PsiEnRetort"));
    }
    	
}