//::///////////////////////////////////////////////
//:: Dragonfire Adept Breath Effects
//:: inv_adeptbreath.nss
//::///////////////////////////////////////////////
/*
    Handles the breath effects for Dragonfire Adepts
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Jan 25, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_breath"

void main()
{
	object oPC = OBJECT_SELF;
	int nClass = GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC);
	//PrC arcane spellcasting levels grant damage dice and DC
	nClass += GetArcanePRCLevels(oPC);
	int nDice = (nClass + 1) / 2;
	int nSaveDCBonus = nClass / 2;
	float fRange = nClass < 10 ? 15.0 : 30.0;
	int nAlignment = GetAlignmentGoodEvil(oPC);
	int nLastEffectUsed = GetLocalInt(oPC, "LastBreathEffect");
	struct breath BaseBreath;
	
	if(GetLocalInt(oPC, "AdeptTiamatLock"))
	{
		SendMessageToPC(oPC, "You cannot use your breath weapon again until next round");
		return;
	}
	
	if(nLastEffectUsed == GetSpellId() 
	   && GetSpellId() != BREATH_SHAPED_BREATH
	   && GetSpellId() != BREATH_CLOUD_BREATH
	   && GetSpellId() != BREATH_ENDURING_BREATH)
	{
		SendMessageToPC(oPC, "You cannot use the same breath effect two rounds in a row.");
		return;
	}
	
	switch(GetSpellId())
	{
		case BREATH_FIRE_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, DAMAGE_TYPE_FIRE, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_FIRE_LINE:
		     BaseBreath = CreateBreath(oPC, TRUE, fRange * 2, DAMAGE_TYPE_FIRE, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_FROST_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, DAMAGE_TYPE_COLD, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_ELECTRIC_LINE:
		     BaseBreath = CreateBreath(oPC, TRUE, fRange * 2, DAMAGE_TYPE_ELECTRICAL, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_SICKENING_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, -1, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_SICKENING, 0, SAVING_THROW_FORT);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_ACID_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, DAMAGE_TYPE_ACID, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_ACID_LINE:
		     BaseBreath = CreateBreath(oPC, TRUE, fRange * 2, DAMAGE_TYPE_ACID, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_SHAPED_BREATH:
		     if(GetLocalInt(oPC, "AdeptShapedBreath"))
		     {
		     	DeleteLocalInt(oPC, "AdeptShapedBreath");
		     	FloatingTextStringOnCreature("*Shaped Breath Removed*", oPC, FALSE);
		     }
		     else
		     {
		     	SetLocalInt(oPC, "AdeptShapedBreath", TRUE);
		     	FloatingTextStringOnCreature("*Shaped Breath Applied*", oPC, FALSE);
		     } break;
		
		case BREATH_SLOW_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, -1, 6, 2, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_SLOW, 0, SAVING_THROW_FORT);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_WEAKENING_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, -1, 6, 6, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_WEAKENING, 0, SAVING_THROW_FORT);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_CLOUD_BREATH:
		     if(GetLocalInt(oPC, "AdeptCloudBreath"))
		     {
		     	DeleteLocalInt(oPC, "AdeptCloudBreath");
		     	FloatingTextStringOnCreature("*Cloud Breath Removed*", oPC, FALSE);
		     }
		     else
		     {
		     	SetLocalInt(oPC, "AdeptCloudBreath", TRUE);
		     	FloatingTextStringOnCreature("*Cloud Breath Applied*", oPC, FALSE);
		     } break;
		
		case BREATH_ENDURING_BREATH:
		     if(GetLocalInt(oPC, "AdeptEnduringBreath"))
		     {
		     	DeleteLocalInt(oPC, "AdeptEnduringBreath");
		     	FloatingTextStringOnCreature("*Enduring Breath Removed*", oPC, FALSE);
		     }
		     else
		     {
		     	SetLocalInt(oPC, "AdeptEnduringBreath", TRUE);
		     	FloatingTextStringOnCreature("*Enduring Breath Applied*", oPC, FALSE);
		     } break;
		
		case BREATH_SLEEP_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, -1, 6, 1, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_SLEEP, 0, SAVING_THROW_WILL);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_THUNDER_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, DAMAGE_TYPE_SONIC, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0, SAVING_THROW_FORT);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		         
		case BREATH_BAHAMUT_LINE:
		     //evil characters can't use this breath
		     if(nAlignment == ALIGNMENT_EVIL) return;
		     BaseBreath = CreateBreath(oPC, TRUE, fRange * 2, DAMAGE_TYPE_MAGICAL, 6, nDice * 2, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); 
		     if(nAlignment == ALIGNMENT_GOOD) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nClass * 2, DAMAGE_TYPE_MAGICAL), oPC);
		     if(nAlignment == ALIGNMENT_NEUTRAL) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nClass * 4, DAMAGE_TYPE_MAGICAL), oPC);
		     break;
		     
		case BREATH_FORCE_LINE:
		     BaseBreath = CreateBreath(oPC, TRUE, fRange * 2, DAMAGE_TYPE_MAGICAL, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		 
		case BREATH_PARALYZE_CONE:
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, -1, 6, 1, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_PARALYZE, 0, SAVING_THROW_FORT);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); break;
		     
		case BREATH_FIVEFOLD_TIAMAT:
		     //good characters can't use this breath
		     if(nAlignment == ALIGNMENT_GOOD) return;
		     BaseBreath = CreateBreath(oPC, TRUE, fRange * 2, DAMAGE_TYPE_ACID, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); 
		     BaseBreath = CreateBreath(oPC, TRUE, fRange * 2, DAMAGE_TYPE_ELECTRICAL, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); 
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, DAMAGE_TYPE_ACID, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); 
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, DAMAGE_TYPE_COLD, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); 
		     BaseBreath = CreateBreath(oPC, FALSE, fRange, DAMAGE_TYPE_FIRE, 6, nDice, ABILITY_CONSTITUTION, nSaveDCBonus, BREATH_NORMAL, 0);
		     ApplyBreath(BaseBreath, PRCGetSpellTargetLocation()); 
		     if(nAlignment == ALIGNMENT_EVIL) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nClass * 2, DAMAGE_TYPE_MAGICAL), oPC);
		     if(nAlignment == ALIGNMENT_NEUTRAL) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nClass * 4, DAMAGE_TYPE_MAGICAL), oPC);
		     SetLocalInt(oPC, "AdeptTiamatLock", TRUE);
		     DelayCommand(6.0, DeleteLocalInt(oPC, "AdeptTiamatLock"));
		     break;
		     
	}
	
	//Mark the breath effect as used.
	if(GetSpellId() != BREATH_SHAPED_BREATH
	   && GetSpellId() != BREATH_CLOUD_BREATH
	   && GetSpellId() != BREATH_ENDURING_BREATH)
	{
	   SetLocalInt(oPC, "LastBreathEffect", GetSpellId());
	   DelayCommand(6.0, DeleteLocalInt(oPC, "LastBreathEffect"));
	}
}