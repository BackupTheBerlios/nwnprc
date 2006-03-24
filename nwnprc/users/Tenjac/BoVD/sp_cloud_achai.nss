//::///////////////////////////////////////////////
//:: Name      Cloud of the Achaierai  
//:: FileName  sp_cloud_achai  
//:://////////////////////////////////////////////
/**@file Cloud of the Achaierai
Conjuration (Creation) [Evil]
Level: Clr 6, Demonologist 4
Components: V, S, Disease
Casting Time: 1 action
Range: Personal
Area: 10-ft.radius spread
Duration: 10 minutes/level
Saving Throw: Fortitude partial
Spell Resistance: Yes

The caster conjures a choking, toxic cloud of inky 
blackness. Those other than the caster within the 
cloud take 2d6 points of damage. They must also 
succeed at a Fortitude save or be subject to a 
confusion effect for the duration of the spell.

Disease Component: Soul rot. 

Author:    Tenjac
Created:   03/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_misc_const"

void main()
{
	
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	/*
	Spellcast Hook Code
	Added 2003-06-20 by Georg
	If you want to make changes to all spells,
	check x2_inc_spellhook.nss to find out more
	*/
	
	if (!X2PreSpellCastCode())
	{
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}
	// End of Spell Cast Hook
	
	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_PER_ACHAIERAI);
	object oPC = OBJECT_SELF
	object oTarget = PRCGetSpellTargetObject();
	object oItemTarget = oTarget;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	float fDuration = (nCasterLvl * 600.0f);
	location lLoc = GetSpellTargetLocation();
	
	
	//Check Extend metamagic feat.
	if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
	{
		nDuration = nDuration *2;    //Duration is +100%
	}
	
	//Create an instance of the AOE Object using the Apply Effect function
	
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);
		
	SPEvilShift(oPC);
	
	SPSetSchool();
}