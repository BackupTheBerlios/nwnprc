//::///////////////////////////////////////////////
//:: Name      Addiction: Devil Weed  
//:: FileName  sp_addct_dw.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Devil Weed

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

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
	int nDC    = GetPersistantLocalInt(oPC, "Addiction_Devilweed_DC");
	int nSatiation = GetPersistantLocalInt(oPC, "DevilweedSatiation") ;
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   nSatiation < 1))
	
	{
		//1d3 Dex
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d3(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		DeletePersistantLocalInt(oPC, "PreviousDevilweedSave");
	}

        else 
        {
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PreviousDevilweedSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(OBJECT_SELF);
			effect eTest = EffectDisease(DISEASE_DEVILWEED_ADDICTION);
			
			while(GetIsEffectValid(eDisease))
			{
				if(eDisease == eTest)
				{
					RemoveEffect(oPC, eDisease);
					DeletePersistantLocalInt(oPC, "PreviousDevilweedSave");
					break;
				}
				eDisease = GetNextEffect(OBJECT_SELF);
			}
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PreviousDevilweedSave", 1);
		}
		
		//Handle DC increase from addiction.  
		if(nSatiation < 1)
		{
			SetPersistantLocalInt(oPC, "Addiction_Devilweed_DC", (nDC + 5));
		}
		
		//Decrement satiation
		nSatiation--;
		SetPersistantLocalInt(oPC, "DevilweedSatiation", nSatiation);
	}
}