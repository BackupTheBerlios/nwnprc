//::///////////////////////////////////////////////
//:: Astral Construct Poison Touch ability OnHit
//:: psi_ast_con_ptch
//::///////////////////////////////////////////////
/*
   Fort save vs DC 10 + 0.5 * AC's HD + AC's Cha mod
   On failed save, 1 Con damage
   1 minute later, regardless of first save, a second
   save versus same DC, on fail 1d2 Con damage 
    
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.01.2005
//:://////////////////////////////////////////////

#include "spinc_common"


void DoPoison(object oTarget, object oCaster, int nDC, int nDam){
	//Declare major variables
	effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
	effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_IMP_POISON_S), eDamage);

	// First check for poison immunity, if not, make a fort save versus spells.
	if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) &&
	!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oCaster))
	{
		//Apply the poison effect and VFX impact
		SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0f, FALSE);
	}
}


void main()
{
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = 10 + GetHitDice(oCaster) / 2 + GetAbilityModifier(ABILITY_CHARISMA, oCaster);

	// Primary damage
	DoPoison(oTarget, oCaster, nDC, 1);

	// Secondary damage
	DelayCommand(MinutesToSeconds(1), DoPoison(oTarget, oCaster, nDC, d2(1)));
}