//::///////////////////////////////////////////////
//:: Name      Addiction: Terran Brandy
//:: FileName  sp_addct_tb.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Terran Brandy

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//::///////////////////////////////////////////////
//:: Name      Addiction: Sannish
//:: FileName  sp_addct_snh.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Sannish

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//::///////////////////////////////////////////////
//:: Name      Addiction: Mushroom Powder 
//:: FileName  sp_addct_msh.nss 
//:://////////////////////////////////////////////
/** Script for addiction to the drug Mushroom Powder

Author:    Tenjac
Created:   5/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	int nDC    = GetPersistantLocalInt(oPC, "PRC_Addiction_TerranBrandy_DC");
	int nSatiation = GetPersistantLocalInt(oPC, "PRC_TerranBrandySatiation");
		
	//make save vs nasty bad things or have satiation
	if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, nDC, SAVING_THROW_TYPE_DISEASE) &&
	   (!GetPersistantLocalInt(oPC, "PRC_TerranBrandySatiation")))
	{
		//1d8 Dex, 1d8 Wis, 1d6 Con, 1d6 Str
		ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, d3(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f, FALSE);
		
		DeletePersistantLocalInt(oPC, "PRC_PreviousTerranBrandySave");
	}
	
	else 
	{
		//Two successful saves
		if(GetPersistantLocalInt(oPC, "PRC_PreviousTerranBrandySave"))
		{
			//Remove addiction
			//Find the disease effect
			effect eDisease = GetFirstEffect(oPC);
			effect eTest = EffectDisease(DISEASE_TERRAN_BRANDY_ADDICTION);
			
			while(GetIsEffectValid(eDisease))
			{
				if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
				{
					if(GetEffectSpellId(eDisease) == SPELL_DEVILWEED)
					{
						RemoveEffect(oPC, eDisease);
						DeletePersistantLocalInt(oPC, "PRC_PreviousTerranBrandySave");
						break;
					}
				}
				
				eDisease = GetNextEffect(oPC);
			}			
		}
		//Saved, but no previous
		else
		{
			SetPersistantLocalInt(oPC, "PRC_PreviousTerranBrandySave", 1);
		}
	}
	
	//Handle DC increase from addiction.  
	if(!GetPersistantLocalInt(oPC, "PRC_TerranBrandySatiation"))
	{
		SetPersistantLocalInt(oPC, "PRC_Addiction_TerranBrandy_DC", (nDC + 5));
	}
	
	//Decrement satiation
	nSatiation--;
	SetPersistantLocalInt(oPC, "PRC_TerranBrandySatiation", nSatiation);
}