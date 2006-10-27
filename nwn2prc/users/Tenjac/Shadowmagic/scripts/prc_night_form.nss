////////////////////////////////////////////////
// Night Form
// prc_night_form.nss
////////////////////////////////////////////////
/* Child of Night - Night Form ability
   
   Become incorporeal for 1 minute
*/
////////////////////////////////////////////////
// Author: Tenjac
// Date: 10/26/06
////////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;
	effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_GHOSTLY_PULSE), EffectEthereal());
	eLink = EffectLinkEffects(eLink, EffectMovementSpeedIncrease(25));
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0f);	
}
	
    
    