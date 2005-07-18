/*
   ----------------
   Offensive Prescience
   
   prc_all_offpresc
   ----------------

   31/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Your awareness extends a fraction of a second into the future, allowing you to 
   better aim blows against an opponent. You gain a +2 bonus to your damage.
   
   Augment: For every 3 additional power points you spend, the bonus improves by 1.
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
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);      
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	int nBonus = 2;
    	float fDur = 60.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2;
	object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCaster);
	int nType = GetWeaponDamageType(oWeap);

    	// Augmentation effects to armour class
	if (nAugment > 0)	nBonus += nAugment;
	
    	effect eDamage = EffectDamageIncrease(nBonus, DAMAGE_TYPE_BASE_WEAPON);
   	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eDamage, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
    }
}