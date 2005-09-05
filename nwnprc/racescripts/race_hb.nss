
/*
     Script for all racial abilities / penalties that require a heartbeat check
*/

#include "prc_alterations"
#include "prc_feat_const"
#include "inc_utility"

void EffectDazzled(object oPC, float fDelay);

void main()
{
    object oPC = GetFirstPC();
    object oArea;
    object oSkin;
    int bHasLightSensitive;
    int bHasLightBlindness;
    int bIsEffectedByLight;
    
    while(GetIsObjectValid(oPC))
    {
        oArea = GetArea(oPC);
        oSkin = GetPCSkin(oPC);
        
        bHasLightSensitive = GetHasFeat(FEAT_LTSENSE, oPC);
        bHasLightBlindness = GetHasFeat(FEAT_LTBLIND, oPC);
        
        if(bHasLightSensitive || bHasLightBlindness)
        {
           if(   GetIsObjectValid(oArea)
              && !GetHasFeat(FEAT_DAYLIGHTADAPT, oPC)
              && !GetHasFeat(FEAT_NS_LIGHT_ADAPTION, oPC)
              && GetIsDay()
              && GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND
              && !GetIsAreaInterior(oArea)
             )  bIsEffectedByLight = TRUE;
           else bIsEffectedByLight = FALSE;
        }

        // light sensitivity
        // those with lightblindess are also sensitive
        if( (bHasLightSensitive || bHasLightBlindness) && bIsEffectedByLight)
        {
           EffectDazzled(oPC, 6.5);
        }

        // light blindness
        if(bHasLightBlindness && bIsEffectedByLight)
        {
           // on first entering bright light
           // cause blindness for 1 round
           if(GetLocalInt(oPC, "EnteredDaylight") == FALSE)
           {
               effect eBlind = EffectBlindness();
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 5.99);
               SetLocalInt(oPC, "EnteredDaylight", TRUE);
               EffectDazzled(oPC, 6.5);
           }
        }
        
        if(!bIsEffectedByLight && GetLocalInt(oPC, "EnteredDaylight") == TRUE)
        {
             DeleteLocalInt(oPC, "EnteredDaylight");
        }

        // imaskari underground hide bonus
        //this is in addition to the normal bonus
        if(GetIsAreaAboveGround(oArea) == AREA_UNDERGROUND && GetHasFeat(FEAT_SA_HIDEU, oPC) )
        {
            SetCompositeBonus(oSkin, "SA_Hide_Underground", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);       
        }
    
        // forest gnomes bonus to hide in the woods
        //this is in addition to the normal bonus
        if(GetHasFeat(FEAT_SA_HIDEF, oPC) &&
           GetIsAreaNatural(oArea) == AREA_NATURAL && 
           GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
        {
            SetCompositeBonus(oSkin, "SA_Hide_Forest", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE); 
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