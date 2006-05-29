//::///////////////////////////////////////////////
//:: Name      Addiction: Luhix  
//:: FileName  sp_addct_lhx.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Luhix

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "Addiction_Luhix_DC");
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   (!GetPersistantLocalInt(oPC, "LuhixSatiation")))
	{
		//1d8 Dex, 1d8 Wis, 1d6 Con, 1d6 Str
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d8(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_WISDOM, d8(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		ApplyAbilityDamage(oPC, ABILITY_STRENGTH, d6(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		
		DeletePersistantLocalInt(oPC, "PreviousLuhixSave");
	}
	
	else 
	{
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PreviousLuhixSave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(OBJECT_SELF);
			effect eTest = EffectDisease(DISEASE_LUHIX_ADDICTION);
			
			while(GetIsEffectValid(eDisease))
			{
				if(eDisease == eTest)
				{
					RemoveEffect(oPC, eDisease);
					DeletePersistantLocalInt(oPC, "PreviousLuhixSave");
					break;
				}
				
				eDisease = GetNextEffect(OBJECT_SELF);
			}			
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PreviousLuhixSave", 1);
		}
	}
	
	//Handle DC increase from addiction.  
	if(!GetPersistantLocalInt(oPC, "LuhixSatiation"))
	{
		SetPersistantLocalInt(oPC, "Addiction_Luhix_DC", (nDC + 5));
	}
	
	//Remove the int, as it only lasts 1 day
	DeletePersistantLocalInt(oPC, "LuhixSatiation");
}
