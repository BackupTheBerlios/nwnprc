//::///////////////////////////////////////////////
//:: Talon of Tiamat Breath Weapons
//:: prc_taltia_brth.nss
//::///////////////////////////////////////////////
/*
    Handles the breath weapons of the Talon of Tiamat
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 22, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_spells"
#include "prc_inc_breath"

//internal function to reset the breath used marker
void RechargeBreath(object oPC)
{
	SendMessageToPC(oPC, "Breath recharged!");
	SetLocalInt(oPC, "UsedTalonBreath", FALSE);
}

void main()
{
	object oPC = OBJECT_SELF;
	
	//check to see if 1d4 rounds have passed
	int bCannotUse = GetLocalInt(oPC, "UsedTalonBreath");
	if(bCannotUse) 
	{
	    FloatingTextStringOnCreature("Your breath is still recharging.", oPC, FALSE);
	    return;
	}
	
        int nSpellID = GetSpellId();
        int nClass = GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oPC);
        struct breath TalonBreath;
        
        //Acid cone
        if(nSpellID == SPELL_TOT_ACID_LINE)
        {
             TalonBreath = CreateBreath(oPC, TRUE, 60.0, DAMAGE_TYPE_ACID, 4, 8, ABILITY_CONSTITUTION, nClass);
                          
             if(nClass < 3)
             {
             	FloatingTextStringOnCreature("This breath requires 3rd level Talon of Tiamat.", oPC, FALSE);
             	return;
             }
        }
        
        //Acid line
        if(nSpellID == SPELL_TOT_ACID_CONE)
        {
             TalonBreath = CreateBreath(oPC, FALSE, 30.0, DAMAGE_TYPE_ACID, 6, 10, ABILITY_CONSTITUTION, nClass);
             
             if(nClass < 5)
             {
             	FloatingTextStringOnCreature("This breath requires 5th level Talon of Tiamat.", oPC, FALSE);
             	return;
             }
        }
             
        //Cold
        if(nSpellID == SPELL_TOT_COLD_CONE)
        {
             TalonBreath = CreateBreath(oPC, FALSE, 30.0, DAMAGE_TYPE_COLD, 6, 3, ABILITY_CONSTITUTION, nClass);
        }
        
        //Electric
        if(nSpellID == SPELL_TOT_ELEC_LINE)
        {
             TalonBreath = CreateBreath(oPC, TRUE, 60.0, DAMAGE_TYPE_ELECTRICAL, 8, 12, ABILITY_CONSTITUTION, nClass);
             
             if(nClass < 7)
             {
             	FloatingTextStringOnCreature("This breath requires 7th level Talon of Tiamat.", oPC, FALSE);
             	return;
             }
        }
        
        //Fire
        if(nSpellID == SPELL_TOT_FIRE_CONE)
        {
             TalonBreath = CreateBreath(oPC, FALSE, 30.0, DAMAGE_TYPE_FIRE, 8, 14, ABILITY_CONSTITUTION, nClass);
             
             if(nClass < 9)
             {
             	FloatingTextStringOnCreature("This breath requires 9th level Talon of Tiamat.", oPC, FALSE);
             	return;
             }
        }
        
        //apply the breath to the affected area
        ApplyBreath(TalonBreath, PRCGetSpellTargetLocation());
        
        //apply the recharge delay
        int nBreathDelay = TalonBreath.nRoundsUntilRecharge;
        SetLocalInt(oPC, "UsedTalonBreath", TRUE);
        SendMessageToPC(oPC, IntToString(nBreathDelay) + " rounds until you can use your breath.");
        DelayCommand(RoundsToSeconds(nBreathDelay), RechargeBreath(oPC));
}