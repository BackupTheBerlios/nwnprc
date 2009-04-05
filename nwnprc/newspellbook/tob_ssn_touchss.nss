/*
   ----------------
   Touch of the Shadow Sun

   tob_ssn_touchss.nss
   ----------------

    18 MAR 09 by GC
*/ /** @file

*/
#include "tob_inc_move"
#include "tob_movehook"
#include "prc_alterations"
#include "prc_inc_sp_tch"
#include "prc_inc_unarmed"

int UnarmedDamageRoll(int nDamageProp)
{
    int nDie = StringToInt(Get2DACache("iprp_monstcost", "Die", nDamageProp));
    int nNum  = StringToInt(Get2DACache("iprp_monstcost", "NumDice", nDamageProp));

	int nRoll = Random(nDie) * nNum;
	return nRoll;
}

void main()
{
	if (!PreManeuverCastCode())
	{
			// If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
			return;
	}
	// End of Spell Cast Hook

	object oInitiator    = OBJECT_SELF;
	object oTarget       = PRCGetSpellTargetObject();
	struct maneuver move = EvaluateManeuver(oInitiator, oTarget, TRUE);
	int nDamage;
	effect eLink;

	if(move.bCanManeuver)
	{
		if(GetLocalInt(oInitiator, "SSN_TOUCH_LIGHT"))
		{// Must do light touch this round
			// Get damage from last negative attack
			nDamage = GetLocalInt(oInitiator, "SSN_TOUCH_DMG");

			eLink = EffectVisualEffect(VFX_IMP_HEALING_L);
			if(GetIsEnemy(oTarget, oInitiator))
			{// Must take touch attack
				int nAttackRoll = PRCDoMeleeTouchAttack(oTarget, TRUE, oInitiator);
				if(nAttackRoll > 0)
				{// Need to hit
					ApplyTouchAttackDamage(oInitiator, oTarget, 1, nDamage, DAMAGE_TYPE_POSITIVE);
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				}
				else return; // Need to discharge energy to use other ability ..keep trying
			}
			else
			{// No need to do touch attack
				eLink = EffectLinkEffects(eLink, EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE));
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
			// Set dark touch next time used
			DeleteLocalInt(oInitiator, "SSN_TOUCH_LIGHT");
		}
		else
		{// Must do dark touch this round
			// Get damage
			nDamage = FindUnarmedDamage(oInitiator);
			nDamage = UnarmedDamageRoll(nDamage);
			nDamage += GetAbilityModifier(ABILITY_WISDOM, oInitiator);

			SetLocalInt(oInitiator, "SSN_TOUCH_DMG", nDamage);
			eLink = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
			//eLink = EffectLinkEffects(eLink, GetAttackDamage(oTarget, oInitiator, OBJECT_INVALID, GetWeaponBonusDamage(OBJECT_INVALID, oTarget), GetMagicalBonusDamage(oTarget)));
			if(GetIsEnemy(oTarget, oInitiator))
			{// Must take touch attack
				int nAttackRoll = PRCDoMeleeTouchAttack(oTarget, TRUE, oInitiator);
				if(nAttackRoll > 0)// Need to hit
				{
					ApplyTouchAttackDamage(oInitiator, oTarget, 1, nDamage, DAMAGE_TYPE_NEGATIVE);
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				}
				else return; // Need to discharge energy to use other ability ..keep trying
			}
			else
			{// No need to do touch attack
				eLink = EffectLinkEffects(eLink, EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE));
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
			// Set light touch next time used
			SetLocalInt(oInitiator, "SSN_TOUCH_LIGHT", TRUE);
		}
	}
}