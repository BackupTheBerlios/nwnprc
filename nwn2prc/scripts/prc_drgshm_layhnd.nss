//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	This is the Touch of Vitality feat that Dragon Shamans are given which acts like a Paladin Lay Hands ability
//  The reason for the rewrite instead of using the lame Obs version is that it is not a true lay hands and needs
//  to have the lost functionality.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "prc_inc_dragsham"

void main()
{
	// declare major variables;
	effect eHeal;
	string sTouchOfVitality = "DRAGON_SHAMAN_TOUCH_REMAIN";
	int nHealPowerRemain = GetLocalInt(OBJECT_SELF, sTouchOfVitality);
	// Get the target of the lay hands attempt.
	object oTarget = GetSpellTargetObject();
	string sMes;
	// Variable to store the spell so that all the healing auras can be stored in one file.
	int nSpellId = GetSpellId();
	// Get the amount of damage to heal which will be subtracted from the amount of damage remaining to heal.
	int nAmountToHeal = (GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget));
	// if the spell is lay hands to restore damage.
	if(nSpellId == 1111)
	{	
		// If the caster has 0 healing power left, let him know.
		if(nHealPowerRemain == 0)
		{
			sMes = "Cannot heal any further damage.";
			FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
		}
		// if they have the whole thing, heal the whole thing and pop a message letting them know how much is left.
		else if(nHealPowerRemain >= nAmountToHeal)
		{
			eHeal = ExtraordinaryEffect(EffectHeal(nAmountToHeal));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
			nHealPowerRemain -= nAmountToHeal;
			sMes = "Healing power remaining " + IntToString(nHealPowerRemain) + ".";
			SetLocalInt(OBJECT_SELF, sTouchOfVitality, nHealPowerRemain);
			FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
		}
		// if the healing power remaining is less than the total damage, heal with the remaining power.
		else if(nHealPowerRemain < nAmountToHeal)
		{
			nAmountToHeal = nHealPowerRemain;
			eHeal = ExtraordinaryEffect(EffectHeal(nAmountToHeal));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
			sMes = "Healing power exhausted.";
			SetLocalInt(OBJECT_SELF, sTouchOfVitality, 0);
			FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
		}
	}
	// else if the spell is Touch Minor, heal ability damage and remove daze effect
	else if(nSpellId == 1112)
	{
		if(nHealPowerRemain < 8)
		{
			sMes = "Cannot heal any further effects.";
			FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
		}
		else
		{
    		int nType;
    		int bValid = FALSE;
    		effect eStatus = GetFirstEffect(oTarget);
    		effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    		//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_RESTORATION, FALSE));
    		//Get the first effect on the target
   			while(GetIsEffectValid(eStatus))
    		{
       			 //Check if the current effect is of correct type
        		if (GetEffectType(eStatus) == EFFECT_TYPE_DAZED || GetEffectType(eStatus) == EFFECT_TYPE_ABILITY_DECREASE)
        		{
           			//Remove the effect
           			RemoveEffect(oTarget, eStatus);
            		bValid = TRUE;
        		}
        		//Get the next effect on the target
        		GetNextEffect(oTarget);
    		}
    		if (bValid)
    		{
        		//Apply VFX Impact
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				nHealPowerRemain -= 8;
				SetLocalInt(OBJECT_SELF, sTouchOfVitality, nHealPowerRemain);
    		}
		}
	}
	// else if the spell is touch restore - remove stunned or poisoned effect
	else if(nSpellId == 1113)
	{
		if(nHealPowerRemain < 15)
		{
			sMes = "Cannot heal any further effects.";
			FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
		}
		else
		{
    		int nType;
    		int bValid = FALSE;
    		effect eStatus = GetFirstEffect(oTarget);
    		effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    		//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
    		//Get the first effect on the target
   			while(GetIsEffectValid(eStatus))
    		{
       			 //Check if the current effect is of correct type
        		if (GetEffectType(eStatus) == EFFECT_TYPE_POISON || GetEffectType(eStatus) == EFFECT_TYPE_STUNNED)
        		{
           			//Remove the effect
           			RemoveEffect(oTarget, eStatus);
            		bValid = TRUE;
        		}
        		//Get the next effect on the target
        		GetNextEffect(oTarget);
    		}
    		if (bValid)
    		{
        		//Apply VFX Impact
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				nHealPowerRemain -= 15;
				SetLocalInt(OBJECT_SELF, sTouchOfVitality, nHealPowerRemain);
    		}
		}
	}
	// else if the spell is touch major - remove disease, blind/deaf, negative level
	else if(nSpellId == 1114)
	{
		if(nHealPowerRemain < 30)
		{
			sMes = "Cannot heal any further effects.";
			FloatingTextStringOnCreature(sMes, OBJECT_SELF, FALSE);
		}
		else
		{
    		int nType;
    		int bValid = FALSE;
    		effect eStatus = GetFirstEffect(oTarget);
    		effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    		//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_RESTORATION, FALSE));
    		//Get the first effect on the target
   			while(GetIsEffectValid(eStatus))
    		{
       			 //Check if the current effect is of correct type
        		if (GetEffectType(eStatus) == EFFECT_TYPE_DISEASE || GetEffectType(eStatus) == EFFECT_TYPE_NEGATIVELEVEL ||
					GetEffectType(eStatus) == EFFECT_TYPE_BLINDNESS || GetEffectType(eStatus) == EFFECT_TYPE_DEAF)
        		{
           			//Remove the effect
           			RemoveEffect(oTarget, eStatus);
            		bValid = TRUE;
        		}
        		//Get the next effect on the target
        		GetNextEffect(oTarget);
    		}
    		if (bValid)
    		{
        		//Apply VFX Impact
        		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				nHealPowerRemain -= 30;
				SetLocalInt(OBJECT_SELF, sTouchOfVitality, nHealPowerRemain);
    		}
		}
	}
}