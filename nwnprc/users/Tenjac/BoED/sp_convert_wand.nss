//::///////////////////////////////////////////////
//:: Name      Convert Wand
//:: FileName  sp_convert_wand.nss
//:://////////////////////////////////////////////
/**@file Convert Wand
Transmutation 
Level: Clr 5 
Components: V, S 
Casting Time: 1 standard action 
Range: Touch
Target: Wand touched 
Duration: 1 minute/level
Saving Throw: None 
Spell Resistance: No

This spell temporarily transforms a magic wand of 
any type into a healing wand with the same number 
of charges remaining. At the end of the spell's 
duration, the wand's original effect is restored,
and any charges that were depleted remain so. The 
spell level of the wand determines how powerful a
healing instrument the wand becomes: 

Spell Level   New Wand Type

 
 1st          Wand of cure light wounds 
 
 2nd          Wand of cure moderate wounds
 
 3rd          Wand of cure serious wounds
 
 4th          Wand of cure critical wounds
 

For example, a 10th-level cleric can transform a wand 
of lightning bolt (3rd­level spell) into a wand of 
cure serious wounds for 10 minutes.

[11:43] <Primogenitor> Spam ahoy!
[11:43] <Primogenitor> 1) Store the current spellID, caster level, DC, & spell level on the wand from cast spell itemproperty. 
[11:43] <Primogenitor> Include PRC itemproperties for caster level & DC
[11:43] <Primogenitor> 2) Add a new temporary cast spell itemproperty
[11:43] <Primogenitor> Include PRC itemproperty for casterlevel & DC 
[11:43] <Primogenitor> (since cures are hostile to undead).
[11:43] <Primogenitor> 3) Mark the item with a local variable.
[11:43] <Primogenitor> 4) Modify the spellhook so non-cure spells cast from an item with that variable dont work.
[11:43] <Primogenitor> 5) Add a check to the spellhook that if the item has the local but no cure itemprops, clear the local and continue the spell.
[11:44] <Primogenitor> (this copes with logoff symptoms where the temp ip is lost and after the temp ip has expired)
[11:44] <Primogenitor> 6) Add lots of sanity checks. Not a wand, already a curing wand, etc.
[11:44] <Primogenitor> done ;)
[11:52] <Primogenitor> Oh, Tenjac dont forget to add a temporary Restricted Use : Cleric IP too ;)
[11:53] <Primogenitor> And its probably worth adding a clause that says "if I target a creature, get the first wand in its inventory"

Author:    Tenjac
Created:   7/3/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void WandCounter(object oPC, object oSkin, object oNewWand, int nCounter);

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	object oTargetWand = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLvl);
			
	//Get spell level
	itemproperty ipTest = GetFirstItemProperty(oTargetWand);
		
	while(GetIsItemPropertyValid(ipTest))
	{
		if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
		{ 
			//Get row
			int nRow = GetItemPropertySubType(ipTest);
			
			//Get spellID
			int nSpellID = StringToInt(Get2DACache("iprp_spells.2da", "SpellIndex", nRow));
			
			//Get spell level
			nLevel = StringToInt(Get2DACache("spells", "Innate", nSpellID));
			
			//no need to check rest of the ips
			break;
		}
		ipTest = GetNextItemProperty(oTargetWand);
	}
	
	//Determine ip	
	if(nLevel > 4)
	{
		nLevel = 4;
	}
	
	switch(nLevel)
	{
		case 0: ipSpell = ItemPropertyCastSpell(SPELL_CURE_MINOR_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
		
		case 1: ipSpell = ItemPropertyCastSpell(SPELL_CURE_LIGHT_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
		        break;
		
		case 2: ipSpell = ItemPropertyCastSpell(SPELL_CURE_MODERATE_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
		        break;
		
		case 3: ItemPropertyCastSpell(SPELL_CURE_SERIOUS_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
		        break;
		
		case 4: ItemPropertyCastSpell(SPELL_CURE_CRITICAL_WOUNDS, IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
		        break;
		
		default: break;
	}
	
	//Set up Cleric req
	itemproperty ipCleric = ItemPropertyLimitUseByClass(IP_CONST_CLASS_CLERIC);	
	
}



