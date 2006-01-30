//::///////////////////////////////////////////////
//:: Truevenom OnHit
//:: psi_truvenom_hit
//::///////////////////////////////////////////////
/*
   Fort save vs DC 10 + 4 (Power Level) + Manifesting stat modifier
   On failed save, 1d8 Con damage, plus 1d8 Con damage 1 minute later.
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
	int nClass = GetManifestingClass(oCaster);
	
	// Gets the ability mod in the casting class and returns it for the DC
	int nDC = 14 + GetAbilityModifier(GetAbilityOfClass(nClass), oCaster);

	// Primary damage
	DoPoison(oTarget, oCaster, nDC, d8(1));

	// Secondary damage
	DelayCommand(60.0, DoPoison(oTarget, oCaster, nDC, d8(1)));
	
	//Cleanup
	RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
    	DeleteLocalInt(oItem, "Truevenom");	
}