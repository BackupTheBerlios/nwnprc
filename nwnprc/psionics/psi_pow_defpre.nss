/*
   ----------------
   Defensive Precognition
   
   prc_all_defpre
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
   better evade an opponent's blows. You gain a +1 bonus to all saving throws and 
   to your armour class.
   
   Augment: For every 3 additional power points you spend, the bonuses improves by 1.
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
    int nAugCost = 3;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	int nBonus = 1;
    	float fDur = 60.0 * CasterLvl;
    	if (nMetaPsi == 2)	fDur *= 2;


    	// Augmentation effects to armour class
	if (nAugment > 0)	nBonus += nAugment;
	
	effect eArmor = EffectACIncrease(nBonus, AC_DODGE_BONUS);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
	effect eLink = EffectLinkEffects(eArmor, eDur);
	eLink = EffectLinkEffects(eLink, eSave);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,CasterLvl);
    }
}