/*
    prc_hexbl_curse

    Afflicted creatures save or suffer a large penalty to stats.
*/

#include "prc_inc_combat"

void main()
{
	object oCaster = OBJECT_SELF; 
	object oTarget = PRCGetSpellTargetObject();
	int nClass = GetLevelByClass(CLASS_TYPE_HEXBLADE, oCaster);
	int nPen;
	effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
	int nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA, oCaster) + (nClass / 2);
	
	if (nClass >= 37) nPen = 8;
	else if (nClass >= 19 && nClass < 37) nPen = 6;
	else if (nClass >= 7 && nClass < 19) nPen = 4;
	else nPen = 2;
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	int nDamage = GetWeaponDamageType(oItem);
	effect eLink = EffectLinkEffects(EffectAttackDecrease(nPen), EffectSavingThrowDecrease(SAVING_THROW_ALL, nPen));
	eLink = EffectLinkEffects(eLink, EffectDamageDecrease(nPen, nDamage));
	eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPen));
	eLink = SupernaturalEffect(eLink);
   
      	//Make Will Save
	if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
	{
		//Apply Effect and VFX
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(1));
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}    
    else
    {
        //  get to use curse again
        IncrementRemainingFeatUses(oCaster, FEAT_HEXCURSE);
    }
}