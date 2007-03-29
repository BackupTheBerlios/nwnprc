/*
   ----------------
   Desert Wind On Hit

   tob_dw_onhit.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    OnHit for Burning Blade and other DW booster spells.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
	// fill the variables
	object oPC     = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	object oItem   = GetSpellCastItem();
	int nLevel     = GetInitiatorLevel(oPC, CLASS_TYPE_SWORDSAGE);
	int nSpellId   = GetLocalInt(oPC, "DesertWindBoot");
	if(DEBUG) DoDebug("tob_dw_onhit: nSpellId " + IntToString(nSpellId));
	effect eDam;
	switch(nSpellId)
	{
		case MOVE_DW_BURNING_BLADE:
		{
			eDam = EffectDamage(d6() + nLevel, DAMAGE_TYPE_FIRE);
			if(DEBUG) DoDebug("tob_dw_onhit: MOVE_DW_BURNING_BLADE");
			break;
		}
	}
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
}