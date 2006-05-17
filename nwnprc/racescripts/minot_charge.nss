//::///////////////////////////////////////////////
//:: [Powerful Charge]
//:: [avar_dive.nss]
//:://////////////////////////////////////////////
/*
  
  Creature can perform an unarmed charge attack at +2 while suffering -2 to armor
  class. A successful attack does an additional 4d6+6 damage.
  
*/
//:://////////////////////////////////////////////
//:: Created By: WodahsEht
//:: Created On: Oct. 3, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_combat"
#include "nw_i0_spells"
#include "prc_inc_util"
#include "prc_inc_skills"

void HitString(int iHit)
{
    object oPC = OBJECT_SELF;
    if (iHit)
    {
        FloatingTextStringOnCreature("*Powerful Charge hit*", oPC);
    }
    else
    {
        FloatingTextStringOnCreature("*Powerful Charge miss*", oPC);
    }
}

void Attack(object oTarget)
{
    object oPC = OBJECT_SELF;
    AssignCommand(oPC, ActionAttack(oTarget));
}

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
    if(oTarget == OBJECT_INVALID)
    {
       FloatingTextStringOnCreature("Invalid Target for Powerful Charge", oPC);
       return;
    }
    
    float fDistance = GetDistanceBetweenLocations(GetLocation(oPC), GetLocation(oTarget) );
    
    // PnP rules use feet, might as well convert it now.
    fDistance = MetersToFeet(fDistance);
    if(fDistance >= 10.0)
    {
        string sResRef = "prc_mino_char";
        object oWeapon = GetObjectByTag(sResRef);
        if(!GetIsObjectValid(oWeapon))
        {
            object oLimbo = GetObjectByTag("HEARTOFCHAOS");
            location lLimbo = GetLocation(oLimbo);
            if(!GetIsObjectValid(oLimbo))
                lLimbo = GetStartingLocation();
            oWeapon = CreateObject(OBJECT_TYPE_ITEM, sResRef, lLimbo);
        }
        
        int iVoice = d3(1);
        switch(iVoice)
        {
             case 1: iVoice = VOICE_CHAT_BATTLECRY1;
                     break;
             case 2: iVoice = VOICE_CHAT_BATTLECRY2;
                     break;
             case 3: iVoice = VOICE_CHAT_BATTLECRY3;
                     break;
        }
        PlayVoiceChat(iVoice);
        //charging allows double speed, +2 AB, -2 AC
        effect eCharge = EffectLinkEffects(EffectAttackIncrease(2), EffectACDecrease(2));
        eCharge = EffectLinkEffects(eCharge, EffectMovementSpeedIncrease(99));
        eCharge = SupernaturalEffect(eCharge);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 3.0);
        //char
        effect eInvalid;
        ActionMoveToObject(oTarget, TRUE);
        ActionDoCommand(
            PerformAttack(oTarget, 
                oPC,                //
                eInvalid,           //effect eSpecialEffect,
                0.0,                //float eDuration = 0.0
                9,                  //int iAttackBonusMod = 0
                0,                  //int iDamageModifier = 0
                0,                  //int iDamageType = 0
                "* Powerful Charge hit *",    //string sMessageSuccess = ""   
                "* Powerful Charge missed *",    //string sMessageFailure = ""
                FALSE,              //int iTouchAttackType = FALSE
                oWeapon,            //object oRightHandOverride = OBJECT_INVALID,
                OBJECT_INVALID      //object oLeftHandOverride = OBJECT_INVALID
            ));
        ActionAttack(oTarget);    
    }
    else
    {
        FloatingTextStringOnCreature("Too close for Powerful Charge", oPC);
    }
}
