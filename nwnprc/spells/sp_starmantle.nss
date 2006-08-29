//::///////////////////////////////////////////////
//:: Name      Starmantle
//:: FileName  sp_starmantle.nss
//:://////////////////////////////////////////////
/**@file Starmantle 
Abjuration 
Level: Joy 7, Sor/Wiz 6 
Components: V, S, M 
Casting Time: 1 standard action
Range: Touch
Target: One living creature touched
Duration: 1 minute/level (D) 
Saving Throw: None
Spell Resistance: Yes (harmless)

This spell manifests as a draping cloak of tiny, 
cascading stars that seem to flicker out before 
touching the ground. The cloak forms over the 
target's existing apparel and sheds light as a 
torch, although this is not the mantle's primary
function.

The starmantle renders the wearer impervious to 
non-magical weapon attacks and transforms any 
non-magical weapon or missile that strikes it 
into harmless light, destroying it forever. 
Contact with the starmantle does not destroy 
magic weapons or missiles, but the starmantle's 
wearer is entitled to a Reflex saving throw 
(DC 15) each time he is struck by such a weapon;
success indicates that the wearer takes only 
half damage from the weapon (rounded down).

Material Component: A pinch of dust from a 
pixie's wing (20 gp).

Author:    Tenjac
Created:   7/17/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ABJURATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nType = MyPRCGetRacialType(oTarget);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLvl);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	if(nType == RACIAL_TYPE_UNDEAD || nType == RACIAL_TYPE_CONSTRUCT)
	{
		SPSetSchool();
		return;
	}
	
	//VFX
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SANCTUARY), oTarget, fDur);
	
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
	
	itemproperty ipOnHit = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
	IPSafeAddItemProperty(oArmor, ipOnHit, fDur);
	
	//Add event script
	AddEventScript(oTarget, EVENT_ONHIT, "prc_evnt_strmtl", TRUE, FALSE);
	
	//impervious to non-magical weapons for the duration
	effect eReduce = EffectDamageReduction(0, DAMAGE_POWER_PLUS_ONE, 0);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReduce, oTarget, fDur);
	
	SPSetSchool();
}
	
	
	
	   
	   
	   