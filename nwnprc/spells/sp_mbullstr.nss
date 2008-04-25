#include "prc_inc_spells"
#include "spinc_massbuff"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoMassBuff (MASSBUFF_STAT, ABILITY_STRENGTH, SPELL_BULLS_STRENGTH);
}
