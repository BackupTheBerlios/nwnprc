//::///////////////////////////////////////////////
//:: Name      Arrow of Dusk
//:: FileName  shd_arrow_dusk.nss
//:://////////////////////////////////////////////
/**@file Arrow of Dusk
Fundamental
Level/School: 1st/Evocation
Range: Medium (100ft. + 10 ft./level)
Effect: Ray
Duration:  Instantaneous
Saving Throw:  None
Spell Resistance: No

You must succeed on a ranged touch attack to deal
2d4 points of nonlethal damage to the target.  If
you score a critical hit, triple the damage.

Author:    Tenjac
Created:   11/17/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_shadow"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject;
	int nDam;
	
	
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	if(nTouch > 0)
	{
		nDam = d4(2);
		
		//metashadow
		
		if(nTouch == 2)
		{
			nDam = (nDam * 3);
		}
		
		//VFX
		
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(DAMAGE_TYPE_MAGICAL, nDam), oTarget);
	}
	
	SPSetSchool();
}
		
	