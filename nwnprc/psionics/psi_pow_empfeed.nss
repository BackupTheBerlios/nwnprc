/*
   ----------------
   Empathic Feedback
   
   prc_pow_empfeed
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 4, Psychic Warrior 3
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7, Psychic Warrior 5
   
   You share your pain and suffering with your attacker. Each time a creature strikes you in melee, it takes damage equal
   to the amount dealt or 5, whichever is less. 
   
   Augment: For every additional power point spend, the damage empathic feedback can deal increases by 1.
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
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCaster);
    	int nDam = 5;
    	float fDur = 600.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2; 
	
	if (nSurge > 0) nAugment += nSurge;
		
	//Augmentation effects to Damage
	if (nAugment > 0) 	nDam += nAugment;
    	
	SetLocalInt(oCaster, "EmpathicFeedback", nDam);
	IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
	effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	DelayCommand(fDur, DeleteLocalInt(oCaster, "EmpathicFeedback"));
    }
}