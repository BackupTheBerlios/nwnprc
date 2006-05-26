//::///////////////////////////////////////////////
//:: Name      Addiction: Agony  
//:: FileName  sp_addct_ag.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Agony

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "Addiction_Agony_DC");
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   (GetPersistantLocalInt(oPC, "AgonySatiation") < 1))
	{
		//1d6 Dex, 1d6 Wis, 1d6 Con
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_WISDOM, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		
		DeletePersistantLocalInt(oPC, "PreviousAgonySave");
	}
	
	else 
	{
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PreviousAgonySave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(OBJECT_SELF);
			effect eTest = EffectDisease(DISEASE_AGONY_ADDICTION);
			
			while(GetIsEffectValid(eDisease))
			{
				if(eDisease == eTest)
				{
					RemoveEffect(oPC, eDisease);
					DeletePersistantLocalInt(oPC, "PreviousAgonySave");
					break;
				}
				
				eDisease = GetNextEffect(OBJECT_SELF);
			}			
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PreviousAgonySave", 1);
		}
	}
	
	//Handle DC increase from addiction.  
	if(!GetPersistantLocalInt(oPC, "AgonySatiation"))
	{
		SetPersistantLocalInt(oPC, "Addiction_Agony_DC", (nDC + 5));
	}
	
	//Remove the int, as it only lasts 1 day
	DeletePersistantLocalInt(oPC, "AgonySatiation");
}

