/*
   ----------------
   Energy Retort Fire
   
   prc_all_enrtrtf
   ----------------

   11/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 min/level
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 5
   
   You weave a potential energy field around your body. The first successful attack made against you in each
   round prompts a response from the field, dealing 4d6 damage of the appropriate element. To deal the damage, you
   must hit on a ranged touch attack. The target then gets power resistance and a save for half.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's duration increases by 1 minute.
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
	float fDur = 60.0 * nCaster;
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCaster);	
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Duration
	if (nAugment > 0) fDur += (nAugment * 60.0);
	if (nMetaPsi == 2)	fDur *= 2;
	
	effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
	
	// Variable for Energy Type
	SetLocalInt(oTarget, "PsiEnRetort", 3);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur,TRUE,-1,nCaster);
	IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
	DelayCommand(fDur, DeleteLocalInt(oTarget, "PsiEnRetort"));
    }
}