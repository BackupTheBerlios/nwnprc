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
#include "prc_alterations"

// This function will take a number and return the proper damage constant
int DamageToConst(int nDam)
{
	int nConst;
	if (nDam == 1) nConst = DAMAGE_BONUS_1;
	else if (nDam == 2) nConst = DAMAGE_BONUS_2;
	else if (nDam == 3) nConst = DAMAGE_BONUS_3;
	else if (nDam == 4) nConst = DAMAGE_BONUS_4;
	else if (nDam == 5) nConst = DAMAGE_BONUS_5;
	else if (nDam == 6) nConst = DAMAGE_BONUS_6;
	else if (nDam == 7) nConst = DAMAGE_BONUS_7;
	else if (nDam == 8) nConst = DAMAGE_BONUS_8;
	else if (nDam == 9) nConst = DAMAGE_BONUS_9;
	else if (nDam == 10) nConst = DAMAGE_BONUS_10;
	else if (nDam == 11) nConst = DAMAGE_BONUS_11;
	else if (nDam == 12) nConst = DAMAGE_BONUS_12;
	else if (nDam == 13) nConst = DAMAGE_BONUS_13;
	else if (nDam == 14) nConst = DAMAGE_BONUS_14;
	else if (nDam == 15) nConst = DAMAGE_BONUS_15;
	else if (nDam == 16) nConst = DAMAGE_BONUS_16;
	else if (nDam == 17) nConst = DAMAGE_BONUS_17;
	else if (nDam == 18) nConst = DAMAGE_BONUS_18;
	else if (nDam == 19) nConst = DAMAGE_BONUS_19;
	else if (nDam == 20) nConst = DAMAGE_BONUS_20;
	
	return nConst;
}

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
    object oTarget = PRCGetSpellTargetObject();
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
	
    	effect eDamage = EffectDamageIncrease(DamageToConst(nBonus), DAMAGE_TYPE_BASE_WEAPON);
   	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eDamage, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
    }
}