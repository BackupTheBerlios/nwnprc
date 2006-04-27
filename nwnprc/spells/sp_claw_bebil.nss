//::///////////////////////////////////////////////
//:: Name:      Claws of the Bebilith
//:: Filename:  sp_claw_bebil.nss
//::///////////////////////////////////////////////
/**Claws of the Bebilith
Transmutation [Evil] 
Level: Corrupt 5 
Components: V, S, Corrupt 
Casting Time: 1 action 
Range: Personal
Target: Caster
Duration: 10 minutes/level

The caster gains claws that deal damage based on 
her size (see below) and can catch and tear an 
opponent's armor and shield. If the opponent has 
both armor and a shield, roll 1d6: A result of 1-4
indicates the armor is affected, and a result of 5-6
affects the shield.

The caster makes a grapple check whenever she hits
with a claw attack, adding to the opponent's roll any
enhancement bonus from magic possessed by the 
opponent's armor or shield. If the caster wins, the
armor or shield is torn away and ruined.

                Caster Size           Claw Damage

                Fine                        -

                Diminutive                  1

                Tiny                        ld2

                Small                       ld3

                Medium-size                 ld4

                Large                       1d6

                Huge                        1d8

                Gargantuan                  2d2

                Colossal                    2d8 

Corruption Cost: 1d6 points of Dexterity damage.


@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	//vars
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nClawSize = max(min(PRCGetCreatureSize(oTarget), CREATURE_SIZE_LARGE), CREATURE_SIZE_SMALL) - CREATURE_SIZE_SMALL;
	int nBaseDamage;
	float fDuration = (600.0f * nCasterLvl);
	
	// Determine base damage
	switch(nClawSize)
	{
		case 0: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3; break;
		case 1: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d4; break;
		case 2: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d6; break;
		case 3: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d8; break;
		case 4: nBaseDamage = IP_CONST_MONSTERDAMAGE_2d6; break;
		case 5: nBaseDamage = IP_CONST_MONSTERDAMAGE_3d6; break;
		case 6: nBaseDamage = IP_CONST_MONSTERDAMAGE_4d6; break;
		case 7: nBaseDamage = IP_CONST_MONSTERDAMAGE_6d6; break;
		
	}
	// Catch exceptions here
	if (nClawSize < 0) nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3;
	else if (nClawSize > 7) nBaseDamage = IP_CONST_MONSTERDAMAGE_6d6;
	
	// Create the creature weapon
	object oLClaw   = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
	object oRClaw   = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
	
	// Add the base damage
	AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oLClaw, fDuration);
	AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oRClaw, fDuration);
	
	//Set up property
	itemproperty ipClaws = (ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
	
	//Add props
	IPSafeAddItemProperty(oLClaw, ipClaws, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); 
	IPSafeAddItemProperty(oRClaw, ipClaws, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	
		
	SPEvilShift(oPC);
	SPSetSchool();
}