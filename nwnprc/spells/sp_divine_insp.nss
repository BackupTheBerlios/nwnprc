//::///////////////////////////////////////////////
//:: Name      Divine Inspiration
//:: FileName  sp_divine_insp.nss
//:://////////////////////////////////////////////
/**@file Divine Inspiration
Divination
Level: Sanctified 1 
Components: Sacrifice 
Casting Time: 1 standard action 
Range: Touch
Target: One creature touched 
Duration: 1d4 rounds
Saving Throw: None
Spell Resistance: Yes (harmless)
 
This spell helps to tip the momentum of combat in 
the favor of good, granting limited precognitive 
ability that enables the spell's recipient to 
circumvent the defenses of evil opponents. The 
target of the spell gains a +3 sacred bonus on all
attack rolls made against evil creatures. This 
bonus does not apply to attacks made against 
non-evil creatures.

Sacrifice: 1d2 points of Strength damage.

Author:    Tenjac
Created:   6/9/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	object oSkin = GetPCSkin(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	itemproperty iBonus = ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 3);
	float fDur = RoundsToSeconds(d4(1));
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	IPSafeAddItemProperty(oSkin, iBonus, fDur, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, FALSE);
	
	DoCorruptionCost(oPC, ABILITY_STRENGTH, d2(), 0);
	
	//Sanctified spells get mandatory 10 pt good adjustment, regardless of switch
	AdjustAlignment(oPC, ALIGNMENT_GOOD, 10);
	
	//Adding a good shift even though the spell has no [Good] descriptor; need to check source
	SPGoodShift(oPC);
}
	