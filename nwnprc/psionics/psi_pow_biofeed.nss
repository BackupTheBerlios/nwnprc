/*
   ----------------
   Biofeedback
   
   prc_all_biofeed
   ----------------

   1/11/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 2, Psychic Warrior 1
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You toughen your body against wounds, lessening their impact. During the duration
   of this power, you gain 2/- DR.
   
   Augment: For every 3 additional power points you spend, the damage reduction improves by 1.
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
    int nAugCost = 3;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	int nDR = 2;    	

    	if (nSurge > 0) nAugment += nSurge;
		
	// Augmentation effects to armour class
	if (nAugment > 0)	nDR += nAugment;
	
	effect eDRB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, nDR);
	effect eDRS = EffectDamageResistance(DAMAGE_TYPE_SLASHING, nDR);
	effect eDRP = EffectDamageResistance(DAMAGE_TYPE_PIERCING, nDR);
	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
	effect eLink = EffectLinkEffects(eDRB, eDur);
	eLink = EffectLinkEffects(eDRS, eLink);
	eLink = EffectLinkEffects(eDRP, eLink);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, (60.0 * CasterLvl),TRUE,-1,CasterLvl);
    }
}