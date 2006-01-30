/*
   ----------------
   Call Weaponry
   
   psi_pow_callweap
   ----------------

   29/10/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Caster
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You call a weapon from thin air into your waiting hand. You don't have to see or know of a weapon to call it - in fact, you
   can't call a specific weapon, you just specify the type. If you call a projectile weapon, it comes with 3d6 bolts, arrows or
   bullets as appropriate. 
   
   Augment: For every 4 power points spent to augment this power, the weapon gains a +1 Enhancement bonus
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
	
	if (nAugment > 0) SetLocalInt(oCaster, "CallWeaponEnhancement", nAugment);
	if (nMetaPsi == 2) fDur *= 2;
	SetLocalFloat(oCaster, "CallWeaponDuration", fDur);
	
	StartDynamicConversation("psi_callweapon", oCaster, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oCaster);
    }
}