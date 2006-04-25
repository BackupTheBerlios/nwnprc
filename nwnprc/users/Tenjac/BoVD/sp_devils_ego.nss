//::///////////////////////////////////////////////
//:: Name      Devil's Ego
//:: FileName  sp_dels_ego.nss
//:://////////////////////////////////////////////
/**@file Devil's Ego 
Transmutation [Evil] 
Level: Diabolic 3 
Components: V, S 
Casting Time: 1 action 
Range: Personal 
Target: Caster
Duration: 1 minute/level

The caster gains an enhancement bonus to Charisma
of +4 points. Furthermore, the caster is treated 
as an outsider with regard to what spells and 
magical effects can affect her (rendering a humanoid
caster immune to charm person and hold person, for
example).

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	//Spellhook
	if(!X2PreSpellCastCode()) return;
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = 60.0f * nCasterLvl;
	
	itemproperty ipRace = ITEM_PROPERTY_BONUS_FEAT(FEAT_RACIAL_OUTSIDER);
	itemproperty ipCha = ITEM_PROPERTY_ABILITY_BONUS(ABILITY_CHARISMA, 4);
	
	AddItemProperty(DURATION_TYPE_TEMPORARY, ipCha, oSkin, fDur);
	IPSafeAddItemProperty(oSkin, ipRace, fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
	
	SPEvilShift(oPC);
	SPSetSchool();
}
	
	