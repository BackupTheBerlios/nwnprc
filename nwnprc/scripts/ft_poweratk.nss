//::///////////////////////////////////////////////
//:: Power Attack script
//:: ft_poweratk
//::///////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//#include "prc_spell_const"
//#include "inc_combat2"
#include "nw_i0_spells"
//#include "x2_i0_spells"
#include "inc_addragebonus"
#include "inc_eventhook"

int BonusAtk(int iDmg)
{
    switch (iDmg)
    {
        case 1:  return DAMAGE_BONUS_1;
        case 2:  return DAMAGE_BONUS_2;
        case 3:  return DAMAGE_BONUS_3;
        case 4:  return DAMAGE_BONUS_4;
        case 5:  return DAMAGE_BONUS_5;
        case 6:  return DAMAGE_BONUS_6;
        case 7:  return DAMAGE_BONUS_7;
        case 8:  return DAMAGE_BONUS_8;
        case 9:  return DAMAGE_BONUS_9;
        case 10:  return DAMAGE_BONUS_10;
        case 11:  return DAMAGE_BONUS_11;
        case 12:  return DAMAGE_BONUS_12;
        case 13:  return DAMAGE_BONUS_13;
        case 14:  return DAMAGE_BONUS_14;
        case 15:  return DAMAGE_BONUS_15;
        case 16:  return DAMAGE_BONUS_16;
        case 17:  return DAMAGE_BONUS_17;
        case 18:  return DAMAGE_BONUS_18;
        case 19:  return DAMAGE_BONUS_19;
        case 20:  return DAMAGE_BONUS_20;
    }
    if (iDmg>20) return DAMAGE_BONUS_20;

    return 0;
}


