//:://////////////////////////////////////////////
/*
    This file is for the code/const for any custom skills.
*/
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"
//#include "prc_inc_util"
//#include "inc_utility"
//#include "prc_class_const"
//#include "prc_misc_const"
// Rework if this file (prc_inc_skills) is ever included to the massive include complex
//#include "x0_i0_spells"

//:://////////////////////////////////////////////
//:: Skill Functions
//:://////////////////////////////////////////////

// returns true if they pass the jump check
// also handles animations and knockdown
int PerformJump(object oPC, location lLoc, int bDoKnockDown = TRUE)
{
     object oArea = GetArea(oPC);
     // if jumping is disabled in this place.
     if( GetLocalInt(oArea, "AreaJumpOff") == TRUE )
     {
          SendMessageToPC(oPC, "Jumping is not allowed in this area.");
          return FALSE;
     }

    // Immobilized creatures can't jump
    effect eCheck = GetFirstEffect(oPC);
    int nCheck;
    while(GetIsEffectValid(eCheck)){
        nCheck = GetEffectType(eCheck);
        if(nCheck == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
           nCheck == EFFECT_TYPE_ENTANGLE)
        {
            SendMessageToPC(oPC, "You cannot move.");
            return FALSE;
        }

        eCheck = GetNextEffect(oPC);
    }

     int bIsRunningJump = FALSE;
     int bPassedJumpCheck = FALSE;
     int iMinJumpDistance = 0;
     int iMaxJumpDistance = 6;
     int iDivisor = 1;
     int iJumpDistance = 0;
     int bIsInHeavyArmor = FALSE;

     int iDistance = FloatToInt(MetersToFeet(GetDistanceBetweenLocations(GetLocation(oPC), lLoc ) ) );

     object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
     int AC = GetBaseAC(oArmor);
     if(AC >= 6) bIsInHeavyArmor = TRUE;

     // Jump check rules depend on a running jump or standing jump
     // running jumps require at least 20 feet run length
     if (iDistance >= 18 && !bIsInHeavyArmor)  bIsRunningJump = TRUE;

     int iBonus = 0;
     if (GetHasFeat(FEAT_GREAT_LEAP, oPC))
     {
        if (Ninja_AbilitiesEnabled(oPC))
        {
            bIsRunningJump = TRUE;
            iBonus = 4;
        }
     }
     /*if (GetHasSpellEffect(MOVE_TC_LEAPING_DRAGON, oPC))
     {
            bIsRunningJump = TRUE;
            iBonus = 10;
     }     */
     // PnP rules are height * 6 for run and height * 2 for jump.
     // I can't get height so that is assumed to be 6.
     // Changed maxed jump distance because the NwN distance is rather short
     // at least compared to height it is.
     if(bIsRunningJump)
     {
          iMinJumpDistance = 5;
          iDivisor = 1;
          iMaxJumpDistance *= 6;
     }
     else
     {
          iMinJumpDistance = 3;
          iDivisor = 2;
          iMaxJumpDistance *= 3;
     }

     // Simulate "leap of the clouds", or RDD's having wings can "fly"
     if(GetLevelByClass(CLASS_TYPE_MONK, oPC) >= 7
        || GetLevelByClass(CLASS_TYPE_NINJA_SPY, oPC) >= 3
        || spellsIsFlying(oPC))
            iMaxJumpDistance *= 100;

     // skill 28 = jump
     int iJumpRoll = d20() + GetSkillRank(SKILL_JUMP, oPC) + iBonus + GetAbilityModifier(ABILITY_STRENGTH, oPC);
     
     // Use Dex instead of Strength
     if (GetHasFeat(FEAT_AGILE_ATHLETE, oPC))
     {
     	iJumpRoll -= GetAbilityModifier(ABILITY_STRENGTH, oPC);
     	iJumpRoll += GetAbilityModifier(ABILITY_DEXTERITY, oPC);
     }

     if(GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5) iJumpRoll += 2;

     // Jump distance is determined by the number exceeding 10
     // divided based on running or standing jump.
     iJumpRoll -= 10;
     if(iJumpRoll < 1) iJumpRoll = 1;
     iJumpRoll /= iDivisor;
     iJumpDistance = iMinJumpDistance + iJumpRoll;

     if(iJumpDistance >= iDistance && iDistance <= iMaxJumpDistance)
     {
          // they passed jump check
          bPassedJumpCheck = TRUE;

          effect eJump = EffectDisappearAppear(lLoc);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eJump, oPC, 3.1);
     }
     else
     {
          // they failed jump check
          FloatingTextStringOnCreature("Jump check failed.", oPC);
          bPassedJumpCheck = FALSE;

          if(bDoKnockDown)
          {
               effect eKnockDown = EffectKnockdown();
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eKnockDown, oPC);
          }
     }

     return bPassedJumpCheck;
}