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


int GetManifesterDC (object oCaster)
{
	int nSpell = GetSpellId();
	int nDC = StringToInt(lookup_spell_innate(nSpell));
	nDC = nDC + 10;
	nDC = nDC + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
}