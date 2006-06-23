//::///////////////////////////////////////////////
//:: Sleep
//:: NW_S0_Sleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Goes through the area and sleeps the lowest 4+d4
    HD of creatures first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 7 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"

#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
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
		
	//Declare major variables
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	effect eSleep =  EffectSleep();
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
	effect eLink = EffectLinkEffects(eSleep, eMind);
	eLink = EffectLinkEffects(eLink, eDur);
	int CasterLvl = 13;
	
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	//Beam VFX.  Ornedan is my hero.
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
	
	if (nTouch)
	{
		int nDuration = CasterLvl + 3;
		int nPenetr = CasterLvl + SPGetPenetr();
		
		string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);
		
		//Make SR check
		if (!MyPRCResistSpell(oPC, oTarget ,nPenetr))
		{
			int nDC = PRCGetSaveDC(oTarget,oPC);
			//Make Fort save
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				
				if((!GetIsImmune(oTarget, IMMUNITY_TYPE_SLEEP) && GetHitDice(oTarget) < 5)
				{
					effect eLink2 = EffectLinkEffects(eLink, eVis);
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
				}
				
			}
		}
	}
	
	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	// Getting rid of the integer used to hold the spells spell school
}