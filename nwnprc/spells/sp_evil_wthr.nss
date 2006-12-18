//::///////////////////////////////////////////////
//:: Name      Evil Weather
//:: FileName  sp_evil_wthr.nss
//:://////////////////////////////////////////////
/**@file Evil Weather
Conjuration (Creation) [Evil] 
Level: Corrupt 8
Components: V, S, M, XP, Corrupt (see below)
Casting Time: 1 hour 
Range: Personal
Area: 1-mile/level radius, centered on caster
Duration: 3d6 minutes 
Saving Throw: None 
Spell Resistance: No
 
The caster conjures a type of evil weather. It 
functions as described in Chapter 2 of this book, 
except that area and duration are as given for this
spell. To conjure violet rain, the caster must 
sacrifice 10,000 gp worth of amethysts and spend 
200 XP. Other forms of evil weather have no material
component or experience point cost.

Corruption Cost: 3d6 points of Constitution damage.

Author:    Tenjac
Created:   3/10/2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"

void main()
{
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oArea = GetArea(oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nSpell = GetSpellId();
	int nWeather = GetWeather(oArea);
	int nType;
	float fDuration = (d6(3) * 60.0f);
	
	//Rain of Blood  -1 to attack, damage, saves and checks living, +1 undead
	if (nSpell == SPELL_EVIL_WEATHER_RAIN_OF_BLOOD)
	{
		//Change to rain
		SetWeather(oArea, WEATHER_RAIN);		
		DelayCommand(fDuration, SetWeather(oArea, nWeather));
		
		//Spell VFX
		
		//Define effects
		effect eBuff = EffectAttackIncrease(1);
		       eBuff = EffectLinkEffects(eBuff, EffectDamageIncrease(1));
		       eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));
		       eBuff = SupernaturalEffect(eBuff);
		effect eDebuff = EffectAttackDecrease(1);
		       eDebuff = EffectLinkEffects(eDebuff, EffectDamageDecrease(1));
		       eDebuff = EffectLinkEffects(eDebuff, EffectSavingThrowDecrease(SAVING_THROW_ALL, 1));
		       eDebuff = SupernaturalEffect(eDebuff);
		
		//GetFirst
		object oObject = GetFirstObjectInArea(oArea);
		
		//Loop
		while(GetIsObjectValid(oObject))
		{
			nType = MyPRCGetRacialType(oObject);
			
			if (nType == RACIAL_TYPE_UNDEAD)
			{
				//Apply bonus
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oObject, fDuration);
			}
			
			else
			{	//Apply penalty if alive
				if(nType != RACIAL_TYPE_CONSTRUCT && nType != RACIAL_TYPE_ELEMENTAL)
				
				{
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oObject, fDuration);					   
				}
			}
			
			oObject = GetNextObjectInArea();
		}		
	}
	
	//Violet Rain   No divine spells/abilities for 24 hours
	if (nSpell == SPELL_EVIL_WEATHER_VIOLET_RAIN)
	{
		//GetFirst
		object oObject = GetFirstObjectInArea(oArea);
		
		//Loop
		while(GetIsObjectValid(oObject))
		{
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oObject, HoursToSeconds(24));
			
			oObject = GetNextObjectInArea();
		}
				
		//Change to rain
		SetWeather(oArea, WEATHER_RAIN);
		
		DelayCommand(fDuration, SetWeather(oArea, nWeather));
	}	
		
	//Green Fog
	if (nSpell == SPELL_EVIL_WEATHER_GREEN_FOG)
	{
		string sFog = "nw_green_fog";
		
	}
	
	//Rain of Frogs or Fish
	if (nSpell == SPELL_EVIL_WEATHER_RAIN_OF_FISH)
	{
		//Change to rain
		SetWeather(oArea, WEATHER_RAIN);		
		DelayCommand(fDuration, SetWeather(oArea, nWeather));
		
	}	
	
	SPEvilShift(oPC);
	
	//Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
	AdjustAlignment(oPC, ALIGNMENT_EVIL, 10);
	
	//Corruption cost
	int nCost = d6(3);
	
	DoCorruptionCost(oPC, ABILITY_CONSTITUTION, nCost, 0);
	
	SPSetSchool();
}