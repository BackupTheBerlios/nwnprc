/*
	Feyri Enervation
*/
#include "spinc_common"
#include "NW_I0_SPELLS"
void main()
{
    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    object oTarget = GetSpellTargetObject();
    int nDrain = d4();
    int CasterLvl = 3;

    int nDuration = CasterLvl;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    int nPenetr = CasterLvl + SPGetPenetr();

    //Undead Gain HP from Enervation
    int nHP = ((CasterLvl/2) * 5);
    if (nHP > 25)
    {
    nHP = 25;
    }

    effect eHP = EffectTemporaryHitpoints(nHP);
    effect eDrain = EffectNegativeLevel(nDrain);
    effect eLink = EffectLinkEffects(eDrain, eDur);

        
        if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HoursToSeconds(1),TRUE,-1,CasterLvl);
        }


    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERVATION));
        //Resist magic check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
            {
                //Apply the VFX impact and effects
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}

