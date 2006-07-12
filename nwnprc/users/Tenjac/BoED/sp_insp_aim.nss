//::///////////////////////////////////////////////
//:: Name      Inspired Aim
//:: FileName  sp_insp_aim.nss
//:://////////////////////////////////////////////
/**@file Inspired Aim
Enchantment(Compulsion)
Level: Bard 4, cleric 3, Fey 3, ranger 3
Components: V
Casting Time: 1 standard action
Range: 40ft
Targets: Allies within 40-foot radius emanation
centered on you
Duration: Concentration
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You inspire allies within the spell's are to focus
their minds on hitting their intended targets.  All 
affected allies gain a +2 insight bonus on all ranged
attcks.

Author:    Tenjac
Created:   7/12/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	object oPC = OBJECT_SELF;
	effect eAOE = EffectAreaOfEffect(VFX_AOE_INSPIRED_AIM);
		
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oPC);
	
	SPSetSchool();
}