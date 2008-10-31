//::///////////////////////////////////////////////
//:: Divine Power
//:: NW_S0_DivPower.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Improves the Clerics base attack by 33%, +1 HP
    per level and raises their strength to 18 if
    is not already there.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 21, 2001
//:://////////////////////////////////////////////

/*
bugfix by Kovi 2002.07.22
- temporary hp was stacked
- loosing temporary hp resulted in loosing the other bonuses
- number of attacks was not increased (should have been a BAB increase)
still problem:
~ attacks are better still approximation (the additional attack is at full BAB)
~ attack/ability bonuses count against the limits

*/


//:: modified by mr_bumpkin Dec 4, 2003
//:: modified by motu99 April 7, 2007

#include "prc_inc_combat"



/*
#include "prc_inc_combat"
#include "x2_inc_shifter"
#include "pnp_shft_poly"
*/

void PnPDivinePowerPseudoHB();

void PnPDivinePowerPseudoHB()
{
//	object oPC = OBJECT_SELF;
	if (DEBUG) DoDebug("entered PnPDivinePowerPseudoHB");

	// if we don't have the spell effect any more, do clean up
    if(!GetHasSpellEffect(SPELL_DIVINE_POWER))
    {
		DeleteLocalInt(OBJECT_SELF, "AttackCount_DivinePower");
		
		// now execute prc_bab_caller to set the base attack count to normal again
		ExecuteScript("prc_bab_caller", OBJECT_SELF);

        //end the pseudoHB
        return;
	}
	// otherwise rerun the Pseudo HB until spell expires
	DelayCommand(6.0, PnPDivinePowerPseudoHB());
}


void RemoveTempHitPointsFromObject(object oPC)
{
    effect eProtection;
    int nCnt = 0;

    eProtection = GetFirstEffect(oPC);
    while (GetIsEffectValid(eProtection))
    {
      if(GetEffectType(eProtection) == EFFECT_TYPE_TEMPORARY_HITPOINTS)
        RemoveEffect(oPC, eProtection);
      eProtection = GetNextEffect(oPC);
    }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    object oTarget = PRCGetSpellTargetObject();
	int iBAB = GetBaseAttackBonus(oTarget);
	int iHD = GetHitDice(oTarget);

    int iCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
//DoDebug("nw_s0_divpower: " +GetName(OBJECT_SELF)+" is casting DivinePower with caster level " + IntToString(iCasterLvl)+" on "+GetName(oTarget));
    int nHP = iCasterLvl;
    float fDuration = RoundsToSeconds(iCasterLvl);

	int iFighterBAB = GetFighterBAB(iHD);
    int iAttackBonus = iFighterBAB - iBAB;
	if (iAttackBonus < 0) iAttackBonus = 0;
	
	int iTotalAttackCount = GetAttacks(iFighterBAB, iHD);
	int iBonusAttacks = iTotalAttackCount - GetAttacks(iBAB, iHD);

    int nStr = GetAbilityScore(oTarget, ABILITY_STRENGTH);
    int iStrengthBonus = 18 - nStr;

	//Meta-Magic
    int nMetaMagic = PRCGetMetaMagicFeat();
    if(nMetaMagic & METAMAGIC_EXTEND)
        fDuration += fDuration;

    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eHP = EffectTemporaryHitpoints(nHP);

	// begin effect link with visual duration effect
	effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
	// make sure the attack bonus is a bonus, link it the the duration visual
	if (iAttackBonus > 0)
		eLink = EffectLinkEffects(eLink, EffectAttackIncrease(iAttackBonus));

	int bBiowareDP = GetPRCSwitch(PRC_BIOWARE_DIVINE_POWER);
	
	// if there are any bonus attacks, link them in, but only if we have biowares Divine Power version
	if (iBonusAttacks > 0 && bBiowareDP)
	{
		eLink = EffectLinkEffects(eLink, EffectModifyAttacks(iBonusAttacks));
	}

    //Make sure that the strength modifier is a bonus, and link it in
    if(iStrengthBonus > 0)
        eLink = EffectLinkEffects(eLink,EffectAbilityIncrease(ABILITY_STRENGTH, iStrengthBonus));
 
	// remove any effects from any previous Divine Power Spell
	PRCRemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveTempHitPointsFromObject(oTarget);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DIVINE_POWER, FALSE));

    //Apply Link and VFX effects to the target
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration,TRUE,-1,iCasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,iCasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

	// motu99: this must be executed *after* the spell effects are applied, otherwise prc_bab_caller will not change the base attack count!
	if(!bBiowareDP)
	{	// if we don't use Bioware's version of DP, set the additional # of attacks via prc_bab_caller
		SetLocalInt(oTarget, "AttackCount_DivinePower", iTotalAttackCount);
		ExecuteScript("prc_bab_caller", oTarget);
/*
		// now reset the # attacks after the spell expires
		DelayCommand(fDuration +0.45, DeleteLocalInt(oTarget, "AttackCount_DivinePower"));
		DelayCommand(fDuration +0.5, ExecuteScript("prc_bab_caller", oTarget));
*/
		// put the pseudo heart beat on the target of the spell, to check whether spell expired
		DelayCommand(6.0, AssignCommand(oTarget,PnPDivinePowerPseudoHB()));
	}

	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

