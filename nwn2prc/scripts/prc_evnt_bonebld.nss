//::///////////////////////////////////////////////
//:: Name      Boneblade event script
//:: FileName  prc_evnt_bonebld.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oSpellOrigin = OBJECT_SELF;
	object oSpellTarget = PRCGetSpellTargetObject();
	object oItem        = GetSpellCastItem();
	
	// Scripted combat system
	if(!GetIsObjectValid(oItem))
	{
		oItem = GetLocalObject(oSpellOrigin, "PRC_CombatSystem_OnHitCastSpell_Item");
	}
	
	//Boneblade +1d6 damage vs living
	if (GetHasSpellEffect(SPELL_BONEBLADE, oItem))
	{
		if(MyPRCGetRacialType(oSpellTarget) != RACIAL_TYPE_UNDEAD &&
		MyPRCGetRacialType(oSpellTarget) != RACIAL_TYPE_CONSTRUCT)
		{
			effect eDam = EffectDamage(d6(1), DAMAGE_TYPE_MAGICAL);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSpellTarget);
		}
	}
}