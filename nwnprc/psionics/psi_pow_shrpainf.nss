/*
   ----------------
   Share Pain, Forced
   
   prc_pow_shrpainf
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Short
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: Fort negates
   Power Resistance: Yes
   Power Point Cost: 5
   
   This power creates a psychometabolic connection between you and an unwilling subject so that some of your wounds
   are transferred to the subject. You take half damage from all attacks that deal hitpoint damage to you
   and the unwilling subject takes the remainder. 
   
   Augment: For every 2 additional power points spend, the DC increases by 1.
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
    int nAugCost = 2;
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
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
    	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCaster);
    	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2; 
	
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 	nDC += (nAugment/2);
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
			SetLocalInt(oCaster, "SharePain", TRUE);
			SetLocalObject(oCaster, "SharePainTarget", oTarget);
			IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), RoundsToSeconds(nDur), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
					
			effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oCaster, "SharePain"));
			DelayCommand(RoundsToSeconds(nDur), DeleteLocalObject(oCaster, "SharePainTarget"));
		}
	}
    }
}