//::///////////////////////////////////////////////
//:: Name      Black Candle
//:: FileName  mys_black_candle.nss
//:://////////////////////////////////////////////
/**@file Black Candle
Fundamental
Level/School: 1st/Evocation [Light or Darkness]
Range: Touch
Target: Object touched 
Duration: 1 round/level 
Saving Throw: None  
Spell Resistance: No

This mystery functions like the spell light or the
spell darkness.  Only one of these two effects is 
possible per use, and you must decide which effect
is desired when casting.

Author:    Tenjac
Created:   11/17/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_shadowmagic"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nSpell = PRCGetSpellId();
	int nMetaShadow = PRCGetMetaShadowFeats();
	int nMystLevel = PRCGetMysteryUserLevel(oPC);
	
	if(nSpell = MYSTERY_BLACK_CANDLE_LIGHT)
	{
		
	}
	
	if(nSpell = MYSTERY_BLACK_CANDLE_DARK)
	{
		
	}
	
	SPSetSchool();
}
	
		