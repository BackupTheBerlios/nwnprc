/*
   ----------------
   Control Object
   
   prc_pow_ctrlobj
   ----------------

   31/7/05 by Stratovarius

   Class: Psion (Kineticist)
   Power Level: 1
   Range: Medium
   Target: One Unattended Object
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You telekinetically bring to life an inanimate object. Though it is not actually alive, it moves under your control. If it is a 
   weapon, it deals the weapons damage plus your Intelligence modifier, otherwise it deals 1d6 plus your intelligence modifier. This
   power only works on weapons and armour.
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;
	float fDelay = 3.0;
	
	MultisummonPreSummon();
	effect eSummon = EffectSummonCreature("psi_ctrlobj", VFX_FNF_SUMMON_CELESTIAL, 0.0);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), RoundsToSeconds(nDur));
	
    	int i = 1;
    	object oHench = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    
    	while (GetIsObjectValid(oHench))
    	{
    	    	if (GetResRef(oHench) == "psi_ctrlobj")
		{
		    	break;
    		}
    		i += 1;
    		oHench = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    	}
	
	if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
	{
		CopyItem(oTarget, oHench, FALSE);
		DestroyObject(oTarget);
	}
	int nWeap = GetWeaponDamageType(oTarget);
	if (nWeap != -1) 
	{
		ForceEquip(oHench, oTarget, INVENTORY_SLOT_RIGHTHAND);
	}
	else
	{
		ForceEquip(oHench, oTarget, INVENTORY_SLOT_CHEST);
	}
	
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
	// Work around for the damage bonus
	string sDam = "DAMAGE_BONUS_" + IntToString(nInt);
	FloatingTextStringOnCreature("Your Damage Bonus is " + sDam, oCaster, FALSE);
		
	effect eAttack = EffectAttackIncrease(nInt);
	effect eDam = EffectDamageIncrease(StringToInt(sDam), DAMAGE_TYPE_BASE_WEAPON);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttack, oHench);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oHench);
    }
}