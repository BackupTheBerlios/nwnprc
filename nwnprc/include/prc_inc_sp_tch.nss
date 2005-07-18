int PRCDoRangedTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF);
int PRCDoMeleeTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF);

#include "prc_inc_sneak"
#include "prc_inc_switch"
#include "prc_inc_combat"

int PRCDoRangedTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF)
{
    if(GetLocalInt(oCaster, "AttackHasHit"))
        return GetLocalInt(oCaster, "AttackHasHit");
    return GetAttackRoll(oTarget, oCaster, OBJECT_INVALID, 0, 0,0,nDisplayFeedback, 0.0, TOUCH_ATTACK_RANGED_SPELL);
}

int PRCDoMeleeTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF)
{
    if(GetLocalInt(oCaster, "AttackHasHit"))
        return GetLocalInt(oCaster, "AttackHasHit");
    return GetAttackRoll(oTarget, oCaster, OBJECT_INVALID, 0, 0,0,nDisplayFeedback, 0.0, TOUCH_ATTACK_MELEE_SPELL);
}

// return sneak attack damage for a spell
// requires caster, target, and spell damage type
int SpellSneakAttackDamage(object oCaster, object oTarget)
{
     int numDice = GetTotalSneakAttackDice(oCaster);
     
     if(numDice != 0 && GetCanSneakAttack(oTarget, oCaster) )
     {
          FloatingTextStringOnCreature("*Sneak Attack Spell*", oCaster, TRUE);
          return GetSneakAttackDamage(numDice); 
     }
     else
     {
          return 0;
     }
}

// Applies damage from a ranged touch attack including critical damage and sneak attack damage
// the target to attack, the original damage ammount (will get doubled if critical)
// TouchAttackType  0 = melee, 1 = ranged  , 3 non-sneak melee, 4 non-sneak ranged
// DisplayFeedBack - default is true
int ApplyTouchAttackDamage(object oCaster, object oTarget, int iAttackRoll, int iDamage, int iDamageType, int bCanSneakAttack = TRUE)
{
     // perform critical
     if(iAttackRoll == 2)  iDamage *= 2;
     
     // add sneak attack damage if applicable
     if(bCanSneakAttack && !GetPRCSwitch(PRC_SPELL_SNEAK_DISABLE))
          iDamage += SpellSneakAttackDamage(oCaster, oTarget);
     
     // adds the bonus for spell bretrayal or spell strike for touch spells
     iDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
     // apply damage
     if(iAttackRoll > 0)
     {
          effect eDamage = EffectDamage(iDamage, iDamageType);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
     }
     
     return iAttackRoll;
}