//::///////////////////////////////////////////////
//:: Prevenom OnHit
//:: psi_prevenom_hit
//::///////////////////////////////////////////////
/*
   Fort save vs DC 10 + 0.5 * Manifester level + Manifesting stat modifier
   On failed save, 2 Con damage
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.01.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"


void DoPoison(object oTarget, object oCaster, int nDC, int nDam){
	//Declare major variables
	//effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
	//effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_IMP_POISON_S), eDamage);

	// First check for poison immunity, if not, make a fort save versus spells.
	if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) &&
	   !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oCaster))
	{
		//Apply the poison effect and VFX impact
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_S), oTarget);
		ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_PERMANENT, TRUE);
	}
}


void main()
{
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	object oItem   = GetSpellCastItem();
	
	int nDC = 10 + GetManifesterLevel(oCaster) / 2 + GetAbilityScoreOfClass(oCaster, GetManifestingClass(oCaster));
	
	int nDam = GetLocalInt(oItem, "Prevenom");

	// Primary damage
	DoPoison(oTarget, oCaster, nDC, nDam);
	
	//Cleanup
	RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
    	DeleteLocalInt(oItem, "Prevenom");
}