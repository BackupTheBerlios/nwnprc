void main()
{

    object oPC = OBJECT_SELF;
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

    int iCha = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    int iDam;

    if(iCha <= 1){iDam = 1;}
    if(iCha == 2){iDam = 2;}
    if(iCha == 3){iDam = 3;}
    if(iCha == 4){iDam = 4;}
    if(iCha == 5){iDam = 5;}
    if(iCha == 6){iDam = 6;}
    if(iCha == 7){iDam = 7;}
    if(iCha == 8){iDam = 8;}
    if(iCha == 9){iDam = 9;}
    if(iCha == 10){iDam = 10;}
    if(iCha == 11){iDam = 11;}
    if(iCha == 12){iDam = 12;}
    if(iCha == 13){iDam = 13;}
    if(iCha == 14){iDam = 14;}
    if(iCha == 15){iDam = 15;}
    if(iCha == 16){iDam = 16;}
    if(iCha == 17){iDam = 17;}
    if(iCha == 18){iDam = 18;}
    if(iCha == 19){iDam = 19;}
    if(iCha == 20){iDam = 20;}

    effect eAttackBonus = EffectAttackIncrease(iCha,ATTACK_BONUS_MISC);
    effect eDamageBonus = EffectDamageIncrease(iDam,DAMAGE_TYPE_DIVINE);

    effect eLink = EffectLinkEffects(eAttackBonus,eDamageBonus);

    PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

    //Dual Weilding
    if(GetIsObjectValid(oItem2) && GetIsObjectValid(oItem1))
    {
    PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oItem1,9.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oItem2,9.0f);
    }

    //One Weapon
    if(GetIsObjectValid(oItem2) && !GetIsObjectValid(oItem1))
    {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oItem2,9.0f);
    }
}
