//::///////////////////////////////////////////////
//:: Death Knell
//:: apal_deathknell.nss
//:://////////////////////////////////////////////
/*
    If target creature with less than 10 HP fails save 
    caster gains 1d8 temp HP, +2 Str, and +1 Caster level
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Sept 13, 2004
//:://////////////////////////////////////////////

#include "spinc_common"
#include "NW_I0_SPELLS"
#include "prc_inc_clsfunc"

void DeathKnellCheck(object oPC)
{
     if (!GetHasSpellEffect(2086, oPC)) // Death Knell
     {
         DeleteLocalInt(oPC, "Apal_DeathKnell");
     }
     else
     {
         DelayCommand(6.0, DeathKnellCheck(oPC));
     }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int iHP = GetCurrentHitPoints(oTarget);
    int CasterLvl = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)/2;
    if (GetLocalInt(OBJECT_SELF, "Apal_DeathKnell") == TRUE)
    {
    	CasterLvl = CasterLvl + 1;
    }
    int nDuration = CasterLvl;
    int nBonus = d8(1);
    int nPenetr = CasterLvl + SPGetPenetr();
    int nDC = GetSpellDCSLA(OBJECT_SELF,1);
    int nSpellDC = (nDC + GetChangesToSaveDC(oTarget,OBJECT_SELF)) ;
    
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
    effect eHP = EffectTemporaryHitpoints(nBonus);

    effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH_L);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    

    effect eLink = EffectLinkEffects(eStr, eDur);

       
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERVATION));
    //Resist magic check
    
if (iHP < 10)
{    
    if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
    {
        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
        {
                //Apply the VFX impact and effects
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                
                
                //Apply the bonuses to the PC
	        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
	        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    		SetLocalInt(OBJECT_SELF, "Apal_DeathKnell", TRUE);
                DelayCommand(9.0, DeathKnellCheck(OBJECT_SELF));
    	}
    }

}
else
{
    FloatingTextStringOnCreature("*Death Knell failure: The target isn't weak enough*", OBJECT_SELF, FALSE);
}

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