void main()
{
    object oUser = OBJECT_SELF;
    int nPower = GetSpellId();

    // Requires the appropriate BW PA feat.
    if(!GetHasFeat(FEAT_POWER_ATTACK))
    {
        FloatingTextStrRefOnCreature(16823148, oUser, FALSE); //Prereq: Power Attack feat
        return;
    }
    if(nPower > SPELL_POWER_ATTACK5 && !GetHasFeat(FEAT_IMPROVED_POWER_ATTACK))
    {
        FloatingTextStrRefOnCreature(16823149, oUser, FALSE); // Prereq: Improved Power Attack feat
        return;
    }

    // This script is for the melee weapon PA. If Power Shot is implemented using the same script
    // at some future date, change this.
    if(GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oUser)))
    {
        FloatingTextStrRefOnCreature(16823150, oUser, FALSE); // You may not use this feat with a ranged weapon.
        return;
    }

    // Check if the character has PA active.
    int bActive = GetLocalInt(oUser, "PowerAttackActive");
    /*
    int bActive = GetHasSpellEffect(SPELL_POWER_ATTACK1,oUser)  ? SPELL_POWER_ATTACK1 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK2,oUser)  ? SPELL_POWER_ATTACK2 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK3,oUser)  ? SPELL_POWER_ATTACK3 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK4,oUser)  ? SPELL_POWER_ATTACK4 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK5,oUser)  ? SPELL_POWER_ATTACK5 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK6,oUser)  ? SPELL_POWER_ATTACK6 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK7,oUser)  ? SPELL_POWER_ATTACK7 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK8,oUser)  ? SPELL_POWER_ATTACK8 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK9,oUser)  ? SPELL_POWER_ATTACK9 :
                  GetHasSpellEffect(SPELL_POWER_ATTACK10,oUser) ? SPELL_POWER_ATTACK10: 
                  0; // None active*/

    // Activate Power Attack
    if(!bActive)
    {
        int nDamageBonusType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, oUser);
        int nDmg, nHit, nDex, nTemp;
        effect eDamage;
        effect eToHit;

        if      (nPower == SPELL_POWER_ATTACK1)  nHit = 1;
        else if (nPower == SPELL_POWER_ATTACK2)  nHit = 2;
        else if (nPower == SPELL_POWER_ATTACK3)  nHit = 3;
        else if (nPower == SPELL_POWER_ATTACK4)  nHit = 4;
        else if (nPower == SPELL_POWER_ATTACK5)  nHit = 5;
        else if (nPower == SPELL_POWER_ATTACK6)  nHit = 6;
        else if (nPower == SPELL_POWER_ATTACK7)  nHit = 7;
        else if (nPower == SPELL_POWER_ATTACK8)  nHit = 8;
        else if (nPower == SPELL_POWER_ATTACK9)  nHit = 9;
        else if (nPower == SPELL_POWER_ATTACK10) nHit = 10;

        // The attack bonus paid to PA is limited to one's BAB
        if(GetBaseAttackBonus(oUser) < (nHit + 
                                        (GetActionMode(oUser, ACTION_MODE_POWER_ATTACK) ? 5 : 0) +
                                        (GetActionMode(oUser, ACTION_MODE_IMPROVED_POWER_ATTACK ? 10 : 0))))
        {
            nHit = GetBaseAttackBonus(oUser) - ((GetActionMode(oUser, ACTION_MODE_POWER_ATTACK) ? 5 : 0) +
                                                (GetActionMode(oUser, ACTION_MODE_IMPROVED_POWER_ATTACK ? 10 : 0)));
            if(nHit < 0) nHit = 0;
            
            FloatingTextStrRefOnCreature(16823151, oUser, FALSE); // Your base attack bonus isn't high enough to pay for chosen Power Attack level.
        }

        // Focused Strike adds Dex mod to damage, limited to number of AB paid.
        if(GetHasFeat(FEAT_FOCUSED_STRIKE))
        {
            // Negative Dex mod won't reduce damage
            nDex = GetAbilityModifier(ABILITY_DEXTERITY) > 0 ? GetAbilityModifier(ABILITY_DEXTERITY) : 0;
            if(nDex > nHit) nDex = nHit;
        }

        // Calculate in Frenzied Berserker PA feats
        nTemp = GetHasFeat(FEAT_SUPREME_POWER_ATTACK, oUser) ? nHit * 2 :
                GetHasFeat(FEAT_FREBZK_IMPROVED_POWER_ATTACK, oUser) ? FloatToInt(1.5 * nHit) :
                nHit;
        
        // Calculate the damage. Supreme Power Attack doubles the dama
        nDmg = BonusAtk(nTemp + nDex);

        eDamage = EffectDamageIncrease(nDmg, nDamageBonusType);
        eToHit = EffectAttackDecrease(nHit);

        effect eLink = ExtraordinaryEffect(EffectLinkEffects(eDamage, eToHit));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oUser);
        
        // Cache the spellid of the power attack used. Also acts as a marker
        SetLocalInt(oUser, "PowerAttackActive", nPower);
        AddEventScript(oUser, EVENT_ONPLAYEREQUIPITEM, "prc_powatk_equ", TRUE, FALSE);

        //                  Power Attack                                      Activated
        string sMes = "*" + GetStringByStrRef(417) + IntToString(nHit) + " " + GetStringByStrRef(63798) + "*";
        FloatingTextStringOnCreature(sMes, oUser, FALSE);

        if (GetHasFeat(FEAT_FAVORED_POWER_ATTACK, oUser))
        {
            ActionCastSpellAtObject(SPELL_UR_FAVORITE_ENEMY, oUser, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
    // Turn Power Attack off
    else
    {
        RemoveSpellEffects(nPower, oUser, oUser);
        RemoveEventScript(oUser, EVENT_ONPLAYEREQUIPITEM, "prc_powatk_equ", TRUE);

        //                   Power Attack Mode Deactivated
        string sMes = "* " + GetStringByStrRef(58282) +  " *";
        FloatingTextStringOnCreature(sMes, oUser, FALSE);

        if(GetHasFeat(FEAT_FAVORED_POWER_ATTACK, oUser))
        {
            ActionCastSpellAtObject(SPELL_UR_FAVORITE_ENEMY, oUser, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
        }
    }
}
