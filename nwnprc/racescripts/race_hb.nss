
/*
     Script for all racial abilities / penalties that require a heartbeat check
*/

#include "prc_feat_const"

void EffectDazzled(object oPC, float fDelay);

void main()
{
    object oPC = GetFirstPC();
    int bHasLightSensitive;
    int bHasLightBlindness;
    int bIsEffectedByLight;
    
    while(GetIsObjectValid(oPC))
    {
        object oArea = GetArea(oPC);
        
        int bHasLightSensitive = GetHasFeat(FEAT_LTSENSE, oPC);
        int bHasLightBlindness = GetHasFeat(FEAT_LTSENSE, oPC);
        
        if(bHasLightSensitive || bHasLightSensitive)
        {
           if(   GetIsObjectValid(oArea)
              && GetIsDay()
              && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
              && !GetIsAreaInterior(oArea)
             )  bIsEffectedByLight = TRUE;
           else bIsEffectedByLight = FALSE;
        }

        //light sensitivity
        if(bHasLightSensitive && bIsEffectedByLight)
        {
           EffectDazzled(oPC, 5.99);
        }

        //light blindness
        if(bHasLightBlindness && bIsEffectedByLight)
        {
           // on first entering bright light
           // cause blindness for 1 round
           if(GetLocalInt(oPC, "EnteredDaylight") == FALSE)
           {
               effect eBlind = EffectBlindness();
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 5.99);
               SetLocalInt(oPC, "EnteredDaylight", TRUE);
               EffectDazzled(oPC, 5.99);
           }
           // Keep Dazzling them until they are out of the light
           else if(GetLocalInt(oPC, "EnteredDaylight") == TRUE)
           {
               EffectDazzled(oPC, 5.99);
           }
           // Finally out of the light, no more daze, remove int
           else
           {
                DeleteLocalInt(oPC, "EnteredDaylight");
           }
        }

        oPC = GetNextPC();
    }
}

void EffectDazzled(object oPC, float fDelay)
{
     effect eAttack = EffectAttackDecrease(1);
     effect eSearch = EffectSkillDecrease(SKILL_SEARCH, 1);
     effect eSpot   = EffectSkillDecrease(SKILL_SPOT,   1);
     effect eLink   = EffectLinkEffects(eAttack, eSearch);
     eLink          = EffectLinkEffects(eLink,   eSpot);
     ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDelay);
}