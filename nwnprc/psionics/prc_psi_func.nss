/* 
   ----------------
   prc_psi_ppoints
   ----------------
   
   19/10/04 by Stratovarius
   
   Calculates the Manifester level, DC, etc.
   Psion, Psychic Warrior, Wilder. (Soulknife does not have Manifester levels)
*/

#include "prc_feat_const"
#include "prc_class_const"
#include "lookup_2da_spell"


int GetPowerLevel()
{
	int nSpell = GetSpellId();
	int nLevel = StringToInt(lookup_spell_innate(nSpell));
	return nLevel;
}


int GetManifesterDC (object oCaster)
{
	int nDC = 10;
	nDC = nDC + GetPowerLevel();
	nDC = nDC + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);

	return nDC;
}

int GetPowerCost (object oCaster, int nAugCost)
{
    int nLevel = GetPowerLevel();
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nPPCost;
    
    if (nLevel == 1) nPPCost = 1;
    else if (nLevel == 2) nPPCost = 3;
    else if (nLevel == 3) nPPCost = 5;
    else if (nLevel == 4) nPPCost = 7;
    else if (nLevel == 5) nPPCost = 9;
    else if (nLevel == 6) nPPCost = 11;
    else if (nLevel == 7) nPPCost = 13;
    else if (nLevel == 8) nPPCost = 15;
    else if (nLevel == 9) nPPCost = 17;
    

    if (nAugment == 0) nPPCost = nPPCost;    
    else if (nAugment == 1) nPPCost = nPPCost + (nAugCost * 1);
    else if (nAugment == 2) nPPCost = nPPCost + (nAugCost * 2);
    else if (nAugment == 3) nPPCost = nPPCost + (nAugCost * 3);
    else if (nAugment == 4) nPPCost = nPPCost + (nAugCost * 4);
    else if (nAugment == 5) nPPCost = nPPCost + (nAugCost * 5);
    
    return nPPCost;

}