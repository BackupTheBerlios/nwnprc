/*
   ----------------
   Animal Affinity
   
   psi_pow_animafin
   ----------------

   3/11/05 by Stratovarius

   Class: Psion (Egoist), Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   You forge an affinity with an idealized animal form, thereby boosting one of your ability scores by +4. 
   
   Augment: For every 5 power points spent to augment this power, you may choose one additional ability.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"
#include "inc_dynconv"

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

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
	int nCaster = GetManifesterLevel(oCaster);
	float fDur = 60.0 * nCaster;
	
	if (nAugment > 0) SetLocalInt(oCaster, "AnimalAffinityAugment", nAugment);
	if (nMetaPsi == 2) fDur *= 2;
	SetLocalFloat(oCaster, "AnimalAffinityDuration", fDur);
	// Need this for dispel checks when applying the power
	SetLocalInt(oCaster, "AnimalAffinityManifesterLevel", nCaster);
	
	StartDynamicConversation("psi_animalaffin", oCaster, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oCaster);
    }
}