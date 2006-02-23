//::///////////////////////////////////////////////
//:: Hatred Domain Power
//:: prc_domain_hate.nss
//::///////////////////////////////////////////////
/*
    Grants +2 Attack, Saving Throws and AC vs the targeted race. 
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_inc_domain"

void main()
{
    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(DOMAIN_HATRED, OBJECT_SELF)) return;
    
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nRace = MyPRCGetRacialType(oTarget);
    int nDur = 10; // Lasts for 1 minute
    int nBonus = 2;

    effect eAttack = EffectAttackIncrease(nBonus);
    effect eAC = EffectACIncrease(nBonus);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    effect eLink = EffectLinkEffects(eAttack, eAC);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = VersusRacialTypeEffect(eLink, nRace);    

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDur));
}
