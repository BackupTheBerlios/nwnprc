/*
   ----------------
   Share Pain
   
   prc_pow_shrpain
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Touch
   Target: One Willing Creature
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   This power creates a psychometabolic connection between you and a willing subject so that some of your wounds
   are transferred to the subject. You take half damage from all attacks that deal hitpoint damage to you
   and the willing subject takes the remainder. 
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
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCaster);
    	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2; 
    	
	if (GetIsFriend(oTarget) && GetIsObjectValid(oTarget))
	{
		SetLocalInt(oCaster, "SharePain", TRUE);
		SetLocalObject(oCaster, "SharePainTarget", oTarget);
		IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), HoursToSeconds(nDur), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
				
		effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		DelayCommand(HoursToSeconds(nDur), DeleteLocalInt(oCaster, "SharePain"));
		DelayCommand(HoursToSeconds(nDur), DeleteLocalObject(oCaster, "SharePainTarget"));
	}
    }
}