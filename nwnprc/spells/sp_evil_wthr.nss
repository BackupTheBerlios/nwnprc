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

// Rewritten 3/31/07 to address occaisional TMIs
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
void RainOfBlood(object oObject, effect eBuff, effect eDebuff, float fDuration);
void VioletRain(object oObject);
void RainOfFrogsOrFish(object oObject);

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
                RainOfBlood(oObject, eBuff, eDebuff);
        }
        
        //Violet Rain   No divine spells/abilities for 24 hours
        if (nSpell == SPELL_EVIL_WEATHER_VIOLET_RAIN)
        {
                //Change to rain
                SetWeather(oArea, WEATHER_RAIN);                                
                DelayCommand(fDuration, SetWeather(oArea, nWeather));
                
                //GetFirst
                object oObject = GetFirstObjectInArea(oArea);
                                
                VioletRain(oObject);               
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
                
                //GetFirst
                object oObject = GetFirstObjectInArea(oArea);
                
                RainOfFrogsOrFish(oObject);               
        }
        
        SPEvilShift(oPC);
        
        //Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
        AdjustAlignment(oPC, ALIGNMENT_EVIL, 10);
        
        //Corruption cost
        int nCost = d6(3);
        
        DoCorruptionCost(oPC, ABILITY_CONSTITUTION, nCost, 0);
        
        SPSetSchool();
}

void RainOfBlood(object oObject, effect eBuff, effect eDebuff, float fDuration)
{
        if (GetIsObjectValid(oObject))
        {
                //Send message to PCs
                if(GetIsPC(oObject))
                {
                        SendMessageToPC(oObject, "The sky pours a thick rain of blood");
                }
                
                int nType = MyPRCGetRacialType(oObject);
                
                if (nType == RACIAL_TYPE_UNDEAD)
                {
                        //Apply bonus
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oObject, fDuration);
                }
                
                else
                //Apply penalty if alive
                {
                        if(nType != RACIAL_TYPE_CONSTRUCT && nType != RACIAL_TYPE_ELEMENTAL)
                        {
                                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oObject, fDuration);                                       
                        }
                }
                oObject = GetNextObjectInArea();
                DelayCommand(0.01f, RainOfBlood(oObject, eBuff, eDebuff, fDuration));
        }        
}        

void VioletRain(object oObject)
{
        if(GetIsObjectValid(oObject))
        {
                //Send message to PCs
                if(GetIsPC(oObject))
                {
                        SendMessageToPC(oObject, "Drops of deep violet rain fall, severing the connection to the divine of those in the area.");
                }
                
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oObject, HoursToSeconds(24));
                
                oObject = GetNextObjectInArea();
                
                DelayCommand(0.1f, VioletRain(oObject));
        }
}                

void RainOfFrogsOrFish(object oObject)
{
        if(GetIsObjectValid(oObject))
        {
                if(GetIsPC(oObject))
                {
                        SendMessageToPC(oObject, "Frogs and fish rain from the sky, pummeling all in the area.");
                }
                
                //Asign local obj to check Area
                SetLocalObject(oObject,"PRC_RAIN_FROGS_FISH_AREA", GetArea(oObject));
                
                //Cast spell on target
                AssignCommand(oObject, ActionCastSpellAtObject(SPELL_FROGS_OR_FISH, oObject, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                
                oObject = GetNextObjectInArea();
                RainOfFrogsOrFish(oObject);
        }
}
        