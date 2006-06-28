//::///////////////////////////////////////////////
//:: Name      Exalted Raiment
//:: FileName  sp_exaltd_raim.nss
//:://////////////////////////////////////////////
/**@file Exalted Raiment
Abjuration
Level: Sanctified 6
Components: V, DF, Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: Robe, garment, or outfit touched
Duration: 1 minute/level
Saving Throw: Will negates (harmless, object)
Spell Resistance: Yes (harmless, object)

You imbue a robe, priestly garment, or outfit of
regular clothing with divine power.  The spell bestows
the following effects for the duration:

     - +1 sacred bonus to AC per five caster levels
     (max +4 at 20th level)
     
     - Damage reduction 10/evil
     
     - Spell resistance 5 + 1/caster level (max SR 25 
     at 20th level
     
     - Reduces ability damage due to spell casting by 1,
     to a minimum of 1 point (but does not reduce the 
     sacrifice cost of this spell).
     
     Sacrifice: 1d4 points of Strength damage
     
Author:    Tenjac
Created:   6/28/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////



#include "spinc_common"

int GetERSpellResistance(int nCasterLvl)
{
	int nSRBonus = min(nCasterLvl, 20);
	int nIPConst;
	
	switch(nSRBonus)
	{
		case 0: return;
		
		case 1: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_6;
		
		case 2: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_7;
		
		case 3: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_8;
		
		case 4: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_9;
		
		case 5: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_10;
		
		case 6: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_11;
		
		case 7: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_12;
		
		case 8: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_13;
		
		case 9: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_14;
		
		case 10: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_15;
		
		case 11: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_16;
		
		case 12: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_17;
		
		case 13: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_18;
		
		case 14: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_19;
		
		case 15: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_20;
		
		case 16: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_21;
		
		case 17: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_22;
		
		case 18: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_23;
		
		case 19: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_24;
		
		case 20: nIPConst = IP_CONST_SPELLRESISTANCEBONUS_25;
	}
	
	return nIPConst;
}	

void main()
{
	object oPC = OBJECT_SELF;
	object oMyArmor = IPGetTargetedOrEquippedArmor(TRUE);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nSR = GetERSpellResistance(nCasterLvl);
	
	itemproperty ipArmor = ItemPropertyACBonus(nCasterLvl / 5);
	itemproperty ipDR    = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGERESIST_10);
	itemporperty ipSR    = ItemPropertyBonusSpellResistance(nSR);
	
	