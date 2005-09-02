/*
   ----------------
   Keen Edge
   
   prc_pow_keenedge
   ----------------

   17/2/05 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 3
   Range: Short
   Target: One Weapon
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You mentally sharpen the edge of your weapon, granting it the keen property. This only works on piercing or slashing weapons.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"
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
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	int nAC = 4;    	
    	float fDur = 600.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2;
	
    	effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();
        int iType = GetWeaponDamageType(oMyWeapon);
	
	if(GetIsObjectValid(oMyWeapon))
    	{
        	SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	        if (iType == DAMAGE_TYPE_SLASHING || iType == DAMAGE_TYPE_PIERCING)
        	{
       		        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
       		        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), fDur);
       		        IPSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
    		}
    	}
    }
}