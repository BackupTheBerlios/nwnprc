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
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    
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
        if (GetIsObjectValid(oWeap))
        {
            FloatingTextStringOnCreature("You must be fighting unarmed to use Powerful Charge", oPC);
            return;
        }
        
        int iVoiceConst = 0;
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

        int iAttackRoll = d20() + GetBaseAttackBonus(oPC) + GetAbilityModifier(ABILITY_STRENGTH, oPC) + 2;
        int iAC = GetAC(oTarget);
        int iDmg = d8() + d6(4) + 6 + GetAbilityModifier(ABILITY_STRENGTH, oPC);
        
        float fDur = 15.0;
        
        effect eAC = EffectACDecrease(2);
        effect eDmg;        

        if (iAttackRoll >= iAC)
        {
            eDmg = EffectDamage(iDmg, DAMAGE_TYPE_PIERCING);
        }
        
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, fDur);
        
        AssignCommand(oPC, ActionMoveToObject(oTarget, TRUE));
        DelayCommand(0.1, AssignCommand(oPC, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget))));
        DelayCommand(0.2, AssignCommand(oPC, ActionDoCommand(HitString(iAttackRoll >= iAC))));
        DelayCommand(0.3, AssignCommand(oPC, ActionDoCommand(RemoveSpellEffects(GetSpellId(), oPC, oPC))));
        DelayCommand(0.4, AssignCommand(oPC, ActionDoCommand(Attack(oTarget))));
    }
    else
    {
        FloatingTextStringOnCreature("Too close for Powerful Charge", oPC);
    }
}
