//::///////////////////////////////////////////////
//:: Name      Addiction: Baccaran  
//:: FileName  sp_addct_bac.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Baccaran

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "Addiction_Baccaran_DC");
	int nSatiation = GetPersistantLocalInt(oPC, "BaccaranSatiation") ;
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   nSatiation < 1))
	
	{
		//1d3 Dex
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d3(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		DeletePersistantLocalInt(oPC, "PreviousBaccaranSave");
	}

        else 
        {
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PreviousBaccSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(OBJECT_SELF);
			effect eTest = EffectDisease(DISEASE_BACCARAN_ADDICTION);
			
			while(GetIsEffectValid(eDisease))
			{
				if(eDisease == eTest)
				{
					RemoveEffect(oPC, eDisease);
					DeletePersistantLocalInt(oPC, "PreviousBaccSave");
					break;
				}
				eDisease = GetNextEffect(OBJECT_SELF);
			}
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PreviousBaccSave", 1);
		}
		
		//Handle DC increase from addiction.  
		if(nSatiation < 1)
		{
			SetPersistantLocalInt(oPC, "Addiction_Baccaran_DC", (nDC + 5));
		}
		
		//Decrement satiation
		nSatiation--;
		SetPersistantLocalInt(oPC, "BaccaranSatiation", nSatiation);
	}
}