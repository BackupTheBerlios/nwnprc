
/*
     Script for all racial abilities / penalties that require a heartbeat check
*/

#include "prc_feat_const"

void main()
{
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        object oArea = GetArea(oPC);

        //light sensitivity
        if(GetHasFeat(FEAT_LTSENSE, oPC)
            && GetIsDay()
            && GetIsObjectValid(oArea)
            && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
            && !GetIsAreaInterior(oArea))
        {
            effect eAttack = EffectAttackDecrease(1);
            effect eSearch = EffectSkillDecrease(SKILL_SEARCH, 1);
            effect eSpot   = EffectSkillDecrease(SKILL_SPOT,   1);
            effect eLink   = EffectLinkEffects(eAttack, eSearch);
            eLink          = EffectLinkEffects(eLink,   eSpot);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 5.99);
        }

        //light blindness
        if(GetHasFeat(FEAT_LTBLIND, oPC))
        {
            if(GetIsDay()
            && GetIsObjectValid(oArea)
            && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
            && !GetIsAreaInterior(oArea))
            {
                if(GetLocalInt(oPC, "EnteredDaylight") == FALSE)
                {
                    effect eBlind = EffectBlindness();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 5.99);
                    SetLocalInt(oPC, "EnteredDaylight", TRUE);
                }
            }
            else
                DeleteLocalInt(oPC, "EnteredDaylight");
        }
        FloatingTextStringOnCreature("Heart Beat Active", oPC);
        oPC = GetNextPC();
    }
    
}