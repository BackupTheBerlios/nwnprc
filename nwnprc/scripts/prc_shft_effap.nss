//::///////////////////////////////////////////////
//:: Shifting effects application spellscript
//:: prc_shft_effap
//::///////////////////////////////////////////////
/** @file prc_shft_effap
    Applies those effects of shifting that
    need an effect placed on the shifter in order
    to bind said effects to a specific spellID.

    @author Ornedan
    @date   Created - 2006.07.02
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_shifting"


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////


void main()
{
    object oApplier = OBJECT_SELF;
    object oShifter = PRCGetSpellTargetObject();
    effect eTotalEffect = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL); // Initialise to an unobtrusive VFX

    if(DEBUG) DoDebug("prc_shft_effap running");

    // Extra STR bonus / penalty
    if(GetLocalInt(oShifter, "PRC_Shifter_ExtraSTR"))
    {
        int nExtraSTR   = GetLocalInt(oShifter, "PRC_Shifter_ExtraSTR");
        int nDamageType = GetLocalInt(oShifter, "PRC_Shifter_DamageType");

        string sDamageType = _prc_inc_damage_type_string(nDamageType);
        if(DEBUG) DoDebug("prc_sft_effap: Applying extra Strength bonus / penalty\n"
                        + "nExtraSTR = " + IntToString(nExtraSTR) + "\n"
                        + "nDamageType = " + IntToString(nDamageType)
                          );

        // Determine whether we need to apply a bonus or a penalty
        if(nExtraSTR > 0)
        {
            // Determine damage bonus constant
            int nDamageBonus;
            switch(nExtraSTR)
            {
                case 1 : nDamageBonus = DAMAGE_BONUS_1 ; break;
                case 2 : nDamageBonus = DAMAGE_BONUS_2 ; break;
                case 3 : nDamageBonus = DAMAGE_BONUS_3 ; break;
                case 4 : nDamageBonus = DAMAGE_BONUS_4 ; break;
                case 5 : nDamageBonus = DAMAGE_BONUS_5 ; break;
                case 6 : nDamageBonus = DAMAGE_BONUS_6 ; break;
                case 7 : nDamageBonus = DAMAGE_BONUS_7 ; break;
                case 8 : nDamageBonus = DAMAGE_BONUS_8 ; break;
                case 9 : nDamageBonus = DAMAGE_BONUS_9 ; break;
                case 10: nDamageBonus = DAMAGE_BONUS_10; break;
                case 11: nDamageBonus = DAMAGE_BONUS_11; break;
                case 12: nDamageBonus = DAMAGE_BONUS_12; break;
                case 13: nDamageBonus = DAMAGE_BONUS_13; break;
                case 14: nDamageBonus = DAMAGE_BONUS_14; break;
                case 15: nDamageBonus = DAMAGE_BONUS_15; break;
                case 16: nDamageBonus = DAMAGE_BONUS_16; break;
                case 17: nDamageBonus = DAMAGE_BONUS_17; break;
                case 18: nDamageBonus = DAMAGE_BONUS_18; break;
                case 19: nDamageBonus = DAMAGE_BONUS_19; break;

                // The value is >= 20, the bonus limit is +20
                default: nDamageBonus = DAMAGE_BONUS_20;
            }

            // Generate bonus effects
            eTotalEffect = EffectLinkEffects(eTotalEffect, EffectAttackIncrease(nExtraSTR, ATTACK_BONUS_MISC));
            eTotalEffect = EffectLinkEffects(eTotalEffect, EffectDamageIncrease(nDamageBonus, nDamageType));
            SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57428+0x01000000) + " +" + IntToString(nExtraSTR)); //Attack increase from STR increase
            SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57429+0x01000000) + " +" + IntToString(nExtraSTR)); //Damage increase from STR increase
        }
        else
        {
            // Generate penalty effects
            eTotalEffect = EffectLinkEffects(eTotalEffect, EffectAttackDecrease(-nExtraSTR, ATTACK_BONUS_MISC));
            eTotalEffect = EffectLinkEffects(eTotalEffect, EffectDamageDecrease(-nExtraSTR, nDamageType));
            SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57428+0x01000000) + " " + IntToString(nExtraSTR)); //Attack decrease from STR increase
            SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57429+0x01000000) + " " + IntToString(nExtraSTR)); //Damage decrease from STR increase
        }

        // Clean up local vars
        DeleteLocalInt(oShifter, "PRC_Shifter_ExtraSTR");
        DeleteLocalInt(oShifter, "PRC_Shifter_DamageType");
    }

    // Extra DEX gets turned into an AC modifier
    if(GetLocalInt(oShifter, "PRC_Shifter_ExtraDEX"))
    {
        int nExtraDEX = GetLocalInt(oShifter, "PRC_Shifter_ExtraDEX");

        if(DEBUG) DoDebug("prc_sft_effap: Applying extra Dexterity bonus / penalty\n"
                        + "nExtraDEX = " + IntToString(nExtraDEX)
                          );

        // Generate effect
        if(nExtraDEX > 0)
        {
            eTotalEffect = EffectLinkEffects(eTotalEffect, EffectACIncrease(nExtraDEX));
            SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57430+0x01000000) + " +" + IntToString(nExtraDEX)); //AC increase from DEX increase
        }
        else
        {
            eTotalEffect = EffectLinkEffects(eTotalEffect, EffectACDecrease(-nExtraDEX));
            SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57430+0x01000000) + " " + IntToString(nExtraDEX)); //AC decrease from DEX increase
        }

        // Clean up local var
        DeleteLocalInt(oShifter, "PRC_Shifter_ExtraDEX");
    }

    // Natural AC
    if(GetLocalInt(oShifter, "PRC_Shifter_NaturalAC"))
    {
        int nNaturalAC = GetLocalInt(oShifter, "PRC_Shifter_NaturalAC");

        if(DEBUG) DoDebug("prc_sft_effap: Applying extra Natural AC bonus\n"
                        + "nNaturalAC = " + IntToString(nNaturalAC)
                          );

        // Generate effect
        eTotalEffect = EffectLinkEffects(eTotalEffect, EffectACIncrease(nNaturalAC, AC_NATURAL_BONUS));
        SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57435+0x01000000) + " " + IntToString(nNaturalAC)); //Natural AC of form

        // Clean up local var
        DeleteLocalInt(oShifter, "PRC_Shifter_NaturalAC");
    }

    // Harmlessly invisible
    if(GetLocalInt(oShifter, "PRC_Shifter_HarmlessInvisible"))
    {
        if(DEBUG) DoDebug("prc_sft_effap: Applying harmlessness invisibility");

        SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57424+0x01000000)); //"Harmlessly Invisible"

        // Generate effect
        eTotalEffect = EffectLinkEffects(eTotalEffect, EffectInvisibility(INVISIBILITY_TYPE_NORMAL));

        // Clean up local var
        DeleteLocalInt(oShifter, "PRC_Shifter_HarmlessInvisible");
    }

    // Supernaturalise and apply the total effect
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eTotalEffect), oShifter);

    // Queue deletion of the applicator object
    DestroyObject(oApplier, 6.0f);
    
    //Apply temporary HP separately from other effects--linking it with other effects
    //causes those other effects to be removed when the temporary HP is used up.
    
    eTotalEffect = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL); // Initialise to an unobtrusive VFX

    // Extra CON bonus gets turned into temporary HP
    if(GetLocalInt(oShifter, "PRC_Shifter_ExtraCON"))
    {
        int nExtraCON = GetLocalInt(oShifter, "PRC_Shifter_ExtraCON");

        if(DEBUG) DoDebug("prc_sft_effap: Applying extra Constitution bonus\n"
                        + "nExtraCON = " + IntToString(nExtraCON)
                          );

        // Generate effect
        int tempHP = nExtraCON * GetHitDice(oShifter);
        eTotalEffect = EffectLinkEffects(eTotalEffect, EffectTemporaryHitpoints(tempHP));
        SendMessageToPC(oShifter, "=== " + GetStringByStrRef(57431+0x01000000) + " " + IntToString(tempHP)); //Temporary HP from CON increase

        // Clean up local var
        DeleteLocalInt(oShifter, "PRC_Shifter_ExtraCON");
    }

    // Supernaturalise and apply the total effect
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eTotalEffect), oShifter);

    // Queue deletion of the applicator object
    DestroyObject(oApplier, 6.0f);
}
